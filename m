From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] btrfs: kick off the useless parameter
Date: Wed, 22 Jun 2011 21:53:54 +0200
Message-ID: <4E024852.2050302@gmx.net>
References: <BANLkTi=yifUriAo7A-9sVbY32-WASWN7=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Wenyi Liu <qingshenlwy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=yifUriAo7A-9sVbY32-WASWN7=Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 22.06.2011 16:56, Wenyi Liu wrote:
> If there is no future development plan, this parameter for btrfs_root
> should be removed.
> ---
>
> Signed-off-by: Liu Wenyi<qingshenlwy@gmail.com>
>
> ---
>   fs/btrfs/compression.c      |    3 +--
>   fs/btrfs/disk-io.c          |    6 +++---
>   fs/btrfs/disk-io.h          |    2 +-
>   fs/btrfs/file-item.c        |    3 +--
>   fs/btrfs/free-space-cache.c |    6 +++---
>   fs/btrfs/inode.c            |    5 ++---
>   6 files changed, 11 insertions(+), 14 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 41d1d7c..499d8a4 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -105,7 +105,6 @@ static int check_compressed_csum(struct inode *inode,
>   				 u64 disk_start)
>   {
>   	int ret;
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
>   	struct page *page;
>   	unsigned long i;
>   	char *kaddr;
> @@ -120,7 +119,7 @@ static int check_compressed_csum(struct inode *inode,
>   		csum = ~(u32)0;
>
>   		kaddr = kmap_atomic(page, KM_USER0);
> -		csum = btrfs_csum_data(root, kaddr, csum, PAGE_CACHE_SIZE);
> +		csum = btrfs_csum_data(kaddr, csum, PAGE_CACHE_SIZE);
>   		btrfs_csum_final(csum, (char *)&csum);
>   		kunmap_atomic(kaddr, KM_USER0);
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index fe5aec9..77fee13 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -192,7 +192,7 @@ out:
>   	return em;
>   }
>
> -u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
> +u32 btrfs_csum_data(char *data, u32 seed, size_t len)

This is also included in my patch

[PATCH v1 1/3] btrfs: remove struct btrfs_root parameter where unused

-Arne

>   {
>   	return crc32c(seed, data, len);
>   }
> @@ -231,7 +231,7 @@ static int csum_tree_block(struct btrfs_root
> *root, struct extent_buffer *buf,
>   		if (err)
>   			return 1;
>   		cur_len = min(len, map_len - (offset - map_start));
> -		crc = btrfs_csum_data(root, kaddr + offset - map_start,
> +		crc = btrfs_csum_data(kaddr + offset - map_start,
>   				      crc, cur_len);
>   		len -= cur_len;
>   		offset += cur_len;
> @@ -2359,7 +2359,7 @@ static int write_dev_supers(struct btrfs_device *device,
>   			btrfs_set_super_bytenr(sb, bytenr);
>
>   			crc = ~(u32)0;
> -			crc = btrfs_csum_data(NULL, (char *)sb +
> +			crc = btrfs_csum_data((char *)sb +
>   					      BTRFS_CSUM_SIZE, crc,
>   					      BTRFS_SUPER_INFO_SIZE -
>   					      BTRFS_CSUM_SIZE);
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 07b20dc..9bef3e0 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -79,7 +79,7 @@ int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
>   int wait_on_tree_block_writeback(struct btrfs_root *root,
>   				 struct extent_buffer *buf);
>   int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
> -u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len);
> +u32 btrfs_csum_data(char *data, u32 seed, size_t len);
>   void btrfs_csum_final(u32 crc, char *result);
>   int btrfs_open_device(struct btrfs_device *dev);
>   int btrfs_verify_block_csum(struct btrfs_root *root,
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index a6a9d4e..611a1be 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -432,8 +432,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root,
> struct inode *inode,
>
>   		data = kmap_atomic(bvec->bv_page, KM_USER0);
>   		sector_sum->sum = ~(u32)0;
> -		sector_sum->sum = btrfs_csum_data(root,
> -						  data + bvec->bv_offset,
> +		sector_sum->sum = btrfs_csum_data(data + bvec->bv_offset,
>   						  sector_sum->sum,
>   						  bvec->bv_len);
>   		kunmap_atomic(data, KM_USER0);
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 63731a1..64ffb39 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -378,7 +378,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
>
>   		/* First lets check our crc before we do anything fun */
>   		cur_crc = ~(u32)0;
> -		cur_crc = btrfs_csum_data(root, addr + start_offset, cur_crc,
> +		cur_crc = btrfs_csum_data(addr + start_offset, cur_crc,
>   					  PAGE_CACHE_SIZE - start_offset);
>   		btrfs_csum_final(cur_crc, (char *)&cur_crc);
>   		if (cur_crc != *crc) {
> @@ -710,7 +710,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>   			entry++;
>   		}
>   		*crc = ~(u32)0;
> -		*crc = btrfs_csum_data(root, addr + start_offset, *crc,
> +		*crc = btrfs_csum_data(addr + start_offset, *crc,
>   				       PAGE_CACHE_SIZE - start_offset);
>   		kunmap(page);
>
> @@ -737,7 +737,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>   		addr = kmap(page);
>   		memcpy(addr, entry->bitmap, PAGE_CACHE_SIZE);
>   		*crc = ~(u32)0;
> -		*crc = btrfs_csum_data(root, addr, *crc, PAGE_CACHE_SIZE);
> +		*crc = btrfs_csum_data(addr, *crc, PAGE_CACHE_SIZE);
>   		kunmap(page);
>   		btrfs_csum_final(*crc, (char *)crc);
>   		crc++;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 870869a..9aa2103 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1989,7 +1989,7 @@ static int btrfs_readpage_end_io_hook(struct
> page *page, u64 start, u64 end,
>   	if (ret)
>   		goto zeroit;
>
> -	csum = btrfs_csum_data(root, kaddr + offset, csum,  end - start + 1);
> +	csum = btrfs_csum_data(kaddr + offset, csum,  end - start + 1);
>   	btrfs_csum_final(csum, (char *)&csum);
>   	if (csum != private)
>   		goto zeroit;
> @@ -5770,7 +5770,6 @@ static void btrfs_endio_direct_read(struct bio
> *bio, int err)
>   	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
>   	struct bio_vec *bvec = bio->bi_io_vec;
>   	struct inode *inode = dip->inode;
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
>   	u64 start;
>   	u32 *private = dip->csums;
>
> @@ -5784,7 +5783,7 @@ static void btrfs_endio_direct_read(struct bio
> *bio, int err)
>
>   			local_irq_save(flags);
>   			kaddr = kmap_atomic(page, KM_IRQ0);
> -			csum = btrfs_csum_data(root, kaddr + bvec->bv_offset,
> +			csum = btrfs_csum_data(kaddr + bvec->bv_offset,
>   					       csum, bvec->bv_len);
>   			btrfs_csum_final(csum, (char *)&csum);
>   			kunmap_atomic(kaddr, KM_IRQ0);

