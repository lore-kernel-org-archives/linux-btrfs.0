Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:46255 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754081AbeDWJ2C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 05:28:02 -0400
Subject: Re: [PATCH 0/5] Remove delay_iput parameter when running delalloc
 work
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b4e0bd43-ad9e-55f5-4e33-7845fdb89270@gmx.com>
Date: Mon, 23 Apr 2018 17:27:49 +0800
MIME-Version: 1.0
In-Reply-To: <1524470057-21969-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月23日 15:54, Nikolay Borisov wrote:
> While trying to make sense of the lifecycle of delayed iputs it became apparent
> that the delay_iput parameter of btrfs_start_delalloc_roots/
> btrfs_start_delalloc_inodes is always set to 0. (Patch 1 contains historical 
> information of why this parameter was needed and when it became obsolete). Now
> that the code has changed sufficiently it's no longer required to have it so
> this series gradually removes it. 
> 
> Nikolay Borisov (5):
>   btrfs: Remove delayed_iput parameter of btrfs_start_delalloc_roots
>   btrfs: Remove delayed_iput parameter from btrfs_start_delalloc_inodes
>   btrfs: Remove delay_iput parameter from __start_delalloc_inodes
>   btrfs: Remove delayed_iput member from btrfs_delalloc_work
>   btrfs: Unexport btrfs_alloc_delalloc_work

Solid cleanup.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Just a little nitpick about the 3rd and 4th patch.
It would be nicer the merge them, as in the the 3rd patch
btrfs_alloc_delalloc_work() call still takes 0 as @delay_iput, but in
next patch the @delay_iput just get removed.

Thanks,
Qu

> 
>  fs/btrfs/ctree.h       |  9 ++-------
>  fs/btrfs/dev-replace.c |  2 +-
>  fs/btrfs/extent-tree.c |  4 ++--
>  fs/btrfs/inode.c       | 28 +++++++++-------------------
>  fs/btrfs/ioctl.c       |  4 ++--
>  5 files changed, 16 insertions(+), 31 deletions(-)
> 
