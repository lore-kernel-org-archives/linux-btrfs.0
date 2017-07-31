Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:35641 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdGaCSj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Jul 2017 22:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAB3wodemv=aP-9chLo5VyN3WC+QNpgRNr1=iPU5ZxmZ37Sk-rw@mail.gmail.com>
References: <20170720212743.3351201-1-terrelln@fb.com> <20170720212743.3351201-5-terrelln@fb.com>
 <CAB3wodemv=aP-9chLo5VyN3WC+QNpgRNr1=iPU5ZxmZ37Sk-rw@mail.gmail.com>
From: Phillip Lougher <phillip.lougher@gmail.com>
Date: Mon, 31 Jul 2017 03:18:38 +0100
Message-ID: <CAB3wodfgkwnf-SWb-biv7F-nrU72EdWb3K6Syn3i-ix_qqaT2g@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] squashfs: Add zstd support
To: Nick Terrell <terrelln@fb.com>
Cc: "Austin S . Hemmelgarn" <ahferroin7@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        SquashFS developers <squashfs-devel@lists.sourceforge.net>,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sean Purcell <me@seanp.xyz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 31, 2017 at 2:50 AM, Phillip Lougher
<phillip.lougher@gmail.com> wrote:
> On Thu, Jul 20, 2017 at 10:27 PM, Nick Terrell <terrelln@fb.com> wrote:
>> Add zstd compression and decompression support to SquashFS. zstd is a
>> great fit for SquashFS because it can compress at ratios approaching xz,
>> while decompressing twice as fast as zlib. For SquashFS in particular,
>> it can decompress as fast as lzo and lz4. It also has the flexibility
>> to turn down the compression ratio for faster compression times.
>
> Hi Nick,
>
> This patch (and none of the previous versions) is showing up on
> squashfs-devel@lists.sourceforge.net.  I also think you should have
> emailed me directly as a courtesy, as I'm the Squashfs author and
> maintainer.

OK, you're not subscribed to squashfs-devel ....   I have accepted
your previous posts, but, please subscribe.

Thanks

Phillip

