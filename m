Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751125AbdBXONH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 09:13:07 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs bug fixes and improvements for 4.11 (2nd retry)
Date: Fri, 24 Feb 2017 03:25:09 +0000
Message-Id: <1487906709-11147-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris, since my previous pull request (sent timely) was either missed
or not pulled for some reason I'm not aware of, here I send it again (with
one more patch included). The following is taken from the former pull
request:

"Please consider the following changes for the 4.11 merge window.
This time there is nothing particularly outstanding when compared to the
usual set of bug fixes. These are mostly fixes for send and the no-holes
feature introduced in 3.14. Test cases for fstests were sent for half of
these changes, with some already merged and two not yet merged."

This was rebased against your current for-linus-4.11 branch and re-tested.

Thanks.

The following changes since commit 6288d6eabc7505f42dda34a2c2962f91914be3a4:

  Btrfs: use the correct type when creating cow dio extent (2017-02-22 15:55:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.11

for you to fetch changes up to 263d3995c93c6020576f6c93506412a0b9d1e932:

  Btrfs: try harder to migrate items to left sibling before splitting a leaf (2017-02-24 00:39:44 +0000)

----------------------------------------------------------------
Filipe Manana (8):
      Btrfs: incremental send, do not delay rename when parent inode is new
      Btrfs: bulk delete checksum items in the same leaf
      Btrfs: do not create explicit holes when replaying log tree if NO_HOLES enabled
      Btrfs: fix assertion failure when freeing block groups at close_ctree()
      Btrfs: fix use-after-free due to wrong order of destroying work queues
      Btrfs: incremental send, fix unnecessary hole writes for sparse files
      Btrfs: fix data loss after truncate when using the no-holes feature
      Btrfs: try harder to migrate items to left sibling before splitting a leaf

Robbie Ko (3):
      Btrfs: send, fix failure to rename top level inode due to name collision
      Btrfs: incremental send, do not issue invalid rmdir operations
      Btrfs: fix leak of subvolume writers counter

 fs/btrfs/ctree.c       |   7 +++++++
 fs/btrfs/disk-io.c     |  15 ++++++++++-----
 fs/btrfs/extent-tree.c |   9 ++++++---
 fs/btrfs/file-item.c   |  28 +++++++++++++++++++++++++++-
 fs/btrfs/inode.c       |  29 ++++++++++++++---------------
 fs/btrfs/send.c        | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/tree-log.c    |   5 +++++
 7 files changed, 188 insertions(+), 30 deletions(-)

-- 
2.7.0.rc3

