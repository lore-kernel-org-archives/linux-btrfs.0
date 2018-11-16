Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3683DC04EBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEAEE22507
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="szzjtx0c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEAEE22507
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbeKPKyS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 05:54:18 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40490 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbeKPKyR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 05:54:17 -0500
Received: by mail-pf1-f193.google.com with SMTP id x2-v6so10509760pfm.7
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 16:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+4PlImHWTIopLh40jUPUR/X/dOBCqUomOuDhTOWVU5A=;
        b=szzjtx0coI1VFYZYY2U92PJOzJj1aTkkmaHrnRRF4VS929UUh8CHYxr4pUFD2QTn2B
         UHRNefdT/zyiKYYwhWgtngAyGSjF4iG1oGJ9DThEoa+0UU3V+DGtpQj1nBc9CyOMuTBF
         GpB5O8qFNtQ66M7VnSJqqpBlTiXX0vtOAaArJVcYRECh8/Nh3MS5s8vRfZjvjTp74FdJ
         yp6vnPsqwqc4PWBYK94JIEJ3d1Eofbk7KWZ1r1zYfl+AORPe2atwNtBy6Yb4ioF9SQsy
         Z/V/WiJN3J8UcSeRO0AujWYus+Bu9C9mL4OdPZiqMzvle8a0Z8aakautOAThniYuL7Bk
         ytbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+4PlImHWTIopLh40jUPUR/X/dOBCqUomOuDhTOWVU5A=;
        b=CSoW3HFeheXxrIbhd9N3ERjVD2Hz5iJg89t3U/7QyeImg6Khv5KiXTOMNNNXfu586Z
         6XrzYsmO5J+DCb3N1OuNaNoQSQYDngRtPOkkm1FG/HIo9ZkqpOTV8EAWOUPKH9KAYPZP
         zqG7CpcG6OpHwtOL9zowVZvK1HNetTQhKTHb6J+rjjQtpqa698GblJUtRT9sQdtQZtw5
         qPa68suwSdw56uoTKOd49NmJEB/ea8f7c1aqx/IlJiQnALHMSpei2/lrO2aWtHFPmpY9
         LeST/OzZ22OSa/7fbgAWzFpOSDeDPTqCK9xqdfcWlfzsHKM6L64ZQEM6N49I3bENdMfY
         J4kg==
X-Gm-Message-State: AGRZ1gK1lkSaCJUYacVrKr6TuxE7HkK7E0Qk71HuLQvM+VY1vSf7x7VB
        /v21sCwfIjUSo1wZeLjdD3dRFQ==
X-Google-Smtp-Source: AJdET5eWQ6hf+4O9YAw3NNHd9pLMuru+HkAKok7P9BojdtdKf95cSDK5LTafxH/kzFEwjsq0/XLRNA==
X-Received: by 2002:a62:113:: with SMTP id 19mr8664453pfb.176.1542329044297;
        Thu, 15 Nov 2018 16:44:04 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id p9-v6sm25334070pfa.22.2018.11.15.16.44.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 16:44:03 -0800 (PST)
Date:   Thu, 15 Nov 2018 16:44:02 -0800
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
Subject: Re: [PATCH V10 11/19] bcache: avoid to use
 bio_for_each_segment_all() in bch_bio_alloc_pages()
Message-ID: <20181116004402.GF23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-12-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-12-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:52:58PM +0800, Ming Lei wrote:
> bch_bio_alloc_pages() is always called on one new bio, so it is safe
> to access the bvec table directly. Given it is the only kind of this
> case, open code the bvec table access since bio_for_each_segment_all()
> will be changed to support for iterating over multipage bvec.
> 
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Acked-by: Coly Li <colyli@suse.de>
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
>  drivers/md/bcache/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index 20eddeac1531..8517aebcda2d 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -270,7 +270,7 @@ int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
>  	int i;
>  	struct bio_vec *bv;
>  
> -	bio_for_each_segment_all(bv, bio, i) {
> +	for (i = 0, bv = bio->bi_io_vec; i < bio->bi_vcnt; bv++) {

This is missing an i++.
