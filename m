Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33597 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbeDEQNf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 12:13:35 -0400
Date: Thu, 5 Apr 2018 18:11:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: clean up resources during umount after trans is
 aborted
Message-ID: <20180405161106.GH2635@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522447918-19147-2-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522447918-19147-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 31, 2018 at 06:11:56AM +0800, Liu Bo wrote:
> Currently if some fatal errors occur, like all IO get -EIO, resources
> would be cleaned up when
> a) transaction is being committed or
> b) BTRFS_FS_STATE_ERROR is set
> 
> However, in some rare cases, resources may be left alone after transaction
> gets aborted and umount may run into some ASSERT(), e.g.
> ASSERT(list_empty(&block_group->dirty_list));
> 
> For case a), in btrfs_commit_transaciton(), there're several places at the
> beginning where we just call btrfs_end_transaction() without cleaning up
> resources.  For case b), it is possible that the trans handle doesn't have
> any dirty stuff, then only trans hanlde is marked as aborted while
> BTRFS_FS_STATE_ERROR is not set, so resources remain in memory.
> 
> This makes btrfs also check BTRFS_FS_STATE_TRANS_ABORTED to make sure that
> all resources won't stay in memory after umount.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Is it possible that the following stactrace could be caused by the
missing check? It roughly matches what you describe (ie. close_ctree and
unreleased resources). This is from generic/475, that does some error
injection:

[16991.455178] WARNING: CPU: 6 PID: 23518 at fs/btrfs/extent-tree.c:9896 btrfs_free_block_groups+0x2c8/0x420 [btrfs]

[16991.621105]  close_ctree+0x114/0x2d0 [btrfs]
[16991.625482]  generic_shutdown_super+0x6c/0x120
[16991.630025]  kill_anon_super+0xe/0x20
[16991.633820]  btrfs_kill_super+0x13/0x100 [btrfs]
[16991.638550]  deactivate_locked_super+0x3f/0x70
[16991.643332]  cleanup_mnt+0x3b/0x70
[16991.646889]  task_work_run+0x89/0xa0
[16991.650565]  exit_to_usermode_loop+0x79/0xa3
[16991.654985]  do_syscall_64+0xe9/0x110
[16991.658841]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
