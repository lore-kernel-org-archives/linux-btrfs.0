Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:34892 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbcKIUNQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Nov 2016 15:13:16 -0500
Received: by mail-it0-f54.google.com with SMTP id e187so222375592itc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Nov 2016 12:13:15 -0800 (PST)
Subject: Re: btrfs scrub with unexpected results
To: Tom Arild Naess <tanaess@gmail.com>, linux-btrfs@vger.kernel.org
References: <84df8b17-65ac-0f40-cf19-471b3664b0b3@gmail.com>
 <f8ba65d7-5854-e853-221c-4b7f4991b21a@gmail.com>
 <e3827c98-3817-81d4-e77b-e2daf00bb3c8@gmail.com>
 <479c9899-f073-5791-0693-1c9daef3f92d@gmail.com>
 <48d461f9-0455-5da2-651a-39d4e59cd217@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e7d6a24f-da82-9d0d-c770-67f8ed0140e6@gmail.com>
Date: Wed, 9 Nov 2016 15:13:08 -0500
MIME-Version: 1.0
In-Reply-To: <48d461f9-0455-5da2-651a-39d4e59cd217@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-09 12:30, Tom Arild Naess wrote:
> On 09. nov. 2016 14:04, Austin S. Hemmelgarn wrote:
>> On 2016-11-09 07:40, Tom Arild Naess wrote:
>>> Thanks for your lengthy answer. Just after posting my question I
>>> realized that the last reboot I did resulted in the filesystem being
>>> mounted RO. I started a "btrfs check --repair" but terminated it after
>>> six days, since I really need to get the backup up and running again. I
>>> have decided to start with a fresh btrfs to rule out any errors created
>>> by old kernels.
>> Even with other filesystems, doing this on occasion is generally a
>> good idea.  It goes double for BTRFS though, I'd say right now every
>> year or so you should be re-creating the filesystem if your using BTRFS.
>>>
>>> I find it unlikely that my problems are caused by any hardware faults,
>>> as the server has been running 24/7 for six months with nightly backups
>>> every day without any problems. Also the system has been scrubbed once a
>>> month without issues in the same timespan. Every time there have been
>>> scrubbing errors, these have all occurred in the the same old snapshots
>>> that I created from my hard link backups. These were the first snapshots
>>> I ever took, and back then I ran a quite old kernel.
>> Just to clarify, most of the reason I'm thinking it's a hardware issue
>> is that a reboot fixed things.  In most cases I've seen, that
>> generally means you either have hardware problems (even failing
>> hardware usually works correctly for a little while after being power
>> cycled), or that you got hit with a memory error somewhere (not
>> everything has ECC memory on a server system, the on-device caches on
>> most disks and some storage controllers often don't for example).  It
>> could just as easily be the result of a bug somewhere as well, but I
>> usually tend to blame the hardware first because I find that it's a
>> lot easier to debug most of the time (I might also be a bit biased
>> because BTRFS has helped me ID a whole lot of marginal hardware in the
>> past 2 years).
>
> Ok, I will keep this in mind if the server is starting to act strange
> again.
>>>
>>> If a fresh btrfs does not solve my problems, I will go through the list
>>> you provided. Some have already been handled earlier, like memtest (did
>>> a long run before the system was put into service). I am also running
>>> smartctl as a service, and nothing is reported there either.
>>>
>>> One last thing: The CPU on the server is a really low end AMD C-70, and
>>> I wonder if it's a little too weak for a storage server? Not in the day
>>> to day, but when a repair is needed. Seems like more than six days for a
>>> repair on 4x 3TB system is way too long?
>> For something like a storage server, what you really want to look at
>> is memory bandwidth, as that tends to directly impact pretty much
>> everything the system is supposed to be doing.  In your case, the
>> limiting factor probably is the CPU, as a C-70 runs at 1GHz and only
>> supports up to DDR3-1066 RAM.  This works fine for just serving files
>> of course, but it gets problematic when you have to move lots of data
>> around or process a filesystem for repairs.  As a general rule for a
>> file-server, I wouldn't use anything running at less than 2GHz with at
>> least 2 (preferably 4) cores which supports at minimum DDR3-1333
>> (preferably DDR3-1600) RAM.
>>
>> In fact, with some very specific exceptions, memory bandwidth is
>> actually one of the most important metrics for almost any computer
>> (provided the CPU isn't running slower than the RAM or limiting it's
>> max operation speed, I'd upgrade RAM before upgrading the CPU most of
>> the time for most systems).
>
> Sorry, but I will have to disagree on your point about memory! The
> memory controllers on modern computers are quite well matched to the
> CPU, and the difference between DDR3-1066 and DDR3-1600 will often be
> minuscule in the real world. I found this article on DDR3 from reputable
> anantech.com showing the real effects the different spec'ed DDR3 has on
> the systems performance: http://www.anandtech.com/show/2792
I've got quite a lot of evidence myself indicating that it does have an 
impact in many cases.  You'll see less impact in single-channel mode 
than with multiple-channels, as well as seeing different numbers running 
multi-core versus single-core (multi-core will usually be lower because 
of the locking and access contention, except on good NUMA systems). 
Something on the order of a 5% increase may not sound like much, but 
when your talking about double (and sometimes triple) digit gigabits per 
second, it actually amounts to a rather large improvement.  Using real 
numbers from my home server, running the same brand and equivalent model 
of DDR3-1866 RAM versus DDR3-1600 bumps the memory bandwidth from about 
20 Gb/s to about 22.5 Gb/s, which in turn translates to a roughly 
proportionate improvement in pretty much any performance measurement 
that does anything other than just burn processing time.  I've see 
pretty similar (albeit less drastic) improvements in most systems I've 
worked with, although it tends to depend on many things (I see bigger 
improvements on AMD desktop and embedded CPU's than anywhere else, as 
well as with faster processors).  Most of the improvement though is in 
latency, because when there's a cache miss, the CPU has to wait for a 
shorter period of time for the RAM when it's using faster RAM, and that 
latency difference is where the improvement comes in on most systems, 
but it's still a factor of memory bandwidth (faster memory means lower 
bandwidth).

In your case though, your RAM is actually going to be waiting on your 
CPU part of the time (something around 6% probably given the ratio of 
CPU frequency to effective transfer frequency for the RAM), and that 
means that the first thing I would upgrade would be the processor.

Now, even aside from all of that, improved memory bandwidth will help 
with btrfs check, since check currently loads most of the metadata into 
memory and works on it there, and it should help with scrubbing and 
defragmenting (at a minimum it should reduce the impact those have on 
serving data).
>
> About multi-core systems: I noticed that "btrfs check" did only utilize
> one single core, and maxed it out at 100%. Seems like it would benefit
> from utilizing more cores. Has this been considered?
>
It's been talked about, but I don't think anybody's done anything about 
it.  The traditional mode would almost certainly benefit, but I'm 
dubious about the low-mem mode (which is bounded by storage I/O more 
than memory bandwidth and thus would still be limited by device access).

