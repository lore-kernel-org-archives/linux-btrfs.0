Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF29C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6173821019
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="Rlo2Qjx5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6173821019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389105AbeKPKeQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 05:34:16 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35820 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389006AbeKPKeI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 05:34:08 -0500
Received: by mail-pl1-f196.google.com with SMTP id v1-v6so3121409plo.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 16:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+YFNdcmtgiMlpQBi7cSJ9gNwFvgbWvI00uoRMZ8sE4o=;
        b=Rlo2Qjx5laXVtcjHx9ekQicwjrYA03QkgQwPxkxgWbLx8sKaJjRgneJG0+8NiPXNGG
         7/G0ajkM5ZCOHdoh0fvGjOT1nDhKECFH5iJ87Anst1VbPmdF4SusRdAqBlvrDs/FOwUk
         wc0sX/b/qZHlAyFLb7QD3dh2imJr4rmZWwfYtsW5WlGwQ1VwG96orQ8RLfm6USWxIUOF
         SC7P5y/FFJAzwejuWUsPU23WCtxY28w2P31SfLFajUmA5fda0gN814CeWb2xwqLv+K8p
         gYc+P+++MkD612wRvmUrANcbeuXIgedN5KO4aY1kjbuR1Ddrr0wG9FbMLzX0+h9ElGrV
         W+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+YFNdcmtgiMlpQBi7cSJ9gNwFvgbWvI00uoRMZ8sE4o=;
        b=QKBjho6BjYKr2VaLOYck3hPTkck9Om66T3xrW6D7VQdGNJi0brNmSNn36RIW4imYUL
         7RQI39r2dapUNnaM5yV8Jzi3dDmrAT+218Yxqas9sPaud9Kn8/b9BD9hnkp1i9weFSEA
         DR/W14EAmu+5JWJ9CNfyOekfgOi8IoznTqWndjFeKWX6uar26/1lHEW+D1WL+nKqkLS7
         J5UKZ1PIzUlu1e+WhOWj50zvF8/OHIvGfwLDzcu9v8Kxl909PighnQ/bcae8WmXl79AE
         irkbLhommWZ8hK+5AGC8h5Ypcc7PW89q+2qU/x6HHgd+oRlSb/f//AEGAPmnr3kbYiRd
         nxbg==
X-Gm-Message-State: AGRZ1gL9Hhs7OXpxodbkuZpxXdQJpRs+tTqhwBTXwFMOGN6uWrWp7gZ4
        Za5hGxoXF5R2js6IivV08hCnCw==
X-Google-Smtp-Source: AJdET5c3eEeEb/rtT8qe8FYmFR65Ntoed+qElVoZCjaP33P5pTJX9NvB5/vYhvrHwReuU6Q95nl+Tg==
X-Received: by 2002:a17:902:20b:: with SMTP id 11-v6mr8267761plc.147.1542327840622;
        Thu, 15 Nov 2018 16:24:00 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id w80-v6sm51261608pfk.11.2018.11.15.16.23.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 16:24:00 -0800 (PST)
Date:   Thu, 15 Nov 2018 16:23:56 -0800
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
Subject: Re: [PATCH V10 08/19] btrfs: move bio_pages_all() to btrfs
Message-ID: <20181116002356.GC23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-9-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-9-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:52:55PM +0800, Ming Lei wrote:
> BTRFS is the only user of this helper, so move this helper into
> BTRFS, and implement it via bio_for_each_segment_all(), since
> bio->bi_vcnt may not equal to number of pages after multipage bvec
> is enabled.

Shouldn't you also get rid of bio_pages_all() in this patch?

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
>  fs/btrfs/extent_io.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5d5965297e7e..874bb9aeebdc 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2348,6 +2348,18 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
>  	return bio;
>  }
>  
> +static unsigned btrfs_bio_pages_all(struct bio *bio)
> +{
> +	unsigned i;
> +	struct bio_vec *bv;
> +
> +	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
> +
> +	bio_for_each_segment_all(bv, bio, i)
> +		;
> +	return i;
> +}
> +
>  /*
>   * this is a generic handler for readpage errors (default
>   * readpage_io_failed_hook). if other copies exist, read those and write back
> @@ -2368,7 +2380,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
>  	int read_mode = 0;
>  	blk_status_t status;
>  	int ret;
> -	unsigned failed_bio_pages = bio_pages_all(failed_bio);
> +	unsigned failed_bio_pages = btrfs_bio_pages_all(failed_bio);
>  
>  	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
>  
> -- 
> 2.9.5
> 
