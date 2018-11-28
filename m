Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD34C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DDFD204FD
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:31:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="0NFpuUEs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DDFD204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbeK1LbM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 06:31:12 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39322 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeK1LbM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 06:31:12 -0500
Received: by mail-pf1-f196.google.com with SMTP id c72so9241857pfc.6
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p1QSYQUFEL5NHg0jwW4SXDwV2AAvo4f/khw636CPCZk=;
        b=0NFpuUEs1x9UNtrjk/ttWA7VPuzxFUl3n7NVD3FxnhAavX6mAn5/qJfwCX1/UAshsJ
         PKBKW3C6cDJD5tlCJRZqXNH42dhnxp9G7MiOCuv3e88MHA4fVvoIGYkfMdGhp0juNdfQ
         2tBL1+bT4WJ3YIrv2fTb9tlaeJWKO7qLmMyT7Elobl4jKcb7a1qvCki9mhftB0N7xxLt
         9k/Lme/I6kcJxP7jowzc5vv7bh/bimXx337VZQgX/8ihMuE1YFtQ0JW5MW5LVq8VS5Xc
         WqKrxJxhRlZ5lEvCVcx0RvGVzFKWWtURN9ha4YG45XPuXP7awI9fkPR4tWC5BNg0osMh
         FHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p1QSYQUFEL5NHg0jwW4SXDwV2AAvo4f/khw636CPCZk=;
        b=dVbdkmdOkroiYwQTgxNr7ptuvBHtnnIOfiVKhJuD9F6hBk5frkdvrkGNHdjbBjqiSd
         qegOuv9J+pDGE8fuFNm3X6CThNH5PjrOzp0s8fPDZbbVcitxoGqGTx82nUTztSB9tuBy
         R6f6wK5XPE7ExBdWt82VJJcWjkTzp2XjMYSj9chYoh/Qb/8zCQxUP0MmG8b6rolDb1ZR
         YPC29GXz/YcvYxb/K2UUh+RVST2pTD+zvqJWgEmPMmQkTVd/6uEd3baflo1+BpuOH/JD
         kupk0Kzzdw3WkUlD2OvIfDlcgVmduXc39Od+UqgOZ5+zCvY2sXq2RfNMBLygdUG5/Rge
         5lzQ==
X-Gm-Message-State: AA+aEWYpvhtEg4wqforLmn38jUk85QxGmFf8eY5t2Uns8RaoDW5Lj90p
        W0mo71Z44XiMLD0KmlY64a3FK7VV4iM=
X-Google-Smtp-Source: AFSGD/Xg0Jb6pxoHzy8dRnCwkcjMH5xOyWIDlxkZsjHkW3+w2UFDUzLz6rIjkS3Hfi7uX7+0SToh/w==
X-Received: by 2002:a63:f710:: with SMTP id x16mr31373806pgh.322.1543365092620;
        Tue, 27 Nov 2018 16:31:32 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:71bd])
        by smtp.gmail.com with ESMTPSA id h7sm7060946pfa.105.2018.11.27.16.31.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 16:31:32 -0800 (PST)
Date:   Tue, 27 Nov 2018 16:31:31 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/9] btrfs: swtich EXTENT_BUFFER_* to enums
Message-ID: <20181128003131.GM846@vader>
References: <cover.1543348078.git.dsterba@suse.com>
 <132de3b38834a3703cc9cebe56e7de8dcbcec1c9.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <132de3b38834a3703cc9cebe56e7de8dcbcec1c9.1543348078.git.dsterba@suse.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:53:50PM +0100, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> extent buffer flags;

This one has a "swtich" typo in the subject. Otherwise,

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.h | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index a1d3ea5a0d32..fd42492e62e5 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -37,18 +37,22 @@
>  #define EXTENT_BIO_COMPRESSED 1
>  #define EXTENT_BIO_FLAG_SHIFT 16
>  
> -/* these are bit numbers for test/set bit */
> -#define EXTENT_BUFFER_UPTODATE 0
> -#define EXTENT_BUFFER_DIRTY 2
> -#define EXTENT_BUFFER_CORRUPT 3
> -#define EXTENT_BUFFER_READAHEAD 4	/* this got triggered by readahead */
> -#define EXTENT_BUFFER_TREE_REF 5
> -#define EXTENT_BUFFER_STALE 6
> -#define EXTENT_BUFFER_WRITEBACK 7
> -#define EXTENT_BUFFER_READ_ERR 8        /* read IO error */
> -#define EXTENT_BUFFER_UNMAPPED 9
> -#define EXTENT_BUFFER_IN_TREE 10
> -#define EXTENT_BUFFER_WRITE_ERR 11    /* write IO error */
> +enum {
> +	EXTENT_BUFFER_UPTODATE,
> +	EXTENT_BUFFER_DIRTY,
> +	EXTENT_BUFFER_CORRUPT,
> +	/* this got triggered by readahead */
> +	EXTENT_BUFFER_READAHEAD,
> +	EXTENT_BUFFER_TREE_REF,
> +	EXTENT_BUFFER_STALE,
> +	EXTENT_BUFFER_WRITEBACK,
> +	/* read IO error */
> +	EXTENT_BUFFER_READ_ERR,
> +	EXTENT_BUFFER_UNMAPPED,
> +	EXTENT_BUFFER_IN_TREE,
> +	/* write IO error */
> +	EXTENT_BUFFER_WRITE_ERR,
> +};
>  
>  /* these are flags for __process_pages_contig */
>  #define PAGE_UNLOCK		(1 << 0)
> -- 
> 2.19.1
> 
