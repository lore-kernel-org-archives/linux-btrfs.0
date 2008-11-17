From: "Liu Hui" <onlyflyer@gmail.com>
Subject: [PATH]Some fix for batching extent insert.
Date: Mon, 17 Nov 2008 23:48:26 +0800
Message-ID: <2c3b11250811170748s508ec4ddlfce9ad80bb296d95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
When I review the code about batching extent insert, I found some code
could result in problems in some corner cases.
1)In finish_current_insert(), when it finds nothing to insert and it
has skipped some locked extents, it should try again to see if the
locked extent is unlocked. So, it will re-search the extent_ins
extent_io_tree by reseting 'search' to 0. There is one place forget to
reset the 'search' pointer to 0 which will lead BTRFS not to finish
*all* current insert.

2)In insert_extents(), when ret==1 and last is not zero, it should
check if the current inserted item is the last item in this batching
inserts. If so, it should just break from loop. If not, 'cur =
insert_list->next' will make no sense because the list is empty now,
and 'op' will point to an unexpectable place.

3)There are also some trivial fixs in this patch including one comment
typo error and deleting two redundant lines.

--
Thanks & Best Regards
Hui
--

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8bb4524..0d0e2e7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3033,7 +3033,6 @@ int btrfs_insert_some_items(struct
btrfs_trans_handle *trans,
 	struct btrfs_item *item;
 	int ret = 0;
 	int slot;
-	int slot_orig;
 	int i;
 	u32 nritems;
 	u32 total_data = 0;
@@ -3056,7 +3055,6 @@ int btrfs_insert_some_items(struct
btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto out;

-	slot_orig = path->slots[0];
 	leaf = path->nodes[0];

 	nritems = btrfs_header_nritems(leaf);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e785f0a..be5b376 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -783,7 +783,7 @@ static int noinline insert_extents(struct
btrfs_trans_handle *trans,
 			i = total - 1;
 			cur = insert_list->prev;
 			op = list_entry(cur, struct pending_extent_op, list);
-		} else if (last) {
+		} else if (last && (i + ret < total)) {
 			/*
 			 * ok we successfully inserted the last item on the
 			 * list, lets reset everything
@@ -2145,6 +2145,7 @@ again:
 		if (ret) {
 			if (skipped && all && !num_inserts) {
 				skipped = 0;
+				search = 0;
 				continue;
 			}
 			mutex_unlock(&info->extent_ins_mutex);
@@ -2184,7 +2185,7 @@ again:
 	}

 	/*
-	 * process teh update list, clear the writeback bit for it, and if
+	 * process the update list, clear the writeback bit for it, and if
 	 * somebody marked this thing for deletion then just unlock it and be
 	 * done, the free_extents will handle it
 	 */
