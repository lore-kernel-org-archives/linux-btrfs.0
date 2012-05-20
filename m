Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46285 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab2ETQGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:37 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 00/24] Btrfs: tree modification log and qgroup patch set
Date: Sun, 20 May 2012 18:06:11 +0200
Message-Id: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a combination of three things:

The first commit fixes a false assumption concerning indirect tree block
backrefs. That one should definitely go into 3.5, thanks to Alexander
Block for finding and testing it.

Commit 2 to 12 provide reliable backref resolving on busy trees. The
previous attempts to block certain tree modifications while we're
resolving backrefs all ended up in (dead-) locking nightmares. What we
now do is we record all the changes we make to fs trees while backref
resolving is in progress into a tree modification log. During backref
resolving we then merge the current state of the tree with the recorded
modifications to get a consistent previous state of the tree. I'd like
to see this in 3.5, too.

Commit 13 to 24 finally add quota groups. This is Arne Jansen's patch
set sent last October [1] rebased on top of the reliable backref
resolver. See his cover letter and [2] for background and usage
information on qgroups. Would be nice if that went into 3.5 as well.

All three stages can be pulled from my git repository, for patch 1 pull:

	git://git.jan-o-sch.net/btrfs-unstable backref-bugfix

For patches 1 to 12 pull:

	git://git.jan-o-sch.net/btrfs-unstable tree-mod-log-done

For patches 1 to 24 pull:

	git://git.jan-o-sch.net/btrfs-unstable tree-mod-log-quota

All these branches are based on the current for-linus branch from Chris'
repository. Checked with xfstests (fails 254 273 275, which i claim has
nothing to do with this patch set) and hammered on the filesystem with
fs_mark while resolving backrefs in a loop. Qgroup functionality was
tested with a private test we might turn into an xfstest soon.

Test it, break it, report it :-)

-Jan

Arne Jansen (12):
  Btrfs: qgroup on-disk format
  Btrfs: add helper for tree enumeration
  Btrfs: check the root passed to btrfs_end_transaction
  Btrfs: added helper to create new trees
  Btrfs: qgroup state and initialization
  Btrfs: Test code to change the order of delayed-ref processing
  Btrfs: qgroup implementation and prototypes
  Btrfs: quota tree support and startup
  Btrfs: hooks for qgroup to record delayed refs
  Btrfs: hooks to reserve qgroup space
  Btrfs: add qgroup ioctls
  Btrfs: add qgroup inheritance

Jan Schmidt (12):
  Btrfs: bugfix: ignore the wrong key for indirect tree block backrefs
  Btrfs: look into the extent during find_all_leafs
  Btrfs: don't set for_cow parameter for tree block functions
  Btrfs: move struct seq_list to ctree.h
  Btrfs: dummy extent buffers for tree mod log
  Btrfs: add tree mod log to fs_info
  Btrfs: add tree modification log functions
  Btrfs: put all modifications into the tree mod log
  Btrfs: add btrfs_search_old_slot
  Btrfs: use the tree modification log for backref resolving
  Btrfs: fs_info variable for join_transaction
  Btrfs: tree mod log sanity checks in join_transaction

 fs/btrfs/Makefile      |    2 +-
 fs/btrfs/backref.c     |  424 +++++++++++---
 fs/btrfs/backref.h     |    3 +-
 fs/btrfs/ctree.c       |  927 +++++++++++++++++++++++++++--
 fs/btrfs/ctree.h       |  231 ++++++++-
 fs/btrfs/delayed-ref.c |   29 +-
 fs/btrfs/delayed-ref.h |    5 -
 fs/btrfs/disk-io.c     |  139 ++++-
 fs/btrfs/disk-io.h     |    5 +
 fs/btrfs/extent-tree.c |   73 +++-
 fs/btrfs/extent_io.c   |   73 +++-
 fs/btrfs/extent_io.h   |    3 +
 fs/btrfs/ioctl.c       |  246 +++++++-
 fs/btrfs/ioctl.h       |   62 ++-
 fs/btrfs/qgroup.c      | 1531 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c |   83 ++-
 fs/btrfs/transaction.h |    8 +
 17 files changed, 3620 insertions(+), 224 deletions(-)
 create mode 100644 fs/btrfs/qgroup.c

-- 
1.7.3.4

