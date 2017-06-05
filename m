Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40415 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751112AbdFERtC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Jun 2017 13:49:02 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs fixes for 4.12
Date: Mon,  5 Jun 2017 19:47:55 +0200
Message-Id: <cover.1496682964.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following assorted fixes to 4.12. Thanks.


The following changes since commit 9bcaaea7418d09691f1ffab5c49aacafe3eef9d0:

  btrfs: fix the gfp_mask for the reada_zones radix tree (2017-05-04 16:56:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.12

for you to fetch changes up to 2eec59665d545ce443184b9c7a32a65b4dde6d4c:

  Btrfs: clear EXTENT_DEFRAG bits in finish_ordered_io (2017-06-01 17:00:11 +0200)

----------------------------------------------------------------
Colin Ian King (1):
      btrfs: fix incorrect error return ret being passed to mapping_set_error

David Sterba (1):
      btrfs: use correct types for page indices in btrfs_page_exists_in_range

Jan Kara (1):
      btrfs: Make flush bios explicitely sync

Jeff Mahoney (2):
      btrfs: fix memory leak in update_space_info failure path
      btrfs: fix race with relocation recovery and fs_root setup

Liu Bo (2):
      Btrfs: skip commit transaction if we don't have enough pinned bytes
      Btrfs: clear EXTENT_DEFRAG bits in finish_ordered_io

Qu Wenruo (1):
      btrfs: fiemap: Cache and merge fiemap extent before submit it to user

Su Yue (1):
      btrfs: tree-log.c: Wrong printk information about namelen

 fs/btrfs/dir-item.c    |   2 +-
 fs/btrfs/disk-io.c     |  10 ++--
 fs/btrfs/extent-tree.c |   9 ++--
 fs/btrfs/extent_io.c   | 126 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/inode.c       |   6 +--
 5 files changed, 138 insertions(+), 15 deletions(-)
