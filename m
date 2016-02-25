Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41841 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760446AbcBYMRY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 07:17:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aYurC-0001eJ-5b
	for linux-btrfs@vger.kernel.org; Thu, 25 Feb 2016 13:17:22 +0100
Received: from 168.159.160.53 ([168.159.160.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 13:17:22 +0100
Received: from toyours_sridhar by 168.159.160.53 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 13:17:22 +0100
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: Re: how many chunk trees and extent trees present
Date: Thu, 25 Feb 2016 12:16:59 +0000 (UTC)
Message-ID: <loom.20160225T125826-47@post.gmane.org>
References: <loom.20150417T081705-332@post.gmane.org> <20150417091911.GK22084@carfax.org.uk> <loom.20150417T115204-272@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do you mean allocated to any file in the subvolume, or do you mean
> > *exclusively* allocated to that subvolume and not shared with any
> > other?

Hi,
Like ext3/ext4, I can find all used blocks of the file system. Once 
identified, I can just copy those blocks for backup. The bit map 
provided by ext3/ext4 includes blocks allocated for both metadata and 
data, backup/recovery won't consume much space.

For btrfs, multiple subvolumes can be created on pool of disks and each 
subvolume can consider as individual file system, I want to know a 
mechanism of identifying blocks allocated for the the subvolume through 
its snapshot so that for recovery, i can able to recovery those blocks 
only.

If btrfs is created on 10 disks each of 100gb and one subvolume is 10GB, 
backup window will be less for just backing up the subvolume.

I checked btrfs send/receive but the problem with send/receive is
1. It is file level dump
2. previous snapshot should be present to get incremental otherwise it 
generates full backup again.


sri <toyours_sridhar <at> yahoo.co.in> writes:

> 
> Hugo Mills <hugo <at> carfax.org.uk> writes:
> 
> > 
> > On Fri, Apr 17, 2015 at 06:24:05AM +0000, sri wrote:
> > > Hi,
> > > I have below queries. Could somebody help me in understanding.
> > > 
> > > 1)
> > > As per my understanding btrfs file system uses one chunk tree and 
> one 
> > > extent tree for entire btrfs disk allocation.
> > > 
> > > Is this correct?
> > 
> >    Yes.
> > 
> > > In, some article i read that future there will be more chunk tree/ 
> extent 
> > > tree for single btrfs. Is this true.
> > 
> >    I recall, many moons ago, Chris saying that there probably 
wouldn't
> > be.
> > 
> > > If yes, I would like to know why more than one chunk / extent tree 
> is 
> > > required to represent one btrfs file system.
> > 
> >    I think the original idea was that it would reduce lock 
contention
> > on the tree root.
> > 
> > > 2)
> > > 
> > > Also I would like to know for a subvolume / snapshot , is there a 
> > > provision to ask btrfs , represent all blocks belongs to that 
> > > subvolume/snapshot should handle with a separate chunk tree and 
> extent 
> > > tree?
> > 
> >    No.
> > 
> > > I am looking for a way to traverse a subvolume preferably a 
snapshot 
> and 
> > > identify all disk blocks (extents) allocated for that particular 
> subvolume 
> > > / snapshot.
> > 
> >    Do you mean allocated to any file in the subvolume, or do you 
mean
> > *exclusively* allocated to that subvolume and not shared with any
> > other?
> > 
> >    The former is easy -- just walk the file tree, and read the 
extents
> > for each file. The latter is harder, because you have to look for
> > extents that are not shared, and extents that are only shared within
> > the current subvolume (think reflink copies within a subvol). I 
think
> > you can do that by counting backrefs, but there may be big race
> > conditions involved on a filesystem that's being written to (because
> > the backrefs aren't created immediately, but delayed for performance
> > reasons).
> > 
> >    Note that if all you want is the count of those blocks (rather 
than
> > the block numbers themselves), then it's already been done with
> > qgroups, and you don't need to write any btrfs code at all.
> > 
> >    What exactly are you going to be doing with this information?
> > 
> >    Hugo.
> > 
> 
> I am trying a way to get all files and folders of a snapshot volume 
> without making file system level calls (fopen etc..) 
> 
> I want to write code to understand the corresponding snapshot btree 
and 
> used related chunk tree and extent tree, and find out for each file 
> (inode) all extent blocks. 
> If I want to backup, I will use above method to traverse snapshot 
> subvolume at disk level and copy all blocks of files/directories.
> 
> Thank you
> sri
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 




