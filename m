Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:32931 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbbLBHHt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 02:07:49 -0500
Received: by wmec201 with SMTP id c201so238864590wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Dec 2015 23:07:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO-VSOH1QUHTXFGzCSUKW=mRoufmUpYG8xRB4N80+rHmjg@mail.gmail.com>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
	<pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
	<CA+WRLO_hx3u0wPy_GfguKmmXY4crxrRFx9TvuoLYh-Su0ju8ww@mail.gmail.com>
	<565E0356.9030006@gmail.com>
	<CA+WRLO-VSOH1QUHTXFGzCSUKW=mRoufmUpYG8xRB4N80+rHmjg@mail.gmail.com>
Date: Wed, 2 Dec 2015 18:07:48 +1100
Message-ID: <CA+WRLO_1bLpve50YkuGD4wDxyO_e=4u9xev8y4XxZT9L01KxDQ@mail.gmail.com>
Subject: Re: utils version and convert crash
From: Gareth Pye <gareth@cerberos.id.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Output from scrub:
sudo btrfs scrub start -Bd /data
scrub device /dev/sdd (id 2) done
        scrub started at Wed Dec  2 07:04:08 2015 and finished after 08:53:53
        total bytes scrubbed: 2.47TiB with 0 errors
scrub device /dev/sde (id 3) done
        scrub started at Wed Dec  2 07:04:08 2015 and finished after 07:22:02
        total bytes scrubbed: 2.47TiB with 0 errors
scrub device /dev/sdf (id 4) done
        scrub started at Wed Dec  2 07:04:08 2015 and finished after 06:48:31
        total bytes scrubbed: 1.09TiB with 0 errors
scrub device /dev/sdg (id 5) done
        scrub started at Wed Dec  2 07:04:08 2015 and finished after 06:52:07
        total bytes scrubbed: 1.10TiB with 0 errors
scrub device /dev/sdh (id 6) done
        scrub started at Wed Dec  2 07:04:08 2015 and finished after 06:47:22
        total bytes scrubbed: 1.09TiB with 2 errors
        error details: read=2
        corrected errors: 2, uncorrectable errors: 0, unverified errors: 30
scrub device /dev/sdc (id 7) done
        scrub started at Wed Dec  2 07:04:08 2015 and finished after 04:11:59
        total bytes scrubbed: 430.52GiB with 0 errors
WARNING: errors detected during scrubbing, corrected

Looks like I have some issues. Going to confirm cables are all secure
and run a memtest.

On Wed, Dec 2, 2015 at 9:22 AM, Gareth Pye <gareth@cerberos.id.au> wrote:
> Will do that once the scrub finishes/I get home from work.
>
> On Wed, Dec 2, 2015 at 7:30 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-12-01 15:12, Gareth Pye wrote:
>>>
>>> On Wed, Dec 2, 2015 at 2:14 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>>>
>>>> So if you're running into the same problem gentoo's live-git build did,
>>>> it's likely because you're building the devel branch cloned from
>>>> kernel.org, which is no longer updated.
>>>
>>>
>>>
>>> Woah, kernel.org is making a log that looks like it's up to date but
>>> isn't that's awkward :(
>>>
>>> Building now from the github you mentioned.
>>>
>>> Also running a scrub, but I'm starting to suspect something else is
>>> responsible. It ran fine overnight but crashed in less than a minute
>>> after I logged back in on ssh this morning . . .
>>>
>> Hmm, the fact that it's intermittent is the most concerning part IMHO. It
>> means it's a lot harder to track down.  If your hard drives aren't any
>> noisier than normal (most traditional hard disks get noticeably noisier when
>> they're failing), then I'd suggest running something like memtest86+ for at
>> least a full cycle with default options to verify if your RAM is working
>> correctly.  Usually, when I see intermittent crashes like this it's either a
>> race condition in software somewhere, or bad RAM, and it's a lot easier to
>> test for bad RAM than it is to test for race conditions.
>>
>
>
>
> --
> Gareth Pye - blog.cerberos.id.au
> Level 2 MTG Judge, Melbourne, Australia
> "Dear God, I would like to file a bug report"



-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
