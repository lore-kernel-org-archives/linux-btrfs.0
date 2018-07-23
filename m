Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55032 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388053AbeGWOV3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:21:29 -0400
Date: Mon, 23 Jul 2018 15:20:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: fix btrfs_write_inode() vs delayed iput deadlock
Message-ID: <20180723132005.GK26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d0e0a0ac06a6479fd305c170cb64a33f3b16ff93.1532112361.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d0e0a0ac06a6479fd305c170cb64a33f3b16ff93.1532112361.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2018 at 11:46:10AM -0700, Omar Sandoval wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We recently ran into the following deadlock involving
> btrfs_write_inode():
> 
> [  +0.005066]  __schedule+0x38e/0x8c0
> [  +0.007144]  schedule+0x36/0x80
> [  +0.006447]  bit_wait+0x11/0x60
> [  +0.006446]  __wait_on_bit+0xbe/0x110
> [  +0.007487]  ? bit_wait_io+0x60/0x60
> [  +0.007319]  __inode_wait_for_writeback+0x96/0xc0
> [  +0.009568]  ? autoremove_wake_function+0x40/0x40
> [  +0.009565]  inode_wait_for_writeback+0x21/0x30
> [  +0.009224]  evict+0xb0/0x190
> [  +0.006099]  iput+0x1a8/0x210
> [  +0.006103]  btrfs_run_delayed_iputs+0x73/0xc0
> [  +0.009047]  btrfs_commit_transaction+0x799/0x8c0
> [  +0.009567]  btrfs_write_inode+0x81/0xb0
> [  +0.008008]  __writeback_single_inode+0x267/0x320
> [  +0.009569]  writeback_sb_inodes+0x25b/0x4e0
> [  +0.008702]  wb_writeback+0x102/0x2d0
> [  +0.007487]  wb_workfn+0xa4/0x310
> [  +0.006794]  ? wb_workfn+0xa4/0x310
> [  +0.007143]  process_one_work+0x150/0x410
> [  +0.008179]  worker_thread+0x6d/0x520
> [  +0.007490]  kthread+0x12c/0x160
> [  +0.006620]  ? put_pwq_unlocked+0x80/0x80
> [  +0.008185]  ? kthread_park+0xa0/0xa0
> [  +0.007484]  ? do_syscall_64+0x53/0x150
> [  +0.007837]  ret_from_fork+0x29/0x40
> 
> Writeback calls btrfs_write_inode(), which calls
> btrfs_commit_transaction(), which calls btrfs_run_delayed_iputs(). If
> iput() is called on that same inode, evict() will wait for writeback
> forever.
> 
> btrfs_write_inode() was originally added way back in 4730a4bc5bf3
> ("btrfs_dirty_inode") to support O_SYNC writes. However, ->write_inode()
> hasn't been used for O_SYNC since 148f948ba877 ("vfs: Introduce new
> helpers for syncing after writing to O_SYNC file or IS_SYNC inode"), so
> btrfs_write_inode() is actually unnecessary (and leads to a bunch of
> unnecessary commits). Get rid of it, which also gets rid of the
> deadlock.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> [Omar: new commit message]
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Thank, added to current 4.19 queue and I'll add tags for stable.
