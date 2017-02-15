Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752245AbdBOV2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:28:41 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D2DDAD55
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 21:28:40 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 0/8] btrfs: cleanup patches
Date: Wed, 15 Feb 2017 16:28:26 -0500
Message-Id: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Hi all -

Here's another around of cleanup patches.  The first 7 cleanup API
blemishes with unused arguments and/or root -> fs_info conversion.  The
last converts the pr_debug in btrfs_abort_transaction to use btrfs_debug.

-Jeff

Jeff Mahoney (8):
  btrfs: pass fs_info to (more) routines that are only called with
    extent_root
  btrfs: flush_space always takes fs_info->fs_root
  btrfs: convert btrfs_inc_block_group_ro to accept fs_info
  btrfs: free-space-cache, clean up unnecessary root arguments
  btrfs: btrfs_wait_cache_io_root doesn't use path argument
  btrfs: btrfs_truncate_free_space_cache always allocates path
  btrfs: drop unused extent_op arg from btrfs_add_delayed_data_ref
  btrfs: use btrfs_debug instead of pr_debug in transaction abort

 fs/btrfs/ctree.h            |   5 +-
 fs/btrfs/delayed-ref.c      |   6 +-
 fs/btrfs/delayed-ref.h      |   3 +-
 fs/btrfs/extent-tree.c      | 144 ++++++++++++++++++++++----------------------
 fs/btrfs/free-space-cache.c |  49 ++++++---------
 fs/btrfs/free-space-cache.h |   7 +--
 fs/btrfs/inode-map.c        |   2 +-
 fs/btrfs/relocation.c       |   7 +--
 fs/btrfs/scrub.c            |   2 +-
 9 files changed, 107 insertions(+), 118 deletions(-)

-- 
2.7.1

