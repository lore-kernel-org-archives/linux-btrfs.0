Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0028BC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 02:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBD96208A3
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 02:05:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="NOOIr37k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBD96208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbeKPMQJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 07:16:09 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41510 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbeKPMQD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 07:16:03 -0500
Received: by mail-pg1-f195.google.com with SMTP id 70so9862365pgh.8
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 18:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tk4zNnRl3iveRzr8VK3BRLGltG68AkALc7dg+BBUT20=;
        b=NOOIr37kMhSPPEh4ThKn2PW78U00DXit+OJMUDU7rUlCiAhyxflrXohn8zcOMK/7l/
         +bXGEUYbes0UROImsRGND5Ic3+0Nhs/AG4lN0QOqPdYHBtSPT+1IcYhF451qs0ZmVbVt
         6b7S8Mws9hiUZnwp7VtXrFf2hU9EOMEmuKqB6HnH4uKITJXBgOmEpI98UIvplxof/tir
         x/Zl/Ux/OOxBlGrw7Dw1qev30vwfLfIpBdD8iIXnG6mIMaWLTcQXf6ldDaPt3MUANg7p
         tInPs235BNbt8zBzJhK8YXR2GzFm0zWZqRbh21MzJ83LVmDqgffBY982ZbRoz41vql2p
         Ko/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tk4zNnRl3iveRzr8VK3BRLGltG68AkALc7dg+BBUT20=;
        b=LEq+Hm091pqhFM/tFADhwfc1K/fFOzsIOsSJBwae14DGkOhbCFSjs7LakQJaFAjLMQ
         u3sT1iC/pRydDklNgQvuUHGueXTayNBw7658uLspRUcscnWtOs/f3eomxN5V5WUBdqGt
         fZHjD+Vdj8sDESDkD4x660Y/9fthdWL1sarieVUvPPPd4i1D0Gp2qg7F/dCnKpupLGgx
         aOuGbHt9JZrX7pDA750CAHsWVJk75uSeLwVvP05orbIXPz1VJxZyPAgiUF2Dpd745FnQ
         Sb/Mr+MaiFAMAdsyQWvAxMIvbWMQTR9awbq0xC47tlfp8giLvmYFyBzbxd8cBgGsMaTb
         DQpA==
X-Gm-Message-State: AGRZ1gJ8KGu5as/Hf/cYfbjNZJcx52FTj3keu8yrqVRa9XIDV/X4VeHG
        dnt6z2q5OTYkAxxTp25fYQi3VA==
X-Google-Smtp-Source: AJdET5cDAqhOHxXhbkbViZgbSd2eSNDO4RE/M2++M50J4g8uUr6objVxBuN27R5l99W82ZePM0EHvw==
X-Received: by 2002:a63:101:: with SMTP id 1mr8156529pgb.152.1542333935862;
        Thu, 15 Nov 2018 18:05:35 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id s37sm25513907pgm.19.2018.11.15.18.05.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 18:05:35 -0800 (PST)
Date:   Thu, 15 Nov 2018 18:05:33 -0800
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
Subject: Re: [PATCH V10 16/19] block: document usage of bio iterator helpers
Message-ID: <20181116020533.GK23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-17-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-17-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:53:03PM +0800, Ming Lei wrote:
> Now multi-page bvec is supported, some helpers may return page by
> page, meantime some may return segment by segment, this patch
> documents the usage.
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
>  Documentation/block/biovecs.txt | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
> index 25689584e6e0..bfafb70d0d9e 100644
> --- a/Documentation/block/biovecs.txt
> +++ b/Documentation/block/biovecs.txt
> @@ -117,3 +117,29 @@ Other implications:
>     size limitations and the limitations of the underlying devices. Thus
>     there's no need to define ->merge_bvec_fn() callbacks for individual block
>     drivers.
> +
> +Usage of helpers:
> +=================
> +
> +* The following helpers whose names have the suffix of "_all" can only be used
> +on non-BIO_CLONED bio, and usually they are used by filesystem code, and driver
> +shouldn't use them because bio may have been split before they got to the driver:

Putting an english teacher hat on, this is quite the run-on sentence.
How about:

* The following helpers whose names have the suffix of "_all" can only be used
on non-BIO_CLONED bio. They are usually used by filesystem code. Drivers
shouldn't use them because the bio may have been split before it reached the
driver.

Maybe also an explanation of why the filesystem would want to use these?

> +	bio_for_each_segment_all()
> +	bio_first_bvec_all()
> +	bio_first_page_all()
> +	bio_last_bvec_all()
> +
> +* The following helpers iterate over single-page bvec, and the local
> +variable of 'struct bio_vec' or the reference records single-page IO
> +vector during the itearation:


* The following helpers iterate over single-page bvecs. The passed 'struct
bio_vec' will contain a single-page IO vector during the iteration.

> +	bio_for_each_segment()
> +	bio_for_each_segment_all()
> +
> +* The following helper iterates over multi-page bvec, and each bvec may
> +include multiple physically contiguous pages, and the local variable of
> +'struct bio_vec' or the reference records multi-page IO vector during the
> +itearation:

* The following helper iterates over multi-page bvecs. Each bvec may
include multiple physically contiguous pages. The passed 'struct bio_vec' will
contain a multi-page IO vector during the iteration.

> +	bio_for_each_bvec()
> -- 
> 2.9.5
> 
