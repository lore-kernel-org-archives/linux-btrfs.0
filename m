Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9237AC43610
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58D1F2146D
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:22:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="t5kdpi0Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58D1F2146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389134AbeKPKcJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 05:32:09 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38723 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389006AbeKPKcI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 05:32:08 -0500
Received: by mail-pl1-f196.google.com with SMTP id e5so233369plb.5
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 16:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T39mcugS1aLkzngTcT53twIshIQ6bootoTES/sa00Ow=;
        b=t5kdpi0ZafvIr/HkP7X6avzLpb2P/ZGm1njaCYT/nrsABPy1EW3Ki4D7N5qtFFPmzK
         uXlinCSIMzWIBAoAw0/FQURIb+XNMWDerNYBxwWUa4TYDaN41YRUfXxQzk3QB41saa0C
         dBIZOpgg1pxz+f+9TM71ZrxLRpTRmXrPiarK7Z0yJn1GdDJT+YPpxp6MqCk6JndcPt0d
         C0EdMprRidCaWMiliNq8GgIztRj92hvrpre4v2zzMp73tq366+43v1ms65UANAuQSmQ7
         lELRH++GmUMwo5AgnhTxGDIpyz9HbdhQs5uVqYoDrwibVMI3ieVnkf5O+ESfFpO80mbG
         R80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T39mcugS1aLkzngTcT53twIshIQ6bootoTES/sa00Ow=;
        b=kDfxIdW1yNBzuKAL/lirV4KHQs5QYthJ+JQv3vtYzYTks2qrO6bFY1hiTUdpGslSmI
         o8G9KMSaX5UrqSgqlIyIP6qI3hvSta2GhIQAmYlP8t1S1Fj3hdprBPIAmnKiYGPKGWF0
         XUdV4zurdugLChspUOXvCx7GhLOQhq4znGxRb0poRUTGonCu7KXdx/fV4I5xRxWdzkN7
         heT3DChfNGKb4zRp3aEw14fkgBuPOj+cqLx4cnXouB94gkQvNb9E4tbLj4iU8wZciNOx
         rsdTb2s5poIiEsBpnML9tphsf3/iK1esIuoGcG0+JtjpvkRr6AwIdDzIu2++9WYkW5Ec
         ha2Q==
X-Gm-Message-State: AGRZ1gKJprtlaQbDgA1XeB2zOrk4bSH2Vl2+3meuki+Rv/1bFHw3q5vT
        w+bT48GmxzHkPJCVgNtTKcuY5A==
X-Google-Smtp-Source: AJdET5c5gYec42aFbvjnF+656sHtt9JGXk44h33X2zFJRGjjNKUSF5rjgiWMHUKJJJzN1cjZ4Se8rA==
X-Received: by 2002:a17:902:744a:: with SMTP id e10mr6788269plt.304.1542327720721;
        Thu, 15 Nov 2018 16:22:00 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id t3sm8676672pgv.31.2018.11.15.16.21.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 16:22:00 -0800 (PST)
Date:   Thu, 15 Nov 2018 16:21:57 -0800
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
Subject: Re: [PATCH V10 07/19] btrfs: use bvec_last_segment to get bio's last
 page
Message-ID: <20181116002157.GB23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-8-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-8-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:52:54PM +0800, Ming Lei wrote:
> Preparing for supporting multi-page bvec.
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

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  fs/btrfs/compression.c | 5 ++++-
>  fs/btrfs/extent_io.c   | 5 +++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 2955a4ea2fa8..161e14b8b180 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -400,8 +400,11 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
>  static u64 bio_end_offset(struct bio *bio)
>  {
>  	struct bio_vec *last = bio_last_bvec_all(bio);
> +	struct bio_vec bv;
>  
> -	return page_offset(last->bv_page) + last->bv_len + last->bv_offset;
> +	bvec_last_segment(last, &bv);
> +
> +	return page_offset(bv.bv_page) + bv.bv_len + bv.bv_offset;
>  }
>  
>  static noinline int add_ra_bio_pages(struct inode *inode,
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d228f706ff3e..5d5965297e7e 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2720,11 +2720,12 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
>  {
>  	blk_status_t ret = 0;
>  	struct bio_vec *bvec = bio_last_bvec_all(bio);
> -	struct page *page = bvec->bv_page;
> +	struct bio_vec bv;
>  	struct extent_io_tree *tree = bio->bi_private;
>  	u64 start;
>  
> -	start = page_offset(page) + bvec->bv_offset;
> +	bvec_last_segment(bvec, &bv);
> +	start = page_offset(bv.bv_page) + bv.bv_offset;
>  
>  	bio->bi_private = NULL;
>  
> -- 
> 2.9.5
> 
