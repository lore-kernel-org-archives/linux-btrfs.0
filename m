Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbeHTRMP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 13:12:15 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 311D8AE71
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2018 13:56:29 +0000 (UTC)
Date: Mon, 20 Aug 2018 15:56:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: Handle owner mismatch gracefully when walking
 up tree
Message-ID: <20180820135619.GY24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180801080801.13024-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180801080801.13024-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 01, 2018 at 04:08:01PM +0800, Qu Wenruo wrote:
> @@ -8949,17 +8949,26 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
>  	}
>  
>  	if (eb == root->node) {
> -		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
> +		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
>  			parent = eb->start;
> -		else
> -			BUG_ON(root->root_key.objectid !=
> -			       btrfs_header_owner(eb));
> +		} else if (root->root_key.objectid != btrfs_header_owner(eb)) {
> +			btrfs_err_rl(fs_info,
> +			"unexpected tree owner, have %llu expect %llu",
> +				     btrfs_header_owner(eb),
> +				     root->root_key.objectid);
> +			return -EINVAL;
> +		}
>  	} else {
> -		if (wc->flags[level + 1] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
> +		if (wc->flags[level + 1] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
>  			parent = path->nodes[level + 1]->start;
> -		else
> -			BUG_ON(root->root_key.objectid !=
> -			       btrfs_header_owner(path->nodes[level + 1]));
> +		} else if (root->root_key.objectid !=
> +			   btrfs_header_owner(path->nodes[level + 1])) {
> +			btrfs_err_rl(fs_info,
> +			"unexpected tree owner, have %llu expect %llu",
> +				     btrfs_header_owner(eb),
> +				     root->root_key.objectid);
> +			return -EINVAL;
> +		}

Same code in both blocks, please merge them and add a label instead.

The suitable error code is EUCLEAN, as mentioned in the therad.
