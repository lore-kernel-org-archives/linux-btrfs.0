Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30236 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbcBVHCK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 02:02:10 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/5] btrfs-find-root enhancement for chunk tree corrupted fs
Date: Mon, 22 Feb 2016 14:59:52 +0800
Message-Id: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patchset, btrfs-find-root needs valid chunk tree from the
fs.
However for chunk root corrupted case, btrfs-find-root is of no use due
to above limitation.

This patchset will allow open_ctree_fs_info() to return a fs_info
without any valid tree root, but system chunk map from superblock only.
And modify btrfs-find-root along with some infrastructure to do chunk
root search.

Also fix an old bug where btrfs-find-root will always skip the first
chunk, with its corresponding regression test.

This also provides the basis for later "btrfsck --chunk-root" and faster
chunk-recovery enhancement.

Qu Wenruo (5):
  btrfs: volume: Fix a bug causing btrfs-find-root to skip first chunk
  btrfs: Allow open_ctree to return fs_info even chunk tree is corrupted
  btrfs: Add support for tree block operations on fs_info without roots.
  btrfs: find-root: Allow btrfs-find-root to search chunk root even
    chunk     root is corrupted
  btrfs: misc-test: Add regression test for find-root gives empty result

 btrfs-corrupt-block.c                              |   2 +-
 btrfs-find-root.c                                  |  17 ++--
 ctree.h                                            |   1 +
 disk-io.c                                          |  99 +++++++++++++--------
 disk-io.h                                          |  35 ++++++--
 extent-tree.c                                      |   3 +-
 find-root.c                                        |  10 +--
 find-root.h                                        |   2 +-
 .../first_meta_chunk.btrfs-image                   | Bin 0 -> 4096 bytes
 tests/misc-tests/012-find-root-no-result/test.sh   |  20 +++++
 volumes.c                                          |  20 +++--
 11 files changed, 147 insertions(+), 62 deletions(-)
 create mode 100644 tests/misc-tests/012-find-root-no-result/first_meta_chunk.btrfs-image
 create mode 100644 tests/misc-tests/012-find-root-no-result/test.sh

-- 
2.7.1



