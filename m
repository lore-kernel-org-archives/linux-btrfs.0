Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbcFQRBk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 13:01:40 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs fixes for 4.7-rc4
Date: Fri, 17 Jun 2016 19:02:09 +0200
Message-Id: <cover.1466182369.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there are a few fixes of things introduced during this dev cycle, the
supreblock validation was too eager and refuses to mount valid fileystems. We
need to fix in on the progs side but for the time being the wrong stripesize
value (4096) must be accepted. Other than that a few more bugfixes. Thanks.

The following changes since commit 719da39a61173c849f70656ed1a302e4b6deaa5b:

  Merge branch 'misc-fixes-4.7' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.7 (2016-06-08 14:36:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris

for you to fetch changes up to dd5c93111dc9d26e038ac437f7a403d617e82c62:

  Btrfs: btrfs_check_super_valid: Allow 4096 as stripesize (2016-06-17 18:32:49 +0200)

----------------------------------------------------------------
Chandan Rajendra (1):
      Btrfs: btrfs_check_super_valid: Allow 4096 as stripesize

David Sterba (2):
      btrfs: use new error message helper in qgroup_account_snapshot
      btrfs: remove build fixup for qgroup_account_snapshot

Heinrich Schuchardt (1):
      btrfs: Use correct format specifier

Jeff Mahoney (1):
      btrfs: account for non-CoW'd blocks in btrfs_abort_transaction

Josef Bacik (1):
      Btrfs: don't BUG_ON() in btrfs_orphan_add

Liu Bo (1):
      Btrfs: check if extent buffer is aligned to sectorsize

Zygo Blaxell (1):
      btrfs: avoid blocking open_ctree from cleaner_kthread

 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/ctree.c           |  7 ++++++-
 fs/btrfs/disk-io.c         | 36 ++++++++++++++++--------------------
 fs/btrfs/extent-tree.c     | 12 +++++++-----
 fs/btrfs/extent_io.c       | 15 ++++++++++++---
 fs/btrfs/inode.c           | 11 ++++++++++-
 fs/btrfs/super.c           |  4 +++-
 fs/btrfs/transaction.c     |  7 +------
 fs/btrfs/transaction.h     |  2 +-
 fs/btrfs/tree-log.c        |  4 ++--
 fs/btrfs/volumes.c         |  4 ++--
 11 files changed, 61 insertions(+), 43 deletions(-)
