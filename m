Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbcG2QyT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 12:54:19 -0400
Date: Fri, 29 Jul 2016 18:53:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: remove BUG() in raid56
Message-ID: <20160729165357.GD30795@suse.cz>
Reply-To: dsterba@suse.cz
References: <1467248276-12310-1-git-send-email-bo.li.liu@oracle.com>
 <1469645807-16370-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469645807-16370-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 27, 2016 at 11:56:47AM -0700, Liu Bo wrote:
> This BUG() has been triggered by a fuzz testing image, which contains
> an invalid chunk type, ie. a single stripe chunk has the raid6 type.
> 
> Btrfs can handle this gracefully by returning -EIO, so besides using
> btrfs_warn to give us more debugging information rather than a single
> BUG(), we can return error properly.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: use btrfs_warn with more debugging information instead of WARN_ONCE.
> v3: - give a short summary about what happens when the error occurs.
>     - add a ASSERT() which only takes effect for developers.
> 
>  fs/btrfs/raid56.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index f8b6d41..6f8addf 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -2139,7 +2139,11 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
>  
>  	rbio->faila = find_logical_bio_stripe(rbio, bio);
>  	if (rbio->faila == -1) {
> -		BUG();
> +		btrfs_warn(root->fs_info,
> +	"%s could not find the bad stripe in raid56 so that we cannot recover any more (bio has logical %llu len %llu, bbio has map_type %llu)",
> +			   __func__, (u64)bio->bi_iter.bi_sector << 9,
> +			   (u64)bio->bi_iter.bi_size, bbio->map_type);
> +		ASSERT(0);

Why is this here? Say we'll test a fuzzed image, this would stop any
further testing. The message and EIO should be fine.

>  		if (generic_io)
>  			btrfs_put_bbio(bbio);
>  		kfree(rbio);
> -- 
> 2.5.5
> 
