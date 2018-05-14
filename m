Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752634AbeENGys (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 02:54:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EB550ACCB
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 06:54:46 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: Detect compressed extent without csum
Date: Mon, 14 May 2018 14:54:41 +0800
Message-Id: <20180514065444.26313-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patches can be fetch from github:
https://github.com/adam900710/btrfs-progs/tree/compress_nodatasum

It's based on v4.16 stable branch.

James Harvey from mail list reports a strange kernel panic, whichs show
obviously kernel memory corruption, while after btrfs decompression
failure.

It turns out that, some compressed extent get corrupted on-disk, while
the inode has NODATASUM set, there is no csum to prevent corrupted
mirror being used.

Although the root cause should be buggy lzo implementation, it still
shows that btrfs is not following the behavior defined in btrfs(5):

     Note
     If nodatacow or nodatasum are enabled, compression is disabled.

So at least make btrfs check to detect such problem.

Qu Wenruo (3):
  btrfs-progs: check/lowmem: Add checks for compressed extent without
    csum
  btrfs-progs: check/original: Add checks for compressed extent without
    csum
  btrfs-progs: fsck-tests: Add test case for detecting compressed extent
    without csum

 check/main.c                                  |  10 ++++++--
 check/mode-lowmem.c                           |  18 +++++++++++++
 .../compressed_extent_without_csum.raw.xz     | Bin 0 -> 21996 bytes
 .../032-compressed-nodatasum/test.sh          |  24 ++++++++++++++++++
 4 files changed, 50 insertions(+), 2 deletions(-)
 create mode 100644 tests/fsck-tests/032-compressed-nodatasum/compressed_extent_without_csum.raw.xz
 create mode 100755 tests/fsck-tests/032-compressed-nodatasum/test.sh

-- 
2.17.0

