Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078B6C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B726420C01
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="kjJ40KIA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B726420C01
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbeK0Jwg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:52:36 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33292 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbeK0Jwf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:52:35 -0500
Received: by mail-pf1-f196.google.com with SMTP id c123so6616583pfb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zbfCjqBHpAJ7K3XFvE3QIuIxE9xXYdGtzAQcePbc+b8=;
        b=kjJ40KIAs6CJd9vbyC4OxMuKuzLv9P0M+3fs8oA7yLXGSKDh9ooEer+N6sG/TIv02K
         u5f09fdt3N2VxD0oiXbct2aJOCQCUdDZPAoy4mJ5K8rZ+Z+ybQvCDf72o3Svo4Ov4lkl
         WoBy9MTIywvgJdsGjaYVHZNPdYKFRsEawnMsU5k+DFWZVESRwLd0zkkqgHmDHlxE4CF2
         Oo2IwAukkVu6SjMPpM4Q22u/sjYGmgK1iGNEDewb0q2UriqLOgaq1YUTIJLvFgU3fMI4
         yJtzFyrEvxnIqJlrsK63mLpslLax00bqYdnyHI4OUwNLu2LTRT7CLJ/Xp0QkBznPBsD0
         GrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zbfCjqBHpAJ7K3XFvE3QIuIxE9xXYdGtzAQcePbc+b8=;
        b=R/rhMft9/P/DHuFERhNGVrraRlGN2nj66nu8ceNVwN0tOR7QICF/gDiL9a87OIcn24
         AXJuhcwCk0z50MP5tNtiSqToRpi6gGMImR+HrWnAJ13gEAdcQHjpEcBl16iSsqltZwI1
         qPp8kDpzLXKTRrrbqnuad3CD+jtABfchbNTux8KL0ZhuqQJ7DTLhB36+DSDUCQuV/KrF
         8PvXWSA7Nr/lMpKOhe4o2HtXWRUkUdSx0KY4AWlVuM0agxRi4NoN97rZu8hm6v40LQ8z
         wf9UKOjBv4ij4vV9Zw4fyJpFpsXMt84ECDK5oaeAsoZjzMBvjds2aDuE8bP0BCBp4svq
         rhGQ==
X-Gm-Message-State: AA+aEWZXfQVdRnkHcfg1WXegybOBP/ETZs/sGFMj+JoD1SQz6UgKRE7+
        K83urK06l+St8509Z6PxK1lNfw==
X-Google-Smtp-Source: AFSGD/XsLnbmJ7JSiEaKpuAFiMdBC3Q1tAhywKOzA3kv9DDd3m2ZXLpW6CUfttmabObm5+3pyI0MyQ==
X-Received: by 2002:a63:5e43:: with SMTP id s64mr26918522pgb.101.1543273012498;
        Mon, 26 Nov 2018 14:56:52 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id n22sm2153399pfh.166.2018.11.26.14.56.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:56:51 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:56:49 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V12 16/20] block: enable multipage bvecs
Message-ID: <20181126225649.GP30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-17-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-17-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:16AM +0800, Ming Lei wrote:
> This patch pulls the trigger for multi-page bvecs.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/bio.c         | 22 +++++++++++++++-------
>  fs/iomap.c          |  4 ++--
>  fs/xfs/xfs_aops.c   |  4 ++--
>  include/linux/bio.h |  2 +-
>  4 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 75fde30af51f..8bf9338d4783 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -753,6 +753,8 @@ EXPORT_SYMBOL(bio_add_pc_page);
>   * @page: page to add
>   * @len: length of the data to add
>   * @off: offset of the data in @page
> + * @same_page: if %true only merge if the new data is in the same physical
> + *		page as the last segment of the bio.
>   *
>   * Try to add the data at @page + @off to the last bvec of @bio.  This is a
>   * a useful optimisation for file systems with a block size smaller than the
> @@ -761,19 +763,25 @@ EXPORT_SYMBOL(bio_add_pc_page);
>   * Return %true on success or %false on failure.
>   */
>  bool __bio_try_merge_page(struct bio *bio, struct page *page,
> -		unsigned int len, unsigned int off)
> +		unsigned int len, unsigned int off, bool same_page)
>  {
>  	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>  		return false;
>  
>  	if (bio->bi_vcnt > 0) {
>  		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
> +		phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) +
> +			bv->bv_offset + bv->bv_len;
> +		phys_addr_t page_addr = page_to_phys(page);
>  
> -		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
> -			bv->bv_len += len;
> -			bio->bi_iter.bi_size += len;
> -			return true;
> -		}
> +		if (vec_end_addr != page_addr + off)
> +			return false;
> +		if (same_page && ((vec_end_addr - 1) & PAGE_MASK) != page_addr)
> +			return false;
> +
> +		bv->bv_len += len;
> +		bio->bi_iter.bi_size += len;
> +		return true;
>  	}
>  	return false;
>  }
> @@ -819,7 +827,7 @@ EXPORT_SYMBOL_GPL(__bio_add_page);
>  int bio_add_page(struct bio *bio, struct page *page,
>  		 unsigned int len, unsigned int offset)
>  {
> -	if (!__bio_try_merge_page(bio, page, len, offset)) {
> +	if (!__bio_try_merge_page(bio, page, len, offset, false)) {
>  		if (bio_full(bio))
>  			return 0;
>  		__bio_add_page(bio, page, len, offset);
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 1f648d098a3b..ec5527b0fba4 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -313,7 +313,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  	 */
>  	sector = iomap_sector(iomap, pos);
>  	if (ctx->bio && bio_end_sector(ctx->bio) == sector) {
> -		if (__bio_try_merge_page(ctx->bio, page, plen, poff))
> +		if (__bio_try_merge_page(ctx->bio, page, plen, poff, true))
>  			goto done;
>  		is_contig = true;
>  	}
> @@ -344,7 +344,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		ctx->bio->bi_end_io = iomap_read_end_io;
>  	}
>  
> -	__bio_add_page(ctx->bio, page, plen, poff);
> +	bio_add_page(ctx->bio, page, plen, poff);
>  done:
>  	/*
>  	 * Move the caller beyond our range so that it keeps making progress.
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 1f1829e506e8..b9fd44168f61 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -616,12 +616,12 @@ xfs_add_to_ioend(
>  				bdev, sector);
>  	}
>  
> -	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff)) {
> +	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
>  		if (iop)
>  			atomic_inc(&iop->write_count);
>  		if (bio_full(wpc->ioend->io_bio))
>  			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
> -		__bio_add_page(wpc->ioend->io_bio, page, len, poff);
> +		bio_add_page(wpc->ioend->io_bio, page, len, poff);
>  	}
>  
>  	wpc->ioend->io_size += len;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index c35997dd02c2..5505f74aef8b 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -441,7 +441,7 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
>  extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
>  			   unsigned int, unsigned int);
>  bool __bio_try_merge_page(struct bio *bio, struct page *page,
> -		unsigned int len, unsigned int off);
> +		unsigned int len, unsigned int off, bool same_page);
>  void __bio_add_page(struct bio *bio, struct page *page,
>  		unsigned int len, unsigned int off);
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
> -- 
> 2.9.5
> 
