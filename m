Return-Path: <SRS0=ifAh=ZZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1988C432C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 13:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C33362073B
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 13:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfLCN1Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 08:27:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:49046 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfLCN1Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Dec 2019 08:27:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 330A3B2B8;
        Tue,  3 Dec 2019 13:27:15 +0000 (UTC)
Date:   Tue, 3 Dec 2019 14:27:13 +0100
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 9/9] btrfs: remove struct find_free_extent.ram_bytes
Message-ID: <20191203132713.GI21721@Johanness-MacBook-Pro.local>
References: <cover.1575336815.git.osandov@fb.com>
 <e86fb919694d8c57612c5690be77b27313325232.1575336816.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e86fb919694d8c57612c5690be77b27313325232.1575336816.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 02, 2019 at 05:34:25PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This hasn't been used since it was first introduced in commit
> b4bd745d1230 ("btrfs: Introduce find_free_extent_ctl structure for later
> rework").
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 18df434bfe52..40c000269232 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3437,7 +3437,6 @@ btrfs_release_block_group(struct btrfs_block_group *cache,
>   */
>  struct find_free_extent_ctl {
>  	/* Basic allocation info */
> -	u64 ram_bytes;
>  	u64 num_bytes;
>  	u64 empty_size;
>  	u64 flags;
> @@ -3809,7 +3808,6 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>  
>  	WARN_ON(num_bytes < fs_info->sectorsize);
>  
> -	ffe_ctl.ram_bytes = ram_bytes;
>  	ffe_ctl.num_bytes = num_bytes;
>  	ffe_ctl.empty_size = empty_size;
>  	ffe_ctl.flags = flags;

Either that or pass in a find_free_extent_ctl to btrfs_add_reserved_bytes() as
ram_bytes, num_bytes and delalloc are set in ffe_ctl. I personally would
favour passing in ffe_ctl to btrfs_add_reserved_bytes() as well as others like
btrfs_add_free_space(), btrfs_free_reserved_bytes() and so on.
