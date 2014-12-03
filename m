Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20933 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLCHYP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Dec 2014 02:24:15 -0500
Date: Wed, 3 Dec 2014 15:23:50 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix fs mapping extent map leak
Message-ID: <20141203072350.GA9450@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1417543650-18002-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417543650-18002-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 02, 2014 at 06:07:30PM +0000, Filipe Manana wrote:
> On chunk allocation error (label "error_del_extent"), after adding the
> extent map to the tree and to the pending chunks list, we would leave
> decrementing the extent map's refcount by 2 instead of 3 (our allocation
> + tree reference + list reference).
> 
> Also, on chunk/block group removal, if the block group was on the list
> pending_chunks we weren't decrementing the respective list reference.
> 
> Detected by 'rmmod btrfs':
> 
> [20770.105881] kmem_cache_destroy btrfs_extent_map: Slab cache still has objects
> [20770.106127] CPU: 2 PID: 11093 Comm: rmmod Tainted: G        W    L 3.17.0-rc5-btrfs-next-1+ #1
> [20770.106128] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> [20770.106130]  0000000000000000 ffff8800ba867eb8 ffffffff813e7a13 ffff8800a2e11040
> [20770.106132]  ffff8800ba867ed0 ffffffff81105d0c 0000000000000000 ffff8800ba867ee0
> [20770.106134]  ffffffffa035d65e ffff8800ba867ef0 ffffffffa03b0654 ffff8800ba867f78
> [20770.106136] Call Trace:
> [20770.106142]  [<ffffffff813e7a13>] dump_stack+0x45/0x56
> [20770.106145]  [<ffffffff81105d0c>] kmem_cache_destroy+0x4b/0x90
> [20770.106164]  [<ffffffffa035d65e>] extent_map_exit+0x1a/0x1c [btrfs]
> [20770.106176]  [<ffffffffa03b0654>] exit_btrfs_fs+0x27/0x9d3 [btrfs]
> [20770.106179]  [<ffffffff8109dc97>] SyS_delete_module+0x153/0x1c4
> [20770.106182]  [<ffffffff8121261b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> [20770.106184]  [<ffffffff813ebf52>] system_call_fastpath+0x16/0x1b
> 
> This applies on top (depends on) of my previous patch titled:
> "Btrfs: fix race between fs trimming and block group remove/allocation"
> 
> But the issue in fact was already present before that change, it only
> became easier to hit after Josef's 3.18 patch that added automatic
> removal of empty block groups.

Good catch.

But I think we can add leak detect code for extent map as what we did
for extent state and extent buffer, then when we test with DEBUG
options, it's easier for us to find this kind of leak problems.

Thanks,

-liubo
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> This replaces my previous patch titled:
> "Btrfs: fix extent map leak on chunk allocation failure"
> 
>  fs/btrfs/extent-tree.c | 4 ++++
>  fs/btrfs/volumes.c     | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a811ed2..17d429d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9479,6 +9479,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  	memcpy(&key, &block_group->key, sizeof(key));
>  
>  	lock_chunks(root);
> +	if (!list_empty(&em->list)) {
> +		/* We're in the transaction->pending_chunks list. */
> +		free_extent_map(em);
> +	}
>  	spin_lock(&block_group->lock);
>  	block_group->removed = 1;
>  	/*
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 66a5a1e..e936fe3 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4496,6 +4496,8 @@ error_del_extent:
>  	free_extent_map(em);
>  	/* One for the tree reference */
>  	free_extent_map(em);
> +	/* One for the pending_chunks list reference */
> +	free_extent_map(em);
>  error:
>  	kfree(devices_info);
>  	return ret;
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
