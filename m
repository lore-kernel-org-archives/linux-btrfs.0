Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50832 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725907AbeH1F0k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 01:26:40 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w7S1ZUrE002874
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 18:37:27 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2m4ry70hru-3
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 18:37:27 -0700
From: Nick Terrell <terrelln@fb.com>
To: Nick Terrell <terrelln@fb.com>
CC: David Sterba <dsterba@suse.cz>, <kernel-team@fb.com>,
        <linux-btrfs@vger.kernel.org>, <grub-devel@gnu.org>
Subject: [PATCH 0/3] btrfs: Add zstd support to btrfs
Date: Mon, 27 Aug 2018 18:36:51 -0700
Message-ID: <20180828013654.1627080-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

This patch set imports the upstream kernel zstd library, patches it to work
in grub, adds zstd support to the btrfs module, and adds a test case. I've
separated the importing and patching of the upstream kernel zstd library
for ease of review.

Thanks to David Sterba for starting this project! I started my patch from
where he left off.

Best,
Nick Terrell

Nick Terrell (3):
  Import kernel zstd
  Patch the kernel zstd
  Add btrfs zstd support

 Makefile.util.def                   |    8 +-
 grub-core/Makefile.core.def         |   10 +-
 grub-core/fs/btrfs.c                |   85 +-
 grub-core/lib/zstd/bitstream.h      |  380 ++++++
 grub-core/lib/zstd/decompress.c     | 2494 +++++++++++++++++++++++++++++++++++
 grub-core/lib/zstd/entropy_common.c |  243 ++++
 grub-core/lib/zstd/error_private.h  |   52 +
 grub-core/lib/zstd/fse.h            |  575 ++++++++
 grub-core/lib/zstd/fse_decompress.c |  329 +++++
 grub-core/lib/zstd/huf.h            |  212 +++
 grub-core/lib/zstd/huf_decompress.c |  957 ++++++++++++++
 grub-core/lib/zstd/kerncompat.h     |   69 +
 grub-core/lib/zstd/mem.h            |  155 +++
 grub-core/lib/zstd/xxhash.c         |  482 +++++++
 grub-core/lib/zstd/xxhash.h         |  236 ++++
 grub-core/lib/zstd/zstd.h           | 1157 ++++++++++++++++
 grub-core/lib/zstd/zstd_common.c    |   75 ++
 grub-core/lib/zstd/zstd_internal.h  |  265 ++++
 tests/btrfs_test.in                 |    1 +
 tests/util/grub-fs-tester.in        |    4 +-
 20 files changed, 7783 insertions(+), 6 deletions(-)
 create mode 100644 grub-core/lib/zstd/bitstream.h
 create mode 100644 grub-core/lib/zstd/decompress.c
 create mode 100644 grub-core/lib/zstd/entropy_common.c
 create mode 100644 grub-core/lib/zstd/error_private.h
 create mode 100644 grub-core/lib/zstd/fse.h
 create mode 100644 grub-core/lib/zstd/fse_decompress.c
 create mode 100644 grub-core/lib/zstd/huf.h
 create mode 100644 grub-core/lib/zstd/huf_decompress.c
 create mode 100644 grub-core/lib/zstd/kerncompat.h
 create mode 100644 grub-core/lib/zstd/mem.h
 create mode 100644 grub-core/lib/zstd/xxhash.c
 create mode 100644 grub-core/lib/zstd/xxhash.h
 create mode 100644 grub-core/lib/zstd/zstd.h
 create mode 100644 grub-core/lib/zstd/zstd_common.c
 create mode 100644 grub-core/lib/zstd/zstd_internal.h

--
2.16.2
