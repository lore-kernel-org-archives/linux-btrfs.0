Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54558 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbcHCKdX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Aug 2016 06:33:23 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes for 4.8
Date: Wed,  3 Aug 2016 11:31:17 +0100
Message-Id: <1470220277-28026-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following small set of fixes for the 4.8 kernel.
These are mostly send fixes, some of them reported and sent by Robbie Ko a
long time ago, which I reviewed, updated (specially the change logs) and
tested. All of these already have test cases in xfstests. The rest are
just some fsync related fixes and a cleanup. These have all been sent to
the mailing list before and were rebased against your 'next' branch.

Thanks.

The following changes since commit 8b8b08cbfb9021af4b54b4175fc4c51d655aac8c:

  Btrfs: fix delalloc accounting after copy_from_user faults (2016-07-21 04:03:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.8

for you to fetch changes up to e6571499336e10f93a77c51a35fd1a96828eea71:

  Btrfs: remove unused function btrfs_add_delayed_qgroup_reserve() (2016-08-03 11:02:51 +0100)

----------------------------------------------------------------
Filipe Manana (8):
      Btrfs: add missing check for writeback errors on fsync
      Btrfs: send, add missing error check for calls to path_loop()
      Btrfs: incremental send, fix invalid paths for rename operations
      Btrfs: send, avoid incorrect leaf accesses when sending utimes operations
      Btrfs: send, don't bug on inconsistent snapshots
      Btrfs: be more precise on errors when getting an inode from disk
      Btrfs: improve performance on fsync against new inode after rename/unlink
      Btrfs: remove unused function btrfs_add_delayed_qgroup_reserve()

Robbie Ko (4):
      Btrfs: send, fix failure to move directories with the same name around
      Btrfs: incremental send, fix premature rmdir operations
      Btrfs: send, fix warning due to late freeing of orphan_dir_info structures
      Btrfs: send, fix invalid leaf accesses due to incorrect utimes operations

 fs/btrfs/delayed-ref.c |  27 ---------------------
 fs/btrfs/delayed-ref.h |   3 ---
 fs/btrfs/file.c        |   8 +++++++
 fs/btrfs/inode.c       |  46 ++++++++++++++++++++++++++++--------
 fs/btrfs/send.c        | 173 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/tree-log.c    |  85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 6 files changed, 283 insertions(+), 59 deletions(-)

-- 
2.7.0.rc3

