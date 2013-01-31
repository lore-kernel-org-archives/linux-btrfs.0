Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:36602 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3AaQkr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 11:40:47 -0500
Date: Thu, 31 Jan 2013 11:40:41 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: serialize unlocked dio reads with truncate
Message-ID: <20130131164041.GP3660@localhost.localdomain>
References: <510A3807.1040306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <510A3807.1040306@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 02:23:19AM -0700, Miao Xie wrote:
> Currently, we can do unlocked dio reads, but the following race
> is possible:
> 
> dio_read_task			truncate_task
> 				->btrfs_setattr()
> ->btrfs_direct_IO
>     ->__blockdev_direct_IO
>       ->btrfs_get_block
> 				  ->btrfs_truncate()
> 				 #alloc truncated blocks
> 				 #to other inode
>       ->submit_io()
>      #INFORMATION LEAK
> 
> In order to avoid this problem, we must serialize unlocked dio reads with
> truncate by inode_dio_wait().
> 

So I had thinking about this, are we sure we don't want to just lock the extent
range when we truncate?  I'm good with this, but it seems like we might as well
and be consistent and use the extent locks.  What do you think?  Thanks,

Josef
