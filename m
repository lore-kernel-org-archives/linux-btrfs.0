Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbbBMP4n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 10:56:43 -0500
Date: Fri, 13 Feb 2015 16:56:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add metadump_v2 support to the kernel
Message-ID: <20150213155641.GK8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423752599-17850-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423752599-17850-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 09:49:59AM -0500, Josef Bacik wrote:
> For newly restored metadumps we can actually mount the fs and use it properly
> except that the data obviously doesn't match properly.  To get around this make
> us skip csum validation if the metadump_v2 flag is set on the fs, this will
> allow us to reproduce balance issues with metadumps.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/ctree.h | 1 +
>  fs/btrfs/inode.c | 4 ++++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 1675602..bc16147 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -356,6 +356,7 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
>  
>  #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
>  #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
> +#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
>  
>  #define BTRFS_BACKREF_REV_MAX		256
>  #define BTRFS_BACKREF_REV_SHIFT		56
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4564975..70d0af8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3039,6 +3039,10 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
>  		return 0;
>  

Please add the text from changelog here as a comment, the flag is not
really selfexplanatory.

> +	if (btrfs_super_flags(root->fs_info->super_copy) &
> +	    BTRFS_SUPER_FLAG_METADUMP_V2)
> +		return 0;
> +
>  	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
>  	    test_range_bit(io_tree, start, end, EXTENT_NODATASUM, 1, NULL)) {
>  		clear_extent_bits(io_tree, start, end, EXTENT_NODATASUM,
