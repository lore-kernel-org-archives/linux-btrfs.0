From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 0/5] Btrfs: mount error handling fixes
Date: Wed,  9 Nov 2011 16:38:32 +0200
Message-ID: <1320849517-13172-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A bunch of fixes (memory leaks, NULL pointer dereferences and devices
hanging in busy state) to sanitize error handling during mount sequence.
This is on top of for-linus + slyfox's double-free fix.

Thanks,

		Ilya


Ilya Dryomov (5):
  Btrfs: fix memory leak in btrfs_parse_early_options()
  Btrfs: fix subvol_name leak on error in btrfs_mount()
  Btrfs: avoid null dereference and leaks when bailing from
    open_ctree()
  Btrfs: close devices on all error paths in open_ctree()
  Btrfs: rework error handling in btrfs_mount()

 fs/btrfs/disk-io.c |   42 ++++++++++++++++++------------------------
 fs/btrfs/super.c   |   47 +++++++++++++++++++++++++----------------------
 2 files changed, 43 insertions(+), 46 deletions(-)

-- 
1.7.6.3

