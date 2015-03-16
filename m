Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933115AbbCPQJN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 12:09:13 -0400
Date: Mon, 16 Mar 2015 17:09:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: account for the correct number of extents for
 delalloc reservations
Message-ID: <20150316160911.GN20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426273943-27013-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426273943-27013-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 03:12:23PM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5136,7 +5136,11 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
>  	num_bytes = ALIGN(num_bytes, root->sectorsize);
>  
>  	spin_lock(&BTRFS_I(inode)->lock);
> -	BTRFS_I(inode)->outstanding_extents++;
> +	nr_extents = (unsigned)div64_u64(num_bytes +
> +					 BTRFS_MAX_EXTENT_SIZE - 1,
> +					 BTRFS_MAX_EXTENT_SIZE);

Use div_u64 as BTRFS_MAX_EXTENT_SIZE is a u32, and you can drop the
typecast.
