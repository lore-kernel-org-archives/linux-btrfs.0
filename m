Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38257 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaEaXso (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:48:44 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so2848507wib.12
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 16:48:43 -0700 (PDT)
From: Philip Worrall <philip.worrall@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Philip Worrall <philip.worrall@googlemail.com>
Subject: [PATCH 0/8] Add support for LZ4 compression
Date: Sat, 31 May 2014 23:48:28 +0000
Message-Id: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

LZ4 is a lossless data compression algorithm that is focused on 
compression and decompression speed. LZ4 gives a slightly worse
compression ratio compared with LZO (and much worse than Zlib)
but compression speeds are *generally* similar to LZO. 
Decompression tends to be much faster under LZ4 compared 
with LZO hence it makes more sense to use LZ4 compression
when your workload involves a higher proportion of reads.

The following patch set adds LZ4 compression support to BTRFS
using the existing kernel implementation. It is based on the 
changeset for LZO support in 2011. Once a filesystem has been 
mounted with LZ4 compression enabled older versions of BTRFS 
will be unable to read it. This implementation is however 
backwards compatible with filesystems that currently use 
LZO or Zlib compression. Existing data will remain unchanged 
but any new files that you create will be compressed with LZ4.

Usage:
Apply the following 8 patches to the current git tree 
(as of 20140531) and compile/load the btrfs module.

# mount -t btrfs -o compress=lz4 device mountpoint

or

# mount -t btrfs -o compress-force=lz4 device mountpoint

Philip Worrall (8):
  Btrfs: Add kernel config options for LZ4
  Btrfs: Add lz4.c to the Makefile
  Btrfs: Add lz4 compression to avaialble compression ops
  Btrfs: Add definition for external lz4 compression struct
  Btrfs: Add feature flags for LZ4 support
  Btrfs: Ensure LZ4 feature flags are set when mounting with LZ4
  Btrfs: Add lz4 compression/decompression struct ops
  Btrfs: Check for compress=lz4 in mount options

 fs/btrfs/Kconfig       |   2 +
 fs/btrfs/Makefile      |   2 +-
 fs/btrfs/compression.c |   1 +
 fs/btrfs/compression.h |   2 +-
 fs/btrfs/ctree.h       |  10 +-
 fs/btrfs/disk-io.c     |   3 +-
 fs/btrfs/lz4.c         | 436 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/super.c       |  12 +-
 8 files changed, 461 insertions(+), 7 deletions(-)
 create mode 100644 fs/btrfs/lz4.c

-- 
1.9.1

