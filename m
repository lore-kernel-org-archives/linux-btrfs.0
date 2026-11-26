Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795717464;
	b=xUFfsMRPQLW4C3o6aia9RPl0+sVMGgqDZR6KuWz2FoF7X7QsCGw9A0hFYqr43O/IcNmo
	 qXShnawKRi9VB6aBSmxDThBeUPTO9xidhHxPGHcfD7xzQb3exuKWTDyMwbjSuuNDmjEqZ
	 yzOArvY70jamNv5fSVOLXmqYbjSz9kF0VbfNgUzPq6N/VRI103q9d/33SUQX5honfXmyJ
	 BcJK1CySf8tXXU+LsDlaQ/Nc/0Srh/uDJx55ODTUI7ZdSAo7A886pmvCzZngq80qukXvT
	 BcJm3d9At7VYM+vAMXfWEl8yNWLcODptRbsoXrM6XEw6Y0M9xLmnlcz2MOviy9CYqWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795717464;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p46nji6+8H2evNv+s8LuBc5mdOs0Oqnj3q/XSEBilcs=;
	b=muro06z9+BBYGFM4qsnu2re4WmUrlRF2ImmjrA+ufpJmwmPZteFUAi66spgYLjKCGuzA
	 SOsvqNli3bLQbG0xpHalYxMv6HtzfyvG1HHv0bZFhMFBdIPOthXP6w72PhqAidQqSfCYa
	 JJX6rhnzXOwMRRV//ycckv2o/JfBXqsuXX8brXfEe45eUNf3LSm2kWOLpZqjeokalj6tW
	 EE5qhm2WzWWviV0gAbWiL8yRAiO5B8GYXRrSKHi03+h7tQMNwcJfFME7Agp7YF4CYgCo9
	 GcjNDkM/1kPtqwVI7+xoj1t4vFlJNGn33x1Gr9o0Mi1rfQSiUOES4ZTzWRtpYzX25Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xz2x1d5r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F05606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 18:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xz2x1d5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A4B1F000C0
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 18:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795717464;
	bh=p46nji6+8H2evNv+s8LuBc5mdOs0Oqnj3q/XSEBilcs=;
	h=From:To:Subject:Date;
	b=Xz2x1d5r9IJdRirl/Wt4gt0B6QIpH8AJLEi19XHv7n6EobmIzixO5P6JMs2zXnLU0
	 CMXoTAmOUH327WHaFXTTj8/3vjlK1uSFb7aZV06mfMMBgJuq34IT507kBuAhUCbH6U
	 qp84uCELnPrAdoacdP9B1t5V3BEOj20bGg6W1ldcmUG1YocAf92OQqsML83MfV2FMM
	 fyQpVEYzZqc21mOuGBo6ljF3Kd42vX7VvDgZfAsXlm0wQGyWoE8hSDGeplK/nsaViy
	 HWnn+3gFESZvcLbklVqdaXWblCNCmtYk/OXNhke1XD0tVzZAxtROa4msZwJcMYApe6
	 +nKZnYIU/MaIg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: verity: don't end transaction handle while having a path with locks
Date: Thu, 26 Nov 2026 18:24:21 +0000
Message-ID: <78a91fbf251780a13130fbebbf09784c26d0b3ff.1795717429.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We have a couple places, in drop_verity_items() and write_key_bytes(),
where after an error we end the transaction handle while we have a path
with extent buffers (at least a leaf) write locked.

This not only violates the invariant that no task holds a write lock on
extent buffers after releasing its transaction handle, but it's also
dangerous as it creates some unexpected locking dependencies that are
prone to deadlocks if we have new pending block groups to create, as in
that case btrfs_end_transaction() calls btrfs_create_pending_block_groups()
and in that call chain we need to take several locks: chunk_mutex and
device_list_mutex as well as lock extent buffers from all the trees
involved in block group creation: chunk, device, block group, extent and
free space trees.

Fix this by freeing the paths before calling btrfs_end_transaction(),
which releases any locks and avoids keeping the path allocated, as if
we happen to enter pending block group creation when ending the
transaction handle, we will need to allocate another path to update
the chunk, device, block group, extent and free space trees.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Link: https://sashiko.dev/#/bug/linux-b28e7923-735f-4781-b6d9-ce76311edb53
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/verity.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 79ace98714ad..cdd63af14c0d 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -126,7 +126,7 @@ static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)
 	BTRFS_PATH_AUTO_FREE(path);
 	struct btrfs_key key;
 	int count = 0;
-	int ret;
+	int ret = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -154,8 +154,7 @@ static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)
 				break;
 			path->slots[0]--;
 		} else if (ret < 0) {
-			btrfs_end_transaction(trans);
-			return ret;
+			break;
 		}
 
 		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
@@ -171,16 +170,24 @@ static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)
 		 * items
 		 */
 		ret = btrfs_del_items(trans, root, path, path->slots[0], 1);
-		if (ret) {
-			btrfs_end_transaction(trans);
-			return ret;
-		}
+		if (ret)
+			break;
 		count++;
 		btrfs_release_path(path);
 		btrfs_end_transaction(trans);
 	}
+	/*
+	 * We don't need the path anymore, so free it. We also may be holding
+	 * extent buffer write locks and btrfs_end_transaction() can trigger the
+	 * finishing phase of creating new and pending block groups, which needs
+	 * to update several trees (chunk, device, block group, extent and free
+	 * space trees), lock chunk_mutex and device_list_mutex mutexes, etc,
+	 * creating unnecessary locking dependencies prone to deadlocks.
+	 */
+	btrfs_free_path(path);
+	path = NULL;
 	btrfs_end_transaction(trans);
-	return count;
+	return ret < 0 ? ret : count;
 }
 
 /*
@@ -233,13 +240,14 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 	unsigned long copy_bytes;
 	unsigned long src_offset = 0;
 	void *data;
-	int ret = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
 	while (len > 0) {
+		int ret;
+
 		/* 1 for the new item being inserted */
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans))
@@ -257,8 +265,16 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 
 		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
 		if (ret) {
+			/*
+			 * Free the path before ending transaction handle
+			 * because we may be holding locks on a leaf and ending
+			 * the transaction handle can trigger creation of new
+			 * pending block groups (which takes several locks).
+			 */
+			btrfs_free_path(path);
+			path = NULL;
 			btrfs_end_transaction(trans);
-			break;
+			return ret;
 		}
 
 		leaf = path->nodes[0];
@@ -274,7 +290,7 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 		btrfs_end_transaction(trans);
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
2.53.0

