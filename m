Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4ACC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FD982082F
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="f/7XFRkx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FD982082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbeK0JIe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:08:34 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42367 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbeK0JIe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:08:34 -0500
Received: by mail-pg1-f193.google.com with SMTP id d72so6805731pga.9
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z828Q1hGWN4xE0ZgmUT37ch1Jh+fPsJT+V+amprtHxs=;
        b=f/7XFRkxWkgNbPNPf+s6683DpOao683kKiPGfp+GDY1wWulUsqMdaALo9ICdTUmCxJ
         N9V3AYcRNie0T3XNvPm5DKhfUhniEaEw3zGp9Hse6oePD1pVUsqmvE2uC/mcg5+XIxnU
         LMKdFvP/+gdqw+WJ+0zz33dXh471ApwV+CszQ6S8iVabJDAyB8RgAw6VXGF1THvbn6Kj
         o9Flhc42RZGBCVbTQs5wtxHFWH2GcnA1vBPkvQefc+fi2XIgy8Vx9Q8wXXGWNEv5FBGD
         r3wuGSM48Ustfn1hUNS3X++TFN30nIeaTExPEOtWt+kYFe39c/YU7xDg2ixcbDV4lgxx
         K8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z828Q1hGWN4xE0ZgmUT37ch1Jh+fPsJT+V+amprtHxs=;
        b=YtdOZMhKGIxVcGCfYQUOrZWyncFUeBw3JP79mbUc4TriY9azFUyR82RrBx29wD3JtZ
         jaGICrncEnjvg7CGeNbLPrIl/iUFzk66anEZi+qGjOmA6yQLnuP+apeIojCIgWCXVr/x
         txbdmaNxGCC4PnUdc0gxWOIJLEjDYcWbyYhARaRBaT6cVs3w38DSm00mYt0+HuaNtQ9q
         kAhxll79+bY+jj4bs7M9zXDF14v+9mXF/+Eb1jiSHso7oxnc2AKEIiTSSmQwmLNy0V4Y
         xE6ayD/c3YZAkVn1r393g1F5YvilaI25uTlStvcI0mUZPa9VhHidNDzZ3sgyk9FiwxSr
         tMDQ==
X-Gm-Message-State: AGRZ1gLgO6aj63StcS/FR/vm+SnLKr6MfCf2FN3WgQCy2LzFphtR3zeG
        LestDsNZE5GX35AppfjqTrNhWg==
X-Google-Smtp-Source: AJdET5cTQuaqAg55SqlEDPYiv4+R2g4Vn4siqfxm4fzsHzoMq4v8KxsClX1F2y/iS6mNA81LmxEZAQ==
X-Received: by 2002:a62:6d07:: with SMTP id i7-v6mr31099102pfc.146.1543270378421;
        Mon, 26 Nov 2018 14:12:58 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id v184sm1780153pfb.182.2018.11.26.14.12.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:12:57 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:12:56 -0800
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
Subject: Re: [PATCH V12 03/20] block: remove the "cluster" flag
Message-ID: <20181126221256.GD30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-4-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-4-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:03AM +0800, Ming Lei wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> The cluster flag implements some very old SCSI behavior.  As far as I
> can tell the original intent was to enable or disable any kind of
> segment merging.  But the actually visible effect to the LLDD is that
> it limits each segments to be inside a single page, which we can
> also affect by setting the maximum segment size and the segment
> boundary.

Reviewed-by: Omar Sandoval <osandov@fb.com>

One comment typo below.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Replace virt boundary with segment boundary limit.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-merge.c       | 20 ++++++++------------
>  block/blk-settings.c    |  3 ---
>  block/blk-sysfs.c       |  5 +----
>  drivers/scsi/scsi_lib.c | 20 ++++++++++++++++----
>  include/linux/blkdev.h  |  6 ------
>  5 files changed, 25 insertions(+), 29 deletions(-)
> 

[snip]

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0df15cb738d2..78d6d05992b0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1810,6 +1810,8 @@ static int scsi_map_queues(struct blk_mq_tag_set *set)
>  void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>  {
>  	struct device *dev = shost->dma_dev;
> +	unsigned max_segment_size = dma_get_max_seg_size(dev);
> +	unsigned long segment_boundary = shost->dma_boundary;
>  
>  	/*
>  	 * this limit is imposed by hardware restrictions
> @@ -1828,13 +1830,23 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>  	blk_queue_max_hw_sectors(q, shost->max_sectors);
>  	if (shost->unchecked_isa_dma)
>  		blk_queue_bounce_limit(q, BLK_BOUNCE_ISA);
> -	blk_queue_segment_boundary(q, shost->dma_boundary);
>  	dma_set_seg_boundary(dev, shost->dma_boundary);
>  
> -	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
> +	/*
> +	 * Clustering is a really old concept from the stone age of Linux
> +	 * SCSI support.  But the basic idea is that we never give the
> +	 * driver a segment that spans multiple pages.  For that we need
> +	 * to limit the segment size, and set the segment boundary so that
> +	 * we never merge a second segment which is no page aligned.

Typo, "which is not page aligned".