>
>
>> | Method         | Ratio | Compression MB/s | Decompression MB/s |
>> |----------------|-------|------------------|--------------------|
>> | gzip           |  2.92 |               15 |                128 |
>> | lzo            |  2.64 |              9.5 |                217 |
>> | lz4            |  2.12 |               94 |                218 |
>> | xz             |  3.43 |              5.5 |                 35 |
>> | xz 256 KB      |  3.53 |              5.4 |                 40 |
>> | zstd 1         |  2.71 |               96 |                210 |
>> | zstd 5         |  2.93 |               69 |                198 |
>> | zstd 10        |  3.01 |               41 |                225 |
>> | zstd 15        |  3.13 |             11.4 |                224 |
>> | zstd 16 256 KB |  3.24 |              8.1 |                210 |
>
>
> Those numbers look good to me.
>
>>
>> This patch was written by Sean Purcell <me@seanp.xyz>, but I will be
>> taking over the submission process.
>>
>> [1] http://releases.ubuntu.com/16.10/
>> [2] https://github.com/facebook/zstd/blob/dev/contrib/linux-kernel/squashfs-benchmark.sh
>
> I can't find your patch that adds zstd to the user-land
> Squashfs-tools.  That would be handy to do any testing :-)
>
> Phillip
>
>>
>> zstd source repository: https://github.com/facebook/zstd
>>
>> Cc: Sean Purcell <me@seanp.xyz>
>> Signed-off-by: Nick Terrell <terrelln@fb.com>
>> ---
>>  fs/squashfs/Kconfig        |  14 +++++
>>  fs/squashfs/Makefile       |   1 +
>>  fs/squashfs/decompressor.c |   7 +++
>>  fs/squashfs/decompressor.h |   4 ++
>>  fs/squashfs/squashfs_fs.h  |   1 +
>>  fs/squashfs/zstd_wrapper.c | 150 +++++++++++++++++++++++++++++++++++++++++++++
>>  6 files changed, 177 insertions(+)
>>  create mode 100644 fs/squashfs/zstd_wrapper.c
>>
>> diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
>> index ffb093e..1adb334 100644
>> --- a/fs/squashfs/Kconfig
>> +++ b/fs/squashfs/Kconfig
>> @@ -165,6 +165,20 @@ config SQUASHFS_XZ
>>
>>           If unsure, say N.
>>
>> +config SQUASHFS_ZSTD
>> +       bool "Include support for ZSTD compressed file systems"
>> +       depends on SQUASHFS
>> +       select ZSTD_DECOMPRESS
>> +       help
>> +         Saying Y here includes support for reading Squashfs file systems
>> +         compressed with ZSTD compression.  ZSTD gives better compression than
>> +         the default ZLIB compression, while using less CPU.
>> +
>> +         ZSTD is not the standard compression used in Squashfs and so most
>> +         file systems will be readable without selecting this option.
>> +
>> +         If unsure, say N.
>> +
>>  config SQUASHFS_4K_DEVBLK_SIZE
>>         bool "Use 4K device block size?"
>>         depends on SQUASHFS
>> diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
>> index 246a6f3..6655631 100644
>> --- a/fs/squashfs/Makefile
>> +++ b/fs/squashfs/Makefile
>> @@ -15,3 +15,4 @@ squashfs-$(CONFIG_SQUASHFS_LZ4) += lz4_wrapper.o
>>  squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
>>  squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
>>  squashfs-$(CONFIG_SQUASHFS_ZLIB) += zlib_wrapper.o
>> +squashfs-$(CONFIG_SQUASHFS_ZSTD) += zstd_wrapper.o
>> diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
>> index d2bc136..8366398 100644
>> --- a/fs/squashfs/decompressor.c
>> +++ b/fs/squashfs/decompressor.c
>> @@ -65,6 +65,12 @@ static const struct squashfs_decompressor squashfs_zlib_comp_ops = {
>>  };
>>  #endif
>>
>> +#ifndef CONFIG_SQUASHFS_ZSTD
>> +static const struct squashfs_decompressor squashfs_zstd_comp_ops = {
>> +       NULL, NULL, NULL, NULL, ZSTD_COMPRESSION, "zstd", 0
>> +};
>> +#endif
>> +
>>  static const struct squashfs_decompressor squashfs_unknown_comp_ops = {
>>         NULL, NULL, NULL, NULL, 0, "unknown", 0
>>  };
>> @@ -75,6 +81,7 @@ static const struct squashfs_decompressor *decompressor[] = {
>>         &squashfs_lzo_comp_ops,
>>         &squashfs_xz_comp_ops,
>>         &squashfs_lzma_unsupported_comp_ops,
>> +       &squashfs_zstd_comp_ops,
>>         &squashfs_unknown_comp_ops
>>  };
>>
>> diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
>> index a25713c..0f5a8e4 100644
>> --- a/fs/squashfs/decompressor.h
>> +++ b/fs/squashfs/decompressor.h
>> @@ -58,4 +58,8 @@ extern const struct squashfs_decompressor squashfs_lzo_comp_ops;
>>  extern const struct squashfs_decompressor squashfs_zlib_comp_ops;
>>  #endif
>>
>> +#ifdef CONFIG_SQUASHFS_ZSTD
>> +extern const struct squashfs_decompressor squashfs_zstd_comp_ops;
>> +#endif
>> +
>>  #endif
>> diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
>> index 506f4ba..24d12fd 100644
>> --- a/fs/squashfs/squashfs_fs.h
>> +++ b/fs/squashfs/squashfs_fs.h
>> @@ -241,6 +241,7 @@ struct meta_index {
>>  #define LZO_COMPRESSION                3
>>  #define XZ_COMPRESSION         4
>>  #define LZ4_COMPRESSION                5
>> +#define ZSTD_COMPRESSION       6
>>
>>  struct squashfs_super_block {
>>         __le32                  s_magic;
>> diff --git a/fs/squashfs/zstd_wrapper.c b/fs/squashfs/zstd_wrapper.c
>> new file mode 100644
>> index 0000000..8cb7c76
>> --- /dev/null
>> +++ b/fs/squashfs/zstd_wrapper.c
>> @@ -0,0 +1,150 @@
>> +/*
>> + * Squashfs - a compressed read only filesystem for Linux
>> + *
>> + * Copyright (c) 2016-present, Facebook, Inc.
>> + * All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2,
>> + * or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
>> + *
>> + * zstd_wrapper.c
>> + */
>> +
>> +#include <linux/mutex.h>
>> +#include <linux/buffer_head.h>
>> +#include <linux/slab.h>
>> +#include <linux/zstd.h>
>> +#include <linux/vmalloc.h>
>> +
>> +#include "squashfs_fs.h"
>> +#include "squashfs_fs_sb.h"
>> +#include "squashfs.h"
>> +#include "decompressor.h"
>> +#include "page_actor.h"
>> +
>> +struct workspace {
>> +       void *mem;
>> +       size_t mem_size;
>> +};
>> +
>> +static void *zstd_init(struct squashfs_sb_info *msblk, void *buff)
>> +{
>> +       struct workspace *wksp = kmalloc(sizeof(*wksp), GFP_KERNEL);
>> +       if (wksp == NULL)
>> +               goto failed;
>> +       wksp->mem_size = ZSTD_DStreamWorkspaceBound(max_t(size_t,
>> +                               msblk->block_size, SQUASHFS_METADATA_SIZE));
>> +       wksp->mem = vmalloc(wksp->mem_size);
>> +       if (wksp->mem == NULL)
>> +               goto failed;
>> +
>> +       return wksp;
>> +
>> +failed:
>> +       ERROR("Failed to allocate zstd workspace\n");
>> +       kfree(wksp);
>> +       return ERR_PTR(-ENOMEM);
>> +}
>> +
>> +
>> +static void zstd_free(void *strm)
>> +{
>> +       struct workspace *wksp = strm;
>> +
>> +       if (wksp)
>> +               vfree(wksp->mem);
>> +       kfree(wksp);
>> +}
>> +
>> +
>> +static int zstd_uncompress(struct squashfs_sb_info *msblk, void *strm,
>> +       struct buffer_head **bh, int b, int offset, int length,
>> +       struct squashfs_page_actor *output)
>> +{
>> +       struct workspace *wksp = strm;
>> +       ZSTD_DStream *stream;
>> +       size_t total_out = 0;
>> +       size_t zstd_err;
>> +       int k = 0;
>> +       ZSTD_inBuffer in_buf = { NULL, 0, 0 };
>> +       ZSTD_outBuffer out_buf = { NULL, 0, 0 };
>> +
>> +       stream = ZSTD_initDStream(wksp->mem_size, wksp->mem, wksp->mem_size);
>> +
>> +       if (!stream) {
>> +               ERROR("Failed to initialize zstd decompressor\n");
>> +               goto out;
>> +       }
>> +
>> +       out_buf.size = PAGE_SIZE;
>> +       out_buf.dst = squashfs_first_page(output);
>> +
>> +       do {
>> +               if (in_buf.pos == in_buf.size && k < b) {
>> +                       int avail = min(length, msblk->devblksize - offset);
>> +                       length -= avail;
>> +                       in_buf.src = bh[k]->b_data + offset;
>> +                       in_buf.size = avail;
>> +                       in_buf.pos = 0;
>> +                       offset = 0;
>> +               }
>> +
>> +               if (out_buf.pos == out_buf.size) {
>> +                       out_buf.dst = squashfs_next_page(output);
>> +                       if (out_buf.dst == NULL) {
>> +                               /* shouldn't run out of pages before stream is
>> +                                * done */
>> +                               squashfs_finish_page(output);
>> +                               goto out;
>> +                       }
>> +                       out_buf.pos = 0;
>> +                       out_buf.size = PAGE_SIZE;
>> +               }
>> +
>> +               total_out -= out_buf.pos;
>> +               zstd_err = ZSTD_decompressStream(stream, &out_buf, &in_buf);
>> +               total_out += out_buf.pos; /* add the additional data produced */
>> +
>> +               if (in_buf.pos == in_buf.size && k < b)
>> +                       put_bh(bh[k++]);
>> +       } while (zstd_err != 0 && !ZSTD_isError(zstd_err));
>> +
>> +       squashfs_finish_page(output);
>> +
>> +       if (ZSTD_isError(zstd_err)) {
>> +               ERROR("zstd decompression error: %d\n",
>> +                               (int)ZSTD_getErrorCode(zstd_err));
>> +               goto out;
>> +       }
>> +
>> +       if (k < b)
>> +               goto out;
>> +
>> +       return (int)total_out;
>> +
>> +out:
>> +       for (; k < b; k++)
>> +               put_bh(bh[k]);
>> +
>> +       return -EIO;
>> +}
>> +
>> +const struct squashfs_decompressor squashfs_zstd_comp_ops = {
>> +       .init = zstd_init,
>> +       .free = zstd_free,
>> +       .decompress = zstd_uncompress,
>> +       .id = ZSTD_COMPRESSION,
>> +       .name = "zstd",
>> +       .supported = 1
>> +};
>> --
>> 2.9.3
