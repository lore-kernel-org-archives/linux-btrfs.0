From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 0/8] Restriper fixes
Date: Tue, 27 Mar 2012 18:04:20 +0300
Message-ID: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

The main one here is the improvement to btrfs_can_relocate(), which is
now a tiny bit smarter and does not return ENOSPC when there's plenty of
unallocated space for target chunks.  This, in addition to my patch
which disables silent profile "upgrades", should lower a number of
corner cases in profile changing.

The rest are a bunch of cleanups and some minor fixes.

Please pull from

git://github.com/idryomov/btrfs-unstable.git for-chris

top commit 213e64da90d14537cd63f7090d6c4d1fcc75d9f8

Thanks,

		Ilya


Ilya Dryomov (8):
  Btrfs: add wrappers for working with alloc profiles
  Btrfs: make profile_is_valid() check more strict
  Btrfs: move alloc_profile_is_valid() to volumes.c
  Btrfs: add get_restripe_target() helper
  Btrfs: add __get_block_group_index() helper
  Btrfs: improve the logic in btrfs_can_relocate()
  Btrfs: validate target profiles only if we are going to use them
  Btrfs: allow dup for data chunks in mixed mode

 fs/btrfs/ctree.h       |   33 +++++------
 fs/btrfs/extent-tree.c |  158 ++++++++++++++++++++++++++----------------------
 fs/btrfs/volumes.c     |   88 ++++++++++++++++-----------
 3 files changed, 152 insertions(+), 127 deletions(-)

-- 
1.7.9.1

