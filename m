Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52728 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2FWIHX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jun 2012 04:07:23 -0400
Received: by obbuo13 with SMTP id uo13so3165053obb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jun 2012 01:07:22 -0700 (PDT)
From: Andrew Mahone <andrew.mahone@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andrew Mahone <andrew.mahone@gmail.com>
Subject: [PATCH 0/5] btrfs: lz4/lz4hc compression
Date: Sat, 23 Jun 2012 04:05:43 -0400
Message-Id: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

WARNING: This is not compatible with the previous lz4 patchset. If you're using
experimental compression that isn't in mainline kernels, be prepared to backup
and restore or decompress before upgrading, and have backups in case it eats
data (which appears not to be a problem any more, but has been during
development).

These patches add lz4 and lz4hc compression (https://code.google.com/p/lz4/) to
btrfs. Compression with lz4 is about the same in throughput and compression
ratio as lzo, but decompression is a good deal faster. In practice, this
implementation also compresses faster and better than lzo because the existing
lzo implementation breaks extents into pages that are compressed individually.
The lz4hc compressor is a slower, higher-compression variation that is
doesn't quite match zlib on compression throughput or ratio, but is much faster
at decompression.

Some quick benchmarks, writing and reading a tarball of the Silesia corpus
(http://sun.aei.polsl.pl/~sdeor/index.php?page=silesia) in a VM on a
tmpfs-backed device. Times are in milliseconds.

method write read     size
none     489  356 202.27MB
lzo     1618  632 115.62MB
zlib    6583 1370  76.07MB
lz4     1216  368 102.15MB
lz4hc   8372  337  81.38MB

And with linux kernel sources (data size is btrfs fi df data size, may be
underestimated due to inline extents).

method write  read      size
none    8255  9880  446.11MB
lzo    11867  9011  225.36MB
zlib   20340 10419  154.22MB
lz4    10642  8417  203.70MB
lz4hc  20270  8280  171.68MB

A large portion of the work was done by Dave Sterba, but in flattening the
commits attribution has been lost. My contribution has been in debugging some
of the cases in which it could crash or produce incorrect data, and cleaning
it up for the ML.

Andrew Mahone (5):
  btrfs: lz4: import lz4/lz4hc C and header files
  btrfs: lz4: add incompat flags and compression types
  btrfs: lz4: add lz4_wrapper implementing btrfs compression interface
  btrfs: lz4: add lz4 files in Makefile
  btrfs: enable lz4/lz4hc compression

 fs/btrfs/Makefile      |   2 +-
 fs/btrfs/compression.c |   2 +
 fs/btrfs/compression.h |   2 +
 fs/btrfs/ctree.h       |  16 +-
 fs/btrfs/disk-io.c     |   4 +
 fs/btrfs/ioctl.c       |   5 +
 fs/btrfs/lz4.c         | 843 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/lz4.h         | 128 ++++++++
 fs/btrfs/lz4_wrapper.c | 419 ++++++++++++++++++++++++
 fs/btrfs/lz4hc.c       | 685 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/lz4hc.h       |  58 ++++
 fs/btrfs/super.c       |  16 +-
 12 files changed, 2174 insertions(+), 6 deletions(-)
 create mode 100644 fs/btrfs/lz4.c
 create mode 100644 fs/btrfs/lz4.h
 create mode 100644 fs/btrfs/lz4_wrapper.c
 create mode 100644 fs/btrfs/lz4hc.c
 create mode 100644 fs/btrfs/lz4hc.h

-- 
1.7.11

