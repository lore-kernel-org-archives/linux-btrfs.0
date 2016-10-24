Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:33866 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753162AbcJXHXG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 03:23:06 -0400
MIME-Version: 1.0
In-Reply-To: <20161015004633.EE40C660FC3@gitolite.kernel.org>
References: <20161015004633.EE40C660FC3@gitolite.kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 24 Oct 2016 09:23:04 +0200
Message-ID: <CAMuHMdVQPFaMYHaj7f3uyToH0ReCj0fRkjHCBbHsHZzwsC+3ZA@mail.gmail.com>
Subject: Re: Btrfs: fix free space tree bitmaps on big-endian systems
To: Omar Sandoval <osandov@fb.com>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 15, 2016 at 2:46 AM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Web:        https://git.kernel.org/torvalds/c/2fe1d55134fce05c17ea118a2e37a4af771887bc
> Commit:     2fe1d55134fce05c17ea118a2e37a4af771887bc

520f16abf003952d in v4.7.10
1ff6341b5d92dd6b in v4.8.4

> Parent:     08895a8b6b06ed2323cd97a36ee40a116b3db8ed
> Refname:    refs/heads/master
> Author:     Omar Sandoval <osandov@fb.com>
> AuthorDate: Thu Sep 22 17:24:20 2016 -0700
> Committer:  David Sterba <dsterba@suse.com>
> CommitDate: Mon Oct 3 18:52:14 2016 +0200
>
>     Btrfs: fix free space tree bitmaps on big-endian systems
>
>     In convert_free_space_to_{bitmaps,extents}(), we buffer the free space
>     bitmaps in memory and copy them directly to/from the extent buffers with
>     {read,write}_extent_buffer(). The extent buffer bitmap helpers use byte
>     granularity, which is equivalent to a little-endian bitmap. This means
>     that on big-endian systems, the in-memory bitmaps will be written to
>     disk byte-swapped. To fix this, use byte-granularity for the bitmaps in
>     memory.

This change looks overly complex to me, and decreases performance.

>
>     Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
>     Cc: stable@vger.kernel.org # 4.5+
>     Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
>     Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>     Signed-off-by: Omar Sandoval <osandov@fb.com>
>     Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c       | 64 +++++++++++++++++++++++++++++++++-------------
>  fs/btrfs/extent_io.h       | 22 ++++++++++++++++
>  fs/btrfs/free-space-tree.c | 17 ++++++------
>  3 files changed, 76 insertions(+), 27 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 44fe66b..c3ec30d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5524,17 +5524,45 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
>         }
>  }
>
> -/*
> - * The extent buffer bitmap operations are done with byte granularity because
> - * bitmap items are not guaranteed to be aligned to a word and therefore a
> - * single word in a bitmap may straddle two pages in the extent buffer.
> - */
> -#define BIT_BYTE(nr) ((nr) / BITS_PER_BYTE)
> -#define BYTE_MASK ((1 << BITS_PER_BYTE) - 1)
> -#define BITMAP_FIRST_BYTE_MASK(start) \
> -       ((BYTE_MASK << ((start) & (BITS_PER_BYTE - 1))) & BYTE_MASK)
> -#define BITMAP_LAST_BYTE_MASK(nbits) \
> -       (BYTE_MASK >> (-(nbits) & (BITS_PER_BYTE - 1)))
> +void le_bitmap_set(u8 *map, unsigned int start, int len)
> +{
> +       u8 *p = map + BIT_BYTE(start);

You cannot use cpu_to_le32/cpu_to_le64 on the masks and operate on
unsigned longs in memory because there's no alignment guarantee, right?

> +       const unsigned int size = start + len;
> +       int bits_to_set = BITS_PER_BYTE - (start % BITS_PER_BYTE);
> +       u8 mask_to_set = BITMAP_FIRST_BYTE_MASK(start);
> +
> +       while (len - bits_to_set >= 0) {
> +               *p |= mask_to_set;
> +               len -= bits_to_set;
> +               bits_to_set = BITS_PER_BYTE;
> +               mask_to_set = ~(u8)0;
> +               p++;
> +       }

memset() for all but the first partial byte (if present)?

> +       if (len) {
> +               mask_to_set &= BITMAP_LAST_BYTE_MASK(size);
> +               *p |= mask_to_set;
> +       }
> +}
> +
> +void le_bitmap_clear(u8 *map, unsigned int start, int len)
> +{
> +       u8 *p = map + BIT_BYTE(start);
> +       const unsigned int size = start + len;
> +       int bits_to_clear = BITS_PER_BYTE - (start % BITS_PER_BYTE);
> +       u8 mask_to_clear = BITMAP_FIRST_BYTE_MASK(start);
> +
> +       while (len - bits_to_clear >= 0) {
> +               *p &= ~mask_to_clear;
> +               len -= bits_to_clear;
> +               bits_to_clear = BITS_PER_BYTE;
> +               mask_to_clear = ~(u8)0;
> +               p++;
> +       }

memset() for all but the first partial byte (if present)?

> +       if (len) {
> +               mask_to_clear &= BITMAP_LAST_BYTE_MASK(size);
> +               *p &= ~mask_to_clear;
> +       }
> +}
>
>  /*
>   * eb_bitmap_offset() - calculate the page and offset of the byte containing the
> @@ -5578,7 +5606,7 @@ static inline void eb_bitmap_offset(struct extent_buffer *eb,
>  int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
>                            unsigned long nr)
>  {
> -       char *kaddr;
> +       u8 *kaddr;
>         struct page *page;
>         unsigned long i;
>         size_t offset;
> @@ -5600,13 +5628,13 @@ int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
>  void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
>                               unsigned long pos, unsigned long len)
>  {
> -       char *kaddr;
> +       u8 *kaddr;
>         struct page *page;
>         unsigned long i;
>         size_t offset;
>         const unsigned int size = pos + len;
>         int bits_to_set = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
> -       unsigned int mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);
> +       u8 mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);
>
>         eb_bitmap_offset(eb, start, pos, &i, &offset);
>         page = eb->pages[i];
> @@ -5617,7 +5645,7 @@ void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
>                 kaddr[offset] |= mask_to_set;
>                 len -= bits_to_set;
>                 bits_to_set = BITS_PER_BYTE;
> -               mask_to_set = ~0U;
> +               mask_to_set = ~(u8)0;

Why?

>                 if (++offset >= PAGE_SIZE && len > 0) {
>                         offset = 0;
>                         page = eb->pages[++i];
> @@ -5642,13 +5670,13 @@ void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
>  void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
>                                 unsigned long pos, unsigned long len)
>  {
> -       char *kaddr;
> +       u8 *kaddr;
>         struct page *page;
>         unsigned long i;
>         size_t offset;
>         const unsigned int size = pos + len;
>         int bits_to_clear = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
> -       unsigned int mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);
> +       u8 mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);
>
>         eb_bitmap_offset(eb, start, pos, &i, &offset);
>         page = eb->pages[i];
> @@ -5659,7 +5687,7 @@ void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
>                 kaddr[offset] &= ~mask_to_clear;
>                 len -= bits_to_clear;
>                 bits_to_clear = BITS_PER_BYTE;
> -               mask_to_clear = ~0U;
> +               mask_to_clear = ~(u8)0;

Why?

>                 if (++offset >= PAGE_SIZE && len > 0) {
>                         offset = 0;
>                         page = eb->pages[++i];

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
