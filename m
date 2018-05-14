Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41593 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751198AbeENLSn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:18:43 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: check: check symlinks with
 append/immutable flags
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
 <20180514102922.8840-2-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ea812fde-5a3b-be23-ffc0-c5a05a80d886@suse.com>
Date: Mon, 14 May 2018 14:18:41 +0300
MIME-Version: 1.0
In-Reply-To: <20180514102922.8840-2-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.05.2018 13:29, Su Yue wrote:
> Define new macro I_ERR_ODD_INODE_FLAGS to represents odd inode flags.
> 
> Symlinks should never have append/immutable flags.
> While processing inodes, if found a symlink with append/immutable
> flags, mark the inode record with I_ERR_ODD_INODE_FLAGS.
> 
> This is for original mode.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  check/main.c          | 7 +++++++
>  check/mode-original.h | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/check/main.c b/check/main.c
> index 68da994f7ae0..f5f52c406046 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -576,6 +576,8 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
>  		fprintf(stderr, ", link count wrong");
>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
>  		fprintf(stderr, ", orphan file extent");
> +	if (errors & I_ERR_ODD_INODE_FLAGS)
> +		fprintf(stderr, ", odd inode flags");
>  	fprintf(stderr, "\n");
>  	/* Print the orphan extents if needed */
>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
> @@ -805,6 +807,7 @@ static int process_inode_item(struct extent_buffer *eb,
>  {
>  	struct inode_record *rec;
>  	struct btrfs_inode_item *item;
> +	u64 flags;
>  
>  	rec = active_node->current;
>  	BUG_ON(rec->ino != key->objectid || rec->refs > 1);
> @@ -822,6 +825,10 @@ static int process_inode_item(struct extent_buffer *eb,
>  	rec->found_inode_item = 1;
>  	if (rec->nlink == 0)
>  		rec->errors |= I_ERR_NO_ORPHAN_ITEM;
> +	flags = btrfs_inode_flags(eb, item);
> +	if (rec->imode & BTRFS_FT_SYMLINK &&
> +	    flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND))
> +		rec->errors = I_ERR_ODD_INODE_FLAGS;
>  	maybe_free_inode_rec(&active_node->inode_cache, rec);
>  	return 0;
>  }
> diff --git a/check/mode-original.h b/check/mode-original.h
> index 368de692fdd1..13cfa5b9e1b3 100644
> --- a/check/mode-original.h
> +++ b/check/mode-original.h
> @@ -186,6 +186,7 @@ struct file_extent_hole {
>  #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
>  #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
>  #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
> +#define I_ERR_ODD_INODE_FLAGS		(1 << 16)

I don't like the name of the flag. How about:

I_ERR_INVALID_SYMLINK_FLAGS

>  
>  struct inode_record {
>  	struct list_head backrefs;
> 
