Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45061 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbcLOHFy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 02:05:54 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: [GIT PULL] btrfs fixes and cleanups
Date: Wed, 14 Dec 2016 23:13:32 -0800
Message-Id: <1481786012-18586-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

This is the collection of my patches targetting 4.10, I've
dropped patch "Btrfs: adjust len of writes if following a
preallocated extent" because of the deadlock caused by this
commit.

Patches are based on v4.9-rc8, and test against fstests with
default mount options has been taken to make sure it doesn't
break anything.

I haven't got a kernel.org git repo, so this is mainly for
tracking purpose and for testing git flow.

(cherry-pick patches might be the only way at this moment...sorry
for the inconvenience.)

Anyway, patches can be found at

	https://github.com/liubogithub/btrfs-work.git for-dave

Thanks,
liubo

Liu Bo (9):
  Btrfs: add 'inode' for extent map tracepoint
  Btrfs: add truncated_len for ordered extent tracepoints
  Btrfs: use down_read_nested to make lockdep silent
  Btrfs: fix lockdep warning about log_mutex
  Btrfs: fix truncate down when no_holes feature is enabled
  Btrfs: fix btrfs_ordered_update_i_size to update disk_i_size properly
  Btrfs: fix comment in btrfs_page_mkwrite
  Btrfs: clean up btrfs_ordered_update_i_size
  Btrfs: fix another race between truncate and lockless dio write

 fs/btrfs/extent-tree.c       |  3 ++-
 fs/btrfs/inode.c             | 43 +++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.c      | 42 ++++++++++++++++++++++++------------------
 fs/btrfs/tree-log.c          | 13 ++++++++++---
 include/trace/events/btrfs.h | 16 ++++++++++++----
 5 files changed, 83 insertions(+), 34 deletions(-)

-- 
2.5.5

