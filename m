Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06ADC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 02:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5DA214F1
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 02:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="n43+lbPG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D5DA214F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389385AbeKPMWR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 07:22:17 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41928 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389344AbeKPMWL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 07:22:11 -0500
Received: by mail-pg1-f196.google.com with SMTP id 70so9869013pgh.8
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 18:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fw5ouGiFQ8H9xz3HMkj3MnFIB/8cu61F/BMbgak5qVo=;
        b=n43+lbPGeaGJv5nZPtjvUNU9RusoWxagZQZh2JUDk5ifS+opUrvbJTg3olvONSVLlO
         ou399InyV5fk0IzEkS4W6JY1CeRJA2LGv9AFhCSbZDGmqqkyu1bFMLye+Gu9w7TA/jcR
         JWidLK99zYGxNywyV0gz2oqvqUlEmVZ2r6LNwyzVQjJI0+YbtAuhTzMTjwjO4lt3JYog
         B4wDn0wG+TFfi8ha98IRF+DhZW8KR8ngaM3/poOZkRLwt1d1PLOI9+YAmvFq6zyuBYCQ
         vLeObpH0P3IxYwopAfD5tyPJMCATwrFNrN4T08PDDJhGtKW5F0skZ1itK2BvlqWWCTwv
         haSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fw5ouGiFQ8H9xz3HMkj3MnFIB/8cu61F/BMbgak5qVo=;
        b=KBC7Zagwsm3UgtooHNA78swHW1k3YT0nyhOBJfBeeCoppM9Cpl5fOOEecqeirXGYcj
         vcC5ug4tcTyR2FigRCQKRZm7U5QGZuASnKI/UQMVXYvSBw4u/C/kmYmWJnUCDgS124eq
         F/2r9ShiSeGYV6Z2bZhwsE1RrQ4sJJWppVdbHvY2eIyo1KkAOTwt73qDu6yxv758k3in
         WLRkbNb14KiTD3jOKrmnw4YanQaDy0wekjriXFq+3XpyDtGeRbN5tllej5IfuK7pVuYj
         wRYc6+aBYWYr9BVwImf/c8TaSJ5UegKEoWaEGYFWzsoNk6tGHeM5a/b9vX/I+7M2Cb6G
         O8vA==
X-Gm-Message-State: AGRZ1gK5zEhgbl5V29cbHrFNVTBFTobf04OX3kDdmgx/goOkjGw+CZY4
        yN2BF5eDJs+qgfI5SyUym8PxSg==
X-Google-Smtp-Source: AJdET5c3E4A2RbqtCnQc5jwvauUMf7a8KgLxcBuVSjYMJIyJ0jhrItIEeS+5+KqwKpfdP8fzYx/xLQ==
X-Received: by 2002:a63:224f:: with SMTP id t15mr8135068pgm.69.1542334302454;
        Thu, 15 Nov 2018 18:11:42 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id t3sm8847311pgv.31.2018.11.15.18.11.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 18:11:41 -0800 (PST)
Date:   Thu, 15 Nov 2018 18:11:40 -0800
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
Subject: Re: [PATCH V10 17/19] block: don't use bio->bi_vcnt to figure out
 segment number
Message-ID: <20181116021140.GL23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-18-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-18-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:53:04PM +0800, Ming Lei wrote:
> It is wrong to use bio->bi_vcnt to figure out how many segments
> there are in the bio even though CLONED flag isn't set on this bio,
> because this bio may be splitted or advanced.
> 
> So always use bio_segments() in blk_recount_segments(), and it shouldn't
> cause any performance loss now because the physical segment number is figured
> out in blk_queue_split() and BIO_SEG_VALID is set meantime since
> bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting").
> 
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Fixes: 7f60dcaaf91 ("block: blk-merge: fix blk_recount_segments()")

From what I can tell, the problem was originally introduced by
76d8137a3113 ("blk-merge: recaculate segment if it isn't less than max segments")

Is that right?

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
>  block/blk-merge.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index cb9f49bcfd36..153a659fde74 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -429,13 +429,7 @@ void blk_recalc_rq_segments(struct request *rq)
>  
>  void blk_recount_segments(struct request_queue *q, struct bio *bio)
>  {
> -	unsigned short seg_cnt;
> -
> -	/* estimate segment number by bi_vcnt for non-cloned bio */
> -	if (bio_flagged(bio, BIO_CLONED))
> -		seg_cnt = bio_segments(bio);
> -	else
> -		seg_cnt = bio->bi_vcnt;
> +	unsigned short seg_cnt = bio_segments(bio);
>  
>  	if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags) &&
>  			(seg_cnt < queue_max_segments(q)))
> -- 
> 2.9.5
> 
