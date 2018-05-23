Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754155AbeEWHcP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 03:32:15 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 314F6AF3C
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 07:32:14 +0000 (UTC)
Subject: Re: [PATCH v3 1/2] btrfs: qgroup: Search commit root for rescan to
 avoid missing extent
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180514013813.30763-1-wqu@suse.com>
 <20180523072939.23538-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4bcfd274-9ce0-81b4-ab0a-e5f7e8aa9ed4@suse.com>
Date: Wed, 23 May 2018 10:32:13 +0300
MIME-Version: 1.0
In-Reply-To: <20180523072939.23538-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.05.2018 10:29, Qu Wenruo wrote:
> When doing qgroup rescan using the following script (modified from
> btrfs/017 test case), we can sometimes hit qgroup corruption.
> 
> ------
> umount $dev &> /dev/null
> umount $mnt &> /dev/null
> 
> mkfs.btrfs -f -n 64k $dev
> mount $dev $mnt
> 
> extent_size=8192
> 
> xfs_io -f -d -c "pwrite 0 $extent_size" $mnt/foo > /dev/null
> btrfs subvolume snapshot $mnt $mnt/snap
> 
> xfs_io -f -c "reflink $mnt/foo" $mnt/foo-reflink > /dev/null
> xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink > /dev/null
> xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink2 > /dev/unll
> btrfs quota enable $mnt
> 
>  # -W is the new option to only wait rescan while not starting new one
> btrfs quota rescan -W $mnt
> btrfs qgroup show -prce $mnt
> umount $mnt
> 
>  # Need to patch btrfs-progs to report qgroup mismatch as error
> btrfs check $dev || _fail
> ------
> 
> For fast machine, we can hit some corruption which missed accounting
> tree blocks:
> ------
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5           8.00KiB        0.00B         none         none ---     ---
> 0/257         8.00KiB        0.00B         none         none ---     ---
> ------
> 
> This is due to the fact that we're always searching commit root for
> btrfs_find_all_roots() at qgroup_rescan_leaf(), but the leaf we get is
> from current transaction, not commit root.
> 
> And if our tree blocks get modified in current transaction, we won't
> find any owner in commit root, thus causing the corruption.
> 
> Fix it by searching commit root for extent tree for
> qgroup_rescan_leaf().
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> changelog:
> v2:
>   Remove unused tree_mod_seq_elem for the 1st patch.
> v3:
>   Also skip locking to avoid lock assert() with Liu Bo's
>   btrfs_search_slot() patchset.
> ---
>  fs/btrfs/qgroup.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 9fb758d5077a..a88330088d03 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2590,7 +2590,6 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>  	struct btrfs_key found;
>  	struct extent_buffer *scratch_leaf = NULL;
>  	struct ulist *roots = NULL;
> -	struct seq_list tree_mod_seq_elem = SEQ_LIST_INIT(tree_mod_seq_elem);
>  	u64 num_bytes;
>  	int slot;
>  	int ret;
> @@ -2625,7 +2624,6 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>  			      btrfs_header_nritems(path->nodes[0]) - 1);
>  	fs_info->qgroup_rescan_progress.objectid = found.objectid + 1;
>  
> -	btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
>  	scratch_leaf = btrfs_clone_extent_buffer(path->nodes[0]);
>  	if (!scratch_leaf) {
>  		ret = -ENOMEM;
> @@ -2664,7 +2662,6 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>  		btrfs_tree_read_unlock_blocking(scratch_leaf);
>  		free_extent_buffer(scratch_leaf);
>  	}
> -	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
>  
>  	return ret;
>  }
> @@ -2681,6 +2678,12 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		goto out;
> +	/*
> +	 * Rescan should only search for commit root, and any later difference
> +	 * should be recorded by qgroup
> +	 */
> +	path->search_commit_root = 1;
> +	path->skip_locking = 1;
>  
>  	err = 0;
>  	while (!err && !btrfs_fs_closing(fs_info)) {
> 
