Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47976 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab3HWGbx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 02:31:53 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 8AEE73EE1D9
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:31:52 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 525B645DE50
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:31:52 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 3D22245DE4F
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:31:52 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 2FF1F1DB8032
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:31:52 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id D472F1DB8051
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:31:50 +0900 (JST)
Message-ID: <521701CD.7060409@jp.fujitsu.com>
Date: Fri, 23 Aug 2013 15:31:41 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: chris.mason@fusionio.com
Subject: [PATCH 2/2] btrfs-progs: exit if there is not enough free space for
 mkfs
References: <52170114.7060604@jp.fujitsu.com>
In-Reply-To: <52170114.7060604@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Again, while playing mkfs with small volumes, I found that mkfs.btrfs
aborts if there is really no spaces for a brand-new filesystem:

  # ./mkfs.btrfs -f /dev/sdf1 /dev/sdf2
  :
  SMALL VOLUME: forcing mixed metadata/data groups
  adding device /dev/sdf2 id 2
  mkfs.btrfs: mkfs.c:184: create_one_raid_group: Assertion `!(ret)' failed.
  Aborted (core dumped)

This fix let mkfs prints error message if it cannot make filesystem due
to a lack of free spaces.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mkfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index b412b7e..3c0bc60 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -181,6 +181,10 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 
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


