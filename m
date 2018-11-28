Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A8AC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFE8320645
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:25:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="gHS7SPZ8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFE8320645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbeK1LY7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 06:24:59 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46374 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeK1LY7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 06:24:59 -0500
Received: by mail-pg1-f195.google.com with SMTP id w7so8615555pgp.13
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=czMNXcgf4DDbKxoM9ah0l7D6AywmMen44WNqy9s+/Q4=;
        b=gHS7SPZ8rvFZguegKHSh2tYRSCVNAN+sIzHsoL0KUshy6eD8ppa2UQ8cAOUMjtyTPE
         MiOE4iBPuacx0hZS48+BFgq/b1wkhBTDQ0vttuwUPY6pb0YzBEDT9Pu/JPJTcmEg8RNx
         ddfnR8XHjYPIuM/jdqNXYdJHKoV4PypgxdWw5BftQMaHx7vgr1wSsit1+I2nmiOxtir/
         wr9yQUxa5ZoTzRKG3l0PYhy5gZ+vYNz1VKkjXUNpqLKy/HGuf4sm/XpjqpQNtIcOzepr
         FHJbb/6NBy58FdYidt3Srz1rdmnLcZQZGqeJcGAT502+eTAKc72lKS5S8TpfXzBajXKw
         GSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=czMNXcgf4DDbKxoM9ah0l7D6AywmMen44WNqy9s+/Q4=;
        b=DzlUIc49fKPp6MkmEuxrQG17BVx5cIeMnXbbth+hNXzZV0B7KCzcb5n2NVOUw64tbv
         Rq9KpRd+mgHXl9gUyPOKG8sqmSnC0jmWEpe+sad5sfrZoOnarWwhZQj1GyQKgz38dAPv
         5zyYmDKJmzoyXrdKenfwUZ1AUWmhZePRxrg/BfFdYBhR+GfUlFdA5FXRZ/FWKMhVIItq
         5Z51CkfnpHBNDeYRtuhgQKofixY0NfQekBKSZonih1QYEtbStav0YByvxAGkc0fYRqBc
         WRTUFbzlDmXO3nzFTov3M5hsFxy5Pa7vkI4jI79jasXeAOl6N+mwWBldfE+52PmACFT5
         t9dA==
X-Gm-Message-State: AA+aEWbBWP/k0y8gHh9xT6xQOXPRLcavZa7iYtRkD34eLeQfftKcGATf
        gh5an1qKI8AJSk1cDgb2FbZezbe8SwY=
X-Google-Smtp-Source: AFSGD/XgOUuFMDUDoiRnmGr3TN6W2vET8H8M6J0gfMiENUc0T+j0VQu0kKvyXIPl+9UN8UkjoaI+vw==
X-Received: by 2002:a63:8441:: with SMTP id k62mr30973661pgd.392.1543364720223;
        Tue, 27 Nov 2018 16:25:20 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:71bd])
        by smtp.gmail.com with ESMTPSA id d2-v6sm7743582pfj.106.2018.11.27.16.25.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 16:25:19 -0800 (PST)
Date:   Tue, 27 Nov 2018 16:25:18 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/9] btrfs: switch BTRFS_BLOCK_RSV_* to enums
Message-ID: <20181128002518.GJ846@vader>
References: <cover.1543348078.git.dsterba@suse.com>
 <cc7de532fc2398392c2735c085f09d5ee07c3b9b.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7de532fc2398392c2735c085f09d5ee07c3b9b.1543348078.git.dsterba@suse.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:53:43PM +0100, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> block reserve types.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index f82ec5e41b0c..40c405d74a01 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -461,13 +461,18 @@ struct btrfs_space_info {
>  	struct kobject *block_group_kobjs[BTRFS_NR_RAID_TYPES];
>  };
>  
> -#define	BTRFS_BLOCK_RSV_GLOBAL		1
> -#define	BTRFS_BLOCK_RSV_DELALLOC	2
> -#define	BTRFS_BLOCK_RSV_TRANS		3
> -#define	BTRFS_BLOCK_RSV_CHUNK		4
> -#define	BTRFS_BLOCK_RSV_DELOPS		5
> -#define	BTRFS_BLOCK_RSV_EMPTY		6
> -#define	BTRFS_BLOCK_RSV_TEMP		7
> +/*
> + * Types of block reserves
> + */
> +enum {
> +	BTRFS_BLOCK_RSV_GLOBAL,
> +	BTRFS_BLOCK_RSV_DELALLOC,
> +	BTRFS_BLOCK_RSV_TRANS,
> +	BTRFS_BLOCK_RSV_CHUNK,
> +	BTRFS_BLOCK_RSV_DELOPS,
> +	BTRFS_BLOCK_RSV_EMPTY,
> +	BTRFS_BLOCK_RSV_TEMP,
> +};
>  
>  struct btrfs_block_rsv {
>  	u64 size;
> -- 
> 2.19.1
> 
