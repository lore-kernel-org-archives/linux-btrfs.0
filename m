Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46170C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0358620823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:50:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0358620823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbeKSUNt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 15:13:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:33904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727084AbeKSUNt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 15:13:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 77110AEC6
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 09:50:35 +0000 (UTC)
Subject: Re: [PATCH v2 5/5] btrfs: use EXPORT_FOR_TESTS for conditionally
 shared functions
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181119093817.9291-1-jthumshirn@suse.de>
 <20181119093817.9291-6-jthumshirn@suse.de>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <1c66cd0f-613e-bf80-bee7-a4e3b1a5d6f2@suse.com>
Date:   Mon, 19 Nov 2018 11:50:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181119093817.9291-6-jthumshirn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 19.11.18 г. 11:38 ч., Johannes Thumshirn wrote:
> Several functions in BTRFS are only used inside the source file they are
> declared if CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not defined. However if
> CONFIG_BTRFS_FS_RUN_SANITY_TESTS is defined these functions are shared with
> the unit tests code.
> 
> Before the introduction of the EXPORT_FOR_TESTS macro, these functions
> could not be declared as static and the compiler had a harder task when
> optimizing and inlining them.
> 
> As we have EXPORT_FOR_TESTS now, use it where appropriate to support the
> compiler.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent_io.c             | 14 ++------------
>  fs/btrfs/extent_io.h             |  7 +++----
>  fs/btrfs/free-space-tree.c       |  8 ++++++--
>  fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
>  4 files changed, 16 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 926bf30c2f2e..16344d5b8d68 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1556,7 +1556,8 @@ static noinline int lock_delalloc_pages(struct inode *inode,
>   *
>   * 1 is returned if we find something, 0 if nothing was in the tree
>   */
> -static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
> +EXPORT_FOR_TESTS
> +noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>  				    struct extent_io_tree *tree,
>  				    struct page *locked_page, u64 *start,
>  				    u64 *end, u64 max_bytes)
> @@ -1636,17 +1637,6 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>  	return found;
>  }
>  
> -#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -u64 btrfs_find_lock_delalloc_range(struct inode *inode,
> -				    struct extent_io_tree *tree,
> -				    struct page *locked_page, u64 *start,
> -				    u64 *end, u64 max_bytes)
> -{
> -	return find_lock_delalloc_range(inode, tree, locked_page, start, end,
> -			max_bytes);
> -}
> -#endif
> -
>  static int __process_pages_contig(struct address_space *mapping,
>  				  struct page *locked_page,
>  				  pgoff_t start_index, pgoff_t end_index,
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index d96fd534f144..a03204a81751 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -522,10 +522,9 @@ int free_io_failure(struct extent_io_tree *failure_tree,
>  		    struct extent_io_tree *io_tree,
>  		    struct io_failure_record *rec);
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -u64 btrfs_find_lock_delalloc_range(struct inode *inode,
> -				      struct extent_io_tree *tree,
> -				      struct page *locked_page, u64 *start,
> -				      u64 *end, u64 max_bytes);
> +u64 find_lock_delalloc_range(struct inode *inode, struct extent_io_tree *tree,
> +			     struct page *locked_page, u64 *start,
> +			     u64 *end, u64 max_bytes);
>  #endif
>  struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
>  					       u64 start);
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index d6736595ec57..cacdebc26fa0 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -74,7 +74,7 @@ static int add_new_free_space_info(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -struct btrfs_free_space_info *
> +EXPORT_FOR_TESTS struct btrfs_free_space_info *
>  search_free_space_info(struct btrfs_trans_handle *trans,
>  		       struct btrfs_fs_info *fs_info,
>  		       struct btrfs_block_group_cache *block_group,
> @@ -176,6 +176,7 @@ static void le_bitmap_set(unsigned long *map, unsigned int start, int len)
>  	}
>  }
>  
> +EXPORT_FOR_TESTS
>  int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
>  				  struct btrfs_block_group_cache *block_group,
>  				  struct btrfs_path *path)
> @@ -315,6 +316,7 @@ int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> +EXPORT_FOR_TESTS
>  int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
>  				  struct btrfs_block_group_cache *block_group,
>  				  struct btrfs_path *path)
> @@ -487,6 +489,7 @@ static int update_free_space_extent_count(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> +EXPORT_FOR_TESTS
>  int free_space_test_bit(struct btrfs_block_group_cache *block_group,
>  			struct btrfs_path *path, u64 offset)
>  {
> @@ -775,6 +778,7 @@ static int remove_free_space_extent(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> +EXPORT_FOR_TESTS
>  int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
>  				  struct btrfs_block_group_cache *block_group,
>  				  struct btrfs_path *path, u64 start, u64 size)
> @@ -968,7 +972,7 @@ static int add_free_space_extent(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
> +EXPORT_FOR_TESTS int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
>  			     struct btrfs_block_group_cache *block_group,
>  			     struct btrfs_path *path, u64 start, u64 size)
>  {
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
> index a99dc04331b4..ab7771b2a5fb 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -107,7 +107,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	set_extent_delalloc(&tmp, 0, sectorsize - 1, 0, NULL);
>  	start = 0;
>  	end = 0;
> -	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> +	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
>  					 &end, max_bytes);
>  	if (!found) {
>  		test_err("should have found at least one delalloc");
> @@ -138,7 +138,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	set_extent_delalloc(&tmp, sectorsize, max_bytes - 1, 0, NULL);
>  	start = test_start;
>  	end = 0;
> -	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> +	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
>  					 &end, max_bytes);
>  	if (!found) {
>  		test_err("couldn't find delalloc in our range");
> @@ -172,7 +172,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	}
>  	start = test_start;
>  	end = 0;
> -	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> +	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
>  					 &end, max_bytes);
>  	if (found) {
>  		test_err("found range when we shouldn't have");
> @@ -193,7 +193,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, 0, NULL);
>  	start = test_start;
>  	end = 0;
> -	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> +	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
>  					 &end, max_bytes);
>  	if (!found) {
>  		test_err("didn't find our range");
> @@ -234,7 +234,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	 * this changes at any point in the future we will need to fix this
>  	 * tests expected behavior.
>  	 */
> -	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> +	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
>  					 &end, max_bytes);
>  	if (!found) {
>  		test_err("didn't find our range");
> 
