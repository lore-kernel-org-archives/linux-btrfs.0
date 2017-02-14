Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43584 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdBNBBi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 20:01:38 -0500
Date: Mon, 13 Feb 2017 16:59:43 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/29] btrfs: remove unused parameter from
 read_block_for_search
Message-ID: <20170214005943.GA16943@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <4d790a3ce2a6fbfc46dc469c851f70cacb63b035.1486977711.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d790a3ce2a6fbfc46dc469c851f70cacb63b035.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:24AM +0100, David Sterba wrote:
> Never used in that function.

There is already one,
https://patchwork.kernel.org/patch/9546079/

Thanks,

-liubo
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index fbeff20eb194..35e22349c139 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2440,7 +2440,7 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
>  static int
>  read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
>  		      struct extent_buffer **eb_ret, int level, int slot,
> -		      const struct btrfs_key *key, u64 time_seq)
> +		      const struct btrfs_key *key)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	u64 blocknr;
> @@ -2871,7 +2871,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  			}
>  
>  			err = read_block_for_search(root, p, &b, level,
> -						    slot, key, 0);
> +						    slot, key);
>  			if (err == -EAGAIN)
>  				goto again;
>  			if (err) {
> @@ -3015,7 +3015,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
>  			}
>  
>  			err = read_block_for_search(root, p, &b, level,
> -						    slot, key, time_seq);
> +						    slot, key);
>  			if (err == -EAGAIN)
>  				goto again;
>  			if (err) {
> @@ -5786,7 +5786,7 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>  		next = c;
>  		next_rw_lock = path->locks[level];
>  		ret = read_block_for_search(root, path, &next, level,
> -					    slot, &key, 0);
> +					    slot, &key);
>  		if (ret == -EAGAIN)
>  			goto again;
>  
> @@ -5836,7 +5836,7 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>  			break;
>  
>  		ret = read_block_for_search(root, path, &next, level,
> -					    0, &key, 0);
> +					    0, &key);
>  		if (ret == -EAGAIN)
>  			goto again;
>  
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
