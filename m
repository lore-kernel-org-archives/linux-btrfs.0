Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:37972 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdGULQR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 07:16:17 -0400
Subject: Re: [PATCH v3 0/4] Add xxhash and zstd modules
To: Nick Terrell <terrelln@fb.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170720212743.3351201-1-terrelln@fb.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <aabfb010-8175-191c-2d90-5a61cfa56e20@gmail.com>
Date: Fri, 21 Jul 2017 07:16:13 -0400
MIME-Version: 1.0
In-Reply-To: <20170720212743.3351201-1-terrelln@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-20 17:27, Nick Terrell wrote:
> Hi all,
> 
> This patch set adds xxhash, zstd compression, and zstd decompression
> modules. It also adds zstd support to BtrFS and SquashFS.
> 
> Each patch has relevant summaries, benchmarks, and tests.
> 
> Best,
> Nick Terrell
> 
> Changelog:
> 
> v1 -> v2:
> - Make pointer in lib/xxhash.c:394 non-const (1/4)
> - Use div_u64() for division of u64s (2/4)
> - Reduce stack usage of ZSTD_compressSequences(), ZSTD_buildSeqTable(),
>    ZSTD_decompressSequencesLong(), FSE_buildDTable(), FSE_decompress_wksp(),
>    HUF_writeCTable(), HUF_readStats(), HUF_readCTable(),
>    HUF_compressWeights(), HUF_readDTableX2(), and HUF_readDTableX4() (2/4)
> - No zstd function uses more than 400 B of stack space (2/4)
> 
> v2 -> v3:
> - Work around gcc-7 bug https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81388
>    (2/4)
> - Fix bug in dictionary compression from upstream commit cc1522351f (2/4)
> - Port upstream BtrFS commits e1ddce71d6, 389a6cfc2a, and 6acafd1eff (3/4)
> - Change default compression level for BtrFS to 3 (3/4)
> 
> Nick Terrell (4):
>    lib: Add xxhash module
>    lib: Add zstd modules
>    btrfs: Add zstd support
>    squashfs: Add zstd support
> 
>   fs/btrfs/Kconfig           |    2 +
>   fs/btrfs/Makefile          |    2 +-
>   fs/btrfs/compression.c     |    1 +
>   fs/btrfs/compression.h     |    6 +-
>   fs/btrfs/ctree.h           |    1 +
>   fs/btrfs/disk-io.c         |    2 +
>   fs/btrfs/ioctl.c           |    6 +-
>   fs/btrfs/props.c           |    6 +
>   fs/btrfs/super.c           |   12 +-
>   fs/btrfs/sysfs.c           |    2 +
>   fs/btrfs/zstd.c            |  435 ++++++
>   fs/squashfs/Kconfig        |   14 +
>   fs/squashfs/Makefile       |    1 +
>   fs/squashfs/decompressor.c |    7 +
>   fs/squashfs/decompressor.h |    4 +
>   fs/squashfs/squashfs_fs.h  |    1 +
>   fs/squashfs/zstd_wrapper.c |  150 ++
>   include/linux/xxhash.h     |  236 +++
>   include/linux/zstd.h       | 1157 +++++++++++++++
>   include/uapi/linux/btrfs.h |    8 +-
>   lib/Kconfig                |   11 +
>   lib/Makefile               |    3 +
>   lib/xxhash.c               |  500 +++++++
>   lib/zstd/Makefile          |   18 +
>   lib/zstd/bitstream.h       |  374 +++++
>   lib/zstd/compress.c        | 3479 ++++++++++++++++++++++++++++++++++++++++++++
>   lib/zstd/decompress.c      | 2526 ++++++++++++++++++++++++++++++++
>   lib/zstd/entropy_common.c  |  243 ++++
>   lib/zstd/error_private.h   |   53 +
>   lib/zstd/fse.h             |  575 ++++++++
>   lib/zstd/fse_compress.c    |  795 ++++++++++
>   lib/zstd/fse_decompress.c  |  332 +++++
>   lib/zstd/huf.h             |  212 +++
>   lib/zstd/huf_compress.c    |  770 ++++++++++
>   lib/zstd/huf_decompress.c  |  960 ++++++++++++
>   lib/zstd/mem.h             |  151 ++
>   lib/zstd/zstd_common.c     |   75 +
>   lib/zstd/zstd_internal.h   |  250 ++++
>   lib/zstd/zstd_opt.h        | 1014 +++++++++++++
>   39 files changed, 14382 insertions(+), 12 deletions(-)
>   create mode 100644 fs/btrfs/zstd.c
>   create mode 100644 fs/squashfs/zstd_wrapper.c
>   create mode 100644 include/linux/xxhash.h
>   create mode 100644 include/linux/zstd.h
>   create mode 100644 lib/xxhash.c
>   create mode 100644 lib/zstd/Makefile
>   create mode 100644 lib/zstd/bitstream.h
>   create mode 100644 lib/zstd/compress.c
>   create mode 100644 lib/zstd/decompress.c
>   create mode 100644 lib/zstd/entropy_common.c
>   create mode 100644 lib/zstd/error_private.h
>   create mode 100644 lib/zstd/fse.h
>   create mode 100644 lib/zstd/fse_compress.c
>   create mode 100644 lib/zstd/fse_decompress.c
>   create mode 100644 lib/zstd/huf.h
>   create mode 100644 lib/zstd/huf_compress.c
>   create mode 100644 lib/zstd/huf_decompress.c
>   create mode 100644 lib/zstd/mem.h
>   create mode 100644 lib/zstd/zstd_common.c
>   create mode 100644 lib/zstd/zstd_internal.h
>   create mode 100644 lib/zstd/zstd_opt.h
> 
> --
> 2.9.3
> 

