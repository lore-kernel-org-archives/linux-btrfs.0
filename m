Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB2EC282C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 22:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 678A0214DA
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 22:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="0evcYAP7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfA2Wa4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 17:30:56 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37842 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfA2Wa4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 17:30:56 -0500
Received: by mail-pf1-f196.google.com with SMTP id y126so10375069pfb.4
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 14:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aps5FwIxeziueABcCIULWl0lThwSnZ/ind67Z6EFwOA=;
        b=0evcYAP7KpRODQF21JXMK9uzho9mL6Xq4e6RoZ6tHVfjgsY9vncictzJ1HOJrjfh07
         PLf+UZQaHdNW+Iut+ZhH7wl0IFRuSCnnePSZ2AgHfAIScT70IlrXj6MNmQOziCyQBhcF
         Q/A6WEOgSGTWz5U8nx12B1YgZLZMEEHaIMTGZholcfebxugTZu9yKxa3BeBilmkK8uNH
         8IZ4bmeB4hSWGantCixnsuSC8lx/ZN+g2dKZdyBkuR0H0lofNF8kqjVP9Jgx/hGiGUl2
         V+tpNRoMpdnCAXRer6qISqqX2rFisEAQB5hRDVkSeWiYMssR3MbJlFNMbXrVS9BUMCZ5
         MNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aps5FwIxeziueABcCIULWl0lThwSnZ/ind67Z6EFwOA=;
        b=cGRre7cbPHe3RuyjcVn0pQOlIMPbd+42dJ/l+d3BG3iP3K/n7lhfpaloZMyrq4mtya
         QoCR0X0Ym3fZ3pcRRyEcNpUQT5FavboF64KXZjS7U26sUMghYI6ChasGE8iKGAc8SBXa
         dmbRolV0qQoaow6apoYXaJkzkuFClQPLXpYoIQaYE3QNaYC/KdEhuJywnmE2/YhvSj7r
         EeT6sf148rV1eptep7xUOkiyBxts4SFnLMPzLyr5idl7nnO3c//RlLa1ofgWfY5DiCmS
         crTkXa7ZZOYbIe+D3ykxs4Ib3yUifPH1zV5kQGjDqQPFDu+26O063UF7rYWN52u2lq3H
         N9XA==
X-Gm-Message-State: AJcUuke6gFyxOuxDmCt4uxkDTqoe5oUvbIHkWD6zcgyDHgCT2udR11o3
        C6gf8KGddMmsVhKZu2jUcrDOdsIdwMc=
X-Google-Smtp-Source: ALg8bN4lGpgsryFpIvRUhSeIVhC45N4KHaK9NM7nR7NvhzYttBeQJWbQgonyxy3pXu+bfjDbkdv2qw==
X-Received: by 2002:a62:a510:: with SMTP id v16mr27847160pfm.18.1548801054736;
        Tue, 29 Jan 2019 14:30:54 -0800 (PST)
Received: from vader ([2620:10d:c090:200::7:d948])
        by smtp.gmail.com with ESMTPSA id y6sm42802694pfl.187.2019.01.29.14.30.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 14:30:53 -0800 (PST)
Date:   Tue, 29 Jan 2019 14:30:53 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] btrfs: add macros for compression type and level
Message-ID: <20190129223053.GB22926@vader>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-2-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-2-dennis@kernel.org>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:27PM -0500, Dennis Zhou wrote:
> It is very easy to miss places that rely on a certain bitshifting for
> decyphering the type_level overloading. Make macros handle this instead.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> ---
>  fs/btrfs/compression.c | 2 +-
>  fs/btrfs/compression.h | 3 +++
>  fs/btrfs/zlib.c        | 2 +-
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 548057630b69..586f95ac0aea 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1036,9 +1036,9 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
>  			 unsigned long *total_in,
>  			 unsigned long *total_out)
>  {
> +	int type = BTRFS_COMPRESS_TYPE(type_level);
>  	struct list_head *workspace;
>  	int ret;
> -	int type = type_level & 0xF;
>  
>  	workspace = find_workspace(type);
>  
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index ddda9b80bf20..69a9197dadc3 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -25,6 +25,9 @@
>  
>  #define	BTRFS_ZLIB_DEFAULT_LEVEL		3
>  
> +#define BTRFS_COMPRESS_TYPE(type_level)		(type_level & 0xF)
> +#define BTRFS_COMPRESS_LEVEL(type_level)	((type_level & 0xF0) >> 4)

Nit: these can be inline functions rather than macros.

>  struct compressed_bio {
>  	/* number of bios pending for this compressed extent */
>  	refcount_t pending_bios;
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index 970ff3e35bb3..1480b3eee306 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -393,7 +393,7 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
>  static void zlib_set_level(struct list_head *ws, unsigned int type)
>  {
>  	struct workspace *workspace = list_entry(ws, struct workspace, list);
> -	unsigned level = (type & 0xF0) >> 4;
> +	unsigned int level = BTRFS_COMPRESS_LEVEL(type);
>  
>  	if (level > 9)
>  		level = 9;
> -- 
> 2.17.1
> 
