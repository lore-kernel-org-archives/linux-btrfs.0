Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47530 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbGMN7l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 09:59:41 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org, clm@fb.com
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] More btrfs bug fixes
Date: Sun, 12 Jul 2015 02:50:47 +0100
Message-Id: <1436665847-31883-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following changes for the kernel 4.2 release. All
these patches have been available in the mailing list for some time.

One of the patches is a fix for a regression in the delayed references
code that landed in 4.2-rc1. Two of them are for issues reported by users
on the list and IRC recently (which I've cc'ed for stable) and the final
one is just a missing update of an inode's on disk size after truncating
a file if the no_holes feature is enabled, which I found some time ago.

I have rebased them on top of your current integration-4.2 branch,
re-tested them and incorporated any tags people have added through the
mailing list (Reviewed-by, Acked-by).

Thanks.

The following changes since commit 9689457b5b0a2b69874c421a489d3fb50ca76b7b:

  Btrfs: fix wrong check for btrfs_force_chunk_alloc() (2015-07-01 17:17:22 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.2

for you to fetch changes up to cffc3374e567ef42954f3c7070b3fa83f20f9684:

  Btrfs: fix order by which delayed references are run (2015-07-11 22:36:44 +0100)

----------------------------------------------------------------
Filipe Manana (4):
      Btrfs: fix shrinking truncate when the no_holes feature is enabled
      Btrfs: fix memory leak in the extent_same ioctl
      Btrfs: fix list transaction->pending_ordered corruption
      Btrfs: fix order by which delayed references are run

 fs/btrfs/extent-tree.c | 13 +++++++++++++
 fs/btrfs/inode.c       |  5 ++---
 fs/btrfs/ioctl.c       |  4 +++-
 fs/btrfs/transaction.c |  4 ++--
 4 files changed, 20 insertions(+), 6 deletions(-)

-- 
2.1.3

