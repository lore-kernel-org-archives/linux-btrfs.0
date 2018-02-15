Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40989 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1032447AbeBOCSK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 21:18:10 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1em95T-0001HX-7L
        for linux-btrfs@vger.kernel.org; Thu, 15 Feb 2018 03:15:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Status of FST and mount times
Date: Thu, 15 Feb 2018 02:15:36 +0000 (UTC)
Message-ID: <pan$4ce4f$f90ad4b5$3f1cd3cd$26789d16@cox.net>
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
        <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
        <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Thu, 15 Feb 2018 09:42:27 +0800 as excerpted:

> The easiest way to get a basic idea of how large your extent tree is
> using debug tree:
> 
> # btrfs-debug-tree -r -t extent <device>
> 
> You would get something like:
> btrfs-progs v4.15 extent tree key (EXTENT_TREE ROOT_ITEM 0) 30539776
> level 0  <<<
> total bytes 10737418240 bytes used 393216 uuid
> 651fcf0c-0ffd-4351-9721-84b1615f02e0
> 
> That level is would give you some basic idea of the size of your extent
> tree.
> 
> For level 0, it could contains about 400 items for average.
> For level 1, it could contains up to 197K items.
> ...
> For leven n, it could contains up to 400 * 493 ^ (n - 1) items.
> ( n <= 7 )

So for level 2 (which I see on a couple of mine here, ran it out of 
curiosity):

400 * 493 ^ (2 - 1) = 400 * 493 = 197200

197K for both level 1 and level 2?  Doesn't look correct.

Perhaps you meant a simple power of n, instead of (n-1)?  That would 
yield ~97M for level 2, and would yield the given numbers for levels 0 
and 1 as well, whereby using n-1 for level 0 yields less than a single 
entry, and 400 for level 1.

Or the given numbers were for level 1 and 2, with level 0 not holding 
anything, not levels 0 and 1.  But that wouldn't jive with your level 0 
example, which I would assume could never happen if it couldn't hold even 
a single entry.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

