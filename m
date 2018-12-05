Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58C1C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B472081C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72B472081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbeLEOco (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:32:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:48652 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727195AbeLEOco (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 09:32:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 85C2BAD4B
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 14:32:40 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: use offset_in_page instead of open-coding it
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181205142305.15361-1-jthumshirn@suse.de>
 <20181205142305.15361-2-jthumshirn@suse.de>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <4b49c528-1277-7b28-a0b6-4ef9a01aa2c6@suse.com>
Date:   Wed, 5 Dec 2018 16:32:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181205142305.15361-2-jthumshirn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 5.12.18 г. 16:23 ч., Johannes Thumshirn wrote:
> Constructs like 'var & (PAGE_SIZE - 1)' or 'var & ~PAGE_MASK' can denote an
> offset into a page.
> 
> So replace them by the offset_in_page() macro instead of open-coding it if
> they're not used as an alignment check.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/check-integrity.c | 12 +++++------
>  fs/btrfs/compression.c     |  2 +-
>  fs/btrfs/extent_io.c       | 53 +++++++++++++++++++++-------------------------
>  fs/btrfs/file.c            |  4 ++--
>  fs/btrfs/inode.c           |  7 +++---
>  fs/btrfs/send.c            |  2 +-
>  fs/btrfs/volumes.c         |  2 +-
>  7 files changed, 38 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 781cae168d2a..d319c3020c09 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -1202,24 +1202,24 @@ static void btrfsic_read_from_block_data(
>  	void *dstv, u32 offset, size_t len)
>  {
>  	size_t cur;
> -	size_t offset_in_page;
> +	size_t pgoff;
>  	char *kaddr;
>  	char *dst = (char *)dstv;
> -	size_t start_offset = block_ctx->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(block_ctx->start);
>  	unsigned long i = (start_offset + offset) >> PAGE_SHIFT;
>  
>  	WARN_ON(offset + len > block_ctx->len);
> -	offset_in_page = (start_offset + offset) & (PAGE_SIZE - 1);
> +	pgoff = offset_in_page(start_offset + offset);
>  
>  	while (len > 0) {
> -		cur = min(len, ((size_t)PAGE_SIZE - offset_in_page));
> +		cur = min(len, ((size_t)PAGE_SIZE - pgoff));
>  		BUG_ON(i >= DIV_ROUND_UP(block_ctx->len, PAGE_SIZE));
>  		kaddr = block_ctx->datav[i];
> -		memcpy(dst, kaddr + offset_in_page, cur);
> +		memcpy(dst, kaddr + pgoff, cur);
>  
>  		dst += cur;
>  		len -= cur;
> -		offset_in_page = 0;
> +		pgoff = 0;
>  		i++;
>  	}
>  }
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index dba59ae914b8..2ab5591449f2 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -477,7 +477,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>  
>  		if (page->index == end_index) {
>  			char *userpage;
> -			size_t zero_offset = isize & (PAGE_SIZE - 1);
> +			size_t zero_offset = offset_in_page(isize);
>  
>  			if (zero_offset) {
>  				int zeros;
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b2769e92b556..e365c5272e6b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2585,7 +2585,7 @@ static void end_bio_extent_readpage(struct bio *bio)
>  			unsigned off;
>  
>  			/* Zero out the end if this page straddles i_size */
> -			off = i_size & (PAGE_SIZE-1);
> +			off = offset_in_page(i_size);
>  			if (page->index == end_index && off)
>  				zero_user_segment(page, off, PAGE_SIZE);
>  			SetPageUptodate(page);
> @@ -2888,7 +2888,7 @@ static int __do_readpage(struct extent_io_tree *tree,
>  
>  	if (page->index == last_byte >> PAGE_SHIFT) {
>  		char *userpage;
> -		size_t zero_offset = last_byte & (PAGE_SIZE - 1);
> +		size_t zero_offset = offset_in_page(last_byte);
>  
>  		if (zero_offset) {
>  			iosize = PAGE_SIZE - zero_offset;
> @@ -3432,7 +3432,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
>  
>  	ClearPageError(page);
>  
> -	pg_offset = i_size & (PAGE_SIZE - 1);
> +	pg_offset = offset_in_page(i_size);
>  	if (page->index > end_index ||
>  	   (page->index == end_index && !pg_offset)) {
>  		page->mapping->a_ops->invalidatepage(page, 0, PAGE_SIZE);
> @@ -5307,7 +5307,7 @@ void read_extent_buffer(const struct extent_buffer *eb, void *dstv,
>  	struct page *page;
>  	char *kaddr;
>  	char *dst = (char *)dstv;
> -	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(eb->start);
>  	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
>  
>  	if (start + len > eb->len) {
> @@ -5317,7 +5317,7 @@ void read_extent_buffer(const struct extent_buffer *eb, void *dstv,
>  		return;
>  	}
>  
> -	offset = (start_offset + start) & (PAGE_SIZE - 1);
> +	offset = offset_in_page(start_offset + start);
>  
>  	while (len > 0) {
>  		page = eb->pages[i];
> @@ -5342,14 +5342,14 @@ int read_extent_buffer_to_user(const struct extent_buffer *eb,
>  	struct page *page;
>  	char *kaddr;
>  	char __user *dst = (char __user *)dstv;
> -	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(eb->start);
>  	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
>  	int ret = 0;
>  
>  	WARN_ON(start > eb->len);
>  	WARN_ON(start + len > eb->start + eb->len);
>  
> -	offset = (start_offset + start) & (PAGE_SIZE - 1);
> +	offset = offset_in_page(start_offset + start);
>  
>  	while (len > 0) {
>  		page = eb->pages[i];
> @@ -5383,7 +5383,7 @@ int map_private_extent_buffer(const struct extent_buffer *eb,
>  	size_t offset;
>  	char *kaddr;
>  	struct page *p;
> -	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(eb->start);
>  	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
>  	unsigned long end_i = (start_offset + start + min_len - 1) >>
>  		PAGE_SHIFT;
> @@ -5420,14 +5420,14 @@ int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
>  	struct page *page;
>  	char *kaddr;
>  	char *ptr = (char *)ptrv;
> -	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(eb->start);
>  	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
>  	int ret = 0;
>  
>  	WARN_ON(start > eb->len);
>  	WARN_ON(start + len > eb->start + eb->len);
>  
> -	offset = (start_offset + start) & (PAGE_SIZE - 1);
> +	offset = offset_in_page(start_offset + start);
>  
>  	while (len > 0) {
>  		page = eb->pages[i];
> @@ -5476,13 +5476,13 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
>  	struct page *page;
>  	char *kaddr;
>  	char *src = (char *)srcv;
> -	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(eb->start);
>  	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
>  
>  	WARN_ON(start > eb->len);
>  	WARN_ON(start + len > eb->start + eb->len);
>  
> -	offset = (start_offset + start) & (PAGE_SIZE - 1);
> +	offset = offset_in_page(start_offset + start);
>  
>  	while (len > 0) {
>  		page = eb->pages[i];
> @@ -5506,13 +5506,13 @@ void memzero_extent_buffer(struct extent_buffer *eb, unsigned long start,
>  	size_t offset;
>  	struct page *page;
>  	char *kaddr;
> -	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(eb->start);
>  	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
>  
>  	WARN_ON(start > eb->len);
>  	WARN_ON(start + len > eb->start + eb->len);
>  
> -	offset = (start_offset + start) & (PAGE_SIZE - 1);
> +	offset = offset_in_page(start_offset + start);
>  
>  	while (len > 0) {
>  		page = eb->pages[i];
> @@ -5551,13 +5551,12 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
>  	size_t offset;
>  	struct page *page;
>  	char *kaddr;
> -	size_t start_offset = dst->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(dst->start);
>  	unsigned long i = (start_offset + dst_offset) >> PAGE_SHIFT;
>  
>  	WARN_ON(src->len != dst_len);
>  
> -	offset = (start_offset + dst_offset) &
> -		(PAGE_SIZE - 1);
> +	offset = offset_in_page(start_offset + dst_offset);
>  
>  	while (len > 0) {
>  		page = dst->pages[i];
> @@ -5593,7 +5592,7 @@ static inline void eb_bitmap_offset(struct extent_buffer *eb,
>  				    unsigned long *page_index,
>  				    size_t *page_offset)
>  {
> -	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(eb->start);
>  	size_t byte_offset = BIT_BYTE(nr);
>  	size_t offset;
>  
> @@ -5605,7 +5604,7 @@ static inline void eb_bitmap_offset(struct extent_buffer *eb,
>  	offset = start_offset + start + byte_offset;
>  
>  	*page_index = offset >> PAGE_SHIFT;
> -	*page_offset = offset & (PAGE_SIZE - 1);
> +	*page_offset = offset_in_page(offset);
>  }
>  
>  /**
> @@ -5747,7 +5746,7 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  	size_t cur;
>  	size_t dst_off_in_page;
>  	size_t src_off_in_page;
> -	size_t start_offset = dst->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(dst->start);
>  	unsigned long dst_i;
>  	unsigned long src_i;
>  
> @@ -5765,10 +5764,8 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  	}
>  
>  	while (len > 0) {
> -		dst_off_in_page = (start_offset + dst_offset) &
> -			(PAGE_SIZE - 1);
> -		src_off_in_page = (start_offset + src_offset) &
> -			(PAGE_SIZE - 1);
> +		dst_off_in_page = offset_in_page(start_offset + dst_offset);
> +		src_off_in_page = offset_in_page(start_offset + src_offset);
>  
>  		dst_i = (start_offset + dst_offset) >> PAGE_SHIFT;
>  		src_i = (start_offset + src_offset) >> PAGE_SHIFT;
> @@ -5796,7 +5793,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  	size_t src_off_in_page;
>  	unsigned long dst_end = dst_offset + len - 1;
>  	unsigned long src_end = src_offset + len - 1;
> -	size_t start_offset = dst->start & ((u64)PAGE_SIZE - 1);
> +	size_t start_offset = offset_in_page(dst->start);
>  	unsigned long dst_i;
>  	unsigned long src_i;
>  
> @@ -5820,10 +5817,8 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  		dst_i = (start_offset + dst_end) >> PAGE_SHIFT;
>  		src_i = (start_offset + src_end) >> PAGE_SHIFT;
>  
> -		dst_off_in_page = (start_offset + dst_end) &
> -			(PAGE_SIZE - 1);
> -		src_off_in_page = (start_offset + src_end) &
> -			(PAGE_SIZE - 1);
> +		dst_off_in_page = offset_in_page(start_offset + dst_end);
> +		src_off_in_page = offset_in_page(start_offset + src_end);
>  
>  		cur = min_t(unsigned long, len, src_off_in_page + 1);
>  		cur = min(cur, dst_off_in_page + 1);
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 3835bb8c146d..81aae230d1a5 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -399,7 +399,7 @@ static noinline int btrfs_copy_from_user(loff_t pos, size_t write_bytes,
>  	size_t copied = 0;
>  	size_t total_copied = 0;
>  	int pg = 0;
> -	int offset = pos & (PAGE_SIZE - 1);
> +	int offset = offset_in_page(pos);
>  
>  	while (write_bytes > 0) {
>  		size_t count = min_t(size_t,
> @@ -1611,7 +1611,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>  		return -ENOMEM;
>  
>  	while (iov_iter_count(i) > 0) {
> -		size_t offset = pos & (PAGE_SIZE - 1);
> +		size_t offset = offset_in_page(pos);
>  		size_t sector_offset;
>  		size_t write_bytes = min(iov_iter_count(i),
>  					 nrptrs * (size_t)PAGE_SIZE -
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d54bdef16d8d..bc0564c384de 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -230,7 +230,7 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
>  				     start >> PAGE_SHIFT);
>  		btrfs_set_file_extent_compression(leaf, ei, 0);
>  		kaddr = kmap_atomic(page);
> -		offset = start & (PAGE_SIZE - 1);
> +		offset = offset_in_page(start);
>  		write_extent_buffer(leaf, kaddr + offset, ptr, size);
>  		kunmap_atomic(kaddr);
>  		put_page(page);
> @@ -539,8 +539,7 @@ static noinline void compress_file_range(struct inode *inode,
>  					   &total_compressed);
>  
>  		if (!ret) {
> -			unsigned long offset = total_compressed &
> -				(PAGE_SIZE - 1);
> +			unsigned long offset = offset_in_page(total_compressed);
>  			struct page *page = pages[nr_pages - 1];
>  			char *kaddr;
>  
> @@ -8878,7 +8877,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>  
>  	/* page is wholly or partially inside EOF */
>  	if (page_start + PAGE_SIZE > size)
> -		zero_start = size & ~PAGE_MASK;
> +		zero_start = offset_in_page(size);
>  	else
>  		zero_start = PAGE_SIZE;
>  
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 5be83b5a1b43..9df4c0b0e789 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -4775,7 +4775,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
>  	struct btrfs_key key;
>  	pgoff_t index = offset >> PAGE_SHIFT;
>  	pgoff_t last_index;
> -	unsigned pg_offset = offset & ~PAGE_MASK;
> +	unsigned pg_offset = offset_in_page(offset);
>  	ssize_t ret = 0;
>  
>  	key.objectid = sctx->cur_ino;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d49baad64fe6..bb0430b2a8ba 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1436,7 +1436,7 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  	p = kmap(*page);
>  
>  	/* align our pointer to the offset of the super block */
> -	*disk_super = p + (bytenr & ~PAGE_MASK);
> +	*disk_super = p + offset_in_page(bytenr);
>  
>  	if (btrfs_super_bytenr(*disk_super) != bytenr ||
>  	    btrfs_super_magic(*disk_super) != BTRFS_MAGIC) {
> 
