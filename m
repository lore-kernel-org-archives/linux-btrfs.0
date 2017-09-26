Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S967750AbdIZJYt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 05:24:49 -0400
Subject: Re: [PATCH] Btrfs: compress_file_range() remove dead variable
 num_bytes
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170911211517.22441-1-nefelim4ag@gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ac3b4cef-7099-a67b-4d78-03fcde34c9e8@suse.com>
Date: Tue, 26 Sep 2017 12:24:47 +0300
MIME-Version: 1.0
In-Reply-To: <20170911211517.22441-1-nefelim4ag@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.09.2017 00:15, Timofey Titovets wrote:
> Remove dead assigment of num_bytes
> 
> Also as num_bytes only used in will_compress block as
> copy of total_in just replace that with total_in and drop num_bytes entire
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/inode.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 17ad018da0a2..1ff4fa461555 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -446,7 +446,6 @@ static noinline void compress_file_range(struct inode *inode,
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	u64 num_bytes;
>  	u64 blocksize = fs_info->sectorsize;
>  	u64 actual_end;
>  	u64 isize = i_size_read(inode);
> @@ -496,8 +495,6 @@ static noinline void compress_file_range(struct inode *inode,
>  
>  	total_compressed = min_t(unsigned long, total_compressed,
>  			BTRFS_MAX_UNCOMPRESSED);
> -	num_bytes = ALIGN(end - start + 1, blocksize);
> -	num_bytes = max(blocksize,  num_bytes);
>  	total_in = 0;
>  	ret = 0;
>  
> @@ -613,7 +610,6 @@ static noinline void compress_file_range(struct inode *inode,
>  		 */
>  		total_in = ALIGN(total_in, PAGE_SIZE);
>  		if (total_compressed + blocksize <= total_in) {
> -			num_bytes = total_in;
>  			*num_added += 1;
>  
>  			/*
> @@ -621,12 +617,12 @@ static noinline void compress_file_range(struct inode *inode,
>  			 * allocation on disk for these compressed pages, and
>  			 * will submit them to the elevator.
>  			 */
> -			add_async_extent(async_cow, start, num_bytes,
> +			add_async_extent(async_cow, start, total_in,
>  					total_compressed, pages, nr_pages,
>  					compress_type);
>  
> -			if (start + num_bytes < end) {
> -				start += num_bytes;
> +			if (start + total_in < end) {
> +				start += total_in;
>  				pages = NULL;
>  				cond_resched();
>  				goto again;
> 
