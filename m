Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:62297 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaH1OsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 10:48:05 -0400
Received: by mail-oi0-f45.google.com with SMTP id a3so618902oib.32
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 07:48:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$4f96f$308624ac$25e2c83c$5db208b4@cox.net>
References: <CADw2B2PYPJdcLWvkufY71kvAdCdgXhsdO2Gizf8hXAruppxXPA@mail.gmail.com>
	<pan$427a1$f65bd1f8$7ddfd94c$6b06de1b@cox.net>
	<CADw2B2NX8XY3V_vD-7eN9vj0tHtEfJwdsS4bovQ0cOHus_9Q-g@mail.gmail.com>
	<CADw2B2MJS-pkd+XfwLTpq_pqzQzLWnkzxLcaw8UYjnS-jOF25g@mail.gmail.com>
	<CADw2B2M3+M6-W-bqyQNYXLX4ug0=t9kNOp320UU3G2iN-CGbHQ@mail.gmail.com>
	<CADw2B2MmR41K3_qEeHUg0ZQAEojK4T3PTFUeUQxLLxsEiEa8_w@mail.gmail.com>
	<pan.2014.08.27.23.33.55@googlemail.com>
	<pan$4f96f$308624ac$25e2c83c$5db208b4@cox.net>
Date: Thu, 28 Aug 2014 07:48:04 -0700
Message-ID: <CADw2B2Nr56D7_RKSpEOybDFMNr=g_9nZvOFdcYjgN+FaiQyx=w@mail.gmail.com>
Subject: Re: fallocate fail on btrfs
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 28, 2014 at 2:12 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Holger Hoffstätte posted on Wed, 27 Aug 2014 23:33:55 +0000 as excerpted:
>
>> On Wed, 27 Aug 2014 15:58:49 -0700, G. Richard Bellamy wrote:
>>
>>> [..snip..]
>>
>> I can use fallocate on btrfs as you tried in your first post, with or
>> without --keep-size, and it does the right things without errors.
>> Running kernel 3.14+ (patched btrfs), util-linux-2.24.2 on Gentoo.
>>
>>> There are two things going wrong here.
>>>
>>> 1. The "open" command fallocate is using isn't passing along the
>>> O_CREAT flag properly.
>>> https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/sys-
>>> utils/fallocate.c#n368
>
>>> CODE: fd = open(filename, O_RDWR | (!dig && !mode ? O_CREAT : 0),
>>> 0644);
>>> STRACE: open("test.test", O_RDWR) = -1 ENOENT (No such file or
>>> directory)
>>
>> When you have fallocate.c open in cgit, go to its log and you will find
>> a recent commit:
>>
>> https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/sys-
>> utils/fallocate.c?id=575718a04aa0c053875041dc387e360f2dcaa70d
>>
>> aka: "fallocate: use O_CREAT only for the default behavior"
>
> From the getopt_long processing switch/case while earlier in the file,
> lines 319-321:
>
>                 case 'n':
>                         mode |= FALLOC_FL_KEEP_SIZE;
>                         break;
>
>
> So mode is set to FALLOC_FL_KEEP_SIZE, the !mode test fails, and O_CREAT
> isn't passed.
>
> Basically, you can't pass --keep-size/-n on a non-existent file; the file
> doesn't exist so there's nothing to keep the size of and the fallocate
> fails.  Based on the commit, that's deliberate.
>
> So the no-existing-file behavior would seem to be NOTABUG.

The incantation I was using is from a bug report comment:
https://bugzilla.redhat.com/show_bug.cgi?id=689127#c24

And yeah, I misread the !mode test, so the code is behaving as designed.

My biggest crime, and wow what a doozy, is that I didn't read the
frickin comment in the code. YOU KNOW, the one where it explains the
new O_CREAT behavior? Those are hours I'm never going to get back, and
it's because I, once again, wasn't paying attention.

Now, whether you can pass --keep-size/-n on a non-existent file, you
could in the past.

>
>
> As for the existing-file case...
>
>>> And the strace of fallocate execution against a zero-length file I
>>> created with touch: http://sprunge.us/BRML
>>>
>>> You can see in the strace that fallocate thinks it worked (= 0),
>>> but here's the file post-execution:
>>> 2014-08-27 15:49:45 root@eanna i ~ # ls -alh test.test
>>> -rw------- 1 root root 0 Aug 27 15:46 test.test
>
> From the fallocate manpage:
> -n, --keep-size
>         Do  not  modify  the  apparent length of the file.  This may
>         effectively allocate blocks past EOF, which can be removed with a
>         truncate.
>
> Seems to me that's exactly what you're seeing -- allocation BEYOND EOF.
> Try this:
>
> touch test.test
> ls -lsh test.test
> fallocate -n -l 1024000 test.test
> ls -lsh test.test
>
> As described in the ls manpage, -s/--size displays the ALLOCATED size (as
> opposed to the actual file size), and that *DOES* show the expected
> ALLOCATED size change with util-linux-2.25 (and kernel 3.16) for me here,
> tho the file size itself remains zero, as the fallocate manpage suggests
> should indeed be the case if --keep-size was used.
>
> So it looks to me like it's working as it should.

School is in again... and my goodness I learned a lot in this go-around.

>
>> Seems to me you need to downgrade util-linux and/or complain to the
>> util-linux folks. In fact downgrade util-linux first (cfdisk in 2.25
>> eats partitions) and try fallocate again on whatever kernel you have
>> running, just to rule out btrfs.
>
> On the eats partitions bit, gentoo bug:
>
> https://bugs.gentoo.org/show_bug.cgi?id=520838
>
> Util-linux list thread on gmane, not much there but admitting the issue
> and saying they plan a 2.25.1 ASAP:
>
> http://thread.gmane.org/gmane.linux.utilities.util-linux-ng/9765
>
>
> As a result, 2.25, which was in ~arch on gentoo, got hard-masked.  Tho
> I've standardized on gpt partitions and use gdisk (cgdisk) instead, so I
> unmasked it again locally and kept it installed.

I now use gdisk (cgdisk) when working with partitions - but in fact,
did get bit by it recently.

Duncan & Holger - I owe you both a beer!

-rb
