Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49974 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3KDRJV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 12:09:21 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 841869A06AF
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Nov 2013 10:09:21 -0700 (MST)
Date: Mon, 4 Nov 2013 12:09:18 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 7/7] Btrfs: rename btrfs_start_all_delalloc_inodes
Message-ID: <20131104170918.GJ16855@localhost.localdomain>
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
 <1383578006-22691-8-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1383578006-22691-8-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 04, 2013 at 11:13:26PM +0800, Miao Xie wrote:
> rename the function -- btrfs_start_all_delalloc_inodes(), and make its
> name be compatible to btrfs_wait_ordered_roots(), since they are always
> used at the same place.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h       | 3 +--
>  fs/btrfs/dev-replace.c | 2 +-
>  fs/btrfs/extent-tree.c | 2 +-
>  fs/btrfs/inode.c       | 3 +--
>  fs/btrfs/relocation.c  | 2 +-
>  fs/btrfs/transaction.c | 2 +-
>  6 files changed, 6 insertions(+), 8 deletions(-)
> 

Theres another use in ioctl.c in my tree, I've just rebased that change in,
please check my tree when I push it to make sure I did it right.  Thanks,

Josef
