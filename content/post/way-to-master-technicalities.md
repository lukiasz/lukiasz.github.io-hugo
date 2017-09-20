+++
date = 2017-09-20
lastmod = 2017-09-20
draft = true
tags = ["WTM", "projects"]
title = "Way To Master - Technical Details"
math = true
summary = """Implementation details of Way To Master - one of the most interesting after-hour projects that I've been involved into."""


+++

In this post I'll write about architecture of Way To Master. Your can read about what Way To Master was in [previous post](post/way-to-master-post-mortem/). This post will briefly describe how things were connected to each other and how some of them was implemented. The overall design wasn't really exceptional (comparing to what I'm doing in my job right now) but I'd like to keep it written down somewhere for me in the future.

## Runtime view

From runtime perspective, WTM consisted of several blocks.

{{< figure src="/img/wtm-2/wtm-schema-1.svg" title="Runtime perspective." >}}

#### 1. Frontend Application

It was responsible for landing page as well as for the whole frontend application. Written using AngularJS 1.

<WSTAW FILMIKI? I'm using the same videos...>

#### 2. Popcorn Time Fork

Fork of Popcorn Time application. Original application is a torrent client that allows for watching movies and tv shows. Our modification pushed and pulled subtitles to and from our server. After starting an application, user put his credentials into out login popup. Then, subtitles for every movie he watched were sent to our server and then downloaded back with proper translations.

#### 3. Desktop Application

Desktop application was a small tool for making process of uploading/downloading subtitles more convenient. Instead of opening a browser it allowed for RMB click on subtitle and selecting new option **Translate Hard Words**. It was written in Qt/QML with proper explorer.exe handlers that allowed us to attach to the system right mouse button menu. We could write it in C# (in which we've been much more familiar) but after doing a small prototype we realized that running managed code per every RMB click was a significant overhead so we decided to just write everything in good old C++.

#### 4. Backend Application

The main place where everything was happening. From runtime perspective it was a one thing (it was hosted as a single ASP.NET application) but from logical standpoint a lot of things were going on. If we look at it from domain perspective, it would look like this:

{{< figure src="/img/wtm-2/ddd-schema.svg" title="Backend code organization perspective." >}}

  1. **Learning Module** - [Bounded Context](https://martinfowler.com/bliki/BoundedContext.html) containing `UserLanguageKnowledge` aggregate and several other entities related with maintaining user language knowledge states. Model for storing knowledge was actually quite simple. Every unique [lemma](https://en.wikipedia.org/wiki/Lemma_(morphology)) had has its own row representation in words table. Knowledge of given lemma for given user was stored in `WordCard` entity. Knowledge state was either `NotKnown` or `Known`.
  
    That design was simple yet it would probably not scale well - at the end we were going to store one row per every English lemma per every user of our application. As stated in [previous post](post/way-to-master-post-mortem/), we ended having more than 30 millions of word cards from less than 5 thousands of users. If I was to write it again, I would probably go for [jsonb](https://www.postgresql.org/docs/current/static/datatype-json.html) column for the whole user language knowledge. It would be a bit more tricky to implement updating a single word knowledge but it'll probably help in DB performance in a long run.

  2. **Content Module** - Bounded Context containing `Content` aggregate which represented a single uploaded file with all sentences and words. Model was also quite straightforward. `Content` had has multiple sentences. Every `Sentence` had has collection of words in context. `Word In Context` contained link to lemma (`Word`), abstract location data allowing us to find occurrence of this word in uploaded file, id of [part of speech](https://en.wikipedia.org/wiki/Part_of_speech) and id of [synset](https://en.wiktionary.org/wiki/synset).

  3. **User Profile Module** - bunch of services for managing accounts. Some of methods were just wrappers for ASP.NET Membership Provider. From what I remember it required a significant amount of work to make it running with PostgreSQL and Entity Framework back then. The interface of ASP.NET Membership looked like it's basing on on Entity Framework structure entirely but in the reality some internal SQL Server stored procedures were called under the hood :smile:. Looking now into installed NuGet packages I see that we used the [pgprovider library](https://github.com/jholovacs/pgprovider).

  4. **Administration Module** - bunch of services for managing  administration tasks.

  5. **Translation Module** - quite interesting piece. It was a service which was providing translations for words. Translations consisted of... well... translations :smile: and word definitions taken from [WordNet](https://wordnet.princeton.edu/). We utilized [WordReference's APIs](http://www.wordreference.com/) with quite aggressive caching so we didn't need to call it per every single word. WordNet database was translated and stored in our PostgreSQL database.


If you're familiar with DDD, you could wonder *Why on top level you're talking about bounded contexts and services, shouldn't services be a part of bounded contexts?*. And you'll be right :smile:. When we were implementing this, we were learning about how to design object oriented code. Some of design decisions made sense, some not. For example, today I would keep **Content** and **Learning** bounded contexts together. But from the other hand - what's the point of crafting code that is used by no-one? Most of the time in this project should be spent on crafting value proposition, not on improving the code that worked.

#### 5. PostgreSQL

Well, what to write about... Just PostgreSQL database :smile:. We didn't use jsonb features.


#### 6. File Parsing / Translating Services

In Way To Master we've been processing subtitles for movies - in two formats - [SubRip](https://en.wikipedia.org/wiki/SubRip) and [SubStation Alpha](https://en.wikipedia.org/wiki/SubStation_Alpha), but the second one was only as a output format.

{{< figure src="/img/wtm/screen2.jpg" title="Thanks to SSA format, we could display translations on the top." >}}

Obviously, if we wanted to parse and modify content of subtitles, we needed to parse these files correctly. We recognized manipulations on files as a possible bottleneck so we designed code in the way that services for parsing and for inserting translations were quite separated from backend application's code. They were implemented quite good, I remember having great fun writing this part of code. Let me give you a short description.

So, in the backend application part there was a `ContentProcessingService`. It was implementing a [Service Registry](http://microservices.io/patterns/service-registry.html) pattern allowing to add support for new file formats. Adding support consisted of writing a new web application that was exposing methods for:
  a) returning metadata - which formats with which options were supported,
  b) extracting sentences (with their positions) from file,
  c) inserting translations for text inside sentences (usually just for words).

Then, we're supposed to add it's url into database so that backend could know about support for new format.

After having sentences extracted, on the backend part, words from sentences were extracted and analyzed using custom text analyzer.

#### A note on parsing

For generating parsers we used great [ANTLR](http://www.antlr.org/) toolset. Writing grammars and using resulting parsers was a pleasure comparing to my university experience with Bison/Flex. Actually the whole SRT grammar was quite simple, here is the lexer part:

```
lexer grammar SRTLexer;
TIMESPAN: TIME ARROW TIME -> pushMode(TEXT);
 
TIME: NUMBER NUMBER ':' NUMBER NUMBER ':' NUMBER NUMBER ',' NUMBER NUMBER NUMBER ;
ID: NUMBER+; 
NUMBER: '0'..'9' ;
NEWLINE: '\r'? '\n';
ARROW: ' --> ' ;
mode TEXT;

CAPTION: LINE+ -> popMode;
LINE: ~[\r\n]+ END -> skip;
END: '\r'? '\n' -> skip;

```

and parser part:

```
parser grammar SRTParser;
options { tokenVocab = SRTLexer; }

file: (subtitle NEWLINE) + subtitle NEWLINE ? EOF;
subtitle: ID NEWLINE TIMESPAN CAPTION NEWLINE*;
```

Actually, there is a [repo on Github](https://github.com/antlr/grammars-v4) with a lot of ANRLR grammars; I should review code above and create pull request in one day with it. 