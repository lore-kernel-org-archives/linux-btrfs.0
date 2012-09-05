Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:47904 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab2IER6J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Sep 2012 13:58:09 -0400
Date: Wed, 5 Sep 2012 13:58:05 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: David Sterba <dave@jikos.cz>
CC: Miao Xie <miaox@cn.fujitsu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 6/7] Btrfs: fix corrupted metadata in the snapshot
Message-ID: <20120905175805.GA1895@localhost.localdomain>
References: <503D96DC.7050701@cn.fujitsu.com>
 <20120905163205.GN17430@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120905163205.GN17430@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 05, 2012 at 10:32:05AM -0600, David Sterba wrote:
> On Wed, Aug 29, 2012 at 12:13:16PM +0800, Miao Xie wrote:
> > When we delete a inode, we will remove all the delayed items including delayed
> > inode update, and then truncate all the relative metadata. If there is lots of
> > metadata, we will end the current transaction, and start a new transaction to
> > truncate the left metadata. In this way, we will leave a inode item that its
> > link counter is > 0, and also may leave some directory index items in fs/file tree
> > after the current transaction ends. In other words, the metadata in this fs/file tree
> > is inconsistent. If we create a snapshot for this tree now, we will find a inode with
> > corrupted metadata in the new snapshot, and we won't continue to drop the left metadata,
> > because its link counter is not 0.
> > 
> > We fix this problem by updating the inode item before the current transaction ends.
> 
> A comment before the while() says
> 
> 3780         /*
> 3781          * This is a bit simpler than btrfs_truncate since
> 3782          *
> 3783          * 1) We've already reserved our space for our orphan item in the
> 3784          *    unlink.
> 3785          * 2) We're going to delete the inode item, so we don't need to update
> 3786          *    it at all.
> 3787          *
> 3788          * So we just need to reserve some slack space in case we add bytes when
> 3789          * doing the truncate.
> 3790          */
> 
> Point 2 states that the inode update is not needed, but as you write in the
> changelog it can lead to inconsistent metadata. I can't say either way, but
> rather would like to hear Josef's oppinion on that, as the comment and related
> code comes from
> 4289a667a0d7c6b134898cac7bfbe950267c305c
> (Btrfs: fix how we reserve space for deleting inodes)
> 

Yeah I was wrong and Miao is right, we need to update the inode if we stop the
transaction just for consistency sake.  We're not quite doing the right thing
for enospc here but thats a problem for a later date.  Thanks,

Josef
