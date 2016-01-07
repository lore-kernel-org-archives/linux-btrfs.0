Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbcAGOzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jan 2016 09:55:10 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs: cleanups for 4.5
Date: Thu,  7 Jan 2016 15:52:47 +0100
Message-Id: <cover.1452177907.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few more patches from the mailinglist, cleanups. Please pull to 4.5. Thanks.

----------------------------------------------------------------
The following changes since commit 4ef7675344d687a0ef5b0d7c0cee12da005870c0:

  Linux 4.4-rc6 (2015-12-20 16:06:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git misc-cleanups-4.5

for you to fetch changes up to a7ca42256d9fad572fb7f2c471514d7d3572b1db:

  btrfs: use list_for_each_entry* in backref.c (2016-01-07 14:42:46 +0100)

----------------------------------------------------------------
Alexandru Moise (3):
      btrfs: switch __btrfs_fs_incompat return type from int to bool
      btrfs: pass proper enum type to start_transaction()
      btrfs: zero out delayed node upon allocation

Byongho Lee (2):
      btrfs: remove unused inode argument from uncompress_inline()
      Btrfs: use linux/sizes.h to represent constants

David Sterba (1):
      btrfs: cleanup, remove stray return statements

Geliang Tang (3):
      btrfs: use list_for_each_entry* in check-integrity.c
      btrfs: use list_for_each_entry_safe in free-space-cache.c
      btrfs: use list_for_each_entry* in backref.c

 fs/btrfs/backref.c                |  23 ++---
 fs/btrfs/check-integrity.c        | 105 ++++++---------------
 fs/btrfs/ctree.c                  |   2 +-
 fs/btrfs/ctree.h                  |   7 +-
 fs/btrfs/delayed-inode.c          |   7 +-
 fs/btrfs/disk-io.c                |   3 +-
 fs/btrfs/disk-io.h                |   4 +-
 fs/btrfs/extent-tree.c            |  29 +++---
 fs/btrfs/extent_io.c              |   2 +-
 fs/btrfs/free-space-cache.c       |  24 ++---
 fs/btrfs/inode-map.c              |   2 +-
 fs/btrfs/inode.c                  |  28 +++---
 fs/btrfs/ioctl.c                  |  23 +++--
 fs/btrfs/locking.c                |   2 -
 fs/btrfs/raid56.c                 |   2 -
 fs/btrfs/scrub.c                  |   2 -
 fs/btrfs/send.h                   |   4 +-
 fs/btrfs/super.c                  |   2 +-
 fs/btrfs/tests/extent-io-tests.c  |  11 ++-
 fs/btrfs/tests/free-space-tests.c | 186 ++++++++++++++++----------------------
 fs/btrfs/tests/inode-tests.c      |   2 +-
 fs/btrfs/transaction.c            |  15 ++-
 fs/btrfs/volumes.c                |  17 ++--
 fs/btrfs/volumes.h                |   2 +-
 24 files changed, 197 insertions(+), 307 deletions(-)
