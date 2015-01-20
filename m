Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:40974 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbATAT2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 19:19:28 -0500
Message-ID: <54BD9F0A.6040100@huawei.com>
Date: Tue, 20 Jan 2015 08:19:22 +0800
From: Miao Xie <miaoxie@huawei.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen
 fs to avoid deadlock.
References: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="gbk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 19 Jan 2015 15:42:41 +0800, Qu Wenruo wrote:
> Commit 6b5fe46dfa52 (btrfs: do commit in sync_fs if there are pending
> changes) will call btrfs_start_transaction() in sync_fs(), to handle
> some operations needed to be done in next transaction.
> 
> However this can cause deadlock if the filesystem is frozen, with the
> following sys_r+w output:
> [  143.255932] Call Trace:
> [  143.255936]  [<ffffffff816c0e09>] schedule+0x29/0x70
> [  143.255939]  [<ffffffff811cb7f3>] __sb_start_write+0xb3/0x100
> [  143.255971]  [<ffffffffa040ec06>] start_transaction+0x2e6/0x5a0
> [btrfs]
> [  143.255992]  [<ffffffffa040f1eb>] btrfs_start_transaction+0x1b/0x20
> [btrfs]
> [  143.256003]  [<ffffffffa03dc0ba>] btrfs_sync_fs+0xca/0xd0 [btrfs]
> [  143.256007]  [<ffffffff811f7be0>] sync_fs_one_sb+0x20/0x30
> [  143.256011]  [<ffffffff811cbd01>] iterate_supers+0xe1/0xf0
> [  143.256014]  [<ffffffff811f7d75>] sys_sync+0x55/0x90
> [  143.256017]  [<ffffffff816c49d2>] system_call_fastpath+0x12/0x17
> [  143.256111] Call Trace:
> [  143.256114]  [<ffffffff816c0e09>] schedule+0x29/0x70
> [  143.256119]  [<ffffffff816c3405>] rwsem_down_write_failed+0x1c5/0x2d0
> [  143.256123]  [<ffffffff8133f013>] call_rwsem_down_write_failed+0x13/0x20
> [  143.256131]  [<ffffffff811caae8>] thaw_super+0x28/0xc0
> [  143.256135]  [<ffffffff811db3e5>] do_vfs_ioctl+0x3f5/0x540
> [  143.256187]  [<ffffffff811db5c1>] SyS_ioctl+0x91/0xb0
> [  143.256213]  [<ffffffff816c49d2>] system_call_fastpath+0x12/0x17
> 
> The reason is like the following:
> (Holding s_umount)
> VFS sync_fs staff:
> |- btrfs_sync_fs()
>    |- btrfs_start_transaction()
>       |- sb_start_intwrite()
>       (Waiting thaw_fs to unfreeze)
> 					VFS thaw_fs staff:
> 					thaw_fs()
> 					(Waiting sync_fs to release
> 					 s_umount)
> 
> So deadlock happens.
> This can be easily triggered by fstest/generic/068 with inode_cache
> mount option.
> 
> The fix is to check if the fs is frozen, if the fs is frozen, just
> return and waiting for the next transaction.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Reported-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 60f7cbe..1d9f1e6 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1000,6 +1000,14 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>  			 */
>  			if (fs_info->pending_changes == 0)
>  				return 0;


I think the problem is here -- why ->pending_changes is not 0 when the
filesystem is frozen? so I think the reason of this problem is btrfs_freeze
forget to deal with the pending changes, and the correct fix is to correct
the behavior of btrfs_freeze().

Thanks
Miao

> +			/*
> +			 * Test if the fs is frozen, or start_trasaction
> +			 * will deadlock on itself.
> +			 */
> +			if (__sb_start_write(sb, SB_FREEZE_FS, false))
> +				__sb_end_write(sb, SB_FREEZE_FS);
> +			else
> +				return 0;
>  			trans = btrfs_start_transaction(root, 0);
>  		} else {
>  			return PTR_ERR(trans);
> 

