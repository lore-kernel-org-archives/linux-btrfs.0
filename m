Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A246C46475
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 14:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D2C220685
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 14:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHJHpcyy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D2C220685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbeKEX5W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:57:22 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40981 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbeKEX5W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 18:57:22 -0500
Received: by mail-pf1-f195.google.com with SMTP id e22-v6so4519852pfn.8;
        Mon, 05 Nov 2018 06:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8+8I/eQqiDXhce3J03v8grupt2D0goqdxCeIffJZIPI=;
        b=KHJHpcyyCjnMnhdCno+ewTY1WcXdICYeWpWYDzzSzXmb+oWV7Gl8EOY+YUuiOCqblL
         2wy03AmSPYT/nr5QwAEjSEA8N8mPVSlRdGf8+TkxXBqZhv6/h2N6K5q41fDxdjLl3B/e
         gB4cWHppTTb6hkn5e0Y0QBIRES7iXmrCwgnBHEU2x9iluJn4yvybQoE90aulOQ0j5RAz
         wph1jiMtJ4DjV/peVX3hlnsc8WG2hYw/CGDTYLK/ei4vigX2pN0e7j/sXqzxn01UEgTV
         t22EFw6u+f0GWJQ76e65WRHUZNSf7bAmS7DdfOVjB9by4ni6+Sa35Zz9/LC3wvC4GLMl
         +5pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8+8I/eQqiDXhce3J03v8grupt2D0goqdxCeIffJZIPI=;
        b=til27UrWaFShjJRoYoib9PavsmCy4g8sMaWGc3xeCuEe83rlgDSfGcBuUVOyhJL6mT
         fhMA5XvZkPb76ozNlgJ6oKCRdV39VlSitH5hfdFQXB6dRrG2X84rGRbcTsO689BhbmJW
         Hk0pypM4th32f7KBVvBuz8d93lG2xgBM+nDj6ufNg/sTVh29vq1of9e3/n/onR9Pv4mj
         LXRSyQR9PU/qCiWTMMPIY9/Kwk8Q0ORiKoqf4QIh9foKUI6YsllCa7NsmktJeS/JfL3Q
         3InuUr8b8nkRJgYvSPb9IMhJrLYN6IlPYgQIY5HeZlnnLHLoaYjLz5I72K7FVxd98FnH
         GpKQ==
X-Gm-Message-State: AGRZ1gK0eBsQ0VI3rpCNYGd4GGXg61Z8yjLnMCz5yETBPmTH1Vi41Vuz
        1QLDWkcf/m/8WkiQQ+ClMAg=
X-Google-Smtp-Source: AJdET5fkK2/hs2SnHha1d6NCj5Jn7T0bxtWO/CGzHqAgTwpq8584JS5RLaLxYIGwopd/BlhvEBLy6g==
X-Received: by 2002:a63:1342:: with SMTP id 2-v6mr20148687pgt.19.1541428641125;
        Mon, 05 Nov 2018 06:37:21 -0800 (PST)
Received: from mail.google.com ([2001:19f0:6001:4ff6:5400:1ff:feb7:a195])
        by smtp.gmail.com with ESMTPSA id p14-v6sm50648616pgn.45.2018.11.05.06.37.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Nov 2018 06:37:20 -0800 (PST)
Date:   Mon, 5 Nov 2018 14:37:18 +0000
From:   Changbin Du <changbin.du@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Changbin Du <changbin.du@gmail.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, Gu Jinxiang <gujx@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
Message-ID: <20181105143717.xrarjgcdgaipmsqd@mail.google.com>
References: <20181103153941.1881966-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181103153941.1881966-1-arnd@arndb.de>
User-Agent: NeoMutt/20180716-508-7c9a6d
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for this fix.

Reviewed-by: Changbin Du <changbin.du@gmail.com>

On Sat, Nov 03, 2018 at 04:39:28PM +0100, Arnd Bergmann wrote:
> On 32-bit ARM with gcc-8, I see a link error with the addition of the
> CONFIG_NO_AUTO_INLINE option:
> 
> fs/btrfs/super.o: In function `btrfs_statfs':
> super.c:(.text+0x67b8): undefined reference to `__aeabi_uldivmod'
> super.c:(.text+0x67fc): undefined reference to `__aeabi_uldivmod'
> super.c:(.text+0x6858): undefined reference to `__aeabi_uldivmod'
> super.c:(.text+0x6920): undefined reference to `__aeabi_uldivmod'
> super.c:(.text+0x693c): undefined reference to `__aeabi_uldivmod'
> fs/btrfs/super.o:super.c:(.text+0x6958): more undefined references to `__aeabi_uldivmod' follow
> 
> So far this is the only file that shows the behavior, so I'd propose
> to just work around it by marking the functions as 'static inline'
> that normally get inlined here.
> 
> The reference to __aeabi_uldivmod comes from a div_u64() which has an
> optimization for a constant division that uses a straight '/' operator
> when the result should be known to the compiler. My interpretation is
> that as we turn off inlining, gcc still expects the result to be constant
> but fails to use that constant value.
> 
> Cc: Changbin Du <changbin.du@gmail.com>
> Fixes: 943b8435c3bd ("kernel hacking: add a config option to disable compiler auto-inlining")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/btrfs/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index c3c1e7bee49d..b7af0b8936ad 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1922,7 +1922,7 @@ static int btrfs_remount(struct super_block *sb, int *flags,
>  }
>  
>  /* Used to sort the devices by max_avail(descending sort) */
> -static int btrfs_cmp_device_free_bytes(const void *dev_info1,
> +static inline int btrfs_cmp_device_free_bytes(const void *dev_info1,
>  				       const void *dev_info2)
>  {
>  	if (((struct btrfs_device_info *)dev_info1)->max_avail >
> @@ -1951,8 +1951,8 @@ static inline void btrfs_descending_sort_devices(
>   * The helper to calc the free space on the devices that can be used to store
>   * file data.
>   */
> -static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
> -				       u64 *free_bytes)
> +static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
> +					      u64 *free_bytes)
>  {
>  	struct btrfs_device_info *devices_info;
>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> -- 
> 2.18.0
>

-- 
Thanks,
Changbin Du
