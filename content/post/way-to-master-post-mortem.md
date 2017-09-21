+++
date = 2017-09-10
lastmod = 2017-09-21
draft = false
tags = ["WTM", "projects"]
title = "The history of Way To Master and lessons learned"
math = true
summary = """Brief history of one of Way To Master - one of the most interesting after-hour projects that I've been involved into."""

[header]
image = "/wtm-1/wtm-logo.png"
caption = ""

+++

This page describes a brief history of one of the most interesting after-hour projects that I've been involved into. It was called Way To Master and it was intended to help learning English for Polish people. Nothing related to it happened for a two years from now. There are no users, no ads, no new features. Also, there is one week left until domain will expire so probably now the page you're reading is one of few visible signs of existence of Way To Master. I'm writing this post mostly for myself in the future. There will be a point in my life when I'll forget some of these things and then I'll just open it and read, assuming Github won't go offline :smile:.

I've split this article into two separate posts. The first one (that you're reading right now) is overall description of the project. The second one explains technicalities and will be published soon.

{{< figure src="/img/wtm-1/screen1.jpg" title="In-line translation (.srt format)." >}}

## Learning foreign languages - standard approach

Way to master was all about learning foreign languages. And learning a language is a bit twisted phenomena comparing to learning other things. Usually, if you want to master some subject, you're using language (either spoken or written) to learn new concepts. A programmer could say that the role of a language here is acting as a transport layer carrying content to learn. By adjusting language, one can gain better understanding of given concept - sometimes learned topics are easier to understand if different words are used and sometimes the opposite holds true.

If you're learning a language things are different. What you want to learn is *the transport layer* and you're doing it by utilizing some content - articles, sentences, songs, movies, dialogues. Whatever way of learning a language you will use, you need *something* to read, write, speak or hear about. 

If you prefer to learn a language using one of most common approaches - stationary course, these *somethings* to read, write, speak or hear about are usually fixed and provided by a course creators. Sometimes student has limited possibility of choosing one article or another but there are chances that nothing will really meet his areas of interests anyway. It's partially because people are varying on their interests and partially because learning materials need to be adjusted basing on language level.

{{< figure src="/img/wtm-1/app_screen1.gif" title="Summary widget displayed after uploading new subtitles." >}}

## Learning foreign languages - our approach

The core idea behind Way To Master was to allow to use any materials for learning foreign languages.

