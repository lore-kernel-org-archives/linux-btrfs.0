Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbbFCKlE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jun 2015 06:41:04 -0400
Date: Wed, 3 Jun 2015 12:41:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: btrfs_defrag_file: Fix calculation of
 max_to_defrag.
Message-ID: <20150603104102.GL6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433323794-10045-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433323794-10045-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 03, 2015 at 02:59:54PM +0530, Chandan Rajendra wrote:
> max_to_defrag represents the number of pages to defrag rather than the last
> page of the file range to be defragged. Fix this.

Please update the changelog and describe the buggy behaviour. From a
brief look I think that the defrag batch will be much higher than
desired. Elsewhere the defrag batch is 1024, the page indexes used here
are always large numbers. I guess this could (partially) explain high
load during defrag that people report.

ACK for the fix, I'll stick a reviewed-by to v2.

> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/btrfs/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ca5d968..2a45026 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1318,7 +1318,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		i = range->start >> PAGE_CACHE_SHIFT;
>  	}
>  	if (!max_to_defrag)
> -		max_to_defrag = last_index + 1;
> +		max_to_defrag = last_index - i + 1;
>  
>  	/*
>  	 * make writeback starts from i, so the defrag range can be
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
