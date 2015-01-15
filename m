Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbbAOMwc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 07:52:32 -0500
Date: Thu, 15 Jan 2015 13:52:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 04/15] Btrfs: add ref_count and free function for
 btrfs_bio
Message-ID: <20150115125230.GG3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421152488-30548-1-git-send-email-zhaolei@cn.fujitsu.com>
 <1421152488-30548-5-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421152488-30548-5-git-send-email-zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The cleanups look good in general, some minor nitpicks below.

On Tue, Jan 13, 2015 at 08:34:37PM +0800, Zhaolei wrote:
> -		kfree(bbio);
> +		put_btrfs_bio(bbio);

Please rename it to btrfs_put_bbio, this is more consistent with other
*_put_* helpers and 'bbio' distinguishes btrfs_bio from regular 'bio'.

>  
>  static void btrfs_end_bio(struct bio *bio, int err)
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index fb0e8c3..db195f0 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -295,6 +295,7 @@ typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
>  #define BTRFS_BIO_ORIG_BIO_SUBMITTED	(1 << 0)
>  
>  struct btrfs_bio {
> +	atomic_t ref_count;

	atomic_t refs;

>  	atomic_t stripes_pending;
>  	struct btrfs_fs_info *fs_info;
>  	bio_end_io_t *end_io;
> @@ -394,13 +395,8 @@ struct btrfs_balance_control {
>  
>  int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
>  				   u64 end, u64 *length);
> -
> -#define btrfs_bio_size(total_stripes, real_stripes)		\
> -	(sizeof(struct btrfs_bio) +				\
> -	 (sizeof(struct btrfs_bio_stripe) * (total_stripes)) +	\
> -	 (sizeof(int) * (real_stripes)) +			\
> -	 (sizeof(u64) * (real_stripes)))
> -
> +void get_btrfs_bio(struct btrfs_bio *bbio);

	btrfs_get_bbio

> +void put_btrfs_bio(struct btrfs_bio *bbio);
>  int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
>  		    u64 logical, u64 *length,
>  		    struct btrfs_bio **bbio_ret, int mirror_num);
