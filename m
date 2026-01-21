Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C2A3EF0D6
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013053; cv=none; b=vAbiTr29vHlG7GUpOySJhEQbyf0FzcyeJji6y8lug2dhVFsH7OGw2Ghx3kqi+uWHwjarhnHjo1iTYqbA1ie9PZpBxUxSeoTMQyi4I2GTeaixK7OrBc1WV7UVy926PtR4hfcqXKCoDBwjv4LZkelcFoivtc4CbfRc4Cv6QZlcwg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013053; c=relaxed/simple;
	bh=t1R4imCWtWPWVUIA1c7hMOEoa2mJNnKuCNmacLSn6Eo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q22/OlrZ8mUp7vYDFzH/084rPU1N4wYQ3PUydqt/y3s5BHtKtYi5c8RxXYHMigZKN1FTsl5yD4m7RNXApMf8Yud1BQYO21IAVta0Sxh/Hmym4GeCA2ssFrJBz4wNyPyxewVU2B9ACcHmIa8KPWWYAkfKf66kCk6Hx5Adh2K8ENQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBiZFi54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBiZFi54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BA8C19421
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013052;
	bh=t1R4imCWtWPWVUIA1c7hMOEoa2mJNnKuCNmacLSn6Eo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UBiZFi54K/51qmQt+Vq8cLi6cHwXEpowaX3sEv9+VexhM76sxFwGIHsu78+iJ8Bpk
	 h894p71yVYgASwaAguqFfW3x5lbV/BUp3e1KniGXwCAgpUs/lFZFd0wpdYA2LkSiJ6
	 mE29FvI1soiRq6yzG1xzONsqTXdN4UN6h5/HFn+AAHxpoSoBomYIioS46thsFU9eIY
	 IL+lZdJW3nY2uGn+76xwkwH5hGMy7Vto/v+G5TXn4TjeuzvhqxgObesLG3z16GJWEN
	 mGpqqNCzcuBh9RcyKqtgRNbwrQ7Rrp+A8nePdypnwSAFUqOCiUA4ACRjFKCtDwJ5PU
	 VyZADnZmliFsw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 04/19] btrfs: remove pointless out labels from qgroup.c
Date: Wed, 21 Jan 2026 16:30:30 +0000
Message-ID: <dbc3101d81e185daff432bd8c7f0b3e7f05cd6d2.1769012877.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1769012876.git.fdmanana@suse.com>
References: <cover.1769012876.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Some functions (__del_qgroup_relation() and
qgroup_trace_new_subtree_blocks()) have an 'out' label that does nothing
but return, making it pointless. Simplify this by removing the label and
returning instead of gotos plus setting the 'ret' variable.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c03bb96d3a34..f53c313ab6e4 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1613,10 +1613,8 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	int ret = 0;
 	int ret2;
 
-	if (!fs_info->quota_root) {
-		ret = -ENOTCONN;
-		goto out;
-	}
+	if (!fs_info->quota_root)
+		return -ENOTCONN;
 
 	member = find_qgroup_rb(fs_info, src);
 	parent = find_qgroup_rb(fs_info, dst);
@@ -1638,12 +1636,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 delete_item:
 	ret = del_qgroup_relation_item(trans, src, dst);
 	if (ret < 0 && ret != -ENOENT)
-		goto out;
+		return ret;
 	ret2 = del_qgroup_relation_item(trans, dst, src);
-	if (ret2 < 0 && ret2 != -ENOENT) {
-		ret = ret2;
-		goto out;
-	}
+	if (ret2 < 0 && ret2 != -ENOENT)
+		return ret2;
 
 	/* At least one deletion succeeded, return 0 */
 	if (!ret || !ret2)
@@ -1657,7 +1653,7 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 		squota_check_parent_usage(fs_info, parent);
 		spin_unlock(&fs_info->qgroup_lock);
 	}
-out:
+
 	return ret;
 }
 
@@ -2490,13 +2486,11 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 
 		/* This node is old, no need to trace */
 		if (child_gen < last_snapshot)
-			goto out;
+			return ret;
 
 		eb = btrfs_read_node_slot(eb, parent_slot);
-		if (IS_ERR(eb)) {
-			ret = PTR_ERR(eb);
-			goto out;
-		}
+		if (IS_ERR(eb))
+			return PTR_ERR(eb);
 
 		dst_path->nodes[cur_level] = eb;
 		dst_path->slots[cur_level] = 0;
@@ -2541,7 +2535,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 		dst_path->slots[cur_level] = 0;
 		dst_path->locks[cur_level] = 0;
 	}
-out:
+
 	return ret;
 }
 
-- 
2.47.2

