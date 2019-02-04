Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4DCC282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 16:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B59F20815
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 16:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfBDQ5E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 11:57:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:47498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727308AbfBDQ5E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Feb 2019 11:57:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CF0C7AC8D
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Feb 2019 16:57:02 +0000 (UTC)
Subject: Re: [PATCH 14/15] btrfs: Implement find_first_clear_extent_bit
To:     linux-btrfs@vger.kernel.org
Cc:     jeffm@suse.com
References: <20190130145102.4708-1-nborisov@suse.com>
 <20190130145102.4708-15-nborisov@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <0dbc158a-f1d8-47c0-cfbf-b1c5f6f3ff84@suse.com>
Date:   Mon, 4 Feb 2019 18:57:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190130145102.4708-15-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 30.01.19 г. 16:51 ч., Nikolay Borisov wrote:
> This function is very similar to find_first_extent_bit except that it
> locates the first contiguous span of space which does not have bits set.
> It's intended use is in the freespace trimming code.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent_io.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/extent_io.h |  2 ++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d5525d18803d..542eaab9c0c1 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1474,6 +1474,84 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
>  	return ret;
>  }
>  
> +/* find_first_clear_extent_bit - finds the first range that has @bits not set
> + * and that starts after @start
> + *
> + * @tree - the tree to search
> + * @start - the offset at/after which the found extent should start
> + * @start_ret - records the beginning of the range
> + * @end_ret - records the end of the range (inclusive)
> + * @bits - the set of bits which must be unset
> + *
> + * Returns 0 when a range is found and @start_ret/@end_ret are initialised
> + * accordingly, 1 otherwise. Since unallocated range is also considered one
> + * which doesn't have the bits set it's possible that @end_ret contains -1, this
> + * happens in case the range spans (last_range_end, end of device]. In this case
> + * it's up to the caller to trim @end_ret to the appropriate size.
> + */
> +int find_first_clear_extent_bit(struct extent_io_tree *tree, u64 start,
> +				u64 *start_ret, u64 *end_ret, unsigned bits)
> +{
> +	struct extent_state *state;
> +	struct rb_node *node, *prev = NULL, *next;
> +	int ret = 1;
> +
> +	spin_lock(&tree->lock);
> +
> +	/* Find first extent with bits cleared */
> +	while (1) {
> +		node = __etree_search(tree, start, &next, &prev, NULL, NULL);
> +		if (!node) {
> +			node = next;
> +			if (!node) {
> +				/*
> +				 * We are past the last allocated chunk,
> +				 * set start at the end of the last extent. The
> +				 * device alloc tree should never be empty so
> +				 * prev is always set.
> +				 */
> +				ASSERT(prev);
> +				state = rb_entry(prev, struct extent_state, rb_node);
> +				*start_ret = state->end + 1;
> +				*end_ret = -1;
> +				ret = 0;
> +				goto out;

Bummer this is not working as expected. For example, for a fs which
doesn't have any holes it will return 0 but in fact it should return 1
and terminate the search. Have to figure how to distinguish between
"everything after last extent until -1 is not allocated" VS "there is no
extent which satisfies the condition so just return 1/failure"

> +			}
> +		}
> +		state = rb_entry(node, struct extent_state, rb_node);
> +		if (in_range(start, state->start, state->end - state->start + 1) &&
> +			(state->state & bits)) {
> +			start = state->end + 1;
> +		} else {
> +			*start_ret = start;
> +			break;
> +		}
> +	}
> +
> +	/*
> +	 * Find the longest stretch from start until an entry which has the
> +	 * bits set
> +	 */
> +	while (1) {
> +		state = rb_entry(node, struct extent_state, rb_node);
> +		if (state->end >= start && !(state->state & bits)) {
> +			*end_ret = state->end;
> +			ret = 0;
> +		} else {
> +			*end_ret = state->start - 1;
> +			ret = 0;
> +			break;
> +		}
> +
> +		node = rb_next(node);
> +		if (!node)
> +			break;
> +	}
> +out:
> +	spin_unlock(&tree->lock);
> +	return ret;
> +}
> +
>  /*
>   * find a contiguous range of bytes in the file marked as delalloc, not
>   * more than 'max_bytes'.  start and end are used to return the range,
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index d238efd628cf..7ddb3ec70023 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -391,6 +391,8 @@ static inline int set_extent_uptodate(struct extent_io_tree *tree, u64 start,
>  int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
>  			  u64 *start_ret, u64 *end_ret, unsigned bits,
>  			  struct extent_state **cached_state);
> +int find_first_clear_extent_bit(struct extent_io_tree *tree, u64 start,
> +				u64 *start_ret, u64 *end_ret, unsigned bits);
>  int extent_invalidatepage(struct extent_io_tree *tree,
>  			  struct page *page, unsigned long offset);
>  int extent_write_full_page(struct page *page, struct writeback_control *wbc);
> 
