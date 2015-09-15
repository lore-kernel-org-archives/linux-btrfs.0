Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33739 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbbIOKkC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 06:40:02 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs bug fixes
Date: Tue, 15 Sep 2015 03:22:58 +0100
Message-Id: <1442283778-2342-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following fixes for the 4.3 kernel release candidates.
One of them addresses a deadlock introduced in 4.3, another is for a false
enospc condition (which I introduced in a 4.2 commit) that can happen either
on empty filesystems or filesystems with files having only inlined extents
after mounting with "-o nospace_cache", a fix for read corruption of
compressed and shared (cloned, deduped) extents that has been present
possibly since the compression feature exists or since the clone/dedup
ioctls exist, and finally, from Jeff, a fix for a long standing null
pointer dereference during inode eviction that some users were running
into very often.

They are all short and simple, the read corruption one is bigger only
because it adds a big fat comment, and just like Jeff's fix, it was
tagged for backporting to stable releases too.

I included any Reviewed-by tags people added through the mailing list and
two of these fixes have corresponding test cases for fstests that were
submitted, along with the respective fixes, to the mailing list.

Thanks.

The following changes since commit 527afb4493c2892ce89fb74648e72a30b68ba120:

  Btrfs: cleanup: remove unnecessary check before btrfs_free_path is called (2015-08-31 11:46:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.3

for you to fetch changes up to a30e577c96f59b1e1678ea5462432b09bf7d5cbc:

  btrfs: skip waiting on ordered range for special files (2015-09-15 02:21:08 +0100)

----------------------------------------------------------------
Filipe Manana (3):
      Btrfs: don't initialize a space info as full to prevent ENOSPC
      Btrfs: remove unnecessary locking of cleaner_mutex to avoid deadlock
      Btrfs: fix read corruption of compressed and shared extents

Jeff Mahoney (1):
      btrfs: skip waiting on ordered range for special files

 fs/btrfs/disk-io.c     |  2 --
 fs/btrfs/extent-tree.c |  5 +----
 fs/btrfs/extent_io.c   | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/inode.c       |  3 ++-
 fs/btrfs/super.c       |  2 --
 5 files changed, 60 insertions(+), 17 deletions(-)

-- 
2.1.3

