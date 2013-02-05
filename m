Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38506 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3BEScw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 13:32:52 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 4A2839A0362
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Feb 2013 11:32:51 -0700 (MST)
Date: Tue, 5 Feb 2013 13:32:48 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Tomasz Torcz <tomek@pipebreaker.pl>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: experimental raid5/6 code in git
Message-ID: <20130205183248.GF20797@shiny>
References: <20130202160212.GB4694@shiny>
 <20130205142236.GA6619@mother.jarsat.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130205142236.GA6619@mother.jarsat.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 05, 2013 at 07:22:36AM -0700, Tomasz Torcz wrote:
> Hi,
> 
>   I believe XOR_BLOCKS must be selected, otherwise build fails with:
> ERROR: "xor_blocks" [fs/btrfs/btrfs.ko] undefined!
>  
> 
> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> index 4f5dc93..5f583c8 100644
> --- a/fs/btrfs/Kconfig
> +++ b/fs/btrfs/Kconfig
> @@ -7,6 +7,7 @@ config BTRFS_FS
>  	select LZO_COMPRESS
>  	select LZO_DECOMPRESS
>  	select RAID6_PQ
> +	select XOR_BLOCKS
>  
>  	help
>  	  Btrfs is a new filesystem with extents, writable snapshotting,

Thanks, I've put this in.

-chris
