Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05E2C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 21:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C4802081B
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 21:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="hgbbKqK/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C4802081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbeJaGfp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 02:35:45 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42108 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbeJaGfo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 02:35:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id t6-v6so6186737plo.9
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 14:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aHVIz18Y5sY4jsbnTbezq4QKbxhyodElUFmJSbeOYac=;
        b=hgbbKqK/rA1Xi3gam3utB+I6R/K2RXzfPHUDWxJOdk+ysanNTnsz/Tats00vzWgu8e
         nh/X+H7T4vFAPR+xHF+gxkH7yjFuyO95ustIpV0x8Zn6vwCk+tHmFXygMg8ZOznxUnkP
         3V5aLmtfLaG2JWM6Un+JvqPuyy20BDOmoawqkBKpqrDodKB+Ethe3//+McbnVw/DoQeM
         gQueKhUP1q+OBTa3CNlIZDKLnNW6OwbCB74UnvuqXqRxb9C8hpo9jBeNNMaCcqrOoCey
         xp8or6DrMtO4mMCmzXAtezrEBUdlz7hNK581is7vKqHwpPOUeHjGpQO9ZBHj2x7otebw
         YN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aHVIz18Y5sY4jsbnTbezq4QKbxhyodElUFmJSbeOYac=;
        b=RbIkcbfJcM2bDut/ViTOXN7+P1EovjqacdDFyt7dcaKpyimu36XzcmT9aUOoY+mB9H
         B0u8Qcs8Kaq10NXnZhFQp5vwvimGP67L7vD02C8H+v2t+4qGOwO97/hKW99yYWLIiyXu
         s5B6/jYYLnSA1mxh7lLCEYqVvDQqh6Mak+xwgiTHGjp8HjHZcNJMGDcd+jE9D0o5zkY+
         qEgx8ffu5iq9h76p1jeJ3SLp3JVjaug43shDD7CWTSbMl5heg0kll45OU7N1qttY7BPQ
         E5YYdKi6nx0aHYq2IhTIJz2J277V9fDfxr9f+NEgi67jxBRS5SaIOz1cI9jT2BZm73Dw
         JbKA==
X-Gm-Message-State: AGRZ1gJmuDDTCA7sOxdHHBZ6zzxIoCmOGlOQrC0XrGu+IRMJ5nh3eQ0P
        rmltz/HV71rV4d+7RssM9JE/JA==
X-Google-Smtp-Source: AJdET5f7iHo6ADSkTmAYYT+BjUPPl/JmK4Y+WJoYLjf0/wDxq83qXDjTwsiqwwSNoUpi+oloAZTJsw==
X-Received: by 2002:a17:902:bb06:: with SMTP id l6-v6mr454127pls.58.1540935634518;
        Tue, 30 Oct 2018 14:40:34 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::4:86b2])
        by smtp.gmail.com with ESMTPSA id e131-v6sm39065421pfc.52.2018.10.30.14.40.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Oct 2018 14:40:34 -0700 (PDT)
Date:   Tue, 30 Oct 2018 14:40:32 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, Omar Sandoval <osandov@fb.com>,
        linux-btrfs@vger.kernel.org, Jennifer Liu <jenniferliu620@fb.com>
Subject: Re: [PATCH] btrfs: add zstd compression level support
Message-ID: <20181030214032.GA31980@vader>
References: <20181030190621.716013-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030190621.716013-1-terrelln@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 12:06:21PM -0700, Nick Terrell wrote:
> From: Jennifer Liu <jenniferliu620@fb.com>
> 
> Adds zstd compression level support to btrfs. Zstd requires
> different amounts of memory for each level, so the design had
> to be modified to allow set_level() to allocate memory. We
> preallocate one workspace of the maximum size to guarantee
> forward progress. This feature is expected to be useful for
> read-mostly filesystems, or when creating images.
> 
> Benchmarks run in qemu on Intel x86 with a single core.
> The benchmark measures the time to copy the Silesia corpus [0] to
> a btrfs filesystem 10 times, then read it back.
> 
> The two important things to note are:
> - The decompression speed and memory remains constant.
>   The memory required to decompress is the same as level 1.
> - The compression speed and ratio will vary based on the source.
> 
> Level	Ratio	Compression	Decompression	Compression Memory
> 1    	2.59 	153 MB/s   	112 MB/s     	0.8 MB
> 2    	2.67 	136 MB/s   	113 MB/s     	1.0 MB
> 3    	2.72 	106 MB/s   	115 MB/s     	1.3 MB
> 4    	2.78 	86  MB/s   	109 MB/s     	0.9 MB
> 5    	2.83 	69  MB/s   	109 MB/s     	1.4 MB
> 6    	2.89 	53  MB/s   	110 MB/s     	1.5 MB
> 7    	2.91 	40  MB/s   	112 MB/s     	1.4 MB
> 8    	2.92 	34  MB/s   	110 MB/s     	1.8 MB
> 9    	2.93 	27  MB/s   	109 MB/s     	1.8 MB
> 10   	2.94 	22  MB/s   	109 MB/s     	1.8 MB
> 11   	2.95 	17  MB/s   	114 MB/s     	1.8 MB
> 12   	2.95 	13  MB/s   	113 MB/s     	1.8 MB
> 13   	2.95 	10  MB/s   	111 MB/s     	2.3 MB
> 14   	2.99 	7   MB/s   	110 MB/s     	2.6 MB
> 15   	3.03 	6   MB/s   	110 MB/s     	2.6 MB
> 
> [0] http://sun.aei.polsl.pl/~sdeor/index.php?page=silesia

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Jennifer Liu <jenniferliu620@fb.com>
> Signed-off-by: Nick Terrell <terrelln@fb.com>
> ---
>  fs/btrfs/compression.c | 172 +++++++++++++++++++++++++----------------
>  fs/btrfs/compression.h |  18 +++--
>  fs/btrfs/lzo.c         |   5 +-
>  fs/btrfs/super.c       |   7 +-
>  fs/btrfs/zlib.c        |  33 ++++----
>  fs/btrfs/zstd.c        |  74 ++++++++++++++----
>  6 files changed, 204 insertions(+), 105 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 2955a4ea2fa8..bd8e69381dc9 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -822,11 +822,15 @@ void __init btrfs_init_compress(void)
>  
>  		/*
>  		 * Preallocate one workspace for each compression type so
> -		 * we can guarantee forward progress in the worst case
> +		 * we can guarantee forward progress in the worst case.
> +		 * Provide the maximum compression level to guarantee large
> +		 * enough workspace.
>  		 */
> -		workspace = btrfs_compress_op[i]->alloc_workspace();
> +		workspace = btrfs_compress_op[i]->alloc_workspace(
> +				btrfs_compress_op[i]->max_level);
>  		if (IS_ERR(workspace)) {
> -			pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
> +			pr_warn("BTRFS: cannot preallocate compression "
> +				"workspace, will try later\n");

Nit: since you didn't change this line, don't rewrap it.
