From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 0/3] Btrfs-progs: fix 'subvol get-default' command
Date: Mon, 12 Mar 2012 20:05:44 +0200
Message-ID: <1331575547-5796-1-git-send-email-idryomov@gmail.com>
Cc: idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs subvol get-default' has been broken for a while, fix it.  Patches
1 and 2 are straightforward cleanups in that area, patch 3 fixes the
problem.

Thanks,

		Ilya


Ilya Dryomov (3):
  Btrfs-progs: nuke redundant zeroing in __list_subvol_search()
  Btrfs-progs: refactor resolve_root() function a bit
  Btrfs-progs: bring 'subvol get-default' back in

 btrfs-list.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++++---------
 ctree.h      |    2 +
 2 files changed, 92 insertions(+), 16 deletions(-)

-- 
1.7.9.1

