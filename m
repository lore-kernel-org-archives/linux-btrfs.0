Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39595 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbbFXKqg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 06:46:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z7iCN-00073r-6k
	for linux-btrfs@vger.kernel.org; Wed, 24 Jun 2015 12:46:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 12:46:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 12:46:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: counting fragments takes more time than defragmenting
Date: Wed, 24 Jun 2015 10:46:22 +0000 (UTC)
Message-ID: <pan$5335b$94315604$8405c6ac$de90de30@cox.net>
References: <20150604084245.GR23272@merlins.org>
	<20150624032008.GF20517@merlins.org>
	<CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrik Lundquist posted on Wed, 24 Jun 2015 10:28:09 +0200 as excerpted:

> But what doesn't make sense to me is btrfs fi defrag; the -t option says
> 
>            -t <size>
>                defragment only files at least <size> bytes big
> 
> The -t value goes into struct
> btrfs_ioctl_defrag_range_args.extent_thresh which is documented as
> 
>        /*
>          * any extent bigger than this will be considered * already
>          defragged.  Use 0 to take the kernel default * Use 1 to say
>          every single extent must be rewritten */
> 
> Default extent_thresh is 256K. I can't see how 1 would say every single
> extent must be rewritten. On the contrary; 1 skips every extent. The
> compress flag even sets extent_thresh=(u32)-1 to force a rewrite.
> 
> Marc, try btrfs fi defrag -t 4294967295 Win7.vdi for maximum defrag and
> time filefrag again with fewer extents.

The manpage wording for btrfs fi defrag -t has been debated on-list 
several times, and I believe remains (as of btrfs-progs v4.1) confusing 
still.

First, under the general defragment description, before the individual 
options, it says:

>>>> Any extent bigger than threshold given by -t option, will be
>>>> considered already defragged. Use 0 to take the kernel default.

So according to that, an extent BIGGER than -t is treated as already 
defragged (it defrags SMALLER extents)

But, under the -t option, it says:

>>>> -t <size>[kKmMgGtTpPeE]
>>>>     defragment only files at least <size> bytes big

So according to that, only extents BIGGER than -t are defragged (smaller 
is ignored).

Again, that's the btrfs-filesystem (8) manpage as of -progs 4.1.

So which is it?  The manpage itself can't make up its mind.


AFAIK, it's set huge to defrag everything, but last time I posted on this 
I got it wrong, and I don't remember for sure what I said then, so... try 
it and see to be sure, which is what I'd do.

Meanwhile, it's worth noting that btrfs data chunks are normally 1 GiB 
(tho apparently they can be bigger under certain circumstances).  1 
extent per chunk is the best btrfs normally does, which means 1 GiB per 
extent is nominally the best that can be done, with the first and last 
extent possibly less than a gig (the first taking up the remainder of a 
partially used chunk and the last finishing up the file, which probably 
won't end on an even chunk boundary).

Assuming "set a huge -t to defrag to the maximum extent possible" is 
correct, that means -t 1G should be exactly as effective as -t 1T...

Regardless of whether 1 or huge -t means maximum defrag, however, the 
nominal data chunk size of 1 GiB means that 30 GiB file you mentioned 
should be considered ideally defragged at 31 extents.  This is a 
departure from ext4, which AFAIK in theory has no extent upper limit, so 
should be able to do that 30 GiB file in a single extent.

But btrfs or ext4, 31 extents ideal or a single extent ideal, 150 extents 
still indicates at least some remaining fragmentation.

Finally, last I remember, filefrag didn't understand btrfs compression 
(which is off for nocow, so this shouldn't apply there), which uses 128 
KiB blocks IIRC.  Until it does, large btrfs-compressed files will always 
show many extents 8/MiB, so thousands on anything even close to a GiB, 
tens of thousands on multiple GiBs).  But I believe there had been some 
work to teach filefrag about btrfs compression, tho I don't know if it 
has made it into an e2fsprogs release, yet.  If so, it'll be pretty close 
to the latest release.  So anything but the latest filefrag won't be 
accurate with btrfs-compressed files, while the latest may now be 
accurate, or not, I'm not sure.  I guess one could check e2fsprogs' 
release notes...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

