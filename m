Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EECC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F3523108
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbhASWuG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:50:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:56132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728061AbhASWtu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jan 2021 17:49:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A4757AAAE;
        Tue, 19 Jan 2021 22:49:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CB8F6DA6E3; Tue, 19 Jan 2021 23:47:13 +0100 (CET)
Date:   Tue, 19 Jan 2021 23:47:13 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/13] btrfs: Document fs_info in btrfs_rmap_block
Message-ID: <20210119224713.GW6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210119122649.187778-1-nborisov@suse.com>
 <20210119122649.187778-8-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119122649.187778-8-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 19, 2021 at 02:26:43PM +0200, Nikolay Borisov wrote:
> Fixes fs/btrfs/block-group.c:1570: warning: Function parameter or member 'fs_info' not described in 'btrfs_rmap_block'
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/block-group.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 0886e81e5540..1b71e7be04a9 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -1554,6 +1554,7 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
>  
>  /**
>   * btrfs_rmap_block - Map a physical disk address to a list of logical addresses
> + * @fs_info:       fs context

I think documenting the fs_info parameter is awkward in all cases, so
we could just put 'the filesystem' everywhere. Here 'context' could be
confusing as there aready is something called fs_context.

>   * @chunk_start:   logical address of block group
>   * @physical:	   physical address to map to logical addresses
>   * @logical:	   return array of logical addresses which map to @physical
> -- 
> 2.25.1
