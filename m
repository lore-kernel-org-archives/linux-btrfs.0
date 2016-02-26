Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36616 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbcBZNWM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 08:22:12 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes for 4.6
Date: Fri, 26 Feb 2016 13:22:00 +0000
Message-Id: <1456492920-18169-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following changes for the 4.6 kernel merge window.
Nothing particularly outstanding, just the usual sort of bug fixes.
These have all been sent to the mailing list before (I just changed in
my repo the changelog for the deadlock fix patch to fix a typo pointed
by Liu Bo, other than that it's exactly the same as the version sent to
the mailing list). Some xfstests for these were already merged upstream
and one more sent earlier this week (for the listxattrs issue) that is
not yet merged.

Thanks.

The following changes since commit 0fcb760afa6103419800674e22fb7f4de1f9670b:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.6 (2016-02-24 10:21:44 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.6

for you to fetch changes up to 97c86c11a5cb9839609a9df195e998c3312e68b0:

  Btrfs: do not collect ordered extents when logging that inode exists (2016-02-26 04:28:15 +0000)

----------------------------------------------------------------
Filipe Manana (7):
      Btrfs: fix unreplayable log after snapshot delete + parent dir fsync
      Btrfs: fix file loss on log replay after renaming a file and fsync
      Btrfs: fix extent_same allowing destination offset beyond i_size
      Btrfs: fix deadlock between direct IO reads and buffered writes
      Btrfs: fix listxattrs not listing all xattrs packed in the same item
      Btrfs: fix race when checking if we can skip fsync'ing an inode
      Btrfs: do not collect ordered extents when logging that inode exists

 fs/btrfs/file.c     |  9 +++++----
 fs/btrfs/inode.c    | 25 +++++++++++++++++++++++--
 fs/btrfs/ioctl.c    |  6 ++++++
 fs/btrfs/tree-log.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/tree-log.h |  2 ++
 fs/btrfs/xattr.c    | 65 +++++++++++++++++++++++++++++++++++++++++------------------------
 6 files changed, 165 insertions(+), 41 deletions(-)

-- 
2.7.0.rc3

