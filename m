From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fix for 2.6.33-rc
Date: Mon, 15 Feb 2010 20:03:34 -0500
Message-ID: <20100216010334.GA18738@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

This is a late regression fix for btrfs fallocated extents.  We're
updating the wrong slot in the btree and that can lead to the wrong data
in the file:

Linus, please pull the master branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Shaohua Li (1) commits (+4/-2):
    Btrfs: btrfs_mark_extent_written uses the wrong slot

Total: (1) commits

 fs/btrfs/file.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
