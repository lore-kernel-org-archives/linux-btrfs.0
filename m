From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [PATCH v2 2/2] Cancel filesystem balance.
Date: 12 Nov 2010 12:25:00 +0100
Message-ID: <B$jNZIPD1uB@helmut.hullen.de>
References: <20101112090755.GA16221@attic.humilis.net>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101112090755.GA16221@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Sander,

Du meintest am 12.11.10:

>> Given that there's been at least 1 report of it taking 12 hours
>> to balance a non-trivial amount of data I suspect putting this
>> operation into the background by default and having the cancel
>> option might be a better plan.
>>
>> Thoughts ?

> My humble opinion: I very much like the way mdadm works, with the
> progress bar in /proc/mdstat if an array is rebuilding for example.

Hmmm - it blocks the console for a long time.

I prefer running those long time jobs via "at"; all messages go into a  
mail to root (or whoever has started the job).

"balance" seems to produce a logfile entry every 40 seconds, that may be  
about 1500 lines for a 1 TByte job.
A progress bar produces similar messages, but they aren't as good  
readable in an e-mail ...

I know those long and nearly unreadable mails p.e. from "squidGuard" ...

Viele Gruesse!
Helmut
