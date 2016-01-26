Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:45716 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933916AbcAZIQq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 03:16:46 -0500
Subject: Re: [PATCH] btrfs: simplify expression in
 btrfs_csum_bytes_to_leaves()
To: Byongho Lee <bhlee.kernel@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
References: <1453792397-4363-1-git-send-email-bhlee.kernel@gmail.com>
From: Stefan Behrens <sbehrens@giantdisaster.de>
Message-ID: <56A729F8.4010603@giantdisaster.de>
Date: Tue, 26 Jan 2016 09:10:32 +0100
MIME-Version: 1.0
In-Reply-To: <1453792397-4363-1-git-send-email-bhlee.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The result of the calculation is different, which doesn't look right.


On Tue, 26 Jan 2016 16:13:17 +0900, Byongho Lee wrote:
> Simplify expression in btrfs_csum_bytes_to_leaves().
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
> ---
>  fs/btrfs/ctree.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a9496644f47d..3ab8026280a2 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3448,8 +3448,7 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes);
>  static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
>  						 unsigned num_items)
>  {
> -	return (root->nodesize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
> -		2 * num_items;
> +	return root->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
>  }
>  
>  /*
>  
