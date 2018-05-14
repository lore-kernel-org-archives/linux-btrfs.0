Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52595 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752403AbeENIKh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 04:10:37 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 79237ACA3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 08:10:36 +0000 (UTC)
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180514070210.27047-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
Date: Mon, 14 May 2018 11:10:34 +0300
MIME-Version: 1.0
In-Reply-To: <20180514070210.27047-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.05.2018 10:02, Qu Wenruo wrote:
> As btrfs(5) specified:
> 
> 	Note
> 	If nodatacow or nodatasum are enabled, compression is disabled.
> 
> If NODATASUM or NODATACOW set, we should not compress the extent.
> 
> And in fact, we have bug report about corrupted compressed extent
> leading to memory corruption in mail list.
> Although it's mostly buggy lzo implementation causing the problem, btrfs

What does it mean "it's mostly buggy lzo implementation"? If we have bug
in the LZO implementation that btrfs uses shouldn't it be fixed as well ?

> still needs to be fixed to meet the specification.
> 
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
> +
>  	/* force compress */
>  	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
>  		return 1;

But if we have mounted the fs with FORCE_COMPRESS shouldn't we disregard
the inode flags, presumably the admin knows what he is doing? Won't it
be better if somewhere further in the call chain we check if
FORCE_COMPRESS is set and if so override any inode flags. This can be
implemented by _always_ calling inode_need_compress to decide if we
should compress or not?

> 
