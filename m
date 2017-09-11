Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53331 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750789AbdIKGgU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 02:36:20 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 0/7] Mkfs: Rework --rootdir to a more generic behavior
Date: Mon, 11 Sep 2017 15:36:05 +0900
Message-Id: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs --rootdir provides user a method to generate btrfs with
pre-written content while without the need of root privilege to mount
the fs.

However the code is quite old and doesn't get much review or test.
This makes some strange behavior, from customized chunk allocation
(which uses the reserved 0~1M device space) to variant BUG_ON caused by
ENOSPC or EPERM.

The reworked --rootdir will be based on traditional mkfs, everything is
processed after traditional mkfs, so nothing is customized.

The result will be an equivalent of mkfs, mount, cp, umount.
(If btrfs-progs chunk/extent allocator acts as the same as kernel)

And, add extra explanation for --rootdir, since the old implement
introduced a confusing behavior to limit the filesystem size.

Patch 1 is just a refactor I found during coding.
Patch 2 fixes a bug that will cause BUG_ON if modifying the first DATA
chunk after cleanup_temp_chunks().
Patch 3 is the rework.
Patch 4~5 fixes extra BUG_ON() caused by --rootdir in different error
path.
Patch 6 will add extra explanation for man page.

Qu Wenruo (7):
  btrfs-progs: Refactor find_next_chunk() to get rid of parameter root
    and objectid
  btrfs-progs: Fix one-byte overlap bug in free_block_group_cache
  btrfs-progs: mkfs: Rework rootdir option to avoid custom chunk layout
  btrfs-progs: mkfs: Update allocation info before verbose output
  btrfs-progs: Avoid BUG_ON for chunk allocation when ENOSPC happens
  btrfs-progs: mkfs: Workaround BUG_ON caused by rootdir option
  btrfs-progs: Doc/mkfs: Add extra condition for rootdir option

 Documentation/mkfs.btrfs.asciidoc |  11 ++
 extent-tree.c                     |   5 +-
 mkfs/main.c                       | 281 +++++++++++---------------------------
 volumes.c                         |  32 +++--
 4 files changed, 113 insertions(+), 216 deletions(-)

-- 
2.14.1

