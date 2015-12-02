Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54047 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbbLBKg4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 05:36:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a44mL-0002kC-1a
	for linux-btrfs@vger.kernel.org; Wed, 02 Dec 2015 11:36:53 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 11:36:53 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 11:36:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: compression disk space saving - what are your results?
Date: Wed, 2 Dec 2015 10:36:47 +0000 (UTC)
Message-ID: <pan$101f2$e235cddd$fea951cb$dcf70182@cox.net>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Wed, 02 Dec 2015 18:46:30 +0900 as excerpted:

> What are your disk space savings when using btrfs with compression?
> 
> I have a 200 GB btrfs filesystem which uses compress=zlib, only stores
> text files (logs), mostly multi-gigabyte files.
> 
> 
> It's a "single" filesystem, so "df" output matches "btrfs fi df":
> 
> # df -h Filesystem      Size  Used Avail Use% Mounted on (...)
> /dev/xvdb       200G  124G   76G  62% /var/log/remote
> 
> 
> # du -sh /var/log/remote/
> 153G    /var/log/remote/
> 
> 
>  From these numbers (124 GB used where data size is 153 GB), it appears
> that we save around 20% with zlib compression enabled.
> Is 20% reasonable saving for zlib? Typically text compresses much better
> with that algorithm, although I understand that we have several
> limitations when applying that on a filesystem level.

Here, just using compress=lzo, no compress-force and lzo not zlib, I'm 
mostly just happy to see lower usage than I was getting on reiserfs.  
Between that and no longer needing to worry whether copying a sparse file 
is going to end up sparse or not, because even if not the compression 
should effectively collapse the sparse areas, I've been happy /enough/ 
with it.


There's at least three additional factors to consider, for your case.

* There is of course metadata to consider as well as data, and on
single-device btrfs, metadata normally defaults to dup, 2X the space.  
You did say single, but didn't specify whether that was for metadata also 
(and for that matter, didn't specify whether it was a single-device 
filesystem or not, tho I assume it is).  And of course btrfs does 
checksumming that other filesystems don't do, and even puts small files 
in metadata too, all of which will be dup by default, taking even more 
space.

A btrfs fi df will of course give you separate data/metadata/system 
values, and you can take the data used value and compare that against the 
du -sh value to get a more accurate read on how well your compression 
really is working.  (Tho as noted, small files, a few KiB max, are often 
stored in the metadata, so if you have lots of those, you'd probably need 
to adjust for that, but you mentioned mostly GiB-scale files, so...)

* There's the compress vs. compress-force option and discussion.  A 
number of posters have reported that for mostly text, compress didn't 
give them expected compression results and they needed to use compress-
force.

Of course, changing the option now won't change how existing files are 
stored.  You'd have to either rewrite them, or wait for log rotation to 
rotate out the old files, to see the full effect.  Also see the btrfs fi 
defrag -c option.

* Talking about defrag, it's not snapshot aware, which brings up the 
question of whether you're using btrfs snapshots on this filesystem and 
the effect that would have if you do. 

I'll presume not, as that would seem to be important enough to mention in 
a discussion of this sort, if you were, and also because that allows me 
to simply handwave further discussion of this point away. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

