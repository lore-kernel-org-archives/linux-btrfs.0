Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41998 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdEBFBR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 01:01:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d5Pvv-0006eE-S3
        for linux-btrfs@vger.kernel.org; Tue, 02 May 2017 07:01:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
Date: Tue, 2 May 2017 05:01:02 +0000 (UTC)
Message-ID: <pan$e2463$2d3d82e9$144941f3$9eeef2a4@cox.net>
References: <20170501170641.GG3516@merlins.org>
        <20170501180856.GH3516@merlins.org>
        <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
        <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Mon, 01 May 2017 20:23:46 -0700 as excerpted:

> Also, how is --mode=lowmem being useful?

FWIW, I just watched your talk that's linked from the wiki, and wondered 
what you were doing these days as I hadn't seen any posts from you here 
for awhile.

Well, that you're asking that question confirms you've not been following 
the list too closely...  Of course that's understandable as people have 
other stuff to do, but just sayin'.

The answer is... btrfs check in lowmem mode isn't simply lowmem, it's 
also effectively a very nearly entirely rewritten second implementation, 
which has already demonstrated its worth as it has already allowed 
finding and fixing a number of bugs in normal mode check.  Of course 
normal mode check has returned the favor a few times as well, so it is 
now reasonably standard list troubleshooting practice to ask for the 
output from both modes to see what and where they differ, especially if 
it's not something known to be directly fixable by normal mode, which of 
course remains the more mature default.

So even if neither one can actually fix the problem ATM, any differences 
in output both lend important clues to the real problem, and potentially 
help developers to find and fix bugs in one or the other implementation.

Tho it's worth noting that lowmem mode can be expected to take longer, as 
it favors lower memory usage over speed, just as the mode title suggests 
it will.  On a filesystem as big as yours... it may unfortunately not be 
entirely practical, especially if as you hint there's at least some time 
pressure here, tho it's not extreme.

Of course on-list I'm somewhat known for my arguments propounding the 
notion that any filesystem that's too big to be practically maintained 
(including time necessary to restore from backups, should that be 
necessary for whatever reason) is... too big... and should ideally be 
broken along logical and functional boundaries into a number of 
individual smaller filesystems until such point as each one is found to 
be practically maintainable within a reasonably practical time frame.  
Don't put all the eggs in one basket, and when the bottom of one of those 
baskets inevitably falls out, most of your eggs will be safe in other 
baskets. =:^)

But as someone else (pg, IIRC) on-list is fond of saying, lots of other 
people "know better" (TM).  Whatever.  It's your data, your systems and 
your time, not mine.  I just know what I've found (sometimes finding it 
the hard way!) to work best for me, and TBs on TBs of data on a single 
filesystem, even if it's a backup and is itself backed up, isn't 
something I'd be putting my own faith in, as the time even for a simple 
restore from backups is simply too high for me to consider it at all 
practical. =:^)

> And for re-parenting a sub-subvolume, is that possible?
> (I want to delete /sub1/ but I can't because I have /sub1/sub2 that's
> also a subvolume and I'm not sure how to re-parent sub2 to somewhere
> else so that I can subvolume delete sub1)

As I believe you know my own use-case doesn't deal with subvolumes and 
snapshots, so this may be of limited practicality, but FWIW, the 
sysadmin's guide discussion of snapshot management and special cases 
seems apropos as a first stop, before going further:

https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Managing_Snapshots

Note that toward the bottom of "management" it discusses moving 
subvolumes (which will obviously reparent them), but then below that in 
special cases it says that read-only subvolumes (and thus snapshots) 
cannot be moved, explaining why.


*BUT*, and here's the "go further" part, keep in mind that subvolume-read-
only is a property, gettable and settable by btrfs property.

So you should be able to unset the read-only property of a subvolume or 
snapshot, move it, then if desired, set it again.

Of course I wouldn't expect send -p to work with such a snapshot, but 
send -c /might/ still work, I'm not actually sure but I'd consider it 
worth trying.  (I'd try -p as well, but expect it to fail...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

