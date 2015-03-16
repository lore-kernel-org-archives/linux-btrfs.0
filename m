Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbbCPR2D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 13:28:03 -0400
Date: Mon, 16 Mar 2015 18:28:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Sebastian Thorarensen <sebth@naju.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Allow setting nodesize
Message-ID: <20150316172800.GP20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 03, 2015 at 12:47:39PM +0100, Sebastian Thorarensen wrote:
> Allow btrfs-convert to use nodesizes other than 4096. It defaults to
> max(16384, pagesize), like mkfs. The constant DEFAULT_MKFS_LEAF_SIZE has
> been moved to utils.h and renamed to BTRFS_MKFS_DEFAULT_NODE_SIZE for
> consistency. convert-tests now test both 4096 and 16384 nodesizes.

Thanks, this sounds very useful.

> +static int ext2_free_block_range(ext2_filsys fs, u64 block, int num)
> +{
> +	BUG_ON(block != (blk_t)block);

What's the purpose of this? Some kind of overflow check?

> +	ext2fs_fast_unmark_block_bitmap_range(fs->block_map, block, num);
> +	return 0;
> +}
> +
>  static int cache_free_extents(struct btrfs_root *root, ext2_filsys ext2_fs)
>  
>  {
> @@ -2231,10 +2257,28 @@ err:
>  	return ret;
>  }
>  
> +static int check_nodesize(u32 nodesize, u32 sectorsize)

This is duplicating check_leaf_or_node_size from mkfs.c, the right way
is to move that to utils.c and then use in convert.

> +{
> +	if (nodesize < sectorsize) {
> +		fprintf(stderr, "illegal nodesize %u (smaller than %u)\n",
> +			nodesize, sectorsize);
> +		return -1;
> +	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
> +		fprintf(stderr, "illegal nodesize %u (larger than %u)\n",
> +			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
> +		return -1;
> +	} else if (nodesize & (sectorsize - 1)) {
> +		fprintf(stderr, "illegal nodesize %u (not aligned to %u)\n",
> +			nodesize, sectorsize);
> +		return -1;
> +	}
> +	return 0;
> +}

Otherwise looks good. If you're going to resend, please split the patch
into one logical change per patch:

1) generic and preparatory changes, like moving the check_node to
utils.c, moving the mkfs default leaf size

2) the changes to convert, ie. most of this patch minus 1 and 3

3) the tests

Thanks.
