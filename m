From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: please review snapshot corruption path with delayed metadata
 insertion
Date: Fri, 01 Jul 2011 17:11:28 +0900
Message-ID: <4E0D8130.8040101@jp.fujitsu.com>
References: <1308345034-sup-1969@shiny> <4DFD7C63.6040902@jp.fujitsu.com> <4DFE8933.7040101@jp.fujitsu.com> <20110621002435.GK12709@twin.jikos.cz> <1308616798-sup-2605@shiny> <4DFFF0B2.1070403@jp.fujitsu.com> <4E0C186C.8060101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, David Sterba <dave@jikos.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0C186C.8060101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Miao,

(2011/06/30 15:32), Miao Xie wrote:
> Hi, Itoh-san
> 
> Could you test the following patch to check whether it can fix the bug or not?
> I have tested it on my x86_64 machine by your test script for two days, it worked well.

I ran my test script about a day, I was not able to reproduce this BUG.

Thanks,
Tsutomu

> 
> Thanks
> Miao
> 
> Subject: [PATCH] btrfs: fix oops when doing space balance
> 
> When doing space balance, the following oops happened.
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/relocation.c:4303!
> [SNIP]
> Call Trace:
>  [<ffffffffa03143fd>] ? update_ref_for_cow+0x22d/0x330 [btrfs]
>  [<ffffffffa0314951>] __btrfs_cow_block+0x451/0x5e0 [btrfs]
>  [<ffffffffa031355d>] ? read_block_for_search+0x14d/0x4d0 [btrfs]
>  [<ffffffffa0314beb>] btrfs_cow_block+0x10b/0x240 [btrfs]
>  [<ffffffffa031acae>] btrfs_search_slot+0x49e/0x7a0 [btrfs]
>  [<ffffffffa032d8af>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
>  [<ffffffff8147bf0e>] ? mutex_lock+0x1e/0x50
>  [<ffffffffa0380cf1>] btrfs_update_delayed_inode+0x71/0x160 [btrfs]
>  [<ffffffffa037ff27>] ? __btrfs_release_delayed_node+0x67/0x190 [btrfs]
>  [<ffffffffa0381cf8>] btrfs_run_delayed_items+0xe8/0x120 [btrfs]
>  [<ffffffffa03365e0>] btrfs_commit_transaction+0x250/0x850 [btrfs]
>  [<ffffffff810f91d9>] ? find_get_pages+0x39/0x130
>  [<ffffffffa0336cd5>] ? join_transaction+0x25/0x250 [btrfs]
>  [<ffffffff81081de0>] ? wake_up_bit+0x40/0x40
>  [<ffffffffa03785fa>] prepare_to_relocate+0xda/0xf0 [btrfs]
>  [<ffffffffa037f2bb>] relocate_block_group+0x4b/0x620 [btrfs]
>  [<ffffffffa0334cf5>] ? btrfs_clean_old_snapshots+0x35/0x150 [btrfs]
>  [<ffffffffa037fa43>] btrfs_relocate_block_group+0x1b3/0x2e0 [btrfs]
>  [<ffffffffa0368ec0>] ? btrfs_tree_unlock+0x50/0x50 [btrfs]
>  [<ffffffffa035e39b>] btrfs_relocate_chunk+0x8b/0x670 [btrfs]
>  [<ffffffffa031303d>] ? btrfs_set_path_blocking+0x3d/0x50 [btrfs]
>  [<ffffffffa03577d8>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
>  [<ffffffffa031bea1>] ? btrfs_previous_item+0xb1/0x150 [btrfs]
>  [<ffffffffa03577d8>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
>  [<ffffffffa035f5aa>] btrfs_balance+0x21a/0x2b0 [btrfs]
>  [<ffffffffa0368898>] btrfs_ioctl+0x798/0xd20 [btrfs]
>  [<ffffffff8111e358>] ? handle_mm_fault+0x148/0x270
>  [<ffffffff814809e8>] ? do_page_fault+0x1d8/0x4b0
>  [<ffffffff81160d6a>] do_vfs_ioctl+0x9a/0x540
>  [<ffffffff811612b1>] sys_ioctl+0xa1/0xb0
>  [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
> [SNIP]
> RIP  [<ffffffffa037c1cc>] btrfs_reloc_cow_block+0x22c/0x270 [btrfs]
> 
> It is because the data relocation inode delayed to be updated, and it triggered
> BUG_ON() when doing space balance. So we fix it by doing real-time update.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 447612d..13b2c04 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2678,12 +2678,15 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
>  	int ret;
>  
>  	/*
> -	 * If root is tree root, it means this inode is used to
> -	 * store free space information. And these inodes are updated
> -	 * when committing the transaction, so they needn't delaye to
> -	 * be updated, or deadlock will occured.
> +	 * If the inode is a free space inode. they needn't delayed to be
> +	 * updated, because these inodes are updated when committing the
> +	 * transaction, or deadlock will occured.
> +	 *
> +	 * Besides that, the data relocation inode is also needn't delayed
> +	 * to be updated.
>  	 */
> -	if (!is_free_space_inode(root, inode)) {
> +	if (!is_free_space_inode(root, inode)
> +	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {
>  		ret = btrfs_delayed_update_inode(trans, root, inode);
>  		if (!ret)
>  			btrfs_set_inode_last_trans(trans, inode);


