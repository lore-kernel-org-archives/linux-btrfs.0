Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34216 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbbDQJ4Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 05:56:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yj30R-0006gH-AW
	for linux-btrfs@vger.kernel.org; Fri, 17 Apr 2015 11:56:15 +0200
Received: from 168.159.160.54 ([168.159.160.54])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 11:56:15 +0200
Received: from toyours_sridhar by 168.159.160.54 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 11:56:15 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: Re: how many chunk trees and extent trees present
Date: Fri, 17 Apr 2015 09:56:07 +0000 (UTC)
Message-ID: <loom.20150417T115204-272@post.gmane.org>
References: <loom.20150417T081705-332@post.gmane.org> <20150417091911.GK22084@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:

> 
> On Fri, Apr 17, 2015 at 06:24:05AM +0000, sri wrote:
> > Hi,
> > I have below queries. Could somebody help me in understanding.
> > 
> > 1)
> > As per my understanding btrfs file system uses one chunk tree and 
one 
> > extent tree for entire btrfs disk allocation.
> > 
> > Is this correct?
> 
>    Yes.
> 
> > In, some article i read that future there will be more chunk tree/ 
extent 
> > tree for single btrfs. Is this true.
> 
>    I recall, many moons ago, Chris saying that there probably wouldn't
> be.
> 
> > If yes, I would like to know why more than one chunk / extent tree 
is 
> > required to represent one btrfs file system.
> 
>    I think the original idea was that it would reduce lock contention
> on the tree root.
> 
> > 2)
> > 
> > Also I would like to know for a subvolume / snapshot , is there a 
> > provision to ask btrfs , represent all blocks belongs to that 
> > subvolume/snapshot should handle with a separate chunk tree and 
extent 
> > tree?
> 
>    No.
> 
> > I am looking for a way to traverse a subvolume preferably a snapshot 
and 
> > identify all disk blocks (extents) allocated for that particular 
subvolume 
> > / snapshot.
> 
>    Do you mean allocated to any file in the subvolume, or do you mean
> *exclusively* allocated to that subvolume and not shared with any
> other?
> 
>    The former is easy -- just walk the file tree, and read the extents
> for each file. The latter is harder, because you have to look for
> extents that are not shared, and extents that are only shared within
> the current subvolume (think reflink copies within a subvol). I think
> you can do that by counting backrefs, but there may be big race
> conditions involved on a filesystem that's being written to (because
> the backrefs aren't created immediately, but delayed for performance
> reasons).
> 
>    Note that if all you want is the count of those blocks (rather than
> the block numbers themselves), then it's already been done with
> qgroups, and you don't need to write any btrfs code at all.
> 
>    What exactly are you going to be doing with this information?
> 
>    Hugo.
> 

I am trying a way to get all files and folders of a snapshot volume 
without making file system level calls (fopen etc..) 

I want to write code to understand the corresponding snapshot btree and 
used related chunk tree and extent tree, and find out for each file 
(inode) all extent blocks. 
If I want to backup, I will use above method to traverse snapshot 
subvolume at disk level and copy all blocks of files/directories.

Thank you
sri


