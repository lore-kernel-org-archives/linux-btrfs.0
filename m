Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47521 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752619AbeBSPVl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Feb 2018 10:21:41 -0500
Date: Mon, 19 Feb 2018 16:19:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: use ASSERT to report logical error in
 cow_file_range()
Message-ID: <20180219151923.GJ10193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8fd2c67e-3808-f9a8-043c-54a296fc40c6@suse.com>
 <20180215100759.11647-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180215100759.11647-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 06:07:59PM +0800, Anand Jain wrote:
> Use ASSERT to report logical error in cow_file_range(), also move
> it a bit closer to when the num_bytes is derived.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2:
>    ASSERT logic changed. Thanks Nikolay.
> 
>  fs/btrfs/inode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4b156e191592..260fd8139951 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -976,6 +976,7 @@ static noinline int cow_file_range(struct inode *inode,
>  
>  	num_bytes = ALIGN(end - start + 1, blocksize);
>  	num_bytes = max(blocksize,  num_bytes);
> +	ASSERT(num_bytes <= btrfs_super_total_bytes(fs_info->super_copy));

I was looking how if this assert is valid and theoretically possible.
Yes it seems so, extent start of range could be (u64)-1 in some cases
and this must not enter cow_file_range. So the assert is the right way
to check the parameter mismatch.

Reviewed-by: David Sterba <dsterba@suse.com>
