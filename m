From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] btrfs: Fix set/clear_extent_bit for 'end == (u64)-1'
Date: Tue, 26 May 2009 20:59:08 +0800
Message-ID: <4A1BE79C.3030801@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are some 'start = state->end + 1;' like code in set_extent_bit
and clear_extent_bit. They overflow when end == (u64)-1.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urpN 7/fs/btrfs/extent_io.c 8/fs/btrfs/extent_io.c
--- 7/fs/btrfs/extent_io.c	2009-05-08 00:59:34.000000000 +0800
+++ 8/fs/btrfs/extent_io.c	2009-05-26 16:00:37.000000000 +0800
@@ -476,6 +476,7 @@ int clear_extent_bit(struct extent_io_tr
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
 	struct rb_node *node;
+	u64 last_end;
 	int err;
 	int set = 0;
 
@@ -498,6 +499,7 @@ again:
 	if (state->start > end)
 		goto out;
 	WARN_ON(state->end < start);
+	last_end = state->end;
 
 	/*
 	 *     | ---- desired range ---- |
@@ -524,9 +526,11 @@ again:
 		if (err)
 			goto out;
 		if (state->end <= end) {
-			start = state->end + 1;
 			set |= clear_state_bit(tree, state, bits,
 					wake, delete);
+			if (last_end == (u64)-1)
+				goto out;
+			start = last_end + 1;
 		} else {
 			start = state->start;
 		}
@@ -552,8 +556,10 @@ again:
 		goto out;
 	}
 
-	start = state->end + 1;
 	set |= clear_state_bit(tree, state, bits, wake, delete);
+	if (last_end == (u64)-1)
+		goto out;
+	start = last_end + 1;
 	goto search_again;
 
 out:
@@ -707,8 +713,10 @@ again:
 			goto out;
 		}
 		set_state_bits(tree, state, bits);
-		start = state->end + 1;
 		merge_state(tree, state);
+		if (last_end == (u64)-1)
+			goto out;
+		start = last_end + 1;
 		goto search_again;
 	}
 
@@ -742,8 +750,10 @@ again:
 			goto out;
 		if (state->end <= end) {
 			set_state_bits(tree, state, bits);
-			start = state->end + 1;
 			merge_state(tree, state);
+			if (last_end == (u64)-1)
+				goto out;
+			start = last_end + 1;
 		} else {
 			start = state->start;
 		}

