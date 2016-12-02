Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45053 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751201AbcLBFHp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:45 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00ABEAAD0
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:44 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 00/18] misc-4.10: root->fs_info patchset
Date: Fri,  2 Dec 2016 00:07:20 -0500
Message-Id: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Hi all -

Here's the latest version of my root->fs_info patchset.  It's against
Dave's misc-4.10 branch.

-Jeff

---

Jeff Mahoney (18):
  btrfs: call functions that overwrite their root parameter with fs_info
  btrfs: call functions that always use the same root with fs_info
    instead
  btrfs: btrfs_init_new_device should use fs_info->dev_root
  btrfs: alloc_reserved_file_extent trace point should use extent_root
  btrfs: struct btrfsic_state->root should be an fs_info
  btrfs: struct reada_control.root -> reada_control.fs_info
  btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere
  btrfs: root->fs_info cleanup, io_ctl_init
  btrfs: pull node/sector/stripe sizes out of root and into fs_info
  btrfs: root->fs_info cleanup, btrfs_calc_{trans,trunc}_metadata_size
  btrfs: root->fs_info cleanup, lock/unlock_chunks
  btrfs: root->fs_info cleanup, update_block_group{,flags}
  btrfs: root->fs_info cleanup, add fs_info convenience variables
  btrfs: root->fs_info cleanup, access fs_info->delayed_root directly
  btrfs: convert extent-tree tracepoints to use fs_info
  btrfs: simplify btrfs_wait_cache_io prototype
  btrfs: take an fs_info directly when the root is not used otherwise
  btrfs: split btrfs_wait_marked_extents into normal and tree log
    functions

 fs/btrfs/backref.c                     |    8 +-
 fs/btrfs/check-integrity.c             |   73 +-
 fs/btrfs/check-integrity.h             |    5 +-
 fs/btrfs/compression.c                 |   54 +-
 fs/btrfs/ctree.c                       |  468 ++++++------
 fs/btrfs/ctree.h                       |  216 +++---
 fs/btrfs/delayed-inode.c               |  134 ++--
 fs/btrfs/delayed-inode.h               |   19 +-
 fs/btrfs/dev-replace.c                 |   58 +-
 fs/btrfs/dev-replace.h                 |    4 +-
 fs/btrfs/dir-item.c                    |   45 +-
 fs/btrfs/disk-io.c                     |  538 +++++++-------
 fs/btrfs/disk-io.h                     |   30 +-
 fs/btrfs/export.c                      |   10 +-
 fs/btrfs/extent-tree.c                 | 1269 ++++++++++++++++----------------
 fs/btrfs/extent_io.c                   |   61 +-
 fs/btrfs/extent_io.h                   |    8 +-
 fs/btrfs/file-item.c                   |  152 ++--
 fs/btrfs/file.c                        |  194 ++---
 fs/btrfs/free-space-cache.c            |  154 ++--
 fs/btrfs/free-space-cache.h            |   12 +-
 fs/btrfs/free-space-tree.c             |   36 +-
 fs/btrfs/inode-item.c                  |   11 +-
 fs/btrfs/inode-map.c                   |   22 +-
 fs/btrfs/inode.c                       |  691 +++++++++--------
 fs/btrfs/ioctl.c                       |  518 +++++++------
 fs/btrfs/ordered-data.c                |   38 +-
 fs/btrfs/ordered-data.h                |    4 +-
 fs/btrfs/print-tree.c                  |   19 +-
 fs/btrfs/print-tree.h                  |    4 +-
 fs/btrfs/props.c                       |    5 +-
 fs/btrfs/qgroup.c                      |   56 +-
 fs/btrfs/qgroup.h                      |    2 +-
 fs/btrfs/raid56.c                      |   62 +-
 fs/btrfs/raid56.h                      |    8 +-
 fs/btrfs/reada.c                       |   34 +-
 fs/btrfs/relocation.c                  |  229 +++---
 fs/btrfs/root-tree.c                   |   26 +-
 fs/btrfs/scrub.c                       |  157 ++--
 fs/btrfs/send.c                        |   29 +-
 fs/btrfs/super.c                       |  130 ++--
 fs/btrfs/tests/btrfs-tests.c           |   13 +-
 fs/btrfs/tests/btrfs-tests.h           |    4 +-
 fs/btrfs/tests/extent-buffer-tests.c   |    7 +-
 fs/btrfs/tests/extent-io-tests.c       |    5 +-
 fs/btrfs/tests/free-space-tests.c      |   18 +-
 fs/btrfs/tests/free-space-tree-tests.c |    9 +-
 fs/btrfs/tests/inode-tests.c           |   16 +-
 fs/btrfs/tests/qgroup-tests.c          |   11 +-
 fs/btrfs/transaction.c                 |  562 +++++++-------
 fs/btrfs/transaction.h                 |   11 +-
 fs/btrfs/tree-log.c                    |  191 ++---
 fs/btrfs/uuid-tree.c                   |   21 +-
 fs/btrfs/volumes.c                     |  753 +++++++++----------
 fs/btrfs/volumes.h                     |   43 +-
 fs/btrfs/xattr.c                       |   19 +-
 include/trace/events/btrfs.h           |   65 +-
 57 files changed, 3745 insertions(+), 3596 deletions(-)

-- 
2.7.1

