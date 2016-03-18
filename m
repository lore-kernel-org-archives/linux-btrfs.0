Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36901 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069AbcCRNha (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 09:37:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aguaU-0003HK-GF
	for linux-btrfs@vger.kernel.org; Fri, 18 Mar 2016 14:37:20 +0100
Received: from 168.159.160.61 ([168.159.160.61])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 14:37:10 +0100
Received: from toyours_sridhar by 168.159.160.61 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 14:37:10 +0100
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: Re: Blocks changed since previous snapshot of subvolume
Date: Fri, 18 Mar 2016 13:36:50 +0000 (UTC)
Message-ID: <loom.20160318T133531-909@post.gmane.org>
References: <1458211640-13106-1-git-send-email-dsterba@suse.com> <loom.20160317T145003-730@post.gmane.org> <loom.20160317T213216-965@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager <eye1tm <at> gmail.com> writes:

> 
> sri <toyours_sridhar <at> yahoo.co.in> writes:
> 
> > 
> > Hi,
> > 
> > I Would like to know between 2 snapshots of a subvolume, can we 
identify 
> > what all blocks modified particular to that subvolume ?
> > 
> > there can be many subvolume and snapshots present on the btrfs but i 
want 
> > only blocks modified since first snapshot for the specific 
subvolume.
> > 
> > blocks should include metadata and data blocks. 
> 
> Not directly diff blocks, rather files, you could do something like 
this:
> 
> btrfs subvolume find-new <newer_snapshot> `btrfs subvolume show 
> <older_snapshot> | grep Generation | awk '{print $2}'` |  awk '{ print 
$17 }' 
> | sort | uniq
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Thank you. As I checked only blocks related to file are shown. 

sample output:

btrfs subvolume find-new snap2 15
inode 264 file offset 0 len 8192 disk start 351559680 offset 0 gen 16 
flags NONE mman.h
inode 265 file offset 0 len 8192 disk start 351567872 offset 0 gen 16 
flags NONE mount.h
inode 266 file offset 0 len 2374 disk start 0 offset 0 gen 16 flags 
INLINE msg.h
inode 267 file offset 0 len 12288 disk start 351576064 offset 0 gen 16 
flags NONE mtio.h
transid marker was 16


I think it showed blocks changed w.r.t file data block.

is there a way to get other blocks modified such as meta data such as 
inodes blocks modified and corresponding directory inode blocks along 
with files?

Above fs is created on 2 disks /dev/sdd and /dev/sdd of 3 gb.  No raid 
configured. I think it is just strped with 6gb size around.

How should I interpret:
inode 266 file offset 0 len 2374 disk start 0 offset 0 gen 16 flags 
INLINE msg.h

??

disk start is 0 here. Is this w.r.t what?

and offset 0 is offset inside block represented by disk start ?


thank you.







