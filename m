Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:45623 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab2LSPDD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 10:03:03 -0500
Date: Wed, 19 Dec 2012 10:02:59 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't bother updating the inode when evicting
Message-ID: <20121219150259.GB4033@localhost.localdomain>
References: <1355863917-16932-1-git-send-email-jbacik@fusionio.com>
 <50D11F49.4070005@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50D11F49.4070005@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 06:58:33PM -0700, Miao Xie wrote:
> On tue, 18 Dec 2012 15:51:57 -0500, Josef Bacik wrote:
> > We're deleting the stupid thing, no sense in updating the inode for the new
> > size.  We're running into having 50-100 orphans left over with xfstests 83
> > because of ENOSPC when trying to start the transaction for the inode update.
> > This patch fixes this problem.  Thanks,
> 
> This patch is wrong, it will introduce the inconsonant metadata in the snapshot
> tree. The reason is folloing:
> 
> commit 8407aa464331556e4f6784f974030b83fc7585ed
> Author: Miao Xie <miaox@cn.fujitsu.com>
> Date:   Fri Sep 7 01:43:32 2012 -0600
> 
>     Btrfs: fix corrupted metadata in the snapshot
>     
>     When we delete a inode, we will remove all the delayed items including delayed
>     inode update, and then truncate all the relative metadata. If there is lots of
>     metadata, we will end the current transaction, and start a new transaction to
>     truncate the left metadata. In this way, we will leave a inode item that its
>     link counter is > 0, and also may leave some directory index items in fs/file tree
>     after the current transaction ends. In other words, the metadata in this fs/file tree
>     is inconsistent. If we create a snapshot for this tree now, we will find a inode with
>     corrupted metadata in the new snapshot, and we won't continue to drop the left metadata,
>     because its link counter is not 0.
>     
>     We fix this problem by updating the inode item before the current transaction ends.
>     
>     Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> 

So why don't we fix unlink to call btrfs_update_inode_item so that the nlink
counter is set to 0?  The orphan item will be carried over into the snapshot if
we don't actually evict the inode before we do the snapshot and then the orphan
cleanup will take care of the rest?  Thanks,

Josef
