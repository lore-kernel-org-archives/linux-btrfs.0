Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbbETRC3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 13:02:29 -0400
Date: Wed, 20 May 2015 19:02:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        holger.hoffstaette@googlemail.com
Subject: Re: [PATCH] Btrfs: fix regression in raid level conversion
Message-ID: <20150520170227.GM23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150520141301.GA16249@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150520141301.GA16249@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 20, 2015 at 10:13:11AM -0400, Chris Mason wrote:
> Commit 2f0810880f082fa8ba66ab2c33b02e4ff9770a5e changed
> btrfs_set_block_group_ro to avoid trying to allocate new chunks with the
> new raid profile during conversion.  This fixed failures when there was
> no space on the drive to allocate a new chunk, but the metadata
> reserves were sufficient to continue the conversion.
> 
> But this ended up causing a regression when the drive had plenty of
> space to allocate new chunks, mostly because reduce_alloc_profile isn't
> using the new raid profile.
> 
> Fixing btrfs_reduce_alloc_profile is a bigger patch.  For now, do a
> partial revert of 2f0810880, and don't error out if we hit ENOSPC.
> 
> Signed-off-by: Chris Mason <clm@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 45e3f08..a115599 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8829,6 +8829,26 @@ again:
>  		goto again;
>  	}
>  
> +	/*
> +	 * if we are changing raid levels, try to allocate a corresponding
> +	 * block group with the new raid level.
> +	 */
> +	if (!(cache->flags & BTRFS_BLOCK_GROUP_SYSTEM)) {

This prevents to switch the system chunk in all cases. What was the
reason to do it?

If I remove the check, then the conversions work in all combinations.
Eg.

* convert from ext (or use any single device fs)
* add second device
* balance data/metadata/system to raid1
* all fine
