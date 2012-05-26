Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:56278 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab2EZK7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:51 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 00/15] Btrfs: tree modification log
Date: Sat, 26 May 2012 12:59:34 +0200
Message-Id: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris: Please pull

	git://git.jan-o-sch.net/btrfs-unstable for-chris

for 3.5, it's a major improvement for the backref resolver and a good
base to build qgroups and "btrfs send" onto. And, besides all other, its
implications on existing code outside backref.c are very small, mostly
added lines with no effect outside the backref resolver.

This patch set is to provide reliable backref resolving on busy trees.
The previous attempts to block certain tree modifications while we're
resolving backrefs all ended up in (dead-) locking nightmares. What we
now do is we record all the changes we make to fs trees while backref
resolving is in progress into a tree modification log. During backref
resolving we then merge the current state of the tree with the recorded
modifications to get a consistent previous state of the tree.

The first three commits are plain bug fixes, but the tree mod log
cannot function without them. So they're included in this patch set.
To only these three fixes, you can pull

	git://git.jan-o-sch.net/btrfs-unstable 3.5-fixes

For the whole tree modification log, pull

	git://git.jan-o-sch.net/btrfs-unstable tree-mod-log-v2

The tree-mod-log-v2 head is a stable alias for "for-chris".

Both branches are based on the current for-linus branch from Chris'
repository. Checked with xfstests (fails 254 273 275, which i claim has
nothing to do with this patch set) and hammered on the filesystem with
fs_mark while resolving backrefs in a loop.

I removed the qgroups patch series still contained in v1 because I
realized that the fs_mark tests I was doing weren't sufficient. When
testing qgroups with fsstress only for a few seconds, the accounting
breaks. Nothing really bad happens, but quota patches that don't get
quotas right are of litte use. A new qgroup patch set might come out
soon, but it won't make it into 3.5. There's a branch in my git repo
called tree-mod-log-quota-v1+fixes holding the current qgroup state.

Test it, break it, report it :-)

-Jan

--
Changes v1->v2:
- qgroups patches removed
- ulist realloc bugfix added (reported by Alexander Block)
- btrfs_find_parent_nodes bugfix (reported by Alexander Block)
- various smaller bugs in the v1 patch set fixed (reported by Alexander
  Block, Tsutomu Itoh and myself)
--

Jan Schmidt (15):
  Btrfs: ulist realloc bugfix
  Btrfs: bugfix in btrfs_find_parent_nodes
  Btrfs: bugfix: ignore the wrong key for indirect tree block backrefs
  Btrfs: look into the extent during find_all_leafs
  Btrfs: don't set for_cow parameter for tree block functions
  Btrfs: move struct seq_list to ctree.h
  Btrfs: dummy extent buffers for tree mod log
  Btrfs: add tree mod log to fs_info
  Btrfs: add tree modification log functions
  Btrfs: put all block modifications into the tree mod log
  Btrfs: add del_ptr and insert_ptr modifications to the tree mod log
  Btrfs: add btrfs_search_old_slot
  Btrfs: use the tree modification log for backref resolving
  Btrfs: fs_info variable for join_transaction
  Btrfs: tree mod log sanity checks in join_transaction

 fs/btrfs/backref.c     |  465 +++++++++++++++++++---------
 fs/btrfs/backref.h     |    3 +-
 fs/btrfs/ctree.c       |  831 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/ctree.h       |   27 ++-
 fs/btrfs/delayed-ref.h |    5 -
 fs/btrfs/disk-io.c     |    7 +-
 fs/btrfs/extent-tree.c |   10 +-
 fs/btrfs/extent_io.c   |   80 +++++-
 fs/btrfs/extent_io.h   |    3 +
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/transaction.c |   46 ++-
 fs/btrfs/ulist.c       |   23 +-
 fs/btrfs/ulist.h       |    9 +-
 13 files changed, 1286 insertions(+), 225 deletions(-)

-- 
1.7.3.4

