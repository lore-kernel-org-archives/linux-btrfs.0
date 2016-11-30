Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758533AbcK3Rgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 12:36:46 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes for 4.10
Date: Wed, 30 Nov 2016 17:36:14 +0000
Message-Id: <1480527374-20998-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Here follows a small list of fixes a couple cleanups for the 4.10 merge
window. It contains all the patches from the previous pull request (which
got unanswered nor were the changes pulled yet apparently). The most important
change is still the fix for the extent tree corruption that happens due to
balance when qgroups are enabled (a regression introduced in 4.7 by a fix for
a regression from the last qgroups rework). This has been hitting SLE and
openSUSE users and QA very badly, where transactions keep getting aborted when
running delayed references leaving the root filesystem in RO mode and nearly
unusable.
There are fixes here that allow us to run xfstests again with the integrity
checker enabled, which has been impossible since 4.8 (apparently I'm the
only one running xfstests with the integrity checker enabled, which is useful
to validate dirtied leafs, like checking if there are keys out of order, etc).
The rest are just some trivial fixes, most of them tagged for stable, and two
cleanups.

Thanks.

The following changes since commit e3597e6090ddf40904dce6d0a5a404e2c490cac6:

  Merge branch 'for-4.9-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.9 (2016-11-01 12:54:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.10

for you to fetch changes up to 2a7bf53f577e49c43de4ffa7776056de26db65d9:

  Btrfs: fix tree search logic when replaying directory entry deletes (2016-11-30 16:56:12 +0000)

----------------------------------------------------------------
Filipe Manana (5):
      Btrfs: fix relocation incorrectly dropping data references
      Btrfs: remove unused code when creating and merging reloc trees
      Btrfs: remove rb_node field from the delayed ref node structure
      Btrfs: fix emptiness check for dirtied extent buffers at check_leaf()
      Btrfs: fix qgroup rescan worker initialization

Liu Bo (1):
      Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty

Robbie Ko (3):
      Btrfs: fix enospc in hole punching
      Btrfs: fix deadlock caused by fsync when logging directory entries
      Btrfs: fix tree search logic when replaying directory entry deletes

 fs/btrfs/delayed-ref.h |  6 ------
 fs/btrfs/disk-io.c     | 23 +++++++++++++++++++----
 fs/btrfs/file.c        |  4 ++--
 fs/btrfs/qgroup.c      |  5 +----
 fs/btrfs/relocation.c  | 34 ++++++++++++----------------------
 fs/btrfs/tree-log.c    |  7 +++----
 6 files changed, 37 insertions(+), 42 deletions(-)

-- 
2.7.0.rc3

