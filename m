Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46852 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752303AbdC0Pin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 11:38:43 -0400
Date: Mon, 27 Mar 2017 17:37:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: bring back repair during read
Message-ID: <20170327153715.GH4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1490382804-25087-1-git-send-email-bo.li.liu@oracle.com>
 <1490393090-14360-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1490393090-14360-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 24, 2017 at 03:04:50PM -0700, Liu Bo wrote:
> Commit 20a7db8ab3f2 ("btrfs: add dummy callback for readpage_io_failed
> and drop checks") made a cleanup around readpage_io_failed_hook, and
> it was supposed to keep the original sematics, but it also
> unexpectedly disabled repair during read for dup, raid1 and raid10.
> 
> This fixes the problem by letting data's inode call the generic
> readpage_io_failed callback by returning -EAGAIN from its
> readpage_io_failed_hook in order to notify end_bio_extent_readpage to
> do the rest.  We don't call it directly because the generic one takes
> an offset from end_bio_extent_readpage() to calculate the index in the
> checksum array and inode's readpage_io_failed_hook doesn't offer that
> offset.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Thanks for catching it.

> -__attribute__((const))

The attribute could stay.

> -static int dummy_readpage_io_failed_hook(struct page *page, int failed_mirror)
> +static int btrfs_readpage_io_failed_hook(struct page *page, int failed_mirror)
>  {
> -	return 0;
> +	return -EAGAIN;
>  }
