Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22872 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab3B0Aim (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 19:38:42 -0500
Date: Wed, 27 Feb 2013 08:37:08 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Josef Bacik <jbacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/inode.c:2165
 btrfs_orphan_commit_root+0xcb/0xdf()
Message-ID: <20130227003707.GA7028@liubo>
Reply-To: bo.li.liu@oracle.com
References: <20130225025546.GC14143@merlins.org>
 <20130226142043.GD19641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130226142043.GD19641@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 09:20:43AM -0500, Josef Bacik wrote:
> On Sun, Feb 24, 2013 at 07:55:46PM -0700, Marc MERLIN wrote:
> > Is this useful to anyone?
> > 
> > Got this after a crash/reboot:
> > 
> > 	if (block_rsv) {
> > 		WARN_ON(block_rsv->size > 0);  <<<<<<<<<<<<<<<<<<<<<<
> > 		btrfs_free_block_rsv(root, block_rsv);
> > 	}
> > 
> 
> Fixed in btrfs-next, thanks for reporting!

FYI, the commit Josef mentioned is

Btrfs: cleanup orphan reservation if truncate fails
http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-next.git;a=commit;h=4a7d0f6854c4a4ad1dba00a3b128a32d39b9a742

(Correct me if it is wrong.)

thanks,
liubo

> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
