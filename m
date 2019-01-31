Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C48AC169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25B122085B
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388068AbfAaQK5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:10:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:55648 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbfAaQK5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 11:10:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73637B04E;
        Thu, 31 Jan 2019 16:10:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0B9EADA7D6; Thu, 31 Jan 2019 17:10:19 +0100 (CET)
Date:   Thu, 31 Jan 2019 17:10:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] btrfs: manage heuristic workspace as index 0
Message-ID: <20190131161019.GL2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-4-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-4-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:29PM -0500, Dennis Zhou wrote:
> While the heuristic workspaces aren't really compression workspaces,
> they use the same interface for managing them. So rather than branching,
> let's just handle them once again as the index 0 compression type.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> +const struct btrfs_compress_op btrfs_heuristic_compress = {
> +	.alloc_workspace = alloc_heuristic_ws,
> +	.free_workspace = free_heuristic_ws,
> +};
>  struct workspace_manager {
>  	struct list_head idle_ws;
>  	spinlock_t ws_lock;
> @@ -782,9 +789,8 @@ struct workspace_manager {
>  
>  static struct workspace_manager wsm[BTRFS_COMPRESS_TYPES];

This deserves a comment that the 0th workspace is for the heuristics.

> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -97,7 +97,7 @@ enum btrfs_compression_type {
>  	BTRFS_COMPRESS_ZLIB  = 1,
>  	BTRFS_COMPRESS_LZO   = 2,
>  	BTRFS_COMPRESS_ZSTD  = 3,
> -	BTRFS_COMPRESS_TYPES = 3,
> +	BTRFS_COMPRESS_TYPES = 4,

And here too, as there are only 3 compressors but 4 types as value of
the enum. Or rename BTRFS_COMPRESS_TYPES if you find a better name.

>  };
>  
>  struct btrfs_compress_op {
> @@ -125,6 +125,7 @@ struct btrfs_compress_op {
>  	void (*set_level)(struct list_head *ws, unsigned int type);
>  };
>  
> +extern const struct btrfs_compress_op btrfs_heuristic_compress;
>  extern const struct btrfs_compress_op btrfs_zlib_compress;
>  extern const struct btrfs_compress_op btrfs_lzo_compress;
>  extern const struct btrfs_compress_op btrfs_zstd_compress;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9c8e1734429c..20081465a451 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1410,7 +1410,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		return -EINVAL;
>  
>  	if (do_compress) {
> -		if (range->compress_type > BTRFS_COMPRESS_TYPES)
> +		if (range->compress_type >= BTRFS_COMPRESS_TYPES)
>  			return -EINVAL;
>  		if (range->compress_type)
>  			compress_type = range->compress_type;
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index a62e1e837a89..c88e146d8e99 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -133,9 +133,9 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
>  	 * Support for new compression/encryption must introduce incompat flag,
>  	 * and must be caught in open_ctree().
>  	 */
> -	if (btrfs_file_extent_compression(leaf, fi) > BTRFS_COMPRESS_TYPES) {
> +	if (btrfs_file_extent_compression(leaf, fi) >= BTRFS_COMPRESS_TYPES) {
>  		file_extent_err(fs_info, leaf, slot,
> -	"invalid compression for file extent, have %u expect range [0, %u]",
> +	"invalid compression for file extent, have %u expect range [0, %u)",
>  			btrfs_file_extent_compression(leaf, fi),
>  			BTRFS_COMPRESS_TYPES);

This might become a bit confusing, the message is updated to say [0, 4)
but I'm not sure this is commonly understood that 4 does not belong
there. Either do -1 or define a new enum that contains the maximum
number so BTRFS_COMPRESS_TYPES is not overloaded.
