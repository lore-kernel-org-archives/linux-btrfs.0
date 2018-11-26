Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70590C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 312692082F
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:14:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="O7WNWIgz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 312692082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbeK0JKZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:10:25 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32770 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbeK0JKY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:10:24 -0500
Received: by mail-pf1-f195.google.com with SMTP id c123so6569867pfb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9AkyZOjm/sng5co17bYs/2llMKYYVqfTbY1b6HL7DLY=;
        b=O7WNWIgzkXf1oK/nBoaA7B4ovU42gjQqCbUt0jqoaewwuXODvM+n28sAcfrqBN9FxF
         d+sCGTNY8vm9rg4JinMqrXUuXNXRMlbt1mxB1YKPSUhT4JVM7iS2IlpdA4gQ0Dbtly6B
         b2f7hLoWHcdQSAZNx+KRZWuj5zakI4I7SM2Qr/3tFvtVY8TpnkvNwPHrG5yJ9VGMFgtr
         yYMsTmf2CRSl8Pu6UI0/a3xitEaMyrgsc53AbOgHEJwUU8vUMnbYjVGEPT07Pl1LiopT
         aO9PKUVWDb+36q4jj+nyvSoOvdeWUlrWvviQvDDHOl9BFLYcvbShWR4hYnL9ThOjXc6n
         J73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9AkyZOjm/sng5co17bYs/2llMKYYVqfTbY1b6HL7DLY=;
        b=HowTTBxXpeWb5AOL+OJrhsHngbGc3FA5eXqSiTKRy1Z2C0lwNwuCIhanYvkaoWoed4
         zixf1rEFCj1QXn7facyEiXMCNSAeTHgjeAULQZMayI+922brihypxIQgUBL/YlAkHJIb
         UMJhF91/IpEZJzAz8ug284FFy0etS6ArNG7fV94PylceVoC5SIFkf2zUa1dKApI0q3VF
         Uc6LipZyR3d099sgQiZhVhzu/r4aGYnr3hBUF5BzW66m78vW7+lV4zWqqaXKA2fA21Q5
         F/jqUOiq3kC/2aP42afkjJzBkE0hNdG9b++RL74OsSxlyUcyYIglzkMuDQVLdmXOQ0qd
         yPIw==
X-Gm-Message-State: AA+aEWb+kuJUIU7a8R+uGCEtL+qYMnso1oQuBe2UnS1grMjIYhJhPKmg
        7DYcXhbu3UohvPotL7YoqwwX0w==
X-Google-Smtp-Source: AFSGD/Vm+Spxe/zyUiRC0YAVLq9Jbt6VMBjbU7UkRQ356r0R43oVMqtcBLFDj2BhbKX//LTFiFkUvQ==
X-Received: by 2002:a63:78cd:: with SMTP id t196mr26824599pgc.62.1543270489280;
        Mon, 26 Nov 2018 14:14:49 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id c67sm1688753pfg.170.2018.11.26.14.14.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:14:48 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:14:47 -0800
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
Subject: Re: [PATCH V12 04/20] block: don't use bio->bi_vcnt to figure out
 segment number
Message-ID: <20181126221447.GE30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-5-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-5-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:04AM +0800, Ming Lei wrote:
> It is wrong to use bio->bi_vcnt to figure out how many segments
> there are in the bio even though CLONED flag isn't set on this bio,
> because this bio may be splitted or advanced.
> 
> So always use bio_segments() in blk_recount_segments(), and it shouldn't
> cause any performance loss now because the physical segment number is figured
> out in blk_queue_split() and BIO_SEG_VALID is set meantime since
> bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting").
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Fixes: 76d8137a3113 ("blk-merge: recaculate segment if it isn't less than max segments")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-merge.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index e69d8f8ba819..51ec6ca56a0a 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -367,13 +367,7 @@ void blk_recalc_rq_segments(struct request *rq)
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
