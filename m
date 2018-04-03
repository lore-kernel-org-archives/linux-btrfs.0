Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60371 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752515AbeDCSPq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:15:46 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] SPDX to btrfs
Date: Tue,  3 Apr 2018 20:13:17 +0200
Message-Id: <cover.1522778802.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Switch fs/btrfs/*.[ch] and fs/btrfs/tests/*.[ch] to SPDX. I've briefly
verified that there are no exceptions to GPL-2.0 (ie. no 'or later').
The changes match what I've seen in other patches and I don't think
ther's more needed to be done. If there are no objections I'm going to
add the patches to a 4.17 pull.

David Sterba (3):
  btrfs: replace GPL boilerplate by SPDX -- headers
  btrfs: replace GPL boilerplate by SPDX -- sources
  btrfs: add SPDX header to Kconfig

 fs/btrfs/Kconfig                       |  2 ++
 fs/btrfs/acl.c                         | 15 +--------------
 fs/btrfs/async-thread.c                | 15 +--------------
 fs/btrfs/async-thread.h                | 21 +++++----------------
 fs/btrfs/backref.c                     | 15 +--------------
 fs/btrfs/backref.h                     | 19 +++----------------
 fs/btrfs/btrfs_inode.h                 | 19 +++----------------
 fs/btrfs/check-integrity.c             | 15 +--------------
 fs/btrfs/check-integrity.h             | 19 +++----------------
 fs/btrfs/compression.c                 | 15 +--------------
 fs/btrfs/compression.h                 | 19 +++----------------
 fs/btrfs/ctree.c                       | 15 +--------------
 fs/btrfs/ctree.h                       | 20 ++++----------------
 fs/btrfs/dedupe.h                      | 20 ++++----------------
 fs/btrfs/delayed-inode.c               | 15 +--------------
 fs/btrfs/delayed-inode.h               | 19 +++----------------
 fs/btrfs/delayed-ref.c                 | 15 +--------------
 fs/btrfs/delayed-ref.h                 | 21 +++++----------------
 fs/btrfs/dev-replace.c                 | 16 ++--------------
 fs/btrfs/dev-replace.h                 | 20 ++++----------------
 fs/btrfs/dir-item.c                    | 15 +--------------
 fs/btrfs/disk-io.c                     | 15 +--------------
 fs/btrfs/disk-io.h                     | 20 ++++----------------
 fs/btrfs/export.c                      |  1 +
 fs/btrfs/export.h                      |  1 +
 fs/btrfs/extent-tree.c                 | 16 ++--------------
 fs/btrfs/extent_io.c                   |  1 +
 fs/btrfs/extent_io.h                   |  6 ++++--
 fs/btrfs/extent_map.c                  |  1 +
 fs/btrfs/extent_map.h                  |  6 ++++--
 fs/btrfs/file-item.c                   | 15 +--------------
 fs/btrfs/file.c                        | 15 +--------------
 fs/btrfs/free-space-cache.c            | 15 +--------------
 fs/btrfs/free-space-cache.h            | 19 +++----------------
 fs/btrfs/free-space-tree.c             | 15 +--------------
 fs/btrfs/free-space-tree.h             | 19 +++----------------
 fs/btrfs/inode-item.c                  | 15 +--------------
 fs/btrfs/inode-map.c                   | 15 +--------------
 fs/btrfs/inode-map.h                   |  5 +++--
 fs/btrfs/inode.c                       | 15 +--------------
 fs/btrfs/ioctl.c                       | 15 +--------------
 fs/btrfs/locking.c                     | 16 ++--------------
 fs/btrfs/locking.h                     | 19 +++----------------
 fs/btrfs/lzo.c                         | 15 +--------------
 fs/btrfs/math.h                        | 20 +++-----------------
 fs/btrfs/ordered-data.c                | 15 +--------------
 fs/btrfs/ordered-data.h                | 20 ++++----------------
 fs/btrfs/orphan.c                      | 15 +--------------
 fs/btrfs/print-tree.c                  | 15 +--------------
 fs/btrfs/print-tree.h                  | 21 +++++----------------
 fs/btrfs/props.c                       | 15 +--------------
 fs/btrfs/props.h                       | 19 +++----------------
 fs/btrfs/qgroup.c                      | 15 +--------------
 fs/btrfs/qgroup.h                      | 22 +++++-----------------
 fs/btrfs/raid56.c                      | 16 ++--------------
 fs/btrfs/raid56.h                      | 21 +++++----------------
 fs/btrfs/rcu-string.h                  | 20 ++++++--------------
 fs/btrfs/reada.c                       | 15 +--------------
 fs/btrfs/ref-verify.c                  | 15 +--------------
 fs/btrfs/ref-verify.h                  | 23 ++++++-----------------
 fs/btrfs/relocation.c                  | 15 +--------------
 fs/btrfs/root-tree.c                   | 15 +--------------
 fs/btrfs/scrub.c                       | 15 +--------------
 fs/btrfs/send.c                        | 15 +--------------
 fs/btrfs/send.h                        | 20 ++++++--------------
 fs/btrfs/struct-funcs.c                | 15 +--------------
 fs/btrfs/super.c                       | 15 +--------------
 fs/btrfs/sysfs.c                       | 15 +--------------
 fs/btrfs/sysfs.h                       |  7 ++++---
 fs/btrfs/tests/btrfs-tests.c           | 15 +--------------
 fs/btrfs/tests/btrfs-tests.h           | 19 +++----------------
 fs/btrfs/tests/extent-buffer-tests.c   | 15 +--------------
 fs/btrfs/tests/extent-io-tests.c       | 15 +--------------
 fs/btrfs/tests/extent-map-tests.c      | 15 +--------------
 fs/btrfs/tests/free-space-tests.c      | 15 +--------------
 fs/btrfs/tests/free-space-tree-tests.c | 15 +--------------
 fs/btrfs/tests/inode-tests.c           | 15 +--------------
 fs/btrfs/tests/qgroup-tests.c          | 15 +--------------
 fs/btrfs/transaction.c                 | 15 +--------------
 fs/btrfs/transaction.h                 | 20 ++++----------------
 fs/btrfs/tree-checker.c                | 13 +------------
 fs/btrfs/tree-checker.h                | 17 +++--------------
 fs/btrfs/tree-defrag.c                 | 15 +--------------
 fs/btrfs/tree-log.c                    | 15 +--------------
 fs/btrfs/tree-log.h                    | 20 ++++----------------
 fs/btrfs/ulist.c                       |  2 +-
 fs/btrfs/ulist.h                       |  7 +++----
 fs/btrfs/uuid-tree.c                   | 16 ++--------------
 fs/btrfs/volumes.c                     | 16 ++--------------
 fs/btrfs/volumes.h                     | 19 +++----------------
 fs/btrfs/xattr.c                       | 16 +---------------
 fs/btrfs/xattr.h                       | 21 ++++-----------------
 fs/btrfs/zlib.c                        | 15 +--------------
 fs/btrfs/zstd.c                        | 10 ++--------
 94 files changed, 200 insertions(+), 1225 deletions(-)

-- 
2.16.2

