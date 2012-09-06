Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:51101 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2IFNJR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 09:09:17 -0400
Date: Thu, 6 Sep 2012 09:09:14 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 07/12] Btrfs: fix corrupted metadata in the snapshot
Message-ID: <20120906130914.GA18438@localhost.localdomain>
References: <504874D8.60001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <504874D8.60001@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2012 at 04:03:04AM -0600, Miao Xie wrote:
> When we delete a inode, we will remove all the delayed items including delayed
> inode update, and then truncate all the relative metadata. If there is lots of
> metadata, we will end the current transaction, and start a new transaction to
> truncate the left metadata. In this way, we will leave a inode item that its
> link counter is > 0, and also may leave some directory index items in fs/file tree
> after the current transaction ends. In other words, the metadata in this fs/file tree
> is inconsistent. If we create a snapshot for this tree now, we will find a inode with
> corrupted metadata in the new snapshot, and we won't continue to drop the left metadata,
> because its link counter is not 0.
> 
> We fix this problem by updating the inode item before the current transaction ends.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> Changelog v1 -> v4:
> - Update the comment of the truncation in the btrfs_evict_inode()
> - Fix enospc problem of the inode update

This isn't the right way to do the enospc fix, we need to do

btrfs_start_transaction(root, 1); and then change the trans->block_rsv to our
reserve for the truncate and then set it back to the trans rsv for the update
that way we don't run out of space because we used our reservation for the
truncate.  Just update this patch and send it along and I'll include it.
Thanks,

Josef
