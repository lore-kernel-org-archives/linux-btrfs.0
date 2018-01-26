Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38582 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbeAZOVN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:21:13 -0500
Received: by mail-qt0-f195.google.com with SMTP id z10so1597859qti.5
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:21:13 -0800 (PST)
Date: Fri, 26 Jan 2018 09:21:11 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix use-after-free on root->orphan_block_rsv
Message-ID: <20180126142110.srvh55d733hfaxaj@destiny>
References: <20180125180256.10844-7-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-7-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:54AM -0700, Liu Bo wrote:
> I got these from running generic/475,
> 
> WARNING: CPU: 0 PID: 26384 at fs/btrfs/inode.c:3326 btrfs_orphan_commit_root+0x1ac/0x2b0 [btrfs]
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> IP: btrfs_block_rsv_release+0x1c/0x70 [btrfs]
> Call Trace:
>   btrfs_orphan_release_metadata+0x9f/0x200 [btrfs]
>   btrfs_orphan_del+0x10d/0x170 [btrfs]
>   btrfs_setattr+0x500/0x640 [btrfs]
>   notify_change+0x7ae/0x870
>   do_truncate+0xca/0x130
>   vfs_truncate+0x2ee/0x3d0
>   do_sys_truncate+0xaf/0xf0
>   SyS_truncate+0xe/0x10
>   entry_SYSCALL_64_fastpath+0x1f/0x96
> 
> The race is between btrfs_orphan_commit_root and btrfs_orphan_del,
>         t1                                        t2
> btrfs_orphan_commit_root                     btrfs_orphan_del
>    spin_lock
>    check (&root->orphan_inodes)
>    root->orphan_block_rsv = NULL;
>    spin_unlock
>                                              atomic_dec(&root->orphan_inodes);
>                                              access root->orphan_block_rsv
> 
> Accessing root->orphan_block_rsv must be done before decreasing
> root->orphan_inodes.
> 
> cc: <stable@vger.kernel.org> v3.12+
> Fixes: 703c88e03524 ("Btrfs: fix tracking of orphan inode count")
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
