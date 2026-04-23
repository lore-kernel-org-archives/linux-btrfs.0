Received: from mail-yx1-f65.google.com (mail-yx1-f65.google.com [74.125.224.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF1C377029
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 22:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776984223; cv=none; b=kN/0Dky5Ev8V9VkDYak4IB2juYGTIYT4JZ4qTARX+idWi9n523ptWBSqaX+MBIB+v7g2VH0ft9zP4FDS+9kTXnt+VhN87zrljdqtFaJ46gcm/dXjBpN+HYCPAZ6eCqGrS60WwvItKXosUyHBL8K+y50zBD/cVGbWM//cvwwlCZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776984223; c=relaxed/simple;
	bh=wJ0XrAlAnv9JNGMlSGUrS7xexyGJCrl2iac/YWCPApk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oC5uYab0sd+HgbpH8/KlDanlBzJyXdCE1AK+sj59p0+zlrUz6eB7f6LudwjRT/r4kDYxkISnQ/t49TAwnQk/ow+ZGxf1OWho8R3LG6h+t2UmG2dDZvnZ2WksZ37Vyq/5rsUlMIW5eofQiCMRu1JpUtTXhUrJn+nQOatg3YxHl3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kK5L1eAm; arc=none smtp.client-ip=74.125.224.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kK5L1eAm"
Received: by mail-yx1-f65.google.com with SMTP id 956f58d0204a3-651bf4a4140so7105177d50.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 15:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776984221; x=1777589021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PW/6kknbBcL9W5YxGLJdiQk8I72nog8ICJ8o9Kw4ako=;
        b=kK5L1eAmDdfDfOwCVmeUtpYzvT0ijFgIIVAw6cc9rfS7uVuW33PvGsbjJMs+rIiry5
         ZGd705Rg87Rce84QgM8TJAipX2inavcou0S2L6b/S+3b6/rIU8BHGd9oqiJDOV8p8flf
         r1MHu8bETp36h5ylDrFSANT91LxUq+Tow9xmh7oUmRpwWF7Fk6AxnuJw8v0zEgjrwxs9
         QaFhH4gFyRRlxhmfCg+p/nX0ZXQc642x1g/I63PSJWuR0rT/rG2PtFkFUOe5av6Er0e1
         syD+GqNmqh2EtGyopD/HZl7E6Pw+HUS+JkPmqJHvF/MrXX1dTvbmZpPYAIbvJUSqO4I4
         nTAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776984221; x=1777589021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PW/6kknbBcL9W5YxGLJdiQk8I72nog8ICJ8o9Kw4ako=;
        b=qM83i/aU/zDJyJKWTZAv0U+OohWVSdlXyEdCUzjgqN67q/yJkpi/HerLt8YyNfzd7X
         VMgDREi29pr4bGY+6YtyUys3Mi6m9wR8cl87pzbfsnoJRHm1yEjOzqeBNZNJPEcjjqzH
         lTzYSz27Wsbs3W6bAPLOU6zbUUg//O/2PvctypH/UB+SMiJseWPszel+D0/cDwxQDOIZ
         6bIOiz1wrG6y6bFDDg8sgo4XzkqawqJEK7bqOXvS2NQDN9T6jGP/sY9HuvyFqNmmZKIf
         kpluzKeWlXioXO5PCl4jtYYeCz3+EKSEr+/cjq+SoadPDr3cQPKTbL2vWT8M4bwFIN9a
         N+rA==
X-Gm-Message-State: AOJu0Ywy0ePKoUu4mgUsXdwLwFljJNujt0RYdR+x+JvdI3T13h6nuQlO
	SXXQ9i1Za5Vm5MFIAGoZBcsqo84i1lHLqBbi2tlz/Eu/qe4Kj3nq8FAndh3kEC38
X-Gm-Gg: AeBDievGHHE8GrFpoqCmRDa+qviiNWpZf58IbidNfmJXCfoHYmsKtV79xcQhFJ2Gt9i
	GvkKD1ZkAORJj7ZhvqQ+pwAntMl0N+Yt6nu5R24xwaizP6rNI5H/tGbWTjjT5n44EfqK9Z3ZrQV
	XzAE45ImLDko5jeOd7HiWILI+ckmS9E3Nq4M/r+54bP1h+6SkzfeBE07gWGSlVPKh288LkArCGH
	BE0LAu7UcmUYnBGjJ58QVRfqKFsHJ2pmjNZhDCRdcQ5//xbfOokiZV6g1UCzXXzQvb1l3AyA53u
	Apd7EpSqDIWW7M2CvqXLLfPlOC/kv1zhSaNuEMjZOouO/ZHVCJu1w20sb/K2GcN+jD2qSxXxmPN
	jHY6GSqeh7Y+6lLxWlUoeWJUpg0QoE3WI6UdZBvC21NON97JXnhPkxoxdnijWV9ww/s1FAfVdA9
	H9msyaGGMGAVP+FfPVtS0n8QqNkfBmiopUu/iqKpE=
X-Received: by 2002:a05:690e:12cb:b0:650:36b0:7565 with SMTP id 956f58d0204a3-65411a42593mr23902962d50.45.1776984221096;
        Thu, 23 Apr 2026 15:43:41 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4c::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65314f11315sm9774283d50.21.2026.04.23.15.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 15:43:40 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 1/2] btrfs: don't finalize fs roots during qgroup snapshot accounting
Date: Thu, 23 Apr 2026 15:43:33 -0700
Message-ID: <3d60d1354b7f564568532085656a1989d4faa171.1776899536.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776899536.git.loemra.dev@gmail.com>
References: <cover.1776899536.git.loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qgroup_account_snapshot() calls commit_fs_roots() to persist root
items for consistent qgroup accounting. However, commit_fs_roots()
is a transaction finalization function that also clears
BTRFS_ROOT_FORCE_COW, frees log trees, clears BTRFS_ROOT_TRANS_TAG,
and frees qgroup metadata reservations. These are all premature
since the transaction is still in progress and create_pending_snapshot()
will modify the source root's tree afterward.

Currently this is harmless because should_cow_block() always COWs
WRITTEN extent buffers regardless of FORCE_COW state. But clearing
FORCE_COW mid-transaction leaves roots in an incorrect state:
blocks may be shared with a snapshot (via btrfs_copy_root) while
FORCE_COW no longer reflects that. Any future optimization that
relies on FORCE_COW to decide whether COW can be skipped would
silently corrupt snapshots.

Extract prepare_root_item() as a helper that updates a root's
root_item and writes it to the tree root. This is the only part of
commit_fs_roots() that qgroup accounting needs. Add
qgroup_commit_fs_roots() which iterates dirty roots calling only
prepare_root_item(), without finalization side effects. It iterates
using an advancing index instead of clearing tags, so roots remain
tagged for the real commit_fs_roots() call later, eliminating the
record_root_in_trans() re-tagging that was previously needed.

Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
 fs/btrfs/transaction.c | 105 +++++++++++++++++++++++++++++------------
 1 file changed, 75 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 55791bb100a22..5b362f2680200 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1477,8 +1477,66 @@ void btrfs_add_dead_root(struct btrfs_root *root)
 }
 
 /*
- * Update each subvolume root and its relocation root, if it exists, in the tree
- * of tree roots. Also free log roots if they exist.
+ * Update the root_item for @root to point at the current root->node
+ * and write it to the tree root.
+ */
+static int prepare_root_item(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root)
+{
+	if (root->commit_root != root->node) {
+		list_add_tail(&root->dirty_list,
+			      &trans->transaction->switch_commits);
+		btrfs_set_root_node(&root->root_item, root->node);
+	}
+
+	return btrfs_update_root(trans, trans->fs_info->tree_root,
+				 &root->root_key, &root->root_item);
+}
+
+/*
+ * Update root items for all dirty fs roots without the finalization
+ * side effects of commit_fs_roots() (clearing FORCE_COW, freeing
+ * logs, clearing trans tags, etc.). Tags are preserved so
+ * commit_fs_roots() can still find these roots later.
+ */
+static int qgroup_commit_fs_roots(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *gang[8];
+	unsigned long index = 0;
+	int i;
+	int ret;
+
+	spin_lock(&fs_info->fs_roots_radix_lock);
+	while (1) {
+		ret = radix_tree_gang_lookup_tag(&fs_info->fs_roots_radix,
+						 (void **)gang, index,
+						 ARRAY_SIZE(gang),
+						 BTRFS_ROOT_TRANS_TAG);
+		if (ret == 0)
+			break;
+		for (i = 0; i < ret; i++) {
+			struct btrfs_root *root = gang[i];
+			int ret2;
+
+			index = btrfs_root_id(root) + 1;
+			spin_unlock(&fs_info->fs_roots_radix_lock);
+
+			ret2 = prepare_root_item(trans, root);
+			if (unlikely(ret2))
+				return ret2;
+
+			spin_lock(&fs_info->fs_roots_radix_lock);
+		}
+	}
+	spin_unlock(&fs_info->fs_roots_radix_lock);
+	return 0;
+}
+
+/*
+ * Finalize each dirty subvolume root: free log trees, update relocation
+ * roots, clear BTRFS_ROOT_FORCE_COW, persist root items, and clear
+ * BTRFS_ROOT_TRANS_TAG.
  */
 static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 {
@@ -1535,16 +1593,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			clear_bit(BTRFS_ROOT_FORCE_COW, &root->state);
 			smp_mb__after_atomic();
 
-			if (root->commit_root != root->node) {
-				list_add_tail(&root->dirty_list,
-					&trans->transaction->switch_commits);
-				btrfs_set_root_node(&root->root_item,
-						    root->node);
-			}
-
-			ret2 = btrfs_update_root(trans, fs_info->tree_root,
-						&root->root_key,
-						&root->root_item);
+			ret2 = prepare_root_item(trans, root);
 			if (unlikely(ret2))
 				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
@@ -1604,7 +1653,13 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = commit_fs_roots(trans);
+	/*
+	 * Use qgroup_commit_fs_roots() instead of commit_fs_roots()
+	 * because the transaction is still in progress and we must not
+	 * clear FORCE_COW on roots whose blocks are shared with a
+	 * snapshot.
+	 */
+	ret = qgroup_commit_fs_roots(trans);
 	if (ret)
 		return ret;
 	ret = btrfs_qgroup_account_extents(trans);
@@ -1618,16 +1673,12 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 		return ret;
 
 	/*
-	 * Now we do a simplified commit transaction, which will:
-	 * 1) commit all subvolume and extent tree
-	 *    To ensure all subvolume and extent tree have a valid
-	 *    commit_root to accounting later insert_dir_item()
-	 * 2) write all btree blocks onto disk
-	 *    This is to make sure later btree modification will be cowed
-	 *    Or commit_root can be populated and cause wrong qgroup numbers
-	 * In this simplified commit, we don't really care about other trees
-	 * like chunk and root tree, as they won't affect qgroup.
-	 * And we don't write super to avoid half committed status.
+	 * Simplified commit for qgroup accounting:
+	 * 1) commit cow-only roots (extent tree, etc.) for consistent
+	 *    commit_root pointers
+	 * 2) write all btree blocks to disk so subsequent modifications
+	 *    are properly COW'd
+	 * We don't write the super to avoid a half-committed state.
 	 */
 	ret = commit_cowonly_roots(trans);
 	if (ret)
@@ -1640,13 +1691,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	/*
-	 * Force parent root to be updated, as we recorded it before so its
-	 * last_trans == cur_transid.
-	 * Or it won't be committed again onto disk after later
-	 * insert_dir_item()
-	 */
-	return record_root_in_trans(trans, parent, true);
+	return 0;
 }
 
 /*
-- 
2.52.0

