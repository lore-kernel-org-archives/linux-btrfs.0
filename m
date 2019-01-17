Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA799C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 07:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F28F20856
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 07:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbfAQHu6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 02:50:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:55258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727197AbfAQHu6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 02:50:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73287AEC8
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 07:50:56 +0000 (UTC)
Subject: Re: [PATCH 2/5] btrfs: extent_io: Kill the forward declaration of
 flush_write_bio()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190117074855.24818-1-wqu@suse.com>
 <20190117074855.24818-3-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d7924224-801c-3304-c161-c94c7cf870f0@suse.com>
Date:   Thu, 17 Jan 2019 09:50:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190117074855.24818-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 17.01.19 г. 9:48 ч., Qu Wenruo wrote:
> There is no need to forward declare flush_write_bio(), as it only
> depends on submit_one_bio().
> 
> Both of them are pretty small, just move them to kill the forward
> declaration.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

I'm very much in favor of killing forward declarations for static
functions.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent_io.c | 66 +++++++++++++++++++++-----------------------
>  1 file changed, 32 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 52abe4082680..8a2335713a2d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -147,7 +147,38 @@ static int add_extent_changeset(struct extent_state *state, unsigned bits,
>  	return ret;
>  }
>  
> -static void flush_write_bio(struct extent_page_data *epd);
> +static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
> +				       unsigned long bio_flags)
> +{
> +	blk_status_t ret = 0;
> +	struct bio_vec *bvec = bio_last_bvec_all(bio);
> +	struct page *page = bvec->bv_page;
> +	struct extent_io_tree *tree = bio->bi_private;
> +	u64 start;
> +
> +	start = page_offset(page) + bvec->bv_offset;
> +
> +	bio->bi_private = NULL;
> +
> +	if (tree->ops)
> +		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
> +					   mirror_num, bio_flags, start);
> +	else
> +		btrfsic_submit_bio(bio);
> +
> +	return blk_status_to_errno(ret);
> +}
> +
> +static void flush_write_bio(struct extent_page_data *epd)
> +{
> +	if (epd->bio) {
> +		int ret;
> +
> +		ret = submit_one_bio(epd->bio, 0, 0);
> +		BUG_ON(ret < 0); /* -ENOMEM */
> +		epd->bio = NULL;
> +	}
> +}
>  
>  int __init extent_io_init(void)
>  {
> @@ -2692,28 +2723,6 @@ struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size)
>  	return bio;
>  }
>  
> -static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
> -				       unsigned long bio_flags)
> -{
> -	blk_status_t ret = 0;
> -	struct bio_vec *bvec = bio_last_bvec_all(bio);
> -	struct page *page = bvec->bv_page;
> -	struct extent_io_tree *tree = bio->bi_private;
> -	u64 start;
> -
> -	start = page_offset(page) + bvec->bv_offset;
> -
> -	bio->bi_private = NULL;
> -
> -	if (tree->ops)
> -		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
> -					   mirror_num, bio_flags, start);
> -	else
> -		btrfsic_submit_bio(bio);
> -
> -	return blk_status_to_errno(ret);
> -}
> -
>  /*
>   * @opf:	bio REQ_OP_* and REQ_* flags as one value
>   * @tree:	tree so we can call our merge_bio hook
> @@ -4007,17 +4016,6 @@ static int extent_write_cache_pages(struct address_space *mapping,
>  	return ret;
>  }
>  
> -static void flush_write_bio(struct extent_page_data *epd)
> -{
> -	if (epd->bio) {
> -		int ret;
> -
> -		ret = submit_one_bio(epd->bio, 0, 0);
> -		BUG_ON(ret < 0); /* -ENOMEM */
> -		epd->bio = NULL;
> -	}
> -}
> -
>  int extent_write_full_page(struct page *page, struct writeback_control *wbc)
>  {
>  	int ret;
> 
