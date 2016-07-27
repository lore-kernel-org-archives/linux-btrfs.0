Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26740 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751627AbcG0IgQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 04:36:16 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 344AB4295FA0
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 16:36:08 +0800 (CST)
Subject: Re: [PATCH v2] btrfs: fix fsfreeze hang caused by delayed iputs deal
To: <linux-btrfs@vger.kernel.org>
References: <20160727081036.5321-1-wangxg.fnst@cn.fujitsu.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <579871CC.8000103@cn.fujitsu.com>
Date: Wed, 27 Jul 2016 16:33:16 +0800
MIME-Version: 1.0
In-Reply-To: <20160727081036.5321-1-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 07/27/2016 04:10 PM, Wang Xiaoguang wrote:
> When running fstests generic/068, sometimes we got below deadlock:
>    xfs_io          D ffff8800331dbb20     0  6697   6693 0x00000080
>    ffff8800331dbb20 ffff88007acfc140 ffff880034d895c0 ffff8800331dc000
>    ffff880032d243e8 fffffffeffffffff ffff880032d24400 0000000000000001
>    ffff8800331dbb38 ffffffff816a9045 ffff880034d895c0 ffff8800331dbba8
>    Call Trace:
>    [<ffffffff816a9045>] schedule+0x35/0x80
>    [<ffffffff816abab2>] rwsem_down_read_failed+0xf2/0x140
>    [<ffffffff8118f5e1>] ? __filemap_fdatawrite_range+0xd1/0x100
>    [<ffffffff8134f978>] call_rwsem_down_read_failed+0x18/0x30
>    [<ffffffffa06631fc>] ? btrfs_alloc_block_rsv+0x2c/0xb0 [btrfs]
>    [<ffffffff810d32b5>] percpu_down_read+0x35/0x50
>    [<ffffffff81217dfc>] __sb_start_write+0x2c/0x40
>    [<ffffffffa067f5d5>] start_transaction+0x2a5/0x4d0 [btrfs]
>    [<ffffffffa067f857>] btrfs_join_transaction+0x17/0x20 [btrfs]
>    [<ffffffffa068ba34>] btrfs_evict_inode+0x3c4/0x5d0 [btrfs]
>    [<ffffffff81230a1a>] evict+0xba/0x1a0
>    [<ffffffff812316b6>] iput+0x196/0x200
>    [<ffffffffa06851d0>] btrfs_run_delayed_iputs+0x70/0xc0 [btrfs]
>    [<ffffffffa067f1d8>] btrfs_commit_transaction+0x928/0xa80 [btrfs]
>    [<ffffffffa0646df0>] btrfs_freeze+0x30/0x40 [btrfs]
>    [<ffffffff81218040>] freeze_super+0xf0/0x190
>    [<ffffffff81229275>] do_vfs_ioctl+0x4a5/0x5c0
>    [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
>    [<ffffffff810038cf>] ? syscall_trace_enter_phase1+0x11f/0x140
>    [<ffffffff81229409>] SyS_ioctl+0x79/0x90
>    [<ffffffff81003c12>] do_syscall_64+0x62/0x110
>    [<ffffffff816acbe1>] entry_SYSCALL64_slow_path+0x25/0x25
>
>  From this warning, freeze_super() already holds SB_FREEZE_FS, but
> btrfs_freeze() will call btrfs_commit_transaction() again, if
> btrfs_commit_transaction() finds that it has delayed iputs to handle,
> it'll start_transaction(), which will try to get SB_FREEZE_FS lock
> again, then deadlock occurs.
>
> The root cause is that in btrfs, sync_filesystem(sb) does not make
> sure all metadata is updated. There still maybe some codes adding
> delayed iputs, see below sample race window:
>
>           CPU1                                  |         CPU2
> |-> freeze_super()                             |
>      |-> sync_filesystem(sb);                   |
>      |                                          |-> cleaner_kthread()
>      |                                          |   |-> btrfs_delete_unused_bgs()
>      |                                          |       |-> btrfs_remove_chunk()
>      |                                          |           |-> btrfs_remove_block_group()
>      |                                          |               |-> btrfs_add_delayed_iput()
>      |                                          |
>      |-> sb->s_writers.frozen = SB_FREEZE_FS;   |
>      |-> sb_wait_write(sb, SB_FREEZE_FS);       |
>      |   acquire SB_FREEZE_FS lock.             |
>      |                                          |
>      |-> btrfs_freeze()                         |
>          |-> btrfs_commit_transaction()         |
>              |-> btrfs_run_delayed_iputs()      |
>              |   will handle delayed iputs,     |
>              |   that means start_transaction() |
>              |   will be called, which will try |
>              |   to get SB_FREEZE_FS lock.      |
>
> To fix this issue, in btrfs_commit_transaction(), if fs already is in SB_FREEZE_FS,
> we do not handle delayed iputs.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/transaction.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 948aa18..e6931d9 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2277,8 +2277,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>   
>   	kmem_cache_free(btrfs_trans_handle_cachep, trans);
>   
> +	/*
> +	 * If s_writers.frozen >= SB_FREEZE_FS, we can not handle delayed
> +	 * iputs, otherwise it'll result in deallock about SB_FREEZE_FS.
> + 	 */
>   	if (current != root->fs_info->transaction_kthread &&
> -	    current != root->fs_info->cleaner_kthread)
> +	    current != root->fs_info->cleaner_kthread &&
> +	    root->fs_info->sb->s_writers.frozen >= SB_FREEZE_FS)
>   		btrfs_run_delayed_iputs(root);
Sorry, I sent this too quickly...
Above deadlock still occurs, please wait a while.

Regards,
Xiaoguang Wang

>   
>   	return ret;



