Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED62C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7D0121104
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="Kpi1e8f6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7D0121104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbeK0Jlv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:41:51 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33254 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbeK0Jlv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:41:51 -0500
Received: by mail-pl1-f196.google.com with SMTP id z23so14580951plo.0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ywd5ugQ7Rz1RkaT/YTlEuW45bSGgrrZi2Jz7k8219mE=;
        b=Kpi1e8f6GJRJ50Hn5h0sre6zNOKaYDt3fxj+x4x8cevO2ccWoRZdNHAZCVzBUC0duR
         OY877RYF1bg2ljubA75pLiQxyURBIk7QX+iBpEfTzk5bwLKeXVOEDDLkZsI4sqyJb7KU
         uJMGbZXMNH+stq7oP6Qe83wSjgnHOO9JULwlnamt6j9i3EbB6LHL/egqXTeNYZih/G0u
         imwSfHqMXsaOUGnEhojqnHVq6D3X89BuTQETDAW040NuS6FsyFpOCnbREM/md+YzDCpg
         jnVKbt1TyUJ6MJt8wskPNvgMfFeqq84sztCREvP57IozbS1JJdZ4hphMztQXyB5GUhbu
         itQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ywd5ugQ7Rz1RkaT/YTlEuW45bSGgrrZi2Jz7k8219mE=;
        b=omc3aoJNjbSCpqL+ce20ndABnfiOHmkx4CMSJsE+0Y3WYWfvP2lCsTujOFFEL3ZRRE
         /LKkaArllnRAbicWq0dEW6f8PZYvvp7QMBMf74qjz9AcRfysC90kA5TMSzzKVOWYKtu6
         3v1HQev5V1tZqGrToLiiW/gXhjxMVjv6YPHEFi0x39JlfTACW+BTckHuxL3/5HIXHR+t
         9vfIgYLvzU24te5ZW+cnVygUJzuLludMlH5VUF3W/xAz4HwEbyzzj093M29l0sl1Q8J0
         qcxVQfI91Kob7PuRf3x3K86TjMH5KTAf/nYaYTb5nJD++msMcnSm6tGFp9a9JgZGg6+K
         7CTA==
X-Gm-Message-State: AA+aEWYt2wMDrvNAQVOJQxbGuSO5bPZcUz/GBLeQ1fI+4kY//t+x42O9
        D6PMLSXEvCZ7IRLBofvYQacC/Q==
X-Google-Smtp-Source: AFSGD/UL5x1piOl75InkO1fAxBxYd2Fq3/7AjzpD75b4uGy+SpBEB5rHvBG9lh1Zgpjou2Kf5Jm8GA==
X-Received: by 2002:a17:902:a50a:: with SMTP id s10mr28485938plq.278.1543272370482;
        Mon, 26 Nov 2018 14:46:10 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id b9sm1764128pfi.118.2018.11.26.14.46.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:46:09 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:46:08 -0800
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
Subject: Re: [PATCH V12 02/20] btrfs: look at bi_size for repair decisions
Message-ID: <20181126224608.GO30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-3-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-3-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:02AM +0800, Ming Lei wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> bio_readpage_error currently uses bi_vcnt to decide if it is worth
> retrying an I/O.  But the vector count is mostly an implementation
> artifact - it really should figure out if there is more than a
> single sector worth retrying.  Use bi_size for that and shift by
> PAGE_SHIFT.  This really should be blocks/sectors, but given that
> btrfs doesn't support a sector size different from the PAGE_SIZE
> using the page size keeps the changes to a minimum.
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/extent_io.c | 2 +-
>  include/linux/bio.h  | 6 ------
>  2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 15fd46582bb2..40751e86a2a9 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2368,7 +2368,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
>  	int read_mode = 0;
>  	blk_status_t status;
>  	int ret;
> -	unsigned failed_bio_pages = bio_pages_all(failed_bio);
> +	unsigned failed_bio_pages = failed_bio->bi_iter.bi_size >> PAGE_SHIFT;
>  
>  	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
>  
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 056fb627edb3..6f6bc331a5d1 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -263,12 +263,6 @@ static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
>  		bv->bv_len = iter.bi_bvec_done;
>  }
>  
> -static inline unsigned bio_pages_all(struct bio *bio)
> -{
> -	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
> -	return bio->bi_vcnt;
> -}
> -
>  static inline struct bio_vec *bio_first_bvec_all(struct bio *bio)
>  {
>  	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
> -- 
> 2.9.5
> 
