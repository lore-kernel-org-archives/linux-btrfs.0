Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06F23B6341
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790355186; cv=none; b=tV91HpdxitnZIlveSlSt7giZSy7zX/FpKSNYX6TRYVsBexI3egWndSTJRHBXi+H6o9q4e0E1YyO8pEdwLfvMQybIR3x21tLOrlbZ7qQ6Zs2I8rlkIjJWzM08a4bNBLedo8LkTxO6s+3seepYJph0+yg1GJijq/Jh5DAMR0gvI2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790355186; c=relaxed/simple;
	bh=lC6yIzgUittYx5I/xw+HQqmoxuMd4IkvmbTLbxGhQQ0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AOwmX2IREN321oZEFs6WCIpMyCtHCR/MMLPRs0ByXTJ8hxArSSEfKMsAla7UxWdFngQE9Yv7nKsuWOMnMZYhTD3WWKHRSllDP6+HpWRSw14DexRrv5YBunuipBJDQ82wNdTaFEKVjk+nBe/6K/d/A8lEGaC70S5O0i+ilFM57ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBT7rv1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBT7rv1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98E91F000FF
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 16:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790355179;
	bh=ehTXLkiHb8Z6p6FF4ZxGpihYbTGDK9s34r0hGS9Rzog=;
	h=From:To:Subject:Date;
	b=iBT7rv1kkIyh2VJwW1E0shnD4Jj+571tMZnFK50OnGxLHksxHad3VaAwvQbhnC3Ju
	 +08zu+kpmGJT2K45CF18uSTG9JkXr6iOXcaXwKLR2GDloGuv7mPnZgW1qJiZ9wratE
	 xkxdacvq6hF6ee0ku/DV2j4DicTHVxRqZlPjrOvvvsD1ywx/QRkBpUwZR4xfvW5otV
	 2xCrJD1AG+2AY3cbV/CznKcHLK4wwxS18x4FGRAiylDc+YS0gsDzm9ION6E7Pz19/R
	 Sbskq1ZMcq8oJAo88RQlZ/uHLj2IuZLBRhvzL8+J8tivivWxvPZ1eCCYqPsGlCQE2h
	 ApUaznIBPUqIQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: simplify dir item location setup in btrfs_insert_xattr_item()
Date: Fri, 25 Sep 2026 17:52:56 +0100
Message-ID: <8f24a85bf4a14292293a0e43c2522418f80f6a52.1790355077.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The location (a btrfs_disk_key) of a btrfs_dir_item used for a xattr is
always zeroed and we have a complex setup in btrfs_insert_xattr_item()
where we declare an on stack btrfs_key, zero it out, convert it into a
btrfs_disk_key, also declared on stack, and then pass that btrfs_disk_key
to a btrfs_set_dir_item_key() call.

We can simplify this, and save stack space (one btrfs_disk_key and one
btrfs_key), by simply using memzero_extent_buffer().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/dir-item.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 3a90736915af..d39f85035b43 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -62,8 +62,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	struct btrfs_dir_item *dir_item;
 	unsigned long name_ptr, data_ptr;
-	struct btrfs_key key, location;
-	struct btrfs_disk_key disk_key;
+	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	u32 data_size;
 
@@ -79,11 +78,11 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 					name, name_len);
 	if (IS_ERR(dir_item))
 		return PTR_ERR(dir_item);
-	memset(&location, 0, sizeof(location));
 
 	leaf = path->nodes[0];
-	btrfs_cpu_key_to_disk(&disk_key, &location);
-	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
+	memzero_extent_buffer(leaf, (unsigned long)dir_item +
+			      offsetof(struct btrfs_dir_item, location),
+			      sizeof(struct btrfs_disk_key));
 	btrfs_set_dir_flags(leaf, dir_item, BTRFS_FT_XATTR);
 	btrfs_set_dir_name_len(leaf, dir_item, name_len);
 	btrfs_set_dir_transid(leaf, dir_item, trans->transid);
-- 
2.47.2

