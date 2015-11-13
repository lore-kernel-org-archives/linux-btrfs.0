Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35800 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbKNJ52 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 04:57:28 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 0/2] Btrfs: fixes for an ENOSPC issue that left a fs unusable
Date: Fri, 13 Nov 2015 23:57:15 +0000
Message-Id: <1447459037-11422-1-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1447428032-1872-1-git-send-email-fdmanana@kernel.org>
References: <1447428032-1872-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The following pair of changes fix an issue observed in a production
environment where any file operations done by a package manager failed
with ENOSPC. Forcing a commit of the current transaction (through "sync")
didn't help, a balance operation with the filters -dusage=0 didn't help
either and the issue persisted even after rebooting the machine. There
were many data blocks groups that were unused, but they weren't getting
deleted by the cleaner kthread because whenever it tried to start a
transaction to delete a block group it got -ENOSPC error, which it silently
ignores (as it does for any other error).

So these just make sure we fallback to use the global reserve, if -ENOSPC
is encountered through the standard allocation path, to delete block groups
as we do already for inode unlink operations. Another issue fixed is hitting
a BUG_ON() when removing a block group due to -ENSPC failure when creating
the orphan item for its free space cache inode. This second issue has
been reported by a few users in the mailing list and bugzilla (for example
at http://www.spinics.net/lists/linux-btrfs/msg46070.html).

These changes are also available at:
http://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/log/?h=integration-4.4

Thanks.

Changes in v2:

Updated the second patch to account for the space required to remove the
device extents from the device tree (was previously ignored).


Filipe Manana (2):
  Btrfs: use global reserve when deleting unused block group after
    ENOSPC
  Btrfs: fix the number of transaction units needed to remove a block
    group

 fs/btrfs/ctree.h       |  3 +++
 fs/btrfs/extent-tree.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/inode.c       | 24 +-----------------------
 fs/btrfs/transaction.c | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.h |  4 ++++
 fs/btrfs/volumes.c     |  3 ++-
 6 files changed, 85 insertions(+), 26 deletions(-)

-- 
2.1.3

