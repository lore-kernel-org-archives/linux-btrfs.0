Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753745AbcKIRET (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 12:04:19 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93AAEAC34
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 17:04:17 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 00/12] Misc cleanups
Date: Wed,  9 Nov 2016 18:04:15 +0100
Message-Id: <cover.1478710770.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here's a bunch of cleanups and potential speed improvements when copying extent
buffer pages, there are some special cases. I haven't done any performance
measurements though.

Patchset target is 4.10, can be found in branch misc-cleanups-4.10 in my repos.

----------------------------------------------------------------
David Sterba (12):
      btrfs: reada, cleanup remove unneeded variable in __readahead_hook
      btrfs: reada, remove unused parameter from __readahead_hook
      btrfs: reada, sink start parameter to btree_readahead_hook
      btrfs: reada, remove pointless BUG_ON in reada_find_extent
      btrfs: reada, remove pointless BUG_ON check for fs_info
      btrfs: remove trivial helper btrfs_find_tree_block
      btrfs: delete unused member from superblock
      btrfs: introduce helpers for updating eb uuids
      btrfs: use new helpers to set uuids in eb
      btrfs: use specialized page copying helpers in btrfs_clone_extent_buffer
      btrfs: remove constant parameter to memset_extent_buffer and rename it
      btrfs: add optimized version of eb to eb copy

 fs/btrfs/ctree.c                 | 49 ++++++++++++++++------------------------
 fs/btrfs/ctree.h                 |  3 +--
 fs/btrfs/disk-io.c               | 26 +++++++--------------
 fs/btrfs/disk-io.h               |  2 --
 fs/btrfs/extent-tree.c           |  4 ++--
 fs/btrfs/extent_io.c             | 47 +++++++++++++++++++++++++++++++++-----
 fs/btrfs/extent_io.h             |  9 ++++++--
 fs/btrfs/file-item.c             |  2 +-
 fs/btrfs/free-space-cache.c      |  4 ++--
 fs/btrfs/inode.c                 |  2 +-
 fs/btrfs/ioctl.c                 | 10 ++++----
 fs/btrfs/reada.c                 | 24 ++++++--------------
 fs/btrfs/relocation.c            |  2 +-
 fs/btrfs/tests/extent-io-tests.c |  2 +-
 fs/btrfs/volumes.c               |  6 ++---
 15 files changed, 98 insertions(+), 94 deletions(-)
