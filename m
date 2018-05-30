Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:56672 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932618AbeE3Ewk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 00:52:40 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 446CFAC0171
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 13:52:32 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 5ECA16D677F
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 13:52:31 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: ins: dump-tree: Print tree name for tree block backref
Date: Wed, 30 May 2018 13:55:20 +0900
Message-ID: <f6cac4991b513c3c4b00781414d422b3f4c87f6e.1527655420.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1527655420.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1527655420.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Print tree name instead of number to make output more readable.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 print-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 90173c2b..8d551d09 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -470,8 +470,9 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 		offset = btrfs_extent_inline_ref_offset(eb, iref);
 		switch (type) {
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			printf("\t\ttree block backref root %llu\n",
-			       (unsigned long long)offset);
+			printf("\t\ttree block backref root ");
+			print_objectid(stdout, offset, 0);
+			printf("\n");
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
 			printf("\t\tshared block backref parent %llu\n",
-- 
2.14.3


