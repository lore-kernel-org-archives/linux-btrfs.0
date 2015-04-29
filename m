Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966496AbbD2RXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 13:23:08 -0400
Date: Wed, 29 Apr 2015 19:23:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix superblock csum type check.
Message-ID: <20150429172307.GD4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430183163-10870-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430183163-10870-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 28, 2015 at 09:06:03AM +0800, Qu Wenruo wrote:
> Old csum type check is wrong and can't catch csum_type 1(not supported).
> 
> Fix it to avoid hostile 0 division.
> 
> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -428,7 +428,7 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
>  
>  	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
>  		printk(KERN_ERR "BTRFS: unsupported checksum algorithm %u\n",
> -				csum_type);
> +		       csum_type);

Please avoid unrelated changes.

>  		ret = 1;
>  	}
