Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54882 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752603AbeCSK20 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 19 Mar 2018 06:28:26 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: print-tree: Do correct offset output for ROOT_ITEM
Date: Mon, 19 Mar 2018 18:28:10 +0800
Message-Id: <20180319102810.24356-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit Fixes: 8c36786c8198 ("btrfs-progs: print-tree: Print offset as tree objectid for ROOT_ITEM")
changes how we translate offset of ROOT_ITEM.

However the fact is, even for ROOT_ITEM, we have different meaning of
offset.

For tree reloc tree, it's indeed subvolume id.
But for other trees, it's the transid of when it's created.

Fix it.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index 45350fea0963..848e296c4e67 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -834,7 +834,16 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	 */
 	case BTRFS_ROOT_ITEM_KEY:
 		printf(" ");
-		print_objectid(stdout, offset, type);
+		/*
+		 * Normally offset of ROOT_ITEM should presents the generation
+		 * when this root is created.
+		 * However if this is tree reloc tree, offset is the subvolume
+		 * id of its source. Here we do extra check on this.
+		 */
+		if (objectid == BTRFS_TREE_RELOC_OBJECTID)
+			print_objectid(stdout, offset, type);
+		else
+			printf("%lld", offset);
 		printf(")");
 		break;
 	default:
-- 
2.16.2

