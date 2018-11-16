Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB09C04EBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 01:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 514F32146D
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 01:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="YAA64tUv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 514F32146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389201AbeKPMKE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 07:10:04 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40213 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbeKPMKE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 07:10:04 -0500
Received: by mail-pg1-f195.google.com with SMTP id z10so9858964pgp.7
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 17:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L0tQ8ikizxQAgBWBpIiO7+X7FmVylN8wyOGQDrGUknE=;
        b=YAA64tUvsxftqPcARSFvNfvC4gEp9ESF8e9jlJElleZLA4PX+vdfZ9/2UEXqAt5wzz
         K0WNBrLAA5gMWcUz5j5NrwVG/zy8LWrHEpAIPe0ov54g6JE7sJWhvUq9VV+DWfda2sVT
         QIW3ylMmDw+fAVg3Cpj0qhrGf0tbFiro3jvK9gz82rTyxNMJz5P5avgE1B3jOyBJR+Gx
         x6JAGACHMZcG7E0iemqhvKMsu8dl/+VWO7x8FcuVk+Gl8jlZx+IZpODIDigJn62+SKzE
         fvxAL1JOd0T6j/BZg+xie4clkW1ocHVcnBk/Dy5Lbilc/Is67FHaSlDAZir14aDmLpC5
         1HxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=L0tQ8ikizxQAgBWBpIiO7+X7FmVylN8wyOGQDrGUknE=;
        b=oQa35gUgu3d6gsD1ZaBV1dSu3UIWcndcW388+Lf8cbCJN6VgKDd9YEMKzmHTTrD84X
         Yj+31TaYkddPezLEiLoAmHQ31Shafk/fv6y4VacYpRtaR0Av9b2FoaaEbef9if7mK0lI
         Sz6tGFpyHIXBG11S4+H24SsVEBYpqUsC+X2oeKPg0yyXp75qFQ1ezzVhuLhGuPDoqtmP
         izJvtKiy9zOIdcsiRlnnO+3S+yd4CDcKoJHgIaZLZ43HR80sadw5axE+P6BZt3091g/a
         22CBnOmJMb4oAdIkWQ6z58ppeZ2wx7w4VWasp6zo2PJZTp5MWJCm83NUvPFeQSHCvSy+
         /BEg==
X-Gm-Message-State: AGRZ1gIQi3AgMJLKEfPx6HoaG5JQGnjEit6Mn0MdgV+bG6qZwhBkUNUZ
        oAZulbwBNzce5kyLwjf57U7zcg==
X-Google-Smtp-Source: AJdET5eUyw+8KU8Asz6AsSE46jRbu3E7Mpd3Eo3LRaHPzwQJZ7wsjMF2vOsptoFTJn6ARLeTnbzNkQ==
X-Received: by 2002:a63:4d0e:: with SMTP id a14mr1277785pgb.408.1542333578366;
        Thu, 15 Nov 2018 17:59:38 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id i72sm5797049pfe.181.2018.11.15.17.59.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 17:59:37 -0800 (PST)
Date:   Thu, 15 Nov 2018 17:59:36 -0800
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
Subject: Re: [PATCH V10 15/19] block: always define BIO_MAX_PAGES as 256
Message-ID: <20181116015936.GJ23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-16-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-16-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:53:02PM +0800, Ming Lei wrote:
> Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
> increase BIO_MAX_PAGES for it.

You mentioned to it in the cover letter, but this needs more explanation
in the commit message. Why did CONFIG_THP_SWAP require > 256? Why does
multipage bvecs remove that requirement?

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
>  include/linux/bio.h | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 5040e9a2eb09..277921ad42e7 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -34,15 +34,7 @@
>  #define BIO_BUG_ON
>  #endif
>  
> -#ifdef CONFIG_THP_SWAP
> -#if HPAGE_PMD_NR > 256
> -#define BIO_MAX_PAGES		HPAGE_PMD_NR
> -#else
>  #define BIO_MAX_PAGES		256
> -#endif
> -#else
> -#define BIO_MAX_PAGES		256
> -#endif
>  
>  #define bio_prio(bio)			(bio)->bi_ioprio
>  #define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
> -- 
> 2.9.5
> 
