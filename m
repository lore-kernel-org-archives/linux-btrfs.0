From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs-progs: only print FIRST_CHUNK_TREE for chunk items in debug-tree
Date: Wed,  3 Feb 2010 11:13:33 -0800
Message-ID: <1265224413-4192-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Otherwise we print FIRST_CHUNK_TREE for any objectid 256, which e.g. for
the root tree is the first snap/subvol.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 print-tree.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 59f4358..de064e1 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -413,8 +413,11 @@ static void print_objectid(unsigned long long objectid, u8 type)
 		printf("MULTIPLE");
 		break;
 	case BTRFS_FIRST_CHUNK_TREE_OBJECTID:
-		printf("FIRST_CHUNK_TREE");
-		break;
+		if (type == BTRFS_CHUNK_ITEM_KEY) {
+			printf("FIRST_CHUNK_TREE");
+			break;
+		}
+		/* fall-thru */
 	default:
 		printf("%llu", objectid);
 	}
-- 
1.5.6.5

