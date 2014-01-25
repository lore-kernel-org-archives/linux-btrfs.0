Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56783 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaAYOMT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 09:12:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W73y6-0002rM-6l
	for linux-btrfs@vger.kernel.org; Sat, 25 Jan 2014 15:12:18 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 15:12:18 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 15:12:18 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Options for SSD - autodefrag etc?
Date: Sat, 25 Jan 2014 15:06:24 +0100
Message-ID: <00tcra-bh7.ln1@hurikhan77.spdns.de>
References: <52E19667.6090005@gmail.com> <t5uara-vp4.ln1@hurikhan77.spdns.de> <1730344.q7ECaAgUWV@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald <Martin@lichtvoll.de> schrieb:

> Okay, I have seen 260 MB/s. But frankly I am pretty sure that Virtuoso
> isn´t doing this kind of large scale I/O on a highly fragmented file. Its
> a database. Its random access. My oppinion is that Virtuoso couldn´t care
> less about the fragmentation of the file. As long as it is stored on the
> SSD.

I think it makes no real difference here since access to virtuoso is random 
anyway. And if I got you right you run it nocow, so upon writes you aren't 
introducing more fragmentation to the file. All is good... It probably would 
even be good with cow as virtuoso is read-most, so rarely written to. 

For VM images it might be a whole different story. The guest system sees a 
block device and expects it to be continuous. All optimizations for access 
patterns cannot work right if btrfs is constantly moving parts of the file 
around for doing cow. So make it nocow and all should be as good as it can 
get.

> Well… take this with caveat. This is LZO compressed, those 2,4 GiB / 128
> KiB gives at least about 20000 extents already provided that my
> calculation is correct. And these extents could be sequential (I doubt it
> tough also give the high free space fragmention I suspect to be on this
> FS).

Your CPU is more mighty than the flash chips. LZO improves read performance. 
But does it make sense on Intel drives? I think they already do compression.

> Anyway: I do not perceive any noticable performance issues due to file
> fragmentation on SSD and think that at least on highly filled BTRFS
> filesystem autodefrag may do more harm than good (like fragment free space
> and then let btrfs-delalloc go crazy on new allocations). I know xfs_fsr
> for defragmenting XFS in the background, even via cron job. And I think I
> remember Dave Chinner telling in some post that even for harddisks it may
> not be a very wise idea to run this frequently due to the risk to fragment
> free space.
> 
> There are several kinds of fragmentations. And defragmenting files may
> increase freespace fragmentation.

This is why I wondered if btrfs will be optimized for keeping free space 
together in the future for SSD. But it's not as simple as this. It should 
not scatter file blocks all over the disk just to fill tiny holes. It should 
try to keep file blocks together so the read-modify-write-erase cycle of 
SSDs can work optimally.

> Thus, I am not yet convinced regarding autodefrag on SSDs.

I think everything would be easier if btrfs exposed some stats about what 
the autodefrag thread is really doing...

-- 
Replies to list only preferred.

