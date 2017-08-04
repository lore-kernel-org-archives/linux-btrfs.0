Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44120 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751516AbdHDUWB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Aug 2017 16:22:01 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v74KIsdh029023
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Aug 2017 13:22:00 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2c4yh1g2us-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Aug 2017 13:22:00 -0700
Received: from facebook.com (2401:db00:21:6023:face:0:9:0)      by
 mx-out.facebook.com (10.103.99.99) with ESMTP  id
 9147b13e795211e7978f0002c9dfb610-1089c150 for <linux-btrfs@vger.kernel.org>;
        Fri, 04 Aug 2017 13:21:58 -0700
From: Nick Terrell <terrelln@fb.com>
To: Nick Terrell <terrelln@fb.com>
CC: "Austin S . Hemmelgarn" <ahferroin7@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, <kernel-team@fb.com>,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        <squashfs-devel@lists.sourceforge.net>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH v4 0/5] Add xxhash and zstd modules
Date: Fri, 4 Aug 2017 13:19:16 -0700
Message-ID: <20170804201921.156890-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

This patch set adds xxhash, zstd compression, and zstd decompression
modules. It also adds zstd support to BtrFS and SquashFS.

Each patch has relevant summaries, benchmarks, and tests.

Best,
Nick Terrell

Changelog:

v1 -> v2:
- Make pointer in lib/xxhash.c:394 non-const (1/5)
- Use div_u64() for division of u64s (2/5)
- Reduce stack usage of ZSTD_compressSequences(), ZSTD_buildSeqTable(),
  ZSTD_decompressSequencesLong(), FSE_buildDTable(), FSE_decompress_wksp(),
  HUF_writeCTable(), HUF_readStats(), HUF_readCTable(),
  HUF_compressWeights(), HUF_readDTableX2(), and HUF_readDTableX4() (2/5)
- No zstd function uses more than 400 B of stack space (2/5)

v2 -> v3:
- Work around gcc-7 bug https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81388
  (2/5)
- Fix bug in dictionary compression from upstream commit cc1522351f (2/5)
- Port upstream BtrFS commits e1ddce71d6, 389a6cfc2a, and 6acafd1eff (3/5)
- Change default compression level for BtrFS to 3 (3/5)

v3 -> v4:
- Fix compiler warnings (2/5)
- Add missing includes (3/5)
- Fix minor linter warnings (3/5, 4/5)
- Add crypto patch (5/5)

Nick Terrell (5):
  lib: Add xxhash module
  lib: Add zstd modules
  btrfs: Add zstd support
  squashfs: Add zstd support
  crypto: Add zstd support

 crypto/Kconfig             |    9 +
 crypto/Makefile            |    1 +
 crypto/testmgr.c           |   10 +
 crypto/testmgr.h           |   71 +
 crypto/zstd.c              |  265 ++++
 fs/btrfs/Kconfig           |    2 +
 fs/btrfs/Makefile          |    2 +-
 fs/btrfs/compression.c     |    1 +
 fs/btrfs/compression.h     |    6 +-
 fs/btrfs/ctree.h           |    1 +
 fs/btrfs/disk-io.c         |    2 +
 fs/btrfs/ioctl.c           |    6 +-
 fs/btrfs/props.c           |    6 +
 fs/btrfs/super.c           |   12 +-
 fs/btrfs/sysfs.c           |    2 +
 fs/btrfs/zstd.c            |  432 ++++++
 fs/squashfs/Kconfig        |   14 +
 fs/squashfs/Makefile       |    1 +
 fs/squashfs/decompressor.c |    7 +
 fs/squashfs/decompressor.h |    4 +
 fs/squashfs/squashfs_fs.h  |    1 +
 fs/squashfs/zstd_wrapper.c |  149 ++
 include/linux/xxhash.h     |  236 +++
 include/linux/zstd.h       | 1157 +++++++++++++++
 include/uapi/linux/btrfs.h |    8 +-
 lib/Kconfig                |   11 +
 lib/Makefile               |    3 +
 lib/xxhash.c               |  500 +++++++
 lib/zstd/Makefile          |   18 +
 lib/zstd/bitstream.h       |  374 +++++
 lib/zstd/compress.c        | 3479 ++++++++++++++++++++++++++++++++++++++++++++
 lib/zstd/decompress.c      | 2528 ++++++++++++++++++++++++++++++++
 lib/zstd/entropy_common.c  |  243 ++++
 lib/zstd/error_private.h   |   53 +
 lib/zstd/fse.h             |  575 ++++++++
 lib/zstd/fse_compress.c    |  795 ++++++++++
 lib/zstd/fse_decompress.c  |  332 +++++
 lib/zstd/huf.h             |  212 +++
 lib/zstd/huf_compress.c    |  770 ++++++++++
 lib/zstd/huf_decompress.c  |  960 ++++++++++++
 lib/zstd/mem.h             |  151 ++
 lib/zstd/zstd_common.c     |   75 +
 lib/zstd/zstd_internal.h   |  250 ++++
 lib/zstd/zstd_opt.h        | 1014 +++++++++++++
 44 files changed, 14736 insertions(+), 12 deletions(-)
 create mode 100644 crypto/zstd.c
 create mode 100644 fs/btrfs/zstd.c
 create mode 100644 fs/squashfs/zstd_wrapper.c
 create mode 100644 include/linux/xxhash.h
 create mode 100644 include/linux/zstd.h
 create mode 100644 lib/xxhash.c
 create mode 100644 lib/zstd/Makefile
 create mode 100644 lib/zstd/bitstream.h
 create mode 100644 lib/zstd/compress.c
 create mode 100644 lib/zstd/decompress.c
 create mode 100644 lib/zstd/entropy_common.c
 create mode 100644 lib/zstd/error_private.h
 create mode 100644 lib/zstd/fse.h
 create mode 100644 lib/zstd/fse_compress.c
 create mode 100644 lib/zstd/fse_decompress.c
 create mode 100644 lib/zstd/huf.h
 create mode 100644 lib/zstd/huf_compress.c
 create mode 100644 lib/zstd/huf_decompress.c
 create mode 100644 lib/zstd/mem.h
 create mode 100644 lib/zstd/zstd_common.c
 create mode 100644 lib/zstd/zstd_internal.h
 create mode 100644 lib/zstd/zstd_opt.h

--
2.9.3
