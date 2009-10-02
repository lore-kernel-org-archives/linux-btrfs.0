From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] btrfsck: Fix Check limit in check_node/leaf.
Date: Fri, 02 Oct 2009 14:39:19 +0900
Message-ID: <4AC59207.9080309@jp.fujitsu.com>
References: <4AC59118.6030707@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AC59118.6030707@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


In btrfsck.c( check_node/leaf ), it seems that last pair of
ptrs and items are not checked at 2 place.


Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 btrfsck.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 73f1836..ecc7b19 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -1720,7 +1720,7 @@ static int check_node(struct btrfs_root *root,
 		if (memcmp(parent_key, &key, sizeof(key)))
 			return 1;
 	}
-	for (i = 0; nritems > 1 && i < nritems - 2; i++) {
+	for (i = 0; nritems > 1 && i < nritems - 1; i++) {
 		btrfs_node_key(buf, &key, i);
 		btrfs_node_key_to_cpu(buf, &cpukey, i + 1);
 		if (btrfs_comp_keys(&key, &cpukey) >= 0)
@@ -1759,7 +1759,7 @@ static int check_leaf(struct btrfs_root *root,
 		       (unsigned long long)btrfs_header_bytenr(buf));
 		return 1;
 	}
-	for (i = 0; nritems > 1 && i < nritems - 2; i++) {
+	for (i = 0; nritems > 1 && i < nritems - 1; i++) {
 		btrfs_item_key(buf, &key, i);
 		btrfs_item_key_to_cpu(buf, &cpukey, i + 1);
 		if (btrfs_comp_keys(&key, &cpukey) >= 0) {
-- 
1.6.2.1

