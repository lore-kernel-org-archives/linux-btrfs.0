Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160Ab3DPNi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 09:38:29 -0400
Date: Tue, 16 Apr 2013 15:38:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: return error when we specify wrong start to
 defrag
Message-ID: <20130416133827.GN18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366104028-26830-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366104028-26830-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 05:20:28PM +0800, Liu Bo wrote:
> We need such a sanity check for wrong start when we defrag a file, otherwise,
> even with a wrong start that's larger than file size, we can end up changing
> not only inode's force compress flag but also FS's incompat flags.

The range->start check is good, but why are you worried about the
incompat flag? LZO support has been around for more than 2 years.

> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1152,8 +1152,11 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  	u64 new_align = ~((u64)128 * 1024 - 1);
>  	struct page **pages = NULL;
>  
> -	if (extent_thresh == 0)
> -		extent_thresh = 256 * 1024;
> +	if (isize == 0)
> +		return 0;
> +
> +	if (range->start >= isize)
> +		return -EINVAL;
...
> -	if (isize == 0)
> -		return 0;
> +	if (extent_thresh == 0)
> +		extent_thresh = 256 * 1024;

That's a more logical order of the checks, good.

Reviewed-by: David Sterba <dsterba@suse.cz>
