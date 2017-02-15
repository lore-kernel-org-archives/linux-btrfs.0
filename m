Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752997AbdBPLEP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 06:04:15 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes and improvements for 4.11
Date: Wed, 15 Feb 2017 21:01:34 +0000
Message-Id: <1487192494-9599-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris.

Please consider the following changes for the 4.11 merge window.
This time there is nothing particularly outstanding when compared to the
usual set of bug fixes. These are mostly fixes for send and the no-holes
feature introduced in 3.14. Test cases for fstests were sent for half of
these changes, with some already merged and two not yet merged.

Thanks.

The following changes since commit 6e78b3f7a193546b1c00a6d084596e774f147169:

  Btrfs: fix btrfs_decompress_buf2page() (2017-02-10 19:11:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.11

for you to fetch changes up to 0a511ba79d7152b5b3b6b54573511fbdeb014abb:

  Btrfs: fix data loss after truncate when using the no-holes feature (2017-02-15 20:16:19 +0000)

----------------------------------------------------------------
Filipe Manana (7):
      Btrfs: incremental send, do not delay rename when parent inode is new
      Btrfs: bulk delete checksum items in the same leaf
      Btrfs: do not create explicit holes when replaying log tree if NO_HOLES enabled
      Btrfs: fix assertion failure when freeing block groups at close_ctree()
      Btrfs: fix use-after-free due to wrong order of destroying work queues
      Btrfs: incremental send, fix unnecessary hole writes for sparse files
      Btrfs: fix data loss after truncate when using the no-holes feature

Robbie Ko (3):
      Btrfs: send, fix failure to rename top level inode due to name collision
      Btrfs: incremental send, do not issue invalid rmdir operations
      Btrfs: fix leak of subvolume writers counter

 fs/btrfs/disk-io.c     |  15 ++++++++++-----
 fs/btrfs/extent-tree.c |   9 ++++++---
 fs/btrfs/file-item.c   |  28 +++++++++++++++++++++++++++-
 fs/btrfs/inode.c       |  29 ++++++++++++++---------------
 fs/btrfs/send.c        | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/tree-log.c    |   5 +++++
 6 files changed, 181 insertions(+), 30 deletions(-)

-- 
2.7.0.rc3

