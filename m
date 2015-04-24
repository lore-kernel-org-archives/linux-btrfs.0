Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862AbbDXPFK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 11:05:10 -0400
Date: Fri, 24 Apr 2015 17:05:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: Fix superblock csum type check.
Message-ID: <20150424150507.GQ4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429837961-2255-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429837961-2255-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 24, 2015 at 09:12:40AM +0800, Qu Wenruo wrote:
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -173,6 +173,7 @@ struct btrfs_ordered_sum;
>  
>  /* csum types */
>  #define BTRFS_CSUM_TYPE_CRC32	0
> +#define BTRFS_CSUM_LAST_TYPE	0
>  
>  static int btrfs_csum_sizes[] = { 4, 0 };

I'd prefer to fix it by removing the 0 from btrfs_csum_sizes instead of
introducing a define.
