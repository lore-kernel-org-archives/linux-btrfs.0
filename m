From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.33-git
Date: Tue, 19 Jan 2010 21:42:46 -0500
Message-ID: <20100120024246.GA3001@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755055Ab0ATCoK@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The master branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Is against 2.6.32 but pulls cleanly into Linus' current git.  These are
various bug fixes, nothing stands out but some are commonly hit.

The readdir fix brings btrfs in line with what xfs does, limiting the
max directory entry offset for proper results in both 32 bit and 64 bit
environments.

For everyone waiting for Josef's snapshot-rollback work for snapshot
protected upgrades, I'm collecting those into a .34 testing branch along
with other development work.  It will be available this week.

Chris Mason (1) commits (+7/-5):
    Btrfs: deal with NULL acl sent to btrfs_set_acl

Jan Engelhardt (1) commits (+5/-1):
    btrfs: fix missing last-entry in readdir(3)

Jiri Slaby (1) commits (+6/-2):
    Btrfs, fix memory leaks in error paths

Josef Bacik (2) commits (+25/-13):
    Btrfs: fix regression in orphan cleanup (+6/-0)
    Btrfs: fix possible panic on unmount (+19/-13)

Zheng Yan (2) commits (+82/-20):
    Btrfs: align offsets for btrfs_ordered_update_i_size (+2/-0)
    Btrfs: Fix race in btrfs_mark_extent_written (+80/-20)

Total: (7) commits

 fs/btrfs/acl.c          |   12 +++--
 fs/btrfs/extent-tree.c  |   32 +++++++++------
 fs/btrfs/file.c         |  100 ++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/inode.c        |   12 +++++
 fs/btrfs/ordered-data.c |    2 
 fs/btrfs/relocation.c   |    4 +
 fs/btrfs/volumes.c      |    4 +
 7 files changed, 125 insertions(+), 41 deletions(-)
