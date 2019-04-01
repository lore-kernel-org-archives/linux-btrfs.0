Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C722C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 20:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2935F20857
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 20:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfDAUIH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 16:08:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:56186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbfDAUIH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 16:08:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB66AAB6D;
        Mon,  1 Apr 2019 20:08:05 +0000 (UTC)
Date:   Mon, 1 Apr 2019 15:08:03 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        marcin.slusarz@intel.com
Subject: Re: [PATCH] btrfs: allow MAP_SYNC mmap
Message-ID: <20190401200803.k4cm4cbcj6cthy3d@merlin>
References: <20190327232635.zw4edleqwowxfzej@merlin>
 <20190328102418.5466-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328102418.5466-1-kilobyte@angband.pl>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11:24 28/03, Adam Borowski wrote:
> Used by userspace to detect DAX.

Thanks. I will add it to the series.

> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  fs/btrfs/file.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 196c8f37ff9d..8efdb040bc1d 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -16,6 +16,7 @@
>  #include <linux/btrfs.h>
>  #include <linux/uio.h>
>  #include <linux/iversion.h>
> +#include <linux/mman.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> @@ -3320,6 +3321,7 @@ const struct file_operations btrfs_file_operations = {
>  	.splice_read	= generic_file_splice_read,
>  	.write_iter	= btrfs_file_write_iter,
>  	.mmap		= btrfs_file_mmap,
> +	.mmap_supported_flags = MAP_SYNC,
>  	.open		= btrfs_file_open,
>  	.release	= btrfs_release_file,
>  	.fsync		= btrfs_sync_file,
> -- 
> 2.20.1
> 

-- 
Goldwyn
