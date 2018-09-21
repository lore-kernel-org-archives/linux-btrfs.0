Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37667 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391251AbeIVB7C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 21:59:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id q1-v6so936621plr.4
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 13:08:36 -0700 (PDT)
Date: Fri, 21 Sep 2018 13:08:34 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] btrfs-progs: Add extent buffer bitmap manipulation
 infrastructure
Message-ID: <20180921200834.GC31081@vader>
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
 <1529060762-4372-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529060762-4372-3-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2018 at 02:05:58PM +0300, Nikolay Borisov wrote:
> Those functions are in preparation for adding the freespace tree
> repair code since it needs to be able to deal with bitmap based fsts.
> This patch adds extent_buffer_bitmap_set and extent_buffer_bitmap_clear
> functions. Since in userspace we don't have to deal with page mappings
> their implementation is vastly simplified by simply setting each bit in
> the passed range.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  extent_io.c | 39 +++++++++++++++++++++++++++++++++++++++
>  extent_io.h | 15 +++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/extent_io.c b/extent_io.c
> index 198492699438..568a12f7084b 100644
> --- a/extent_io.c
> +++ b/extent_io.c
> @@ -204,6 +204,45 @@ static int clear_state_bit(struct extent_io_tree *tree,
>  	return ret;
>  }
>  
> +/**
> + * extent_buffer_bitmap_set - set an area of a bitmap
> + * @eb: the extent buffer
> + * @start: offset of the bitmap item in the extent buffer
> + * @pos: bit number of the first bit
> + * @len: number of bits to set
> + */
> +void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
> +                              unsigned long pos, unsigned long len)
> +{
> +        u8 *kaddr = (u8 *)eb->data + start;
> +
> +        while (len) {
> +		le_set_bit(pos, kaddr);
> +		pos++;
> +		len--;
> +        }
> +}
> +
> +
> +/**
> + * extent_buffer_bitmap_clear - clear an area of a bitmap
> + * @eb: the extent buffer
> + * @start: offset of the bitmap item in the extent buffer
> + * @pos: bit number of the first bit
> + * @len: number of bits to clear
> + */
> +void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
> +                                unsigned long pos, unsigned long len)
> +{
> +        u8 *kaddr = (u8 *)eb->data + start;
> +
> +        while (len) {
> +		le_clear_bit(pos, kaddr);
> +		pos++;
> +		len--;
> +        }
> +}
> +

Hm, bit-by-bit is pretty slow. We don't have to worry about the kmap
nonsense, but we can still do this byte-by-byte:

/**
 * extent_buffer_bitmap_set - set an area of a bitmap
 * @eb: the extent buffer
 * @start: offset of the bitmap item in the extent buffer
 * @pos: bit number of the first bit
 * @len: number of bits to set
 */
void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
			      unsigned long pos, unsigned long len)
{
        u8 *p = (u8 *)eb->data + start + BIT_BYTE(pos);
	const unsigned int size = pos + len;
	int bits_to_set = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
	u8 mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);

	while (len >= bits_to_set) {
		*p |= mask_to_set;
		len -= bits_to_set;
		bits_to_set = BITS_PER_BYTE;
		mask_to_set = ~0;
		p++;
	}
	if (len) {
		mask_to_set &= BITMAP_LAST_BYTE_MASK(size);
		*p |= mask_to_set;
	}
}

/**
 * extent_buffer_bitmap_clear - clear an area of a bitmap
 * @eb: the extent buffer
 * @start: offset of the bitmap item in the extent buffer
 * @pos: bit number of the first bit
 * @len: number of bits to clear
 */
void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
				unsigned long pos, unsigned long len)
{
        u8 *p = (u8 *)eb->data + start + BIT_BYTE(pos);
	const unsigned int size = pos + len;
	int bits_to_clear = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
	u8 mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);

	while (len >= bits_to_clear) {
		*p &= ~mask_to_clear;
		len -= bits_to_clear;
		bits_to_clear = BITS_PER_BYTE;
		mask_to_clear = ~0;
		p++;
	}
	if (len) {
		mask_to_clear &= BITMAP_LAST_BYTE_MASK(size);
		*p &= ~mask_to_clear;
	}
}

I'm 95% sure that's right ;) Compare to __bitmap_set() and
__bitmap_clear() in the kernel.
