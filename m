Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52368 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1947199AbdEZHnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 03:43:19 -0400
Subject: Re: [PATCH 2/3 v2] btrfs: reduce arguments for decompress_bio ops
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170526074500.20342-1-anand.jain@oracle.com>
 <20170526074500.20342-3-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e27f1af0-5aad-92d4-3dba-ea61b089cc1a@suse.com>
Date: Fri, 26 May 2017 10:43:16 +0300
MIME-Version: 1.0
In-Reply-To: <20170526074500.20342-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.05.2017 10:44, Anand Jain wrote:
> struct compressed_bio pointer can be used instead.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2: added this patch
>  fs/btrfs/compression.c | 43 +------------------------------------------
>  fs/btrfs/compression.h | 44 ++++++++++++++++++++++++++++++++++++++++----
>  fs/btrfs/lzo.c         | 10 +++++-----
>  fs/btrfs/zlib.c        |  9 +++++----
>  4 files changed, 51 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index ee934e612f15..e426a8f427b5 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -42,45 +42,6 @@
>  #include "extent_io.h"
>  #include "extent_map.h"
>  
> -struct compressed_bio {
> -	/* number of bios pending for this compressed extent */
> -	refcount_t pending_bios;
> -
> -	/* the pages with the compressed data on them */
> -	struct page **compressed_pages;
> -
> -	/* inode that owns this data */
> -	struct inode *inode;
> -
> -	/* starting offset in the inode for our pages */
> -	u64 start;
> -
> -	/* number of bytes in the inode we're working on */
> -	unsigned long len;
> -
> -	/* number of bytes on disk */
> -	unsigned long compressed_len;
> -
> -	/* the compression algorithm for this bio */
> -	int compress_type;
> -
> -	/* number of compressed pages in the array */
> -	unsigned long nr_pages;
> -
> -	/* IO errors */
> -	int errors;
> -	int mirror_num;
> -
> -	/* for reads, this is the bio we are copying the data into */
> -	struct bio *orig_bio;
> -
> -	/*
> -	 * the start of a variable length array of checksums only
> -	 * used by reads
> -	 */
> -	u32 sums;
> -};
> -
>  static int btrfs_decompress_bio(struct compressed_bio *cb);
>  
>  static inline int compressed_bio_size(struct btrfs_fs_info *fs_info,
> @@ -964,9 +925,7 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
>  
>  	workspace = find_workspace(type);
>  
> -	ret = btrfs_compress_op[type-1]->decompress_bio(workspace,
> -			cb->compressed_pages, cb->start, cb->orig_bio,
> -			cb->compressed_len);
> +	ret = btrfs_compress_op[type-1]->decompress_bio(workspace, cb);
>  
>  	free_workspace(type, workspace);
>  	return ret;
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index 39ec43ab8df1..89bcf975efb8 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -34,6 +34,45 @@
>  /* Maximum size of data before compression */
>  #define BTRFS_MAX_UNCOMPRESSED		(SZ_128K)
>  
> +struct compressed_bio {
> +	/* number of bios pending for this compressed extent */
> +	refcount_t pending_bios;
> +
> +	/* the pages with the compressed data on them */
> +	struct page **compressed_pages;
> +
> +	/* inode that owns this data */
> +	struct inode *inode;
> +
> +	/* starting offset in the inode for our pages */
> +	u64 start;
> +
> +	/* number of bytes in the inode we're working on */
> +	unsigned long len;
> +
> +	/* number of bytes on disk */
> +	unsigned long compressed_len;
> +
> +	/* the compression algorithm for this bio */
> +	int compress_type;
> +
> +	/* number of compressed pages in the array */
> +	unsigned long nr_pages;
> +
> +	/* IO errors */
> +	int errors;
> +	int mirror_num;
> +
> +	/* for reads, this is the bio we are copying the data into */
> +	struct bio *orig_bio;
> +
> +	/*
> +	 * the start of a variable length array of checksums only
> +	 * used by reads
> +	 */
> +	u32 sums;
> +};
> +
>  void btrfs_init_compress(void);
>  void btrfs_exit_compress(void);
>  
> @@ -78,10 +117,7 @@ struct btrfs_compress_op {
>  			      unsigned long *total_out);
>  
>  	int (*decompress_bio)(struct list_head *workspace,
> -				 struct page **pages_in,
> -				 u64 disk_start,
> -				 struct bio *orig_bio,
> -				 size_t srclen);
> +				struct compressed_bio *cb);
>  
>  	int (*decompress)(struct list_head *workspace,
>  			  unsigned char *data_in,
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index f48c8c14dc14..29b2e1319e6e 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -254,16 +254,13 @@ static int lzo_compress_pages(struct list_head *ws,
>  	return ret;
>  }
>  
> -static int lzo_decompress_bio(struct list_head *ws,
> -				 struct page **pages_in,
> -				 u64 disk_start,
> -				 struct bio *orig_bio,
> -				 size_t srclen)
> +static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
>  {
>  	struct workspace *workspace = list_entry(ws, struct workspace, list);
>  	int ret = 0, ret2;
>  	char *data_in;
>  	unsigned long page_in_index = 0;
> +	size_t srclen = cb->compressed_len;
>  	unsigned long total_pages_in = DIV_ROUND_UP(srclen, PAGE_SIZE);
>  	unsigned long buf_start;
>  	unsigned long buf_offset = 0;
> @@ -278,6 +275,9 @@ static int lzo_decompress_bio(struct list_head *ws,
>  	unsigned long tot_len;
>  	char *buf;
>  	bool may_late_unmap, need_unmap;
> +	struct page **pages_in = cb->compressed_pages;
> +	u64 disk_start = cb->start;
> +	struct bio *orig_bio = cb->orig_bio;
>  
>  	data_in = kmap(pages_in[0]);
>  	tot_len = read_compress_length(data_in);
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index 135b10823c6d..c0f592406bb1 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -211,10 +211,7 @@ static int zlib_compress_pages(struct list_head *ws,
>  	return ret;
>  }
>  
> -static int zlib_decompress_bio(struct list_head *ws, struct page **pages_in,
> -				  u64 disk_start,
> -				  struct bio *orig_bio,
> -				  size_t srclen)
> +static int zlib_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
>  {
>  	struct workspace *workspace = list_entry(ws, struct workspace, list);
>  	int ret = 0, ret2;
> @@ -222,8 +219,12 @@ static int zlib_decompress_bio(struct list_head *ws, struct page **pages_in,
>  	char *data_in;
>  	size_t total_out = 0;
>  	unsigned long page_in_index = 0;
> +	size_t srclen = cb->compressed_len;
>  	unsigned long total_pages_in = DIV_ROUND_UP(srclen, PAGE_SIZE);
>  	unsigned long buf_start;
> +	struct page **pages_in = cb->compressed_pages;
> +	u64 disk_start = cb->start;
> +	struct bio *orig_bio = cb->orig_bio;
>  
>  	data_in = kmap(pages_in[page_in_index]);
>  	workspace->strm.next_in = data_in;
> 


Reviewed-by: Nikolay Borisov <nborisov@suse.com>
