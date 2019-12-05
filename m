Return-Path: <SRS0=8E82=Z3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 224FAC43603
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 07:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF12224F8
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 07:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfLEHVw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 02:21:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:48532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725926AbfLEHVw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Dec 2019 02:21:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 38359B199;
        Thu,  5 Dec 2019 07:21:50 +0000 (UTC)
Date:   Thu, 5 Dec 2019 08:21:44 +0100
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 05/28] btrfs: disallow space_cache in HMZONED mode
Message-ID: <20191205072144.GA6051@Johanness-MacBook-Pro.local>
References: <20191204081735.852438-1-naohiro.aota@wdc.com>
 <20191204081735.852438-6-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204081735.852438-6-naohiro.aota@wdc.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 04, 2019 at 05:17:12PM +0900, Naohiro Aota wrote:
[...]
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 616f5abec267..d411574298f4 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -442,8 +442,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  	cache_gen = btrfs_super_cache_generation(info->super_copy);
>  	if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
>  		btrfs_set_opt(info->mount_opt, FREE_SPACE_TREE);
> -	else if (cache_gen)
> -		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
> +	else if (cache_gen) {
> +		if (btrfs_fs_incompat(info, HMZONED))
> +			WARN_ON(1);
> +		else
> +			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
> +	}

I would probably write this as follows:
	else if (cache_gen)
		if (!WARN_ON(btrfs_fs_incompat(info, HMZONED)))
			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