User was supposed to upload original content and then few things were happening:

  1. Content was analyzed from the language perspective - words were categorized to known and unknown for the particular user basing on his pervious experience with the system,
  2. Unknown words were translated directly in content (depending of content type - differently for movies subtitles, differently for ebooks),
  3. Unknown words were saved in database with their contexts (one or few surrounding sentences),
  4. Unknown words were added into built-in [spaced repetitions system](https://en.wikipedia.org/wiki/Spaced_repetition).

Now, user could:

  1. Download modified content with translations,
  2. Download flashcards with translations and words contexts,
  3. Learn unknown words on the webpage or directly mark them as known.

The learning cycle for the user consisted of:

  1. Uploading, downloading and utilizing modified content - watching movies, playing computer games, reading e-books,
  2. Coming back to system few times in a week to make repetitions of learned words.

{{< figure src="/img/wtm-1/screen2.jpg" title="Top scree translating (.ass format)." >}}

## The big picture

Assuming correct implementation, this system would allow anyone to learn any popular language with an additional boost of experiencing content he likes. That should make the whole process of language acquisition a lot more convenient and similar to how people are learning new languages when they migrate to other countries. I couldn't emphasize that more - just please hold on for a moment and imagine - doesn't it look like a way of learning languages that will anyway come up at one time in the future? People playing computer games, watching movies, reading books AND learning languages by the way... The idea is very alluring, at least for me.

{{< figure src="/img/wtm-1/app_screen2.gif" title="List of words occurring in some subtitles." >}}

## Early stages

During spring of 2013, I and few friends from the same university group created a desktop application that could read text files, extract words from them and synchronize state with remote server. It was focused mostly on movies subtitles but parser was quite generic (it basically cut off all of strings which were not dictionary-based words) and it worked also for most of plain-text based formats. We never showed that for anyone except our professor - this project was purely for university and we didn't thought of it as a any kind of startup or after-hours project.

Then, for our bachelor degree, we implemented a little extended version with a web interface. Never released, only for university. After that, me and my friend Wojtek decided to give it a try and release it to the public and that's where the *startup* chapter starts.

{{< figure src="/img/wtm-1/landing.png" title="Our landing page." >}}

## Final stage

Beginning of 2014 was time of everyone doing their startups. There were a lot of conferences related to this topic in Poland and a lot of buzz about it. Everyone was doing landing pages so we decided to do a landing page before we complete final version. So we did a landing page :smile:. Publishing a real service was a little harder than we thought; yet we had a lot of fun doing side quests - like spending days trying to host our solution on linux in one of Polish small cloud provider or asking random people whether they like the idea. At some point in time we decided to reshape the idea and accomplish something simpler. Driven by all startup gurus advices, we felt that we need to find our target group and focus mostly on them. So we picked:

  - Movies subtitles only
  - People speaking in Polish language which are learning English

We did it under assumption: *If we can interest polish people with only such a product, it proves that it's worth doing*.

Speaking about work - I was mostly responsible for logic of parsing files, extracting words and putting translations in-place. Wojtek was mostly doing frontend and database-related logic (saving words knowledge, comparing knowledge with what was in new files).

{{< video mp4="/img/wtm-1/wtm_desktop.mp4" title="Desktop application was making subtitle translating cycle easier.">}}

At the beginning of October, we finally put our application to the real world. In October 28, 2014, we put it on Polish reddit-like page called [Wykop](https://www.wykop.pl/link/2219310/nauka-angielskiego-z-napisow-do-filmow-i-seriali/). We've received over 800 upvotes which at this time was a pretty good result. It converted to over 30 000 visits on our page on a first few days (at least this is what Google Analytics shown us).

Initial week consisted of a little over 1400 new registrations in our application. We were very excited about that. People were saying good things about the idea and execution (obviously there was also some negative opinions but overall feedback was good) and we felt great about it.

The question then was - what should be next stage and how to proceed?

{{< video mp4="/img/wtm-1/wtm_popcorn.mp4" title="We even released our own version of popcorn time :smile:">}}

## Trying to get attention

We've won a local startup competition (Dig Up Start Up in Katowice) and tried interest few VCs in Poland. Unfortunately, without a success. People were interested rather in fast return than in building a global service that will change the way of people are learning languages. Mostly because the road was not clear to them and also because road was not clear for us. There are huge number of smaller and bigger flashcards-online applications and once you say *flashcard* and *learning*, people seem to recollect memories of all of these websites and apps and try to think like: *ok, that's something like this plus something extra*. It was hard to convince people we've met that having few thousands of free subscriptions actually proves anything valuable for them. Also, it looked like a lot of registered people were just testing our system using it few times and then never going back again. There was no sign of money inside of Way To Master at this stage. We needed to push it to next level. At this time we still received a number of new subscriptions but it started becoming obvious that we need to focus on broader group rather than only Poles trying to learn English. Also, relying on subtitles for movies coming from not 100% legal sources wasn't obviously the best predictor when it comes to monetizing application :smile:. 

## End of project

Due to our implementation, it would require to re-write the whole system in order to support more than English language. At this time both me and Wojtek were studying and working part-time and we decided to not continue. Actually, there was no decision per se that we stop development - it was rather a continuous blanking of effort. We switched to another activities - partially because we needed money that standard job was giving us and partially because we didn't see a next realistic goal.

It was somewhere about May, 2015. Since then, service was active until now, that is - September 2017.

Few statistics:

  * 4379 registered accounts,
  * 10894 unique uploaded and translated subtitles,
  * 30367202 recognized words that were either known or not known by users,
  * 11301546 phrases recognized as separate sentences (less than 3 words per sentence, but please remember they came from movies).


## Lessons learned

Instead of writing a list of things, I'll write only a single one:

> I should do what I believe is the best for the project and not what I suppose to do in the eyes of others.
 
If we didn't focus on Polish people only and English language only, we could show it to a greater range of people, including huge range of programmers on Reddit and Hacker News. I believe that someone of them might be interested in the idea - not only using it but also helping us with execution. Yes, it would be harder to complete it in time we did it but the results will probably be more valuable. And even if we decided to leave it, we could make it open-source side project and more people could actually benefit from it.

In the next article you'll read about technicalities of Way To Master and few code samples.
