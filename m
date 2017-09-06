Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56117 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750957AbdIFRxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 13:53:21 -0400
Date: Wed, 6 Sep 2017 19:51:52 +0200
From: David Sterba <dsterba@suse.cz>
To: zhangyu-fnst@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Check on num_stripes in print_chunk
Message-ID: <20170906175152.GA31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170824103841.16259-1-zhangyu-fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170824103841.16259-1-zhangyu-fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 24, 2017 at 06:38:41PM +0800, zhangyu-fnst@cn.fujitsu.com wrote:
> From: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>
> 
> [TEST/fuzz] case: 004-simple-dump-tree
> 
> Since the wrong key(DATA_RELOC_TREE CHUNK_ITEM 0) in root tree,
> error calling print_chunk(), resulting in num_stripes == 0.
> 
> ERROR:
>      [TEST/fuzz]   004-simple-dump-tree
> ctree.h:317: btrfs_chunk_item_size: BUG_ON `num_stripes == 0`
>         triggered, value 1
> 
> failed (ignored, ret=134): /myproject/btrfs-progs/btrfs
> inspect-internal dump-tree
> /myproject/btrfs-progs/tests/fuzz-tests/images/
> bko-155201-wrong-chunk-item-in-root-tree.raw.restored
> 
> test failed for case 004-simple-dump-tree
> Makefile:288: recipe for target 'test-fuzz' failed
> make: *** [test-fuzz] Error 1
> 
> So, check on num_stripes in print_chunk
> 
> Signed-off-by: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>
> ---
>  print-tree.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/print-tree.c b/print-tree.c
> index a0d3395..08f7edb 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -199,6 +199,15 @@ void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
>  {
>  	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
>  	int i;
> +	/*
> +	 * check on num_stripes
> +	 * Btrfs_chunk contains at least one stripes
> +	 */
> +	if (num_stripes < 1) {
> +		printf("invalid num_stripes: %u\n", num_stripes);
> +		return;
> +	}

This inserts statements inside the declaration block. Although this is
allowed in C, this does not conform to the preferred coding style
(kernel or btrfs-progs). Please fix it, thanks.

> +
>  	u32 chunk_item_size = btrfs_chunk_item_size(num_stripes);
>  	char chunk_flags_str[32] = {0};
>  
> -- 
> 2.9.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
