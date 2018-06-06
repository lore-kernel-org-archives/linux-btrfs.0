Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60356 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932208AbeFFH1U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 03:27:20 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 38569ADB4
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jun 2018 07:27:19 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs-progs: Fixes inline ram_bytes related bugs
Date: Wed,  6 Jun 2018 15:27:11 +0800
Message-Id: <20180606072717.28854-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github (*):
https://github.com/adam900710/btrfs-progs/tree/inline_ram_bytes

It's based on David's devel branch, whose HEAD is:
commit 0d1c5812e28e286648781c7b35b542311cc01aa4 (david/devel)
Author: Matthias Benkard <matthias.benkard@egym.de>
Date:   Wed Apr 25 16:34:54 2018 +0200

    btrfs-progs: mkfs: traverse_directory: Reset error code on continue

Reported-by Steve Leung <sjleung@shaw.ca>, his old btrfs (at least
offending inodes are from 2014) has inline uncompressed extent, while
its ram_bytes mismatch with item size.

Latest kernel tree check catches this bug, while we failed to detect by
dump-tree.

It turns out that btrfs-progs is doing something evil to avoid reading
ram_bytes from inline uncompressed extent.


So this patchset will address all such ram_bytes related problems.

The 1st patch is a not-so-relative fix for restore, which is using
ram_bytes for decompress. Although thanks to the compression header, we
won't read out-of-boundary, but fixing it is never a bad thing.

The 2nd patch will get rid of the evil btrfs_file_extent_inline_len()
which hides raw ram_bytes from us, and fooling us for a long long time.

The 3rd~5th patches introduce check/repair function for both original
and lowmem mode (although lowmem mode can detect it even before this patch).

The last one is the test case for it as usual.

*: Or should I just migrate to gitlab after M$ acquired github?

Qu Wenruo (6):
  btrfs-progs: restore: Fix wrong compressed item size for decompress()
  btrfs-progs: Get rid of the confusing btrfs_file_extent_inline_len()
  btrfs-progs: check/original: Detect and repair wrong inline ram_bytes
  btrfs-progs: check/lowmem: Prepare check_file_extent() to handle
    repair
  btrfs-progs: check/lowmem: Repair wrong inlien ram_bytes for
    uncompressed extent
  btrfs-progs: fsck-tests: Add test case for corrupted inline ram_bytes

 check/main.c                                  |  46 ++++++-
 check/mode-lowmem.c                           | 120 ++++++++++++++----
 check/mode-original.h                         |   1 +
 cmds-restore.c                                |   5 +-
 ctree.h                                       |  22 ----
 file.c                                        |   3 +-
 print-tree.c                                  |   4 +-
 .../offset_by_one.img                         | Bin 0 -> 3072 bytes
 .../035-inline-bad-ram-bytes/test.sh          |  11 ++
 9 files changed, 157 insertions(+), 55 deletions(-)
 create mode 100644 tests/fsck-tests/035-inline-bad-ram-bytes/offset_by_one.img
 create mode 100755 tests/fsck-tests/035-inline-bad-ram-bytes/test.sh

-- 
2.17.1

