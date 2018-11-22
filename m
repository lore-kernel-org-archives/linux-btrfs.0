Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE44C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D441206B2
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:22:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D441206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405771AbeKWDCY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 22:02:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:58510 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404206AbeKWDCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 22:02:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC37FB0B7
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 16:22:15 +0000 (UTC)
Subject: Re: [PATCH 4/4] btrfs: replace btrfs_io_bio::end_io with a simple
 helper
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1542902890.git.dsterba@suse.com>
 <d714df92c07fadf07f92c10f6d629c6fdbe9d9dd.1542902890.git.dsterba@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f103f421-25a0-2c6d-7b48-7800f681b1b5@suse.com>
Date:   Thu, 22 Nov 2018 18:22:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <d714df92c07fadf07f92c10f6d629c6fdbe9d9dd.1542902890.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 22.11.18 г. 18:16 ч., David Sterba wrote:
> The end_io callback implemented as btrfs_io_bio_endio_readpage only
> calls kfree. Also the callback is set only in case the csum buffer is
> allocated and not pointing to the inline buffer. We can use that
> information to drop the indirection and call a helper that will free the
> csums only in the right case.
> 
> This shrinks struct btrfs_io_bio by 8 bytes.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent_io.c |  3 +--
>  fs/btrfs/file-item.c |  9 ---------
>  fs/btrfs/inode.c     |  7 ++-----
>  fs/btrfs/volumes.h   | 10 ++++++++--
>  4 files changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 4ea808d6cfbc..aef3c9866ff0 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2623,8 +2623,7 @@ static void end_bio_extent_readpage(struct bio *bio)
>  	if (extent_len)
>  		endio_readpage_release_extent(tree, extent_start, extent_len,
>  					      uptodate);
> -	if (io_bio->end_io)
> -		io_bio->end_io(io_bio, blk_status_to_errno(bio->bi_status));
> +	btrfs_io_bio_free_csum(io_bio);
>  	bio_put(bio);
>  }
>  
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 1f2d0a6ab634..920bf3b4b0ef 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -142,14 +142,6 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -static void btrfs_io_bio_endio_readpage(struct btrfs_io_bio *bio, int err)
> -{
> -	if (bio->csum != bio->csum_inline) {
> -		kfree(bio->csum);
> -		bio->csum = NULL;
> -	}
> -}
> -
>  static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
>  				   u64 logical_offset, u32 *dst, int dio)
>  {
> @@ -184,7 +176,6 @@ static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio
>  				btrfs_free_path(path);
>  				return BLK_STS_RESOURCE;
>  			}
> -			btrfs_bio->end_io = btrfs_io_bio_endio_readpage;
>  		} else {
>  			btrfs_bio->csum = btrfs_bio->csum_inline;
>  		}
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 26b8bec7c2dc..6bfd37e58924 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8017,9 +8017,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
>  
>  	dio_bio->bi_status = err;
>  	dio_end_io(dio_bio);
> -
> -	if (io_bio->end_io)
> -		io_bio->end_io(io_bio, blk_status_to_errno(err));
> +	btrfs_io_bio_free_csum(io_bio);
>  	bio_put(bio);
>  }
>  
> @@ -8372,8 +8370,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
>  	if (!ret)
>  		return;
>  
> -	if (io_bio->end_io)
> -		io_bio->end_io(io_bio, ret);
> +	btrfs_io_bio_free_csum(io_bio);
>  
>  free_ordered:
>  	/*
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 9a764f2d462e..a13045fcfc45 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -267,14 +267,12 @@ struct btrfs_fs_devices {
>   * we allocate are actually btrfs_io_bios.  We'll cram as much of
>   * struct btrfs_bio as we can into this over time.
>   */
> -typedef void (btrfs_io_bio_end_io_t) (struct btrfs_io_bio *bio, int err);
>  struct btrfs_io_bio {
>  	unsigned int mirror_num;
>  	unsigned int stripe_index;
>  	u64 logical;
>  	u8 *csum;
>  	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
> -	btrfs_io_bio_end_io_t *end_io;
>  	struct bvec_iter iter;
>  	/*
>  	 * This member must come last, bio_alloc_bioset will allocate enough
> @@ -288,6 +286,14 @@ static inline struct btrfs_io_bio *btrfs_io_bio(struct bio *bio)
>  	return container_of(bio, struct btrfs_io_bio, bio);
>  }
>  
> +static inline void btrfs_io_bio_free_csum(struct btrfs_io_bio *io_bio)
> +{
> +	if (io_bio->csum != io_bio->csum_inline) {
> +		kfree(io_bio->csum);
> +		io_bio->csum = NULL;
> +	}
> +}
> +
>  struct btrfs_bio_stripe {
>  	struct btrfs_device *dev;
>  	u64 physical;
> 
