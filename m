Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47874 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753416AbcLZAND (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Dec 2016 19:13:03 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cLIuJ-0005Em-JE
        for linux-btrfs@vger.kernel.org; Mon, 26 Dec 2016 01:12:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: some free space cache corruptions
Date: Mon, 26 Dec 2016 00:12:43 +0000 (UTC)
Message-ID: <pan$6de89$3108fb7c$12cf2501$859bb20@cox.net>
References: <1482703234.6497.1.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sun, 25 Dec 2016 23:00:34 +0100 as
excerpted:

> # btrfs check /dev/mapper/data-a2 ; echo $?
> Checking filesystem on /dev/mapper/data-a2

[...]

> checking free space cache
> block group 5431552376832 has wrong amount of free space
> failed to load free space cache for block group 5431552376832

[...]

> 0
> 
> => same error again...
> 
> Any ideas how to resolve? And is this some serious error that could have
> caused corruptions?

By themselves, free-space cache warnings are minor and not a serious 
issue at all -- the cache is just that, a cache, designed to speed 
operation but not actually necessary, and btrfs can detect and route 
around space-cache corruption on-the-fly so by itself it's not a big deal.

These warnings are however hints that something out of the routine has 
happened, and that you might wish to freshen your backups, run btrfs 
check and scrub and see if anything else is wrong (if you get them at 
mount, you got them /running/ btrfs check and nothing else out of the 
ordinary was reported), etc.

Three things to note:

1) Plain btrfs check, without options that trigger fixes, is read-only, 
so you are likely to see anything unusual it reports again in repeated 
runs, unless the filesystem itself, or a scrub, etc, has fixed things in 
the mean time.  (And as I said, the space-cache is only a cache, designed 
to speed things up, cache corruption is fairly common and btrfs can and 
does deal with it without issue.  In fact btrfs has the nospace_cache 
option to entirely disable it at mount.)

2) It recently came to the attention of the devs that the existing btrfs 
mount-option method of clearing the free-space cache only clears it for 
block-groups/chunks it encounters on-the-fly.  It doesn't do a systematic 
beginning-to-end clear.  As such, in some instances it's possible to run 
with the clear_cache mount option (see the btrfs (5) manpage for mount 
option specifics, but to head off another question, it's recommended to 
stay with v1 cache for now) and still see space-cache warnings you 
thought should be cleared up, if btrfs didn't deal with those chunks in 
the run where the cache was cleared.

3) As a result of #2, the devs only very recently added support in btrfs 
check for a /full/ space-cache-v1 clear, using the new
--clear-space-cache option.  But your btrfs-progs v4.7.3 is too old to 
support it.  I know it's in the v4.9 I just upgraded to... checking the 
wiki it appears the option was added in btrfs-progs v4.8.3 (v4.8.4 for v2 
cache).

So if you want you can try the clear_cache mount option, and if that 
doesn't do it, upgrade to a current btrfs-progs and run it with the
--clear-space-cache option, but you're not endangering your filesystem or 
anything by simply waiting until you get a btrfs-progs update from your 
distro, if you decide to.  The space-cache warnings aren't indicative of 
a serious problem now and btrfs deals with them on its own, they are 
simply hints that something, perhaps a crash with the btrfs mounted 
writable, happened at some time in the past, and that it it might be wise 
to investigate further for other damage, which you've already done, so 
you're good. =:^)

Tho if you haven't recently run a scrub, I'd do that as well (and in fact 
recommend running it before check if you can successfully mount), since 
the problems it detects and fixes are conceptually different than the 
ones btrfs check deals with.  Scrub deals with actual on-media 
corruption, blocks not matching their checksum, while check deals with 
filesystem logic errors, whether or not the blocks containing them match 
the checksum.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

