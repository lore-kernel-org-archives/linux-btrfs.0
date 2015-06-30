Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54035 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbbF3WUr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 18:20:47 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org, clm@fb.com
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs bug fixes
Date: Tue, 30 Jun 2015 23:20:31 +0100
Message-Id: <1435702831-25334-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following changes (or a subset at your will in case
they are too many or too large) for the kernel 4.2 release. All these
patches have been available in the mailing list for at least 2 weeks.

They are all bug fixes and deal with races, crashes, memory corruption,
hangs and data loss on fsync. No cleanups, refactorings or other cosmetic
changes that don't affect users, except for a change that updates a
comment added in a change that was already sent to Linus (but that can
hardly introduce any regression).

I have included 2 fixes from Liu related to error handling of direct IO
writes because not only they seem important to me, I also tested and
reviewed them. My recent patch for direct IO error handling (not included
in this pull request because it's too fresh) does not depend on Liu's
fixes, it's for a different error case (when we fail to submit the bios),
and can be tested/applied with or without his fixes.

Finally I have included a fix from Shilong that has been around since
April and didn't got any attention, despite being correct, trivial and
useful.

I have added Reviewed-By and Tested-by tags to all the patches that got
such tags from people through the mailing list. Some patches are also
tagged for stable.

I have rebased them on top of your current integration-4.2 branch and
re-tested them with xfstests, LTP and some custom tests. Some of these
fixes have new test cases for xfstest submitted recently as well (but
not yet merged as of today, only reviewed).

Thanks.

The following changes since commit 5a5003df98d5a7f6834227885b7c9728f767cc27:

  btrfs: delayed-ref: double free in btrfs_add_delayed_tree_ref() (2015-06-24 12:28:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.2

for you to fetch changes up to 9ac2b7cb4755cb3311bb7d1ccf0eb51d0e006fba:

  Btrfs: fix wrong check for btrfs_force_chunk_alloc() (2015-06-30 05:00:49 +0100)

----------------------------------------------------------------
Filipe Manana (7):
      Btrfs: fix a comment in inode.c:evict_inode_truncate_pages()
      Btrfs: fix race between balance and unused block group deletion
      Btrfs: use kmem_cache_free when freeing entry in inode cache
      Btrfs: fix race between caching kthread and returning inode to inode cache
      Btrfs: fix crash on close_ctree() if cleaner starts new transaction
      Btrfs: fix fsync data loss after append write
      Btrfs: fix fsync xattr loss in the fast fsync path

Liu Bo (2):
      Btrfs: fix hang when failing to submit bio of directIO
      Btrfs: fix warning of bytes_may_use

Shilong Wang (1):
      Btrfs: fix wrong check for btrfs_force_chunk_alloc()

 fs/btrfs/btrfs_inode.h |   2 ++
 fs/btrfs/ctree.h       |   1 +
 fs/btrfs/disk-io.c     |  41 ++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/extent-tree.c |   3 +++
 fs/btrfs/inode-map.c   |  17 ++++++++++++-----
 fs/btrfs/inode.c       |  24 ++++++++++++++++--------
 fs/btrfs/relocation.c  |   2 +-
 fs/btrfs/tree-log.c    | 118 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.c     |  48 +++++++++++++++++++++++++++++++++++++++++++-----
 9 files changed, 231 insertions(+), 25 deletions(-)

-- 
2.1.3

