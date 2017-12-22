Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52831 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751349AbdLVHmT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 02:42:19 -0500
Subject: Re: [PATCH 03/10] Btrfs: add extent map selftests
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
 <20171221224256.18196-4-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4b78320c-a070-fa5f-cec3-38769f0cb7d2@suse.com>
Date: Fri, 22 Dec 2017 09:42:17 +0200
MIME-Version: 1.0
In-Reply-To: <20171221224256.18196-4-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.12.2017 00:42, Liu Bo wrote:
> We've observed that btrfs_get_extent() and merge_extent_mapping() could
> return -EEXIST in several cases, and they are caused by some racy
> condition, e.g dio read vs dio write, which makes the problem very tricky
> to reproduce.
> 
> This adds extent map selftests in order to simulate those racy situations.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/Makefile                 |   2 +-
>  fs/btrfs/tests/btrfs-tests.c      |   3 +
>  fs/btrfs/tests/btrfs-tests.h      |   1 +
>  fs/btrfs/tests/extent-map-tests.c | 202 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 207 insertions(+), 1 deletion(-)
>  create mode 100644 fs/btrfs/tests/extent-map-tests.c
> 
> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index 6fe881d..0c43736 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -19,4 +19,4 @@ btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
>  btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
>  	tests/extent-buffer-tests.o tests/btrfs-tests.o \
>  	tests/extent-io-tests.o tests/inode-tests.o tests/qgroup-tests.o \
> -	tests/free-space-tree-tests.o
> +	tests/free-space-tree-tests.o tests/extent-map-tests.o
> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
> index d3f2537..9786d8c 100644
> --- a/fs/btrfs/tests/btrfs-tests.c
> +++ b/fs/btrfs/tests/btrfs-tests.c
> @@ -277,6 +277,9 @@ int btrfs_run_sanity_tests(void)
>  				goto out;
>  		}
>  	}
> +	ret = btrfs_test_extent_map();
> +	if (ret)
> +		goto out;
>  out:
>  	btrfs_destroy_test_fs();
>  	return ret;
> diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
> index 266f1e3..bc0615b 100644
> --- a/fs/btrfs/tests/btrfs-tests.h
> +++ b/fs/btrfs/tests/btrfs-tests.h
> @@ -33,6 +33,7 @@ int btrfs_test_extent_io(u32 sectorsize, u32 nodesize);
>  int btrfs_test_inodes(u32 sectorsize, u32 nodesize);
>  int btrfs_test_qgroups(u32 sectorsize, u32 nodesize);
>  int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize);
> +int btrfs_test_extent_map(void);
>  struct inode *btrfs_new_test_inode(void);
>  struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize);
>  void btrfs_free_dummy_fs_info(struct btrfs_fs_info *fs_info);
> diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
> new file mode 100644
> index 0000000..0407396
> --- /dev/null
> +++ b/fs/btrfs/tests/extent-map-tests.c
> @@ -0,0 +1,202 @@
> +/*
> + * Copyright (C) 2017 Oracle.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#include <linux/types.h>
> +#include "btrfs-tests.h"
> +#include "../ctree.h"
> +
> +static void free_extent_map_tree(struct extent_map_tree *em_tree)
> +{
> +	struct extent_map *em;
> +	struct rb_node *node;
> +
> +	while (!RB_EMPTY_ROOT(&em_tree->map)) {
> +		node = rb_first(&em_tree->map);
> +		em = rb_entry(node, struct extent_map, rb_node);
> +		remove_extent_mapping(em_tree, em);
> +
> +#ifdef CONFIG_BTRFS_DEBUG
> +		if (refcount_read(&em->refs) != 1) {
> +			test_msg(
> +				 "Oops we have a em leak: em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx) refs %d\n",
> +				 em->start, em->len, em->block_start,
> +				 em->block_len, refcount_read(&em->refs));
> +
> +			refcount_set(&em->refs, 1);
> +		}
> +#endif
> +		free_extent_map(em);
> +	}
> +}
> +
> +/*
> + * Test scenario:
> + *
> + * Suppose that no extent map has been loaded into memory yet, there is a file
> + * extent [0, 16K), followed by another file extent [16K, 20K), two dio reads
> + * are entering btrfs_get_extent() concurrently, t1 is reading [8K, 16K), t2 is
> + * reading [0, 8K)
> + *
> + *     t1                            t2
> + *  btrfs_get_extent()              btrfs_get_extent()
> + *    -> lookup_extent_mapping()      ->lookup_extent_mapping()
> + *    -> add_extent_mapping(0, 16K)
> + *    -> return em
> + *                                    ->add_extent_mapping(0, 16K)
> + *                                    -> #handle -EEXIST
> + */
> +static void test_case_1(struct extent_map_tree *em_tree)
> +{

So here you are testing the "fully overlapping" case in btrfs_add_extent_mapping. 
What about another test case about merging 2 adjacent extents i.e. this block of code: 

} else if (start >= extent_map_end(existing) || start <= existing->start) {

> +	struct extent_map *em;
> +	u64 start = 0;
> +	u64 len = SZ_8K;
> +	int ret;
> +
> +	em = alloc_extent_map();
> +	if (!em)
> +		/* Skip the test on error. */
> +		return;
> +
> +	/* Add [0, 16K) */
> +	em->start = 0;
> +	em->len = SZ_16K;
> +	em->block_start = 0;
> +	em->block_len = SZ_16K;
> +	ret = add_extent_mapping(em_tree, em, 0);
> +	ASSERT(ret == 0);
> +	free_extent_map(em);
> +
> +	/* Add [16K, 20K) following [0, 16K)  */
> +	em = alloc_extent_map();
> +	if (!em)
> +		goto out;
> +
> +	em->start = SZ_16K;
> +	em->len = SZ_4K;
> +	em->block_start = SZ_32K; /* avoid merging */
> +	em->block_len = SZ_4K;
> +	ret = add_extent_mapping(em_tree, em, 0);
> +	ASSERT(ret == 0);
> +	free_extent_map(em);
> +
> +	em = alloc_extent_map();
> +	if (!em)
> +		goto out;
> +
> +	/* Add [0, 8K), should return [0, 16K) instead. */
> +	em->start = start;
> +	em->len = len;
> +	em->block_start = start;
> +	em->block_len = len;

Any particular reason you are using start/len and not the constants as in the 
previous 2 extent insertion cases? Makes it a lot easier to see what's happening 
without reading the above variables?

> +	ret = btrfs_add_extent_mapping(em_tree, &em, em->start, em->len);
> +	if (ret)
> +		test_msg("case1 [%llu %llu]: ret %d\n",
> +			 start, start + len, ret);
> +	if (em &&
> +	    (em->start != 0 || extent_map_end(em) != SZ_16K ||
> +	     em->block_start != 0 || em->block_len != SZ_16K))
> +		test_msg("case1 [%llu %llu]: ret %d return a wrong em (start %llu len %llu block_start %llu block_len %llu\n",
> +			 start, start + len, ret, em->start, em->len,
> +			 em->block_start, em->block_len);
> +	free_extent_map(em);
> +out:
> +	/* free memory */
> +	free_extent_map_tree(em_tree);
> +}
> +
> +/*
> + * Test scenario:
> + *
> + * Reading the inline ending up with EEXIST, ie. read an inline
> + * extent and discard page cache and read it again.
> + */
> +static void test_case_2(struct extent_map_tree *em_tree)
> +{
> +	struct extent_map *em;
> +	int ret;
> +
> +	em = alloc_extent_map();
> +	if (!em)
> +		/* Skip the test on error. */
> +		return;
> +
> +	/* Add [0, 1K) */
> +	em->start = 0;
> +	em->len = SZ_1K;
> +	em->block_start = EXTENT_MAP_INLINE;
> +	em->block_len = (u64)-1;
> +	ret = add_extent_mapping(em_tree, em, 0);
> +	ASSERT(ret == 0);
> +	free_extent_map(em);
> +
> +	/* Add [4K, 4K) following [0, 1K)  */
> +	em = alloc_extent_map();
> +	if (!em)
> +		goto out;
> +
> +	em->start = SZ_4K;
> +	em->len = SZ_4K;
> +	em->block_start = SZ_4K;
> +	em->block_len = SZ_4K;
> +	ret = add_extent_mapping(em_tree, em, 0);
> +	ASSERT(ret == 0);
> +	free_extent_map(em);
> +
> +	em = alloc_extent_map();
> +	if (!em)
> +		goto out;
> +
> +	/* Add [0, 1K) */
> +	em->start = 0;
> +	em->len = SZ_1K;
> +	em->block_start = EXTENT_MAP_INLINE;
> +	em->block_len = (u64)-1;
> +	ret = btrfs_add_extent_mapping(em_tree, &em, em->start, em->len);
> +	if (ret)
> +		test_msg("case2 [0 1K]: ret %d\n", ret);
> +	if (em &&
> +	    (em->start != 0 || extent_map_end(em) != SZ_1K ||
> +	     em->block_start != EXTENT_MAP_INLINE || em->block_len != (u64)-1))
> +		test_msg("case2 [0 1K]: ret %d return a wrong em (start %llu len %llu block_start %llu block_len %llu\n",
> +			 ret, em->start, em->len, em->block_start,
> +			 em->block_len);
> +	free_extent_map(em);
> +out:
> +	/* free memory */
> +	free_extent_map_tree(em_tree);
> +}
> +
> +int btrfs_test_extent_map()
> +{
> +	struct extent_map_tree *em_tree;
> +
> +	test_msg("Running extent_map tests\n");
> +
> +	em_tree = kzalloc(sizeof(*em_tree), GFP_KERNEL);
> +	if (!em_tree)
> +		/* Skip the test on error. */
> +		return 0;
> +
> +	extent_map_tree_init(em_tree);
> +
> +	test_case_1(em_tree);
> +	test_case_2(em_tree);
> +
> +	kfree(em_tree);
> +	return 0;
> +}
> 
