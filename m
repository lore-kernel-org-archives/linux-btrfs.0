Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48940 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932367AbeB1TLZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 14:11:25 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1er76J-0006zP-KJ
        for linux-btrfs@vger.kernel.org; Wed, 28 Feb 2018 20:09:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs space used issue
Date: Wed, 28 Feb 2018 19:09:08 +0000 (UTC)
Message-ID: <pan$e116f$e5aa2400$88c9d453$f5589ed1@cox.net>
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

vinayak hegde posted on Tue, 27 Feb 2018 18:39:51 +0530 as excerpted:

> I am using btrfs, But I am seeing du -sh and df -h showing huge size
> difference on ssd.
> 
> mount:
> /dev/drbd1 on /dc/fileunifier.datacache type btrfs
> 
(rw,noatime,nodiratime,flushoncommit,discard,nospace_cache,recovery,commit=5,subvolid=5,subvol=/)
> 
> 
> du -sh /dc/fileunifier.datacache/ -  331G
> 
> df -h /dev/drbd1      746G  346G  398G  47% /dc/fileunifier.datacache
> 
> btrfs fi usage /dc/fileunifier.datacache/
> Overall:
>     Device size:         745.19GiB Device allocated:         368.06GiB
>     Device unallocated:         377.13GiB Device missing:            
>     0.00B Used:             346.73GiB Free (estimated):        
>     396.36GiB    (min: 207.80GiB)
>     Data ratio:                  1.00 Metadata ratio:              2.00
>     Global reserve:         176.00MiB    (used: 0.00B)
> 
> Data,single: Size:365.00GiB, Used:345.76GiB
>    /dev/drbd1     365.00GiB
> 
> Metadata,DUP: Size:1.50GiB, Used:493.23MiB
>    /dev/drbd1       3.00GiB
> 
> System,DUP: Size:32.00MiB, Used:80.00KiB
>    /dev/drbd1      64.00MiB
> 
> Unallocated:
>    /dev/drbd1     377.13GiB
> 
> 
> Even if we consider 6G metadata its 331+6 = 337.
> where is 9GB used?
> 
> Please explain.

Taking a somewhat higher level view than Austin's reply, on btrfs, plain 
df and to a somewhat lessor extent du[1] are at best good /estimations/ 
of usage, and for df, space remaining.  Due to btrfs' COW/copy-on-write 
semantics and features such as the various replication/raid schemes, 
snapshotting, etc, btrfs makes available, that df/du don't really 
understand as they simply don't have and weren't /designed/ to have that 
level of filesystem-specific insight, they, particularly df due to its 
whole-filesystem focus, aren't particularly accurate on btrfs.  Consider 
their output more a "best estimate given the rough data we have 
available" sort of report.

To get the real filesystem focused picture, use btrfs filesystem usage, 
or btrfs filesystem show combined with btrfs filesystem df.  That's what 
you should trust, altho various utilities that check for available space 
before doing something often use the kernel-call equivalent of (plain) df 
to ensure they have the required space, so it's worthwhile to keep an eye 
on it as the filesystem fills, as well.  If it gets too out of sync with 
btrfs filesystem usage, or if btrfs filesystem usage unallocated drops 
below say five gigs or data or metadata size vs used shows a spread of 
multiple gigs (your data shows a spread of ~20 gigs ATM, but with 377 
gigs still unallocated it's no big deal; it would be a big deal if those 
were reversed, tho, only 20 gigs unallocated and a spread of 300+ gigs in 
data size vs used), then corrective action such as a filtered rebalance 
may be necessary.

There are entries in the FAQ discussing free space issues that you should 
definitely read if you haven't, altho they obviously address the general 
case, so if you have more questions about an individual case after having 
read them, here is a good place to ask. =:^)

Everything having to do with "space" (see both the 1/Important-questions 
and 4/Common-questions sections) here:

https://btrfs.wiki.kernel.org/index.php/FAQ

Meanwhile, it's worth noting that not entirely intuitively, btrfs' COW 
implementation can "waste" space on larger files that are mostly, but not 
entirely, rewritten.  An example is the best way to demonstrate.  
Consider each x a used block and each - an unused but still referenced 
block:

Original file, written as a single extent (diagram works best with 
monospace, not arbitrarily rewrapped):

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

First rewrite of part of it:

xxxxxxxxxxx------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
           xxxxxx


Nth rewrite, where some blocks of the original still remain as originally 
written:

------------------xxx------------------------------
           xxx---
xxxx----xxx
    xxxx
                     xxxxxxxxxxxxxxxxxxxxx---xxxxxx
                                          xxx
              xxx


As you can see, that first really large extent remains fully referenced, 
altho only three blocks of it remain in actual use.  All those -- won't 
be returned to free space until those last three blocks get rewritten as 
well, thus freeing the entire original extent.

I believe this effect is what Austin was referencing when he suggested 
the defrag, tho defrag won't necessarily /entirely/ clear it up.  One way 
to be /sure/ it's cleared up would be to rewrite the entire file, 
deleting the original, either by copying it to a different filesystem and 
back (with the off-filesystem copy guaranteeing that it can't use reflinks 
to the existing extents), or by using cp's --reflink=never option.  
(FWIW, I prefer the former, just to be sure, using temporary copies to a 
suitably sized tmpfs for speed where possible, tho obviously if the file 
is larger than your memory size that's not possible.)

Of course where applicable, snapshots and dedup keep reflink-references 
to the old extents, so they must be adjusted or deleted as well, to 
properly free that space.

---
[1] du: Because its purpose is different.  du's primary purpose is 
telling you in detail what space files take up, per-file and per-
directory, without particular regard to usage on the filesystem itself.  
df's focus, by contrast, is on the filesystem as a whole.  So where two 
files share the same extent due to reflinking, du should and does count 
that usage for each file, because that's what each file /uses/ even if 
they both use the same extents.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

