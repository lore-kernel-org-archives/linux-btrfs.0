Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B05C43610
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCAED21019
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="Jcb61BmO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCAED21019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388964AbeKPKgg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 05:36:36 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42358 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbeKPKgf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 05:36:35 -0500
Received: by mail-pg1-f194.google.com with SMTP id d72so6316399pga.9
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 16:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rc7fjUApD7flLlTVqa/RhgazHXBYzBAhEuXeNhvwmBU=;
        b=Jcb61BmOL2Jy+hgyO2/CuDgpSAkWFinbUNWCgcSEX11fUG/4NFpcyuoqKnENa/1Ua5
         PQrnGT5h+ai+Fxp9DOzzy2Ve6wq1+3E6wccymzQ8rvqQL8QGLxt0rHSw7RIo54m5hnVx
         y6zabFjieEYHME8kJ3pIbuVSPB2uBmQ97htfzqKHtrlfytrO87IkKmWJLD11K8qeEblY
         LVUbI4hmYiHPS0Fz4xAIDJJfVrpqbRyBVM+yYPGAWyWvD0Bj04dMWG2Cu8chIoQYZ+jI
         lDlID/Orlb6eoayXMROJjxhsz7k6qTeyfXxPlRijju/mdxG6gNA7VSOUPUMMLlkqX/qO
         07fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rc7fjUApD7flLlTVqa/RhgazHXBYzBAhEuXeNhvwmBU=;
        b=nIpxjj0N6r7rtdoERJsSUgzzIszYTBkfMR7DCaLrCyZeU5WcA8nPH2dAvPLEMQcbeB
         ZYp/U74/vuPkGcpaxxahTCfgrQ1Z+xyNY/Z1t12HVGthPeXj3FlRZ23ZIhv5I+QQO7XH
         EX/gv2fUx7cby4SAFzypiRALQM01SdoxkJ8IvEj/ehYykJajA9Vv0Ahjg0wGBFWbULEB
         eqJ5w9QaLMNk0cF6WYmbSXuHyxIajKWROGXiFslpKhjKkUWfiHK1yL23CiiJ2TLsPd6E
         ciXGJ0vzH63Or8l3O+64pYMNdg0nXtgEQLqreVBd3GwPGHbOvnAbtl7e5Rdz/VkKrDNk
         qC8Q==
X-Gm-Message-State: AGRZ1gKKXgOw4uE24HWjUVejgy5omnwLLvmxFTd6TSgHeWy+tk7Qd4gY
        W+PfZmsax5w4TPFYMZztOFRZfA==
X-Google-Smtp-Source: AJdET5cOkeCunf0nsmycfXndFMzt5cULp9SAC4eTUiTiSYBG0YlOeorlCbZYURqg38qZwtCXn8+Jiw==
X-Received: by 2002:a63:5518:: with SMTP id j24mr2179612pgb.208.1542327987036;
        Thu, 15 Nov 2018 16:26:27 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id t64-v6sm32749985pfd.127.2018.11.15.16.26.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 16:26:26 -0800 (PST)
Date:   Thu, 15 Nov 2018 16:26:25 -0800
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
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
Message-ID: <20181116002625.GD23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-10-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:52:56PM +0800, Ming Lei wrote:
> There are still cases in which we need to use bio_bvecs() for get the
> number of multi-page segment, so introduce it.
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
>  include/linux/bio.h | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 1f0dcf109841..3496c816946e 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -196,7 +196,6 @@ static inline unsigned bio_segments(struct bio *bio)
>  	 * We special case discard/write same/write zeroes, because they
>  	 * interpret bi_size differently:
>  	 */
> -
>  	switch (bio_op(bio)) {
>  	case REQ_OP_DISCARD:
>  	case REQ_OP_SECURE_ERASE:
> @@ -205,13 +204,34 @@ static inline unsigned bio_segments(struct bio *bio)
>  	case REQ_OP_WRITE_SAME:
>  		return 1;
>  	default:
> -		break;
> +		bio_for_each_segment(bv, bio, iter)
> +			segs++;
> +		return segs;
>  	}
> +}
>  
> -	bio_for_each_segment(bv, bio, iter)
> -		segs++;
> +static inline unsigned bio_bvecs(struct bio *bio)
> +{
> +	unsigned bvecs = 0;
> +	struct bio_vec bv;
> +	struct bvec_iter iter;
>  
> -	return segs;
> +	/*
> +	 * We special case discard/write same/write zeroes, because they
> +	 * interpret bi_size differently:
> +	 */
> +	switch (bio_op(bio)) {
> +	case REQ_OP_DISCARD:
> +	case REQ_OP_SECURE_ERASE:
> +	case REQ_OP_WRITE_ZEROES:
> +		return 0;
> +	case REQ_OP_WRITE_SAME:
> +		return 1;
> +	default:
> +		bio_for_each_bvec(bv, bio, iter)
> +			bvecs++;
> +		return bvecs;
> +	}
>  }
>  
>  /*
> -- 
> 2.9.5
> 
