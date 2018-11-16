Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF64EC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 01:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97DC122507
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 01:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="A+0KDo5V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97DC122507
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbeKPMGz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 07:06:55 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44489 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbeKPMGy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 07:06:54 -0500
Received: by mail-pg1-f195.google.com with SMTP id t13so1198007pgr.11
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 17:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kbBAKpmGBxukNa0l1dZA6Uj0uFhYexx1su4ZT10Uq1E=;
        b=A+0KDo5VgDUkHnbdktqOhaI7gEKEX1v8CWAGlgCVNki/lIAYIsuprJJriZG8tjNgg0
         cHCuA8FPLxzUHQ17Ki4r3/zN5lVAeBXS6hNlTQV6K+Lq4wC0BMaqDSJaNmfUR5UieKP0
         XVYZMCK4p5itPBqs1jb2JHTeIgJTDUfKvCAeplYpogMb4+C8DN/Gz4EdxgH3oVccEGFH
         grPfok5qizO8Z+04faGPjKHlj9C6lyZ58rUgIrF7lnpHBficyMkdeisTL4bDPLPfyYsN
         gmF7E19w6wtvlOQ6yosd9gQso4Mlq6MYjgYOCW/4f0UjgsiHMD3HgDYgOMyGRaq0Ha5/
         G8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kbBAKpmGBxukNa0l1dZA6Uj0uFhYexx1su4ZT10Uq1E=;
        b=ZEuJiSARyRZPjS80k+313ReWv+7ZQFVNA+K7VAEgB8jvsIKynwBtm75tBRqf2W3OU3
         /lSYzinvHHqYLm6Lw6p56dPuSh9k4EGzT5dXwQ+be1fFQC4gGYbRwEuTk/qKVkAy8yjF
         OcDtizTpMhBAJfd1+uH7Ycw3kHk5RZPvmne5Gxo8Y1YzZUdGT5E31r1WAeRhq2Ev8vVu
         +E2UBJsyAnGfKmNX2vQJk4mATgpHfwmfZIsaWMAT1KNMdFHnvgXWdbX39ciV4XP+blvP
         oAe6uCRLKe6k1npqbjr6T4pHaMLBIimnl0bczJ49fchIzGdrT0Ki8ouVNRah2zCmBS26
         y1hA==
X-Gm-Message-State: AGRZ1gKlLnEgOHQZ6Hk91MrKpwe9NbRsDfGbuBidVV8uuc8npRr0TwKK
        3x0uwmTI0tHgIXe1146uFCl07w==
X-Google-Smtp-Source: AJdET5fQ3+kGoJjP6IFjKiErSySgoB0CrwKcUhikiXMn5zzu+lWYZR6BmamiaXZybmvjRkQS2p6tTw==
X-Received: by 2002:a63:194f:: with SMTP id 15mr8188847pgz.192.1542333389183;
        Thu, 15 Nov 2018 17:56:29 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id o12-v6sm37704689pfh.20.2018.11.15.17.56.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 17:56:28 -0800 (PST)
Date:   Thu, 15 Nov 2018 17:56:27 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 14/19] block: enable multipage bvecs
Message-ID: <20181116015627.GI23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-15-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-15-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:53:01PM +0800, Ming Lei wrote:
> This patch pulls the trigger for multi-page bvecs.
> 
> Now any request queue which supports queue cluster will see multi-page
> bvecs.
> 
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: linux-erofs@lists.ozlabs.org
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> Cc: Gao Xiang <gaoxiang25@huawei.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Cc: Coly Li <colyli@suse.de>
> Cc: linux-bcache@vger.kernel.org
> Cc: Boaz Harrosh <ooo@electrozaur.com>
> Cc: Bob Peterson <rpeterso@redhat.com>
> Cc: cluster-devel@redhat.com
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/bio.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 6486722d4d4b..ed6df6f8e63d 100644
> --- a/block/bio.c
> +++ b/block/bio.c

This comment above __bio_try_merge_page() doesn't make sense after this
change:

 This is a
 a useful optimisation for file systems with a block size smaller than the
 page size.

Can you please get rid of it in this patch?

> @@ -767,12 +767,24 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
>  
>  	if (bio->bi_vcnt > 0) {
>  		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
> -
> -		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
> -			bv->bv_len += len;
> -			bio->bi_iter.bi_size += len;
> -			return true;
> -		}
> +		struct request_queue *q = NULL;
> +
> +		if (page == bv->bv_page && off == (bv->bv_offset + bv->bv_len)
> +				&& (off + len) <= PAGE_SIZE)
> +			goto merge;

The parentheses around (bv->bv_offset + bv->bv_len) and (off + len) are
unnecessary noise.

What's the point of the new (off + len) <= PAGE_SIZE check?

> +
> +		if (bio->bi_disk)
> +			q = bio->bi_disk->queue;
> +
> +		/* disable multi-page bvec too if cluster isn't enabled */
> +		if (!q || !blk_queue_cluster(q) ||
> +		    ((page_to_phys(bv->bv_page) + bv->bv_offset + bv->bv_len) !=
> +		     (page_to_phys(page) + off)))

More unnecessary parentheses here.

> +			return false;
> + merge:
> +		bv->bv_len += len;
> +		bio->bi_iter.bi_size += len;
> +		return true;
>  	}
>  	return false;
>  }
> -- 
> 2.9.5
> 
