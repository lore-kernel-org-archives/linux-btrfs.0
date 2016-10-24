Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33251 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756195AbcJXSz5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 14:55:57 -0400
MIME-Version: 1.0
In-Reply-To: <20161024151628.GA3464@vader>
References: <20161015004633.EE40C660FC3@gitolite.kernel.org>
 <CAMuHMdVQPFaMYHaj7f3uyToH0ReCj0fRkjHCBbHsHZzwsC+3ZA@mail.gmail.com> <20161024151628.GA3464@vader>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 24 Oct 2016 20:55:55 +0200
Message-ID: <CAMuHMdX8mqgSDOsKpdDg=K2voS8FsPsjiJifx9Z1ZyNUb50fJA@mail.gmail.com>
Subject: Re: Btrfs: fix free space tree bitmaps on big-endian systems
To: Omar Sandoval <osandov@osandov.com>
Cc: Omar Sandoval <osandov@fb.com>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Omar,

On Mon, Oct 24, 2016 at 5:16 PM, Omar Sandoval <osandov@osandov.com> wrote:
> On Mon, Oct 24, 2016 at 09:23:04AM +0200, Geert Uytterhoeven wrote:
>> On Sat, Oct 15, 2016 at 2:46 AM, Linux Kernel Mailing List
>> <linux-kernel@vger.kernel.org> wrote:
>> > Web:        https://git.kernel.org/torvalds/c/2fe1d55134fce05c17ea118a2e37a4af771887bc
>> > Commit:     2fe1d55134fce05c17ea118a2e37a4af771887bc
>>
>> 520f16abf003952d in v4.7.10
>> 1ff6341b5d92dd6b in v4.8.4
>>
>> > Parent:     08895a8b6b06ed2323cd97a36ee40a116b3db8ed
>> > Refname:    refs/heads/master
>> > Author:     Omar Sandoval <osandov@fb.com>
>> > AuthorDate: Thu Sep 22 17:24:20 2016 -0700
>> > Committer:  David Sterba <dsterba@suse.com>
>> > CommitDate: Mon Oct 3 18:52:14 2016 +0200
>> >
>> >     Btrfs: fix free space tree bitmaps on big-endian systems
>> >
>> >     In convert_free_space_to_{bitmaps,extents}(), we buffer the free space
>> >     bitmaps in memory and copy them directly to/from the extent buffers with
>> >     {read,write}_extent_buffer(). The extent buffer bitmap helpers use byte
>> >     granularity, which is equivalent to a little-endian bitmap. This means
>> >     that on big-endian systems, the in-memory bitmaps will be written to
>> >     disk byte-swapped. To fix this, use byte-granularity for the bitmaps in
>> >     memory.
>>
>> This change looks overly complex to me, and decreases performance.
>
> Do you have evidence of that? Sure, it can in theory, but the change

Nope, just reading the code.

> only affects the free space tree format conversion, which is a rare
> operation. In fact, I actually benchmarked the change with [1] and saw
> no noticable difference on x86-64. In any case, now that the on-disk
> format problem is fixed, we can improve the implementation.

Good to hear that.

>> >     Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
>> >     Cc: stable@vger.kernel.org # 4.5+
>> >     Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
>> >     Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> >     Signed-off-by: Omar Sandoval <osandov@fb.com>
>> >     Signed-off-by: David Sterba <dsterba@suse.com>
>> > ---
>> >  fs/btrfs/extent_io.c       | 64 +++++++++++++++++++++++++++++++++-------------
>> >  fs/btrfs/extent_io.h       | 22 ++++++++++++++++
>> >  fs/btrfs/free-space-tree.c | 17 ++++++------
>> >  3 files changed, 76 insertions(+), 27 deletions(-)
>> >
>> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> > index 44fe66b..c3ec30d 100644
>> > --- a/fs/btrfs/extent_io.c
>> > +++ b/fs/btrfs/extent_io.c
>> > @@ -5524,17 +5524,45 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
>> >         }
>> >  }
>> >
>> > -/*
>> > - * The extent buffer bitmap operations are done with byte granularity because
>> > - * bitmap items are not guaranteed to be aligned to a word and therefore a
>> > - * single word in a bitmap may straddle two pages in the extent buffer.
>> > - */
>> > -#define BIT_BYTE(nr) ((nr) / BITS_PER_BYTE)
>> > -#define BYTE_MASK ((1 << BITS_PER_BYTE) - 1)
>> > -#define BITMAP_FIRST_BYTE_MASK(start) \
>> > -       ((BYTE_MASK << ((start) & (BITS_PER_BYTE - 1))) & BYTE_MASK)
>> > -#define BITMAP_LAST_BYTE_MASK(nbits) \
>> > -       (BYTE_MASK >> (-(nbits) & (BITS_PER_BYTE - 1)))
>> > +void le_bitmap_set(u8 *map, unsigned int start, int len)
>> > +{
>> > +       u8 *p = map + BIT_BYTE(start);
>>
>> You cannot use cpu_to_le32/cpu_to_le64 on the masks and operate on
>> unsigned longs in memory because there's no alignment guarantee, right?
>
> That's right.
>
>> > +       const unsigned int size = start + len;
>> > +       int bits_to_set = BITS_PER_BYTE - (start % BITS_PER_BYTE);
>> > +       u8 mask_to_set = BITMAP_FIRST_BYTE_MASK(start);
>> > +
>> > +       while (len - bits_to_set >= 0) {
>> > +               *p |= mask_to_set;
>> > +               len -= bits_to_set;
>> > +               bits_to_set = BITS_PER_BYTE;
>> > +               mask_to_set = ~(u8)0;
>> > +               p++;
>> > +       }
>>
>> memset() for all but the first partial byte (if present)?
>
> Shrug, the original bitmap_set() helper doesn't do this. For our use
> case, we're not expecting to do big spans with this since our free space
> must be pretty fragmented for us to be using this in the first place.

The original bitmap_set() helper doesn't do byte writes, but 32/64-bit writes,
which is much closer to memset() from a performance point of view.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
