Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47EB125A0
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773776832; cv=none; b=sy8N13cuRxsuSWmhreZTd3lTFjxFBgWJjHmgiGQvDU4WeK06hSEyqnRiug/WCOOeiAIinyFo2HNm5kjemVsBW+NJmzKLTB4gJA6CtOIPjVhPCEWMmXyt9pVVhVzcIyoxSbZK5NMtWCzM3AJ41Pq3HB/bqPZLLX5L8nsYfe9KdzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773776832; c=relaxed/simple;
	bh=DpjC57vYpU/YHnm7ZajMUloQe50s589ackMGNlCMzys=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9wKc1JnzPTEtsmz0iw5f+g9EXeTFnIpiV9ivVHuRpwZTJCiph4T1Qjyzmx3zS1ce1bCKsdN5mOgKEsErc/kZlL3+VFy1666808FFtbh/9V5vOaARIrwKJnrbleHQKpDtCm4FVXmXLAGQQ91MEWbDiT3zqcaokDRpQiMlZ2FTyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KnwxsLNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KnwxsLNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D92C2BC86
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773776832;
	bh=DpjC57vYpU/YHnm7ZajMUloQe50s589ackMGNlCMzys=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KnwxsLNdPE9FwRr+/LtJf1FOajZ2JvD8UUzUOgLf9l94wZC2oVuRMC2bmQ06m4l09
	 vv7waKeh/J8bP3yn6V04rD71julj8/cDwbGF399k7bGhYTEkBqjtvkrB7Kh3OmxRcj
	 ADwPYjfNDRUbDrXzEJeesJKgtr+8PMHaboWd78wkgZbaxX3qKgUtAz62p6adksRSST
	 rKYmDy3sUlm0LOuhMiTNfJCIcXx4OKJfykES5fJWc9K5L8wN4QHVE3keqTkzJoVJoF
	 WsWIrjSeYI8s28m/3ISjSxiQN+4jhDMaF7BXQLpys+BxKFI/dsQAMopLwsI7rIHWXE
	 Nlr1L/4oBgxwg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: collapse __btrfs_qgroup_reserve_meta() into btrfs_qgroup_reserve_meta_prealloc()
Date: Tue, 17 Mar 2026 19:47:02 +0000
Message-ID: <ee8d66150fb1c5f601add25239d590233ac558bb.1773776356.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1773776354.git.fdmanana@suse.com>
References: <cover.1773776354.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Since __btrfs_qgroup_reserve_meta() is only called by
btrfs_qgroup_reserve_meta_prealloc(), which is a simple inline wrapper,
get rid of the later and rename __btrfs_qgroup_reserve_meta() to the
later.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 11 ++++++-----
 fs/btrfs/qgroup.h | 15 ++-------------
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8a9039fba158..702338580601 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4516,20 +4516,21 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 	return ret;
 }
 
-int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-				enum btrfs_qgroup_rsv_type type, bool enforce,
-				bool noflush)
+int btrfs_qgroup_reserve_meta_prealloc(struct btrfs_root *root, int num_bytes,
+				       bool enforce, bool noflush)
 {
 	int ret;
 
-	ret = btrfs_qgroup_reserve_meta(root, num_bytes, type, enforce);
+	ret = btrfs_qgroup_reserve_meta(root, num_bytes,
+					BTRFS_QGROUP_RSV_META_PREALLOC, enforce);
 	if ((ret <= 0 && ret != -EDQUOT) || noflush)
 		return ret;
 
 	ret = try_flush_qgroup(root);
 	if (ret < 0)
 		return ret;
-	return btrfs_qgroup_reserve_meta(root, num_bytes, type, enforce);
+	return btrfs_qgroup_reserve_meta(root, num_bytes,
+					 BTRFS_QGROUP_RSV_META_PREALLOC, enforce);
 }
 
 /*
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 190efe3ca64b..1c568fc9544e 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -394,19 +394,8 @@ int btrfs_qgroup_free_data(struct btrfs_inode *inode,
 			   u64 len, u64 *freed);
 int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 			      enum btrfs_qgroup_rsv_type type, bool enforce);
-int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-				enum btrfs_qgroup_rsv_type type, bool enforce,
-				bool noflush);
-
-static inline int btrfs_qgroup_reserve_meta_prealloc(struct btrfs_root *root,
-						     int num_bytes, bool enforce,
-						     bool noflush)
-{
-	return __btrfs_qgroup_reserve_meta(root, num_bytes,
-					   BTRFS_QGROUP_RSV_META_PREALLOC,
-					   enforce, noflush);
-}
-
+int btrfs_qgroup_reserve_meta_prealloc(struct btrfs_root *root, int num_bytes,
+				       bool enforce, bool noflush);
 /* Pre-allocated meta reservation can be freed at need */
 void btrfs_qgroup_free_meta_prealloc(struct btrfs_root *root, int num_bytes);
 
-- 
2.47.2

