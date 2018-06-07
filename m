Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:59986 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752973AbeFGCqG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 22:46:06 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id CBF15AC0050
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2018 11:45:57 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id D3B09584321
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2018 11:45:56 +0900 (JST)
Subject: Re: [PATCH v2 1/3] btrfs-progs: check: check symlinks with
 append/immutable flags
To: Su Yue <suy.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20180515013324.18838-1-suy.fnst@cn.fujitsu.com>
 <20180515013324.18838-2-suy.fnst@cn.fujitsu.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <ee67d0b0-567f-efa3-5d7f-667bbb098e8c@jp.fujitsu.com>
Date: Thu, 7 Jun 2018 11:45:47 +0900
MIME-Version: 1.0
In-Reply-To: <20180515013324.18838-2-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/05/15 10:33, Su Yue wrote:
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
> index 68da994f7ae0..c764fc011ded 100644
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

Hello,

I observed that this commit causes test-convert/009 in current kdave/devel branch.
Since rec->imode uses S_IFLNK (0xa000) for symbolic link and BTRFS_FT_SYMLINK is 7,
above statement does not work well. Shouldn't we use S_ISLNK(rec->imode) instead?

Thanks,
Tomohiro Misono

> +	    flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND))
> +		rec->errors |= I_ERR_ODD_INODE_FLAGS;
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
>  
>  struct inode_record {
>  	struct list_head backrefs;
> 

