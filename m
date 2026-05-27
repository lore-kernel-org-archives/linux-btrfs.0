Received: from mail-yw1-f196.google.com (mail-yw1-f196.google.com [209.85.128.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D829A37C0FD
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 15:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897087; cv=none; b=I9myFgQvBrMfsaK/t+cmsgEAULH7sWasuvp/KtaCH/AYUaluWRohNp8e+eOuYNt+8KLq8rh7Yuf9N4tlAL3BC8CaQTSL/sl7dAhpJlQ7a6J1eiTWip9nV/7Ozn0Cuu18HLBApYKfQqvQkktpnkh7bmYpG9DxJhV7mCZV8V5HgjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897087; c=relaxed/simple;
	bh=ryDaMP4GF7v9ec/R0E2wfuhXj4ZPsc15Zb83fdquIM4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZzNmDquZRYTzluUM2uGDSCjdJK9pvmesXH0kt6diD5M/63QmhvQfXjqwuzLuEjI+uGUWCkm9kCb6CIom7nw7OC/qzVAFqy9h6q7RdD8BC14A0lMmckbXwBiKyfo6RVWUn6SiZzvd6Blm7QqHQt6xGkuAdxNyfXlSBcqzZr6uGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bRm1PmIq; arc=none smtp.client-ip=209.85.128.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bRm1PmIq"
Received: by mail-yw1-f196.google.com with SMTP id 00721157ae682-7dbe0943b21so4685187b3.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 08:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779897085; x=1780501885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=79GcdrlN8WyysY5g0ke0sjB90hP7MkouNSe9QiIdkqE=;
        b=bRm1PmIqAjxkRqqnCpreIa+WS/UiXXnDb9x01xamtfhbLMsKwlVq7xP2Iq7Zb2dBAG
         U3VglQzubDwiEhLWora6vVGIbR2+mC4CjmJHDufN0QuU+s4JFagQrhL15PkAGZ61M/P9
         2S4078rroBr7h4uZepZt/pCcFLmrjaiLKAufOhkaFjAxWmrYM9cn7lbgDl72LPYgpBUV
         4KopPEWSJQCHddLY1GB/AMC8rB0YSlCF9V8+COEUPzZ4ADhDJ0GfonnGU/pZ2HDzqFVM
         DEnO1bgWQx5xnSDGT9Xq3E4F6mhtGnEpqq0JcTgy+j8UritMKf76pycEf6HVuN1/UfDL
         V8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897085; x=1780501885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=79GcdrlN8WyysY5g0ke0sjB90hP7MkouNSe9QiIdkqE=;
        b=gE9Y+jHVV2yNhSV8FKuvAMWctq6KSk52UiMeSqw1Mripu9DnzccWxVXnax+f2YxMrJ
         EeUUluTswc+dSTYvKSjLOs+f/FeGPpuiKDG30GtRiiHDyembljOgiZSWmUT1cm+6Spge
         +O1C4TC5iCULPIqs4GCjS/BUEfHvYRH+TuW6cG4nMAayTGgd/COGiM28XW3sqh+MCE39
         XL4eRVm3dbm8hxQl7gZ3yq2L1o/W4BCzJVqfcKyjsEN1av7+pRDXhwruE3z1ytsJ3FjY
         aY/lh0xHQUmgNWwAnXQeUoEgXBTcJ4/1Z7IId/6TYL50eDHeUq40kpBGO7TCUGTCsN32
         BIzQ==
X-Gm-Message-State: AOJu0YyQJ+CI2gxaAz9atYb6fLLy09w+lzi6U4bRJwd/cp1BLvZ6sCgZ
	j6ter3ekVInB5B62IA+2XvZW5wHGujnCcupS2143fZNpZ9o5qYzvmQEq2A3i/Gc7
X-Gm-Gg: Acq92OGwAVDLqKefXYwijB0VrPRsYIQiOi0C9sGZbj+7YhfFiryaIzZ9F/rrQiftHJl
	gYYwExnzG2mOCbTgrXbT2fAZJDUzIiZj4CEXqAi3Q368z5V6H1g8Pajzwi/ppAB9CMT45iVRfj3
	DCFwupfQA52RnuS6pVOfvheEiyJhWk7zPl5mZf6tnIUKuNMzBaJ325q2KWhsrxUBIwdA1nTq+CC
	x7hQTlPmwWG0BbhdkcW3vQMNodkAfvnJUgzfg18B34fOWa0YXT/keynUywKIIy99miHpCTsbthK
	ThGpTdV7ZJersAX+jv2LCrGyJwH+0cEKX3JRehj/cvpo527HjwWQ9wEEz7sKQ5BdSdkZSHKjQFe
	IAYLwrA3sYTVYPU46anteCtEYYXzLY4xKFd4Qf6jdrh8UfaurEkOaHiy+2TLBr+ZSqJZTiZWF4Z
	g6F130MdFFaE9m3u3REg==
X-Received: by 2002:a05:690c:4a07:b0:7ba:ded4:df69 with SMTP id 00721157ae682-7d35574ed42mr194853167b3.1.1779897084647;
        Wed, 27 May 2026 08:51:24 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:49::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7d389e1291asm77429877b3.12.2026.05.27.08.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 08:51:24 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 1/2] btrfs: don't finalize fs roots during qgroup snapshot accounting
Date: Wed, 27 May 2026 08:51:08 -0700
Message-ID: <3cad8de2f2c98305e0f5ca2e857c19b2ecab30f8.1779895842.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779895842.git.loemra.dev@gmail.com>
References: <cover.1779895842.git.loemra.dev@gmail.com>
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
v2:
 - Rename qgroup_commit_fs_roots()'s `ret` to `nr` since it holds the
   radix lookup count and is never returned. The inner loop's `ret2`
   becomes `ret` accordingly. (Sun YangKai)
 - Hoist the `index` advance out of the inner for loop and compute it
   once from gang[nr - 1] after the loop, since only the final value
   is consumed by the next radix lookup. (Sun YangKai)

 fs/btrfs/transaction.c | 105 +++++++++++++++++++++++++++++------------
 1 file changed, 75 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 55791bb100a2..728d935388f8 100644
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
+	int nr;
+
+	spin_lock(&fs_info->fs_roots_radix_lock);
+	while (1) {
+		nr = radix_tree_gang_lookup_tag(&fs_info->fs_roots_radix,
+						(void **)gang, index,
+						ARRAY_SIZE(gang),
+						BTRFS_ROOT_TRANS_TAG);
+		if (nr == 0)
+			break;
+		for (i = 0; i < nr; i++) {
+			struct btrfs_root *root = gang[i];
+			int ret;
+
+			spin_unlock(&fs_info->fs_roots_radix_lock);
+
+			ret = prepare_root_item(trans, root);
+			if (unlikely(ret))
+				return ret;
+
+			spin_lock(&fs_info->fs_roots_radix_lock);
+		}
+		index = btrfs_root_id(gang[nr - 1]) + 1;
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
2.53.0-Meta

