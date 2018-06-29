Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932081AbeF2I4k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:56:40 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19001AD67
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:39 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 00/14] Misc cleanups for 4.19
Date: Fri, 29 Jun 2018 10:56:37 +0200
Message-Id: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Minor interface/API and other safe cleanups.

David Sterba (14):
  btrfs: simplify some assignments of inode numbers
  btrfs: simplify pointer chasing of local fs_info variables
  btrfs: use copy_page for copying pages instead of memcpy
  btrfs: prune unused includes
  btrfs: pass only eb to num_extent_pages
  btrfs: switch types to int when counting eb pages
  btrfs: open-code bio_set_op_attrs
  btrfs: raid56: add new helper for starting async work
  btrfs: raid56: use new helper for async_rmw_stripe
  btrfs: raid56: use new helper for async_read_rebuild
  btrfs: raid56: use new helper for async_scrub_parity
  btrfs: raid56: merge rbio_is_full helpers
  btrfs: raid56: don't lock stripe cache table when freeing
  btrfs: raid56: catch errors from full_stripe_write

 fs/btrfs/check-integrity.c  |   2 +-
 fs/btrfs/compression.c      |   8 +--
 fs/btrfs/delayed-inode.c    |   4 +-
 fs/btrfs/dev-replace.c      |   5 --
 fs/btrfs/disk-io.c          |   4 +-
 fs/btrfs/extent-tree.c      |   6 +-
 fs/btrfs/extent_io.c        |  70 +++++++++++-----------
 fs/btrfs/extent_io.h        |   6 +-
 fs/btrfs/file-item.c        |   2 +-
 fs/btrfs/file.c             |  17 +++---
 fs/btrfs/free-space-cache.c |  11 ++--
 fs/btrfs/inode-map.c        |   1 -
 fs/btrfs/inode.c            |  24 ++++----
 fs/btrfs/ioctl.c            |   5 --
 fs/btrfs/ordered-data.c     |   1 -
 fs/btrfs/raid56.c           | 112 +++++++++++-------------------------
 fs/btrfs/reada.c            |   1 -
 fs/btrfs/scrub.c            |   6 +-
 fs/btrfs/struct-funcs.c     |   1 -
 fs/btrfs/super.c            |   3 -
 fs/btrfs/sysfs.c            |   2 -
 fs/btrfs/tree-log.c         |   6 +-
 fs/btrfs/volumes.c          |   3 -
 23 files changed, 109 insertions(+), 191 deletions(-)

-- 
2.17.1

