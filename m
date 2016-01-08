Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36505 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240AbcAHLoQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jan 2016 06:44:16 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org, clm@fb.com
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] More btrfs bug fixes for 4.5
Date: Fri,  8 Jan 2016 11:43:51 +0000
Message-Id: <1452253431-29510-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris.

Please consider the following bug fixes for the 4.5 kernel release.
Just the usual set of bug fixes. One of these is tagged for stable and it
fixes a regression introduced in 4.3 that makes a filesystem unbootable
after a fitrim operation (recently reported by a few openSUSE users).
These patches were all previously sent to the mailing list as well as a
new test case for fstests that covers the regression with fitrim.

Thanks.

The following changes since commit 511711af91f21d80b27f18b569352d6896562828:

  btrfs: don't run delayed references while we are creating the free space tree (2015-12-30 07:52:35 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.5

for you to fetch changes up to 8cdc7c5b00d945a3c823fc4277af304abb9cb43d:

  Btrfs: fix fitrim discarding device area reserved for boot loader's use (2016-01-07 21:16:03 +0000)

----------------------------------------------------------------
Filipe Manana (6):
      Btrfs: fix race between free space endio workers and space cache writeout
      Btrfs: send, don't BUG_ON() when an empty symlink is found
      Btrfs: don't leave dangling dentry if symlink creation failed
      Btrfs: fix number of transaction units required to create symlink
      Btrfs: fix transaction handle leak on failure to create hard link
      Btrfs: fix fitrim discarding device area reserved for boot loader's use

 fs/btrfs/extent-tree.c | 19 +++++++++++++++++++
 fs/btrfs/inode.c       | 21 ++++++++++++++-------
 fs/btrfs/send.c        | 16 +++++++++++++++-
 fs/btrfs/volumes.c     | 20 ++++++++++----------
 4 files changed, 58 insertions(+), 18 deletions(-)

-- 
2.1.3

