Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60416 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdIDGlS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 02:41:18 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/5] Mkfs: Rework --rootdir to a more generic behavior
Date: Mon,  4 Sep 2017 15:41:05 +0900
Message-Id: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs --rootdir provides user a method to generate btrfs with
pre-written content while without the need of root privilege.

However the code is quite old and doesn't get much review or test.
This makes some strange behavior, from customized chunk allocation
(which uses the reserved 0~1M device space) to lack of special file
handler (Fixed in previous 2 patches).

The reworked --rootdir will be based on traditional mkfs, everything is
processed after traditional mkfs, so nothing is customized.

The result will be an equivalent of mkfs, mount, cp, umount.
(If btrfs-progs chunk/extent allocator acts as the same as kernel)

And, add extra explanation for --rootdir, since the old implement
introduced a confusing behavior to limit the filesystem size.

The 1st patch fixes a bug that causes any write after
cleanup_temp_chunks() to trigger a NULL pointer dereference.

The 2nd patch changes the work flow of --rootdir, and slightly changed
the behavior, which will not shrink filesystem size by its own.

The 3rd patch will shrink the fs, to keep the behavior the same as old
--rootdir.
If anyone doesn't like the behavior, it can be removed easily.
(Which is the main part of the new code, I'd like to get rid of this)

The 4th patch enhance the verbose output to reflect the real chunk
allocation of --rootdir.

The final patch add extra documentary explanation.

Qu Wenruo (5):
  btrfs-progs: Fix one-byte overlap bug in free_block_group_cache
  btrfs-progs: mkfs: Rework rootdir option to avoid custom chunk layout
  btrfs-progs: mkfs: Shrink the image for rootdir to minimal size
  btrfs-progs: mkfs: Update allocation info before verbose output
  btrfs-progs: Doc/mkfs: Add explanation for rootdir parameter

 Documentation/mkfs.btrfs.asciidoc |   3 +
 extent-tree.c                     |   2 +-
 mkfs/main.c                       | 342 ++++++++++++++++++--------------------
 3 files changed, 164 insertions(+), 183 deletions(-)

-- 
2.14.1

