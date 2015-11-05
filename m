Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49988 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031108AbbKELUp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Nov 2015 06:20:45 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes
Date: Thu,  5 Nov 2015 11:20:37 +0000
Message-Id: <1446722437-21605-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

please consider the following fixes for the 4.4 merge window (they were
all previously sent to the mailing list already).

One fixes a sleep inside atomic context issue, introduced by one patch
in the integration-4.4 branch. Another two fix races regarding waiting
for qgroup rescan worker to finish and a race between the qgroup rescan
worker and unmounting the filesystem (leading to crashes). The remaining
patch fixes an issue with partial direct IO writes, which has been
introduced in the 4.0 kernel, and results either in an assertion failure
(BUG_ON) when CONFIG_BTRFS_ASSERT=y or arithmetic underflow of an inode's
outstanding extents counter (used for proper space reservation) when
assertions are disabled.

Two test cases for fstests were sent recently to cover the issues regarding
the races and the direct IO partial write regression.

Thanks.

The following changes since commit 2959a32a858a2c44bbbce83d19c158d54cc5998a:

  Btrfs: fix hole punching when using the no-holes feature (2015-11-03 07:44:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.4

for you to fetch changes up to 3b2ba7b31d56c3d8f57cd5d32b8fb5101ab446e4:

  Btrfs: fix sleeping inside atomic context in qgroup rescan worker (2015-11-05 11:02:22 +0000)

----------------------------------------------------------------
Filipe Manana (3):
      Btrfs: fix extent accounting for partial direct IO writes
      Btrfs: fix race waiting for qgroup rescan worker
      Btrfs: fix sleeping inside atomic context in qgroup rescan worker

Justin Maggard (1):
      btrfs: qgroup: exit the rescan worker during umount

 fs/btrfs/disk-io.c |  3 +++
 fs/btrfs/inode.c   | 52 +++++++++++++++++++++++++++++++++++++---------------
 fs/btrfs/qgroup.c  | 13 +++++++------
 3 files changed, 47 insertions(+), 21 deletions(-)

-- 
2.1.3

