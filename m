Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35625 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbeDOMjd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 08:39:33 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.17, part 2
Date: Sun, 15 Apr 2018 14:36:55 +0200
Message-Id: <cover.1523794897.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we have queued a few more fixes (error handling, log replay, softlockup)
and the rest is SPDX update that touches almost all files so the
diffstat is long. The top patch is a fixup for excessive warning and
was not in linux-next but I've tested it locally.

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 57599c7e7722daf5f8c2dba4b0e4628f5c500771:

  btrfs: lift errors from add_extent_changeset to the callers (2018-03-31 02:03:25 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.17-part2-tag

for you to fetch changes up to 5d41be6f702f19f72db816c17175caf9dbdcdfa6:

  btrfs: Only check first key for committed tree blocks (2018-04-13 16:16:15 +0200)

----------------------------------------------------------------
David Sterba (3):
      btrfs: replace GPL boilerplate by SPDX -- headers
      btrfs: replace GPL boilerplate by SPDX -- sources
      btrfs: add SPDX header to Kconfig

Filipe Manana (1):
      Btrfs: fix loss of prealloc extents past i_size after fsync log replay

Liu Bo (3):
      Btrfs: fix NULL pointer dereference in log_dir_items
      Btrfs: bail out on error during replay_dir_deletes
      Btrfs: clean up resources during umount after trans is aborted

Nikolay Borisov (1):
      btrfs: Fix possible softlock on single core machines

Qu Wenruo (1):
      btrfs: Only check first key for committed tree blocks

 fs/btrfs/Kconfig                       |  2 +
 fs/btrfs/acl.c                         | 15 +-----
 fs/btrfs/async-thread.c                | 15 +-----
 fs/btrfs/async-thread.h                | 21 ++------
 fs/btrfs/backref.c                     | 15 +-----
 fs/btrfs/backref.h                     | 19 ++------
 fs/btrfs/btrfs_inode.h                 | 19 ++------
 fs/btrfs/check-integrity.c             | 15 +-----
 fs/btrfs/check-integrity.h             | 19 ++------
 fs/btrfs/compression.c                 | 15 +-----
 fs/btrfs/compression.h                 | 19 ++------
 fs/btrfs/ctree.c                       | 15 +-----
 fs/btrfs/ctree.h                       | 20 ++------
 fs/btrfs/dedupe.h                      | 20 ++------
 fs/btrfs/delayed-inode.c               | 15 +-----
 fs/btrfs/delayed-inode.h               | 19 ++------
 fs/btrfs/delayed-ref.c                 | 15 +-----
 fs/btrfs/delayed-ref.h                 | 21 ++------
 fs/btrfs/dev-replace.c                 | 16 +-----
 fs/btrfs/dev-replace.h                 | 20 ++------
 fs/btrfs/dir-item.c                    | 15 +-----
 fs/btrfs/disk-io.c                     | 26 +++++-----
 fs/btrfs/disk-io.h                     | 20 ++------
 fs/btrfs/export.c                      |  1 +
 fs/btrfs/export.h                      |  1 +
 fs/btrfs/extent-tree.c                 | 17 ++-----
 fs/btrfs/extent_io.c                   |  1 +
 fs/btrfs/extent_io.h                   |  6 ++-
 fs/btrfs/extent_map.c                  |  1 +
 fs/btrfs/extent_map.h                  |  6 ++-
 fs/btrfs/file-item.c                   | 15 +-----
 fs/btrfs/file.c                        | 15 +-----
 fs/btrfs/free-space-cache.c            | 15 +-----
 fs/btrfs/free-space-cache.h            | 19 ++------
 fs/btrfs/free-space-tree.c             | 15 +-----
 fs/btrfs/free-space-tree.h             | 19 ++------
 fs/btrfs/inode-item.c                  | 15 +-----
 fs/btrfs/inode-map.c                   | 15 +-----
 fs/btrfs/inode-map.h                   |  5 +-
 fs/btrfs/inode.c                       | 15 +-----
 fs/btrfs/ioctl.c                       | 15 +-----
 fs/btrfs/locking.c                     | 16 +-----
 fs/btrfs/locking.h                     | 19 ++------
 fs/btrfs/lzo.c                         | 15 +-----
 fs/btrfs/math.h                        | 20 ++------
 fs/btrfs/ordered-data.c                | 15 +-----
 fs/btrfs/ordered-data.h                | 20 ++------
 fs/btrfs/orphan.c                      | 15 +-----
 fs/btrfs/print-tree.c                  | 15 +-----
 fs/btrfs/print-tree.h                  | 21 ++------
 fs/btrfs/props.c                       | 15 +-----
 fs/btrfs/props.h                       | 19 ++------
 fs/btrfs/qgroup.c                      | 15 +-----
 fs/btrfs/qgroup.h                      | 22 ++-------
 fs/btrfs/raid56.c                      | 16 +-----
 fs/btrfs/raid56.h                      | 21 ++------
 fs/btrfs/rcu-string.h                  | 20 +++-----
 fs/btrfs/reada.c                       | 15 +-----
 fs/btrfs/ref-verify.c                  | 15 +-----
 fs/btrfs/ref-verify.h                  | 23 +++------
 fs/btrfs/relocation.c                  | 15 +-----
 fs/btrfs/root-tree.c                   | 15 +-----
 fs/btrfs/scrub.c                       | 15 +-----
 fs/btrfs/send.c                        | 15 +-----
 fs/btrfs/send.h                        | 20 +++-----
 fs/btrfs/struct-funcs.c                | 15 +-----
 fs/btrfs/super.c                       | 15 +-----
 fs/btrfs/sysfs.c                       | 15 +-----
 fs/btrfs/sysfs.h                       |  7 +--
 fs/btrfs/tests/btrfs-tests.c           | 15 +-----
 fs/btrfs/tests/btrfs-tests.h           | 19 ++------
 fs/btrfs/tests/extent-buffer-tests.c   | 15 +-----
 fs/btrfs/tests/extent-io-tests.c       | 15 +-----
 fs/btrfs/tests/extent-map-tests.c      | 15 +-----
 fs/btrfs/tests/free-space-tests.c      | 15 +-----
 fs/btrfs/tests/free-space-tree-tests.c | 15 +-----
 fs/btrfs/tests/inode-tests.c           | 15 +-----
 fs/btrfs/tests/qgroup-tests.c          | 15 +-----
 fs/btrfs/transaction.c                 | 15 +-----
 fs/btrfs/transaction.h                 | 20 ++------
 fs/btrfs/tree-checker.c                | 13 +----
 fs/btrfs/tree-checker.h                | 17 ++-----
 fs/btrfs/tree-defrag.c                 | 15 +-----
 fs/btrfs/tree-log.c                    | 89 +++++++++++++++++++++++++---------
 fs/btrfs/tree-log.h                    | 20 ++------
 fs/btrfs/ulist.c                       |  2 +-
 fs/btrfs/ulist.h                       |  7 ++-
 fs/btrfs/uuid-tree.c                   | 16 +-----
 fs/btrfs/volumes.c                     | 16 +-----
 fs/btrfs/volumes.h                     | 19 ++------
 fs/btrfs/xattr.c                       | 16 +-----
 fs/btrfs/xattr.h                       | 21 ++------
 fs/btrfs/zlib.c                        | 15 +-----
 fs/btrfs/zstd.c                        | 10 +---
 94 files changed, 277 insertions(+), 1234 deletions(-)
