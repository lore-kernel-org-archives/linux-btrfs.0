Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42409 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751830AbdK0RMu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 12:12:50 -0500
Date: Mon, 27 Nov 2017 18:10:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v2 09/11] Btrfs: kill the btree_inode
Message-ID: <20171127171051.GF3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1511385366-20329-1-git-send-email-josef@toxicpanda.com>
 <1511385366-20329-10-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511385366-20329-10-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 22, 2017 at 04:16:04PM -0500, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> @@ -4802,8 +4885,8 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>  	return new;
>  }
>  
> -struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
> -						  u64 start, unsigned long len)
> +struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_eb_info *eb_info,
> +						u64 start, unsigned long len)

The __alloc_dummy_extent_buffer takes the length parameter because it's
used in tests that need to pass different values.
I've removed nodesize from alloc_dummy_extent_buffer and the callchain
because we know that it's always going to be fs_info->nodesize.
Reintroducing it does not look like a good idea.

>  {
>  	struct extent_buffer *eb;
>  	unsigned long num_pages;

> @@ -160,13 +162,25 @@ struct extent_state {
>  #endif
>  };
>  
> +struct btrfs_eb_info {
> +	struct btrfs_fs_info *fs_info;
> +	struct extent_io_tree io_tree;
> +	struct extent_io_tree io_failure_tree;
> +
> +	/* Extent buffer radix tree */
> +	spinlock_t buffer_lock;
> +	struct radix_tree_root buffer_radix;
> +	struct list_lru lru_list;
> +	pgoff_t writeback_index;
> +};
> +
>  #define INLINE_EXTENT_BUFFER_PAGES 16
>  #define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_SIZE)
>  struct extent_buffer {
>  	u64 start;
>  	unsigned long len;
>  	unsigned long bflags;
> -	struct btrfs_fs_info *fs_info;
> +	struct btrfs_eb_info *eb_info;

This single change increases the patch size just because all the
callers need to be updated. I suggest to keep fs_info in extent_buffer,
we're not going to lose much in terms of memory:

currently there are 14 eb objects in a 4k slab page, with the additional
fs_info it's still 14,

280 * 14 = 3920, unused 176 bytes
288 * 14 = 4032, unused 64 bytes

>  	spinlock_t refs_lock;
>  	atomic_t refs;
>  	atomic_t io_pages;
