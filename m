Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:55226 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759011AbdKHAyj (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 19:54:39 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 0/3] tree-checker bug fix and enhancement.
Date: Wed,  8 Nov 2017 08:54:23 +0800
Message-Id: <20171108005426.17903-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fix a false panic introduced by tree-checker,
and then introduce dir_item checker, along with cleanups to remove
existing checkers sparsed in dir-item.

The 1st patch is a fix to address kernel panic with sanity test in btrfs.
The cause is there are several callers which call
btrfs_mark_buffer_dirty() while its data is not initialized.
(The same patch is resent along with the rest of the patchset)

Considering the number of callers and how many times btrfs_mark_buffer_dirty()
is called, the 1st patch will skip item data check, so check in
btrfs_mark_buffer_dirty() will keep the old behavior.
(Only item and item pointer overlap check is newly introduced in this case)

The 2nd patch introduce comprehensive check for dir item, which is used
for 3 key types: DIR_ITEM, DIR_INDEX and XATTR.
(Unlike previous attempts to check all items with variable length)

Except existing checks, new checks are:
1) Enhanced dir type check
   Now only XATTR key can have FT_ATTR dir item.

2) name hash for DIR_ITEM/XATTR_ITEM
   Original introduced in btrfs-progs for a corrupted (non-fuzzed)
   image.

The last patch will cleanup the related existing code, mostly related to
verify_dir_item() and btrfs_is_name_len_valid().

Unlike btrfs_check_leaf() called in btrfs_mark_buffer_dirty(), all the
verification calls are in read path, so we won't lost any early warning
since they didn't exist from the beginning.

Changelog:
v2:
  Rename btrfs_check_leaf() to btrfs_check_leaf_full() and
  btrfs_check_leaf_relaxed() to better show their difference. Suggested
  by David.

  Unintend message in 2nd patch.

Qu Wenruo (3):
  btrfs: tree-checker: Fix false panic for sanity test
  btrfs: tree-checker: Add checker for dir item
  btrfs: Cleanup existing name_len checks

 fs/btrfs/ctree.h        |   5 --
 fs/btrfs/dir-item.c     | 108 -------------------------------
 fs/btrfs/disk-io.c      |  10 ++-
 fs/btrfs/export.c       |   5 --
 fs/btrfs/inode.c        |   4 --
 fs/btrfs/props.c        |   7 --
 fs/btrfs/root-tree.c    |   7 --
 fs/btrfs/send.c         |   6 --
 fs/btrfs/tree-checker.c | 168 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/tree-checker.h |  14 +++-
 fs/btrfs/tree-log.c     |  47 +++-----------
 fs/btrfs/xattr.c        |   6 --
 12 files changed, 193 insertions(+), 194 deletions(-)

-- 
2.15.0

