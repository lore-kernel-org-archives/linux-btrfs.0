Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42881 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752266AbeENQyq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 12:54:46 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 308D5AEB3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 16:54:45 +0000 (UTC)
Date: Mon, 14 May 2018 18:52:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
Message-ID: <20180514165205.GP6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180514070210.27047-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180514070210.27047-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 03:02:10PM +0800, Qu Wenruo wrote:
> As btrfs(5) specified:
> 
> 	Note
> 	If nodatacow or nodatasum are enabled, compression is disabled.
> 
> If NODATASUM or NODATACOW set, we should not compress the extent.
> 
> And in fact, we have bug report about corrupted compressed extent
> leading to memory corruption in mail list.

Link please.

> Although it's mostly buggy lzo implementation causing the problem, btrfs
> still needs to be fixed to meet the specification.

That's very vague, what's the LZO bug? If the input is garbage and lzo
decompression cannot decompress it, it's not a lzo bug.

> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d241285a0d2a..dbef3f404559 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -396,6 +396,14 @@ static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  
> +	/*
> +	 * Btrfs doesn't support compression without csum or CoW.
> +	 * This should have the highest priority.
> +	 */
> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW ||
> +	    BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
> +		return 0;

This is also the wrong place to fix that, NODATASUM or NODATACOW inode
should never make it to compress_file_range (that calls
inode_need_compress).

> +
>  	/* force compress */
>  	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
>  		return 1;
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
