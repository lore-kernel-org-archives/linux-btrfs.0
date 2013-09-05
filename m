Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41652 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab3IEGzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 02:55:18 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id DFFC13EE0F6
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:55:17 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id D2D4945DE4F
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:55:17 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id B209E45DE4D
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:55:17 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A6B091DB8040
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:55:17 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id D08DA1DB8032
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:55:16 +0900 (JST)
Message-ID: <52282ACC.3080702@jp.fujitsu.com>
Date: Thu, 05 Sep 2013 15:55:08 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: chris.mason@fusionio.com
Subject: [PATCH v2 2/3] btrfs-progs: error if device have no space to make
 primary chunks
References: <522829F5.5050405@jp.fujitsu.com>
In-Reply-To: <522829F5.5050405@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The previous patch works fine if the size of specified volume to mkfs
is less than 4MB. However usually btrfs requires more than 4MB to work,
and the minimum preferred size is depending on the raid setting etc.

This patch let mkfs print error message if it cannot allocate one of
chunks should be there at first.

 [before]
  # truncate --size=4500K testfile
  # ./mkfs.btrfs -f testfile
   :
  SMALL VOLUME: forcing mixed metadata/data groups
  mkfs.btrfs: mkfs.c:84: make_root_dir: Assertion `!(ret)' failed.
  Aborted (core dumped)

 [After]
  # truncate --size=4500K testfile
  # ./mkfs.btrfs -f testfile
   :
  SMALL VOLUME: forcing mixed metadata/data groups
  no space to alloc data/metadata chunk
  failed to setup the root directory

TBD is calculate minimum size for setting and put it in the error
message to let user know how large amount of volume is required.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mkfs.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index a98fe54..bac122f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -81,6 +81,11 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_METADATA |
 					BTRFS_BLOCK_GROUP_DATA);
+		if (ret == -ENOSPC) {
+			fprintf(stderr,
+				"no space to alloc data/metadata chunk\n");
+			goto err;
+		}
 		BUG_ON(ret);
 		ret = btrfs_make_block_group(trans, root, 0,
 					     BTRFS_BLOCK_GROUP_METADATA |
@@ -93,6 +98,10 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_METADATA);
+		if (ret == -ENOSPC) {
+			fprintf(stderr, "no space to alloc metadata chunk\n");
+			goto err;
+		}
 		BUG_ON(ret);
 		ret = btrfs_make_block_group(trans, root, 0,
 					     BTRFS_BLOCK_GROUP_METADATA,
@@ -110,6 +119,10 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_DATA);
+		if (ret == -ENOSPC) {
+			fprintf(stderr, "no space to alloc data chunk\n");
+			goto err;
+		}
 		BUG_ON(ret);
 		ret = btrfs_make_block_group(trans, root, 0,
 					     BTRFS_BLOCK_GROUP_DATA,
@@ -181,6 +194,10 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 				&chunk_start, &chunk_size, type);
+	if (ret == -ENOSPC) {
+		fprintf(stderr, "not enough free space\n");
+		exit(1);
+	}
 	BUG_ON(ret);
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-- 
1.7.1


