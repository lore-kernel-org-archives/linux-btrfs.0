Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AC7C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 07:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8AD020863
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 07:05:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8AD020863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbeK2SJ7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 13:09:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:50096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbeK2SJ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 13:09:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1C8A3AD7D;
        Thu, 29 Nov 2018 07:05:35 +0000 (UTC)
Subject: Re: [PATCH v2 1/3] btrfs: remove always true if branch in
 find_delalloc_range
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
 <20181129033338.2647-1-lufq.fnst@cn.fujitsu.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <06caabdd-8043-dd94-c593-9b965944215f@suse.com>
Date:   Thu, 29 Nov 2018 09:05:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181129033338.2647-1-lufq.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 29.11.18 г. 5:33 ч., Lu Fengqi wrote:
> The @found is always false when it comes to the if branch. Besides, the
> bool type is more suitable for @found. Change the return value of the
> function and its caller to bool as well.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent_io.c             | 31 +++++++++++++++----------------
>  fs/btrfs/extent_io.h             |  2 +-
>  fs/btrfs/tests/extent-io-tests.c |  2 +-
>  3 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b2769e92b556..4b6b87e63b4a 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1452,16 +1452,16 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
>   * find a contiguous range of bytes in the file marked as delalloc, not
>   * more than 'max_bytes'.  start and end are used to return the range,
>   *
> - * 1 is returned if we find something, 0 if nothing was in the tree
> + * true is returned if we find something, false if nothing was in the tree
>   */
> -static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
> +static noinline bool find_delalloc_range(struct extent_io_tree *tree,
>  					u64 *start, u64 *end, u64 max_bytes,
>  					struct extent_state **cached_state)
>  {
>  	struct rb_node *node;
>  	struct extent_state *state;
>  	u64 cur_start = *start;
> -	u64 found = 0;
> +	bool found = false;
>  	u64 total_bytes = 0;
>  
>  	spin_lock(&tree->lock);
> @@ -1472,8 +1472,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
>  	 */
>  	node = tree_search(tree, cur_start);
>  	if (!node) {
> -		if (!found)
> -			*end = (u64)-1;
> +		*end = (u64)-1;
>  		goto out;
>  	}
>  
> @@ -1493,7 +1492,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
>  			*cached_state = state;
>  			refcount_inc(&state->refs);
>  		}
> -		found++;
> +		found = true;
>  		*end = state->end;
>  		cur_start = state->end + 1;
>  		node = rb_next(node);
> @@ -1551,13 +1550,13 @@ static noinline int lock_delalloc_pages(struct inode *inode,
>  }
>  
>  /*
> - * find a contiguous range of bytes in the file marked as delalloc, not
> - * more than 'max_bytes'.  start and end are used to return the range,
> + * find and lock a contiguous range of bytes in the file marked as delalloc,
> + * not more than 'max_bytes'.  start and end are used to return the range,
>   *
> - * 1 is returned if we find something, 0 if nothing was in the tree
> + * true is returned if we find something, false if nothing was in the tree
>   */
>  EXPORT_FOR_TESTS
> -noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
> +noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
>  				    struct extent_io_tree *tree,
>  				    struct page *locked_page, u64 *start,
>  				    u64 *end)
> @@ -1565,7 +1564,7 @@ noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>  	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
>  	u64 delalloc_start;
>  	u64 delalloc_end;
> -	u64 found;
> +	bool found;
>  	struct extent_state *cached_state = NULL;
>  	int ret;
>  	int loops = 0;
> @@ -1580,7 +1579,7 @@ noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>  		*start = delalloc_start;
>  		*end = delalloc_end;
>  		free_extent_state(cached_state);
> -		return 0;
> +		return false;
>  	}
>  
>  	/*
> @@ -1612,7 +1611,7 @@ noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>  			loops = 1;
>  			goto again;
>  		} else {
> -			found = 0;
> +			found = false;
>  			goto out_failed;
>  		}
>  	}
> @@ -3195,7 +3194,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
>  {
>  	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
>  	u64 page_end = delalloc_start + PAGE_SIZE - 1;
> -	u64 nr_delalloc;
> +	bool found;
>  	u64 delalloc_to_write = 0;
>  	u64 delalloc_end = 0;
>  	int ret;
> @@ -3203,11 +3202,11 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
>  
>  
>  	while (delalloc_end < page_end) {
> -		nr_delalloc = find_lock_delalloc_range(inode, tree,
> +		found = find_lock_delalloc_range(inode, tree,
>  					       page,
>  					       &delalloc_start,
>  					       &delalloc_end);
> -		if (nr_delalloc == 0) {
> +		if (!found) {
>  			delalloc_start = delalloc_end + 1;
>  			continue;
>  		}
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index a1d3ea5a0d32..67881bca15fe 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -521,7 +521,7 @@ int free_io_failure(struct extent_io_tree *failure_tree,
>  		    struct extent_io_tree *io_tree,
>  		    struct io_failure_record *rec);
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -u64 find_lock_delalloc_range(struct inode *inode, struct extent_io_tree *tree,
> +bool find_lock_delalloc_range(struct inode *inode, struct extent_io_tree *tree,
>  			     struct page *locked_page, u64 *start,
>  			     u64 *end);
>  #endif
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
> index d33f9a95bce1..3c46d7f23456 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -66,7 +66,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
>  	u64 total_dirty = 2 * max_bytes;
>  	u64 start, end, test_start;
> -	u64 found;
> +	bool found;
>  	int ret = -EINVAL;
>  
>  	test_msg("running find delalloc tests");
> 
