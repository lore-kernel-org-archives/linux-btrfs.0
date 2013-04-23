Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:14604 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab3DWJZE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 05:25:04 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp2) (RZmta 31.27 OK)
	with ESMTP id g07632p3MEgX9z for <linux-btrfs@vger.kernel.org>;
	Tue, 23 Apr 2013 11:25:01 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: in btrfs-debug-tree, print -1 in key for (u64)-1
Date: Tue, 23 Apr 2013 11:25:01 +0200
Message-Id: <1366709101-17887-2-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1366709101-17887-1-git-send-email-sbehrens@giantdisaster.de>
References: <1366709101-17887-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the objectid and offset field of a key, print -1 instead of the
decimal representation of 0xffffffffffffffff. At least for me it is
more readable like this.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 print-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index 49c8384..aae47a9 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -585,6 +585,9 @@ static void print_objectid(u64 objectid, u8 type)
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		printf("MULTIPLE");
 		break;
+	case (u64)-1:
+		printf("-1");
+		break;
 	case BTRFS_FIRST_CHUNK_TREE_OBJECTID:
 		if (type == BTRFS_CHUNK_ITEM_KEY) {
 			printf("FIRST_CHUNK_TREE");
@@ -614,7 +617,10 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 			(unsigned long long)(offset & ((1ll << 48) - 1)));
 		break;
 	default:
-		printf(" %llu)", (unsigned long long)offset);
+		if (offset == (u64)-1)
+			printf(" -1)");
+		else
+			printf(" %llu)", (unsigned long long)offset);
 		break;
 	}
 }
-- 
1.8.2.1

