Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751714AbdJPNnM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 09:43:12 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 22739AB12
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:43:11 +0000 (UTC)
Date: Mon, 16 Oct 2017 15:41:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Replace opencoded sizes with their symbolic
 constants
Message-ID: <20171016134125.GK3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1508160596-30915-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508160596-30915-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 04:29:56PM +0300, Nikolay Borisov wrote:
> Currently btrfs' code uses a mix of opencoded sizes and defines from sizes.h.
> Let's unifiy the code base to always use the symbolic constants. No functional
> changes
> 
> -#define BTRFS_DEFRAG_BATCH	1024
> +#define BTRFS_DEFRAG_BATCH	SZ_1K

This is a number, not a size, so the SZ_ constant is misleading

>  static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
>  				    struct inode_defrag *defrag)
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index a7f79254ecca..553172271913 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -58,7 +58,7 @@
>   */
>  #define RBIO_CACHE_READY_BIT	3
>  
> -#define RBIO_CACHE_SIZE 1024
> +#define RBIO_CACHE_SIZE SZ_1K

Same here.

The rest is ok.
