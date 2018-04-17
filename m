Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32895 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752619AbeDQPVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 11:21:19 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 49053AEC7
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 15:21:18 +0000 (UTC)
Date: Tue, 17 Apr 2018 17:18:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: delayed-inode: Remove wrong qgroup meta
 reservation calls
Message-ID: <20180417151846.GE21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180417085245.6303-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180417085245.6303-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2018 at 04:52:45PM +0800, Qu Wenruo wrote:
> Commit 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv for
> delayed inode and item") merged into mainline is not the updated version
> submitted to the mail list in Dec 2017.
> 
> Which lacks the following fixes:
> 
> 1) Remove btrfs_qgroup_convert_reserved_meta() call in
>    btrfs_delayed_item_release_metadata()
> 2) Remove btrfs_qgroup_reserve_meta_prealloc() call in
>    btrfs_delayed_inode_reserve_metadata()
> 
> Those fixes will resolve unexpected EDQUOT problems.
> 
> Fixes: 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and item")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to 4.17 queue, thanks.

> @@ -569,6 +569,12 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
>  	dst_rsv = &fs_info->delayed_block_rsv;
>  
>  	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> +
> +	/*
> +	 * Here we migrate space rsv from transaction rsv, since have
> +	 * already reserved space when starting a transaction.
> +	 * So no need to reserve qgroup space here.
> +	 */

Please format the comments to the full line width.

> @@ -647,7 +657,9 @@ static int btrfs_delayed_inode_reserve_metadata(
>  						      "delayed_inode",
>  						      btrfs_ino(inode),
>  						      num_bytes, 1);
> -		}
> +		} else
> +			btrfs_qgroup_free_meta_prealloc(root,
> +							fs_info->nodesize);

Please don't diverge from the coding style, I'm fixing such issues but,
you know.
