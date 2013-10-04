Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab3JDViQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Oct 2013 17:38:16 -0400
Date: Fri, 4 Oct 2013 14:38:14 -0700
From: Zach Brown <zab@redhat.com>
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Simplify the logic in alloc_extent_buffer() for
 existing extent buffer case
Message-ID: <20131004213814.GC25712@lenny.home.zabbo.net>
References: <1380916529.22521.122.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380916529.22521.122.camel@chandra-dt.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 04, 2013 at 02:55:29PM -0500, Chandra Seetharaman wrote:
> alloc_extent_buffer() uses radix_tree_lookup() when radix_tree_insert() fails
> with EEXIST. That part of the code is very similar to the code in
> find_extent_buffer(). This patch replaces radix_tree_lookup() and surrounding
> code in alloc_extent_buffer() with find_extent_buffer().
> 
> While at it, this patch also changes the other usage of radix_tree_lookup() in
> alloc_extent_buffer() with find_extent_buffer() to reduce redundancy.
> 
> Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>


> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index c09a40d..50345fb 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4451,6 +4451,23 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb)
>  	}
>  }
>  
> +struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
> +					 u64 start, unsigned long len)

len isn't used.

> @@ -4530,24 +4543,17 @@ again:
>  
>  	spin_lock(&tree->buffer_lock);
>  	ret = radix_tree_insert(&tree->buffer, start >> PAGE_CACHE_SHIFT, eb);
> +	spin_unlock(&tree->buffer_lock);
> +	radix_tree_preload_end();
>  	if (ret == -EEXIST) {
> -		exists = radix_tree_lookup(&tree->buffer,
> -						start >> PAGE_CACHE_SHIFT);
> -		if (!atomic_inc_not_zero(&exists->refs)) {
> -			spin_unlock(&tree->buffer_lock);
> -			radix_tree_preload_end();
> -			exists = NULL;
> +		exists = find_extent_buffer(tree, start, len);

Is it safe to do the lookup under rcu instead of under the spinlock?
The commit message should mention the difference.

- z
