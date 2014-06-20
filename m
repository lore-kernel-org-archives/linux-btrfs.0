Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965558AbaFTLBw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 07:01:52 -0400
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PULL] [PATCH 0/8] Cleanups, 3.16 or later
Date: Fri, 20 Jun 2014 13:01:49 +0200
Message-Id: <cover.1403260619.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

this is a set of whole-directory changes that have low impact on stability
(xfstests passed), but touch almost all files aiming for simpler code.

I did not catch the merge window train, so I'm leaving it to your consideration
if you add it to the upcomming pull request(s).

I'm sending this as a pull request combined with patches to mailinglist.

Top commit cbe260e207c57843c1dcd550f9adbab7507945c6
based on 8408c716d7a4ddd5954ce33f53a7d3cd2876cf65 (current for-linus)

Available in the git repository at:

  git://repo.or.cz/linux-2.6/btrfs-unstable.git cleanups-for-3.16

Thanks.

David Sterba (8):
  btrfs: remove obsolete comment in btrfs_clean_one_deleted_snapshot
  btrfs: clenaup: don't call btrfs_release_path before free_path
  btrfs: cleanup ino cache members of btrfs_root
  btrfs: make close_ctree return void
  btrfs: kill the key type accessor helpers
  btrfs: use nodesize everywhere, kill leafsize
  btrfs: clean away stripe_align helper
  btrfs: use DIV_ROUND_UP instead of open-coded variants

 fs/btrfs/backref.c          |   12 +++---
 fs/btrfs/check-integrity.c  |   16 +--------
 fs/btrfs/compression.c      |   10 ++---
 fs/btrfs/ctree.c            |   18 +++++-----
 fs/btrfs/ctree.h            |   31 +++++-----------
 fs/btrfs/delayed-inode.c    |    8 ++--
 fs/btrfs/dir-item.c         |   12 +++---
 fs/btrfs/disk-io.c          |   84 +++++++++++++++++++------------------------
 fs/btrfs/disk-io.h          |    2 +-
 fs/btrfs/export.c           |    4 +-
 fs/btrfs/extent-tree.c      |   53 +++++++++++----------------
 fs/btrfs/extent_io.c        |    2 +-
 fs/btrfs/file-item.c        |   12 +++---
 fs/btrfs/file.c             |   25 ++++++-------
 fs/btrfs/free-space-cache.c |   17 ++++-----
 fs/btrfs/inode-item.c       |   12 +++---
 fs/btrfs/inode-map.c        |   68 +++++++++++++++++-----------------
 fs/btrfs/inode.c            |   28 +++++++-------
 fs/btrfs/ioctl.c            |   23 ++++++------
 fs/btrfs/lzo.c              |    3 +-
 fs/btrfs/orphan.c           |    4 +-
 fs/btrfs/print-tree.c       |    4 +-
 fs/btrfs/qgroup.c           |    6 +--
 fs/btrfs/raid56.c           |    8 ++--
 fs/btrfs/reada.c            |    2 +-
 fs/btrfs/relocation.c       |   22 +++++------
 fs/btrfs/scrub.c            |   19 +---------
 fs/btrfs/super.c            |    8 +----
 fs/btrfs/transaction.c      |    7 +---
 fs/btrfs/tree-log.c         |    8 ++--
 fs/btrfs/volumes.c          |    4 +-
 fs/btrfs/xattr.c            |    4 +-
 fs/btrfs/zlib.c             |    3 +-
 33 files changed, 228 insertions(+), 311 deletions(-)

-- 
1.7.9

