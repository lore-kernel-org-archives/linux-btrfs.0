Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbdAEPXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jan 2017 10:23:13 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs fixes for 4.10
Date: Thu,  5 Jan 2017 16:22:08 +0100
Message-Id: <cover.1483629310.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a collection of fixes (lockdep, delayed ref locking, dio). The
btrfs_uuid_tree_iterate return value fix has a visible impact so it's added to
the mix. Please pull.

The following changes since commit 2939e1a86f758b55cdba73e29397dd3d94df13bc:

  btrfs: limit async_work allocation and worker func duration (2016-12-13 11:01:30 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.10

for you to fetch changes up to 3dda13a8ad787f3d4c4f18c8c05f8eebc7ea135a:

  Merge branch 'misc-4.10' into for-chris-4.10-20170104 (2017-01-04 11:42:16 +0100)

----------------------------------------------------------------
David Sterba (1):
      Merge branch 'misc-4.10' into for-chris-4.10-20170104

Jeff Mahoney (2):
      btrfs: fix error handling when run_delayed_extent_op fails
      btrfs: fix locking when we put back a delayed ref that's too new

Liu Bo (3):
      Btrfs: use down_read_nested to make lockdep silent
      Btrfs: fix lockdep warning about log_mutex
      Btrfs: adjust outstanding_extents counter properly when dio write is split

Pan Bian (1):
      btrfs: return the actual error value from  from btrfs_uuid_tree_iterate

 fs/btrfs/extent-tree.c |  8 ++++++--
 fs/btrfs/inode.c       | 11 +++++++++--
 fs/btrfs/tree-log.c    | 13 ++++++++++---
 fs/btrfs/uuid-tree.c   |  4 +---
 4 files changed, 26 insertions(+), 10 deletions(-)
