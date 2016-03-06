Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36046 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbcCFU1L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2016 15:27:11 -0500
Received: by mail-io0-f169.google.com with SMTP id z76so10279337iof.3
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 12:27:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160305200909.GJ1902@torres.zugschlus.de>
	<pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
Date: Sun, 6 Mar 2016 13:27:10 -0700
Message-ID: <CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 5, 2016 at 11:43 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Marc Haber posted on Sat, 05 Mar 2016 21:09:09 +0100 as excerpted:
>
>> On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
>
>>> Something is happening with the usage of this file system that's out of
>>> the ordinary. This is the first time I've seen such a large amount of
>>> unused metadata allocation. And then for it not only fail to balance,
>>> but for the allocation amount to increase is a first.
>>
>> It is just a root filesystem of a workstation running Debian Linux, in
>> daily use, with daily snapshots of the system, and ten-minute-increment
>> snapshots of /home, with no cleanup happening for a few months.
>>
>>>  So understanding the usage is important to figuring out what's
>>>  happening. I'd file a bug and include as much information on how the
>>>  fs got into this state as possible. And also if possible make a
>>>  btrfs-image using the proper flags to blot out the filenames for
>>>  privacy.
>
> Now you're homing in on what I picked up on.  There's something very
> funky about that metadata, 100+ GiB of metadata total, only just over 2
> GiB metadata used, and attempts to balance it don't help with the spread
> between the two at all, only increasing the total metadata, if anything,
> but still seem to complete without error.  There's gotta be some sort of
> bug going on there, and I'd /bet/ it's the same one that's keeping full
> balances from working, as well.
>
>
> OK, this question's out of left field, but it's the only thing (well,
> /almost/ only, see below) I've seen do anything /remotely/ like that:
>
> Was the filesystem originally created as a convert from ext*, using btrfs-
> convert?  If so, was the ext2_saved or whatever subvolume removed, and a
> successful defrag and balance completed at that time?
>
> Because as I said, problems due to faulty conversion from ext* have been
> the one thing repeatedly reported to trigger balance behavior and spreads
> between total and used that balance doesn't fix, like this.
>
>
> Tho AFAIK there was in addition a very narrow timeframe in which a bug in
> mkfs.btrfs would create invalid btrfs'.  That was with btrfs-progs 4.1.1,
> released in July 2015, with an urgent bugfix release 4.1.2 in the same
> month to fix the problem, so the timeframe was days or weeks.  Btrfs
> created with that buggy mkfs.btrfs were known to have some pretty wild
> behavior as well, with the recommendation being to simply blow them up
> and recreate them with a mkfs.btrfs from a btrfs-progs without the bug,
> as the btrfs created by the bugged version were simply too bugged out to
> reliably fix, and might well appear to work fine for awhile, until BOOM!
> If there's a chance the filesystem in question was created by that bugged
> mkfs.btrfs, don't even try to fix it, just get what you can off it and
> recreate with a mkfs.btrfs without that bug, ASAP.

Marc said it was created maybe 2 years ago and doesn't remember what
version of the tools were used. Between it being two years ago and
also being Debian, for all we know it could've been 0.19. *shrug*

On the one hand, the practical advice is to just blow it away and use
everything current, go back to the same workload including thousands
of snapshots, and see if this balance problem is reproducible. That's
pretty clearly a bug.

On the other hand, we're approaching the state with Btrfs where the
problems we're seeing are at least as much about aging file systems,
because the stability is permitting file systems to get older. As they
get older though, the issues get more non-deterministic. So it's an
interesting bug from that perspective, the current kernel code ought
to be able to contend with this (as in, the user is right to expect
the code to deal with this scenario, and if it doesn't it's a bug; not
that I expect today's code to actually do this).

That's why I'm suggesting btrfs-image, because at some point the aging
question might get a dev's attention. But in the meantime the user
should get back to a reliable state and also find out sooner than
later if this is still a problem with all current tools and code.

So if it were me, I'd gather all possible data, including complete,
not trimmed, logs. And as for the btrfs-image, it could be huge. It
should be only 1GB based on the used metadata but the fact there's 50x
more allocated, I'm not sure how big it'll actually be or if
btrfs-image even has the granularity to capture this. It might not be
a bad idea to capture a complete btrfs-debug-tree also, and compress
that, add as attachment. For the image, stick it up in dropbox or
google drive, and post the URL in the bug and give it a year... I've
had devs come back and fix stuff that old before.

-- 
Chris Murphy
