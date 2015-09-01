Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28498 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750778AbbIATZ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 15:25:59 -0400
Subject: Re: [PATCH 1/6] Btrfs: add extent buffer bitmap operations
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1441131625.git.osandov@fb.com>
 <36f81ee96c9868b1517dbbda553c14b917b5d5ee.1441131625.git.osandov@fb.com>
CC: Omar Sandoval <osandov@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55E5FBC2.7020809@fb.com>
Date: Tue, 1 Sep 2015 15:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <36f81ee96c9868b1517dbbda553c14b917b5d5ee.1441131625.git.osandov@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/01/2015 03:01 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> These are going to be used for the free space tree bitmap items.
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Can we get sanity tests for these operations so we know they are 
properly unit tested?

> ---
>   fs/btrfs/extent_io.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/extent_io.h |   6 +++
>   2 files changed, 107 insertions(+)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 02d05817cbdf..649e3b4eeb1b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5475,6 +5475,107 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
>   	}
>   }
>
> +/*
> + * The extent buffer bitmap operations are done with byte granularity because
> + * bitmap items are not guaranteed to be aligned to a word and therefore a
> + * single word in a bitmap may straddle two pages in the extent buffer.
> + */
> +#define BIT_BYTE(nr) ((nr) / BITS_PER_BYTE)
> +#define BYTE_MASK ((1 << BITS_PER_BYTE) - 1)
> +#define BITMAP_FIRST_BYTE_MASK(start) \
> +	((BYTE_MASK << ((start) & (BITS_PER_BYTE - 1))) & BYTE_MASK)
> +#define BITMAP_LAST_BYTE_MASK(nbits) \
> +	(BYTE_MASK >> (-(nbits) & (BITS_PER_BYTE - 1)))
> +
> +int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
> +			   unsigned long nr)
> +{
> +	size_t offset;
> +	char *kaddr;
> +	struct page *page;
> +	size_t byte_offset = BIT_BYTE(nr);
> +	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
> +	unsigned long i = (start_offset + start + byte_offset) >> PAGE_CACHE_SHIFT;
> +
> +	offset = (start_offset + start + byte_offset) & (PAGE_CACHE_SIZE - 1);
> +	page = eb->pages[i];
> +	WARN_ON(!PageUptodate(page));
> +	kaddr = page_address(page);
> +	return 1U & (kaddr[offset] >> (nr & (BITS_PER_BYTE - 1)));
> +}
> +
> +void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
> +			      unsigned long pos, unsigned long len)
> +{
> +	size_t offset;
> +	char *kaddr;
> +	struct page *page;
> +	size_t byte_offset = BIT_BYTE(pos);
> +	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
> +	unsigned long i = (start_offset + start + byte_offset) >> PAGE_CACHE_SHIFT;
> +	const unsigned int size = pos + len;
> +	int bits_to_set = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
> +	unsigned int mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);
> +
> +	offset = (start_offset + start + byte_offset) & (PAGE_CACHE_SIZE - 1);
> +	page = eb->pages[i];
> +	WARN_ON(!PageUptodate(page));
> +	kaddr = page_address(page);
> +
> +	while (len >= bits_to_set) {
> +		kaddr[offset] |= mask_to_set;
> +		len -= bits_to_set;
> +		bits_to_set = BITS_PER_BYTE;
> +		mask_to_set = ~0U;
> +		if (++offset >= PAGE_CACHE_SIZE && len > 0) {
> +			offset = 0;
> +			page = eb->pages[++i];
> +			WARN_ON(!PageUptodate(page));
> +			kaddr = page_address(page);
> +		}
> +	}
> +	if (len) {
> +		mask_to_set &= BITMAP_LAST_BYTE_MASK(size);
> +		kaddr[offset] |= mask_to_set;
> +	}
> +}
> +
> +void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
> +				unsigned long pos, unsigned long len)
> +{
> +	size_t offset;
> +	char *kaddr;
> +	struct page *page;
> +	size_t byte_offset = BIT_BYTE(pos);
> +	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
> +	unsigned long i = (start_offset + start + byte_offset) >> PAGE_CACHE_SHIFT;
> +	const unsigned int size = pos + len;
> +	int bits_to_clear = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
> +	unsigned int mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);
> +
> +	offset = (start_offset + start + byte_offset) & (PAGE_CACHE_SIZE - 1);
> +	page = eb->pages[i];
> +	WARN_ON(!PageUptodate(page));
> +	kaddr = page_address(page);
> +

Abstract this offset finding logic to a helper function and then comment 
the hell out of it, I now have a migraine trying to figure out what is 
going on.  Thanks,

Josef
