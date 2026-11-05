Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793909277;
	b=FDOP4x/xbtaf7+s0fEG5GrJrZLoe2J6K+U/Sp1b6nx1ghAtkUuXTbnD7XaRlXt4QxGpO
	 rOFL+572wivI/K85X54dI8d5jJgd9Tn/7B32zSR7W1hWIogyc5fYXXY7yWDwh4BFqwexk
	 ChuPvc40pYWGxD1+IDZDXWZysf0qEPX5PDVjS7m7gsDcBU04tDh1VYrXbBvcI7aWXC37a
	 GavzsC6yrLBwhLB9b1RrY4Rbig1NtqqTJ387XKc7BVKOJowohAj0Y8k2vNBgK1jmu7Pxh
	 sqkEt36ukm2N/YYXVbeCVyibIxk5As/IBr9hTRalD8gs6pDLd32A5fxBWEeV1zDREQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909277;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=9vmwXiGPHFcEIbWP/qFodNpix7XUv6txIlxaQwyNm7g=;
	b=rABezScTfZCZGw7HQ14VJfLvQgcToMwNalQr8xcbUoxTIM574vbFYUsbF1+6DrDqH417
	 o76XVftyIcj1hQ9u2UK6BT4yBu27a4Fe++KlE2/w72stmQNw41mw2k0OCRk6L7dmPUKEB
	 2EKHjfTtWefbAu+eA7oDo3lcxwakFGenQCsDMecrvKAeGNTL48Nf6HYj+Dwr7nS4uavzt
	 FU9B47HvGmI8niCbnGGkr+l+3FN2alCnsmCm7u+y6lKAWcj+tuUkQjHfQnNllCj9x+DTd
	 mAcw2ny5MyOeRim4SDEmVhWSDQb/RdQyPIVimlkACmVNLu2w+3flhOoI19RFKBZXXCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8JQGJ0K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC7F606EEBC;
	Thu,  5 Nov 2026 20:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8JQGJ0K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2821F008A5;
	Thu,  5 Nov 2026 20:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793909276;
	bh=9vmwXiGPHFcEIbWP/qFodNpix7XUv6txIlxaQwyNm7g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d8JQGJ0Kr1XItOqRvSt6TDvHhAOOuAKN+arTnYarZawRZxFK6yY8LvzOhTXbVffhi
	 ob+V5kTDLVnIjMERiAycMa16M0ipD+BNunq7Nf40pIg7769+LMUNs/RkI9MTA7RJ16
	 w5AjOs2aKkR8SMDRXlbJIBHprPJ8IVa3o1CMEbEHBv3uzmie8xOyb431baJdcF6MJ4
	 KhRGs5MRYeCDY3J1hTFXUAw7ITEMIQO7t4e8sxo60fEa+mITcbMIu4JdfnHP1yKcbs
	 NsVj2pRK6JlquE69tsmkqoBWPxIcLoYiUavYlQjyz4o5rq8TsuApMq1A6qeJG7+nbH
	 +nMKImGOk7bgQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 05 Nov 2026 15:07:43 -0500
Subject: [PATCH 2/4] btrfs: honor FMODE_NOCMTIME when punching holes
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-delegts-btrfs-v1-2-a42a2b93cdc2@kernel.org>
References: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
In-Reply-To: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chuck Lever <cel@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8046; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=M3qrIeEn/hZ6UREBgvvI1QdgOYNmTW8VAcENlsxMmXs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq7OIZ4tJyEgY+yFLS97ZJl/RhJrDUSZe33AeIx
 A/0I2cGrB2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauziGQAKCRAADmhBGVaC
 FcqvD/9r2ke4rHckjqQ5tqgnWW6DUaTK6kVTkS3XXCa//y6HZqvebSCkv482IlCK38QtQlsId6k
 802nQMvVGoMp/8IBBa38EJr4XBpFvgjdUXvMsyWkusujKFsXVtEv4/ba68L85ukq+75kkBhWUg7
 1rC865wXyELVzITvwqyYcdzzeYDW58ucAwFP5f0arqAKOOTUwSsUB/oBLa4SBeLne0Ju8KbL/q0
 L045vpQK8HOnRZ7ciGAqT1iuflPUQj4YedDgIrkQcE43d2SwkqnZlZrXKnLhHMw99CffGgbRN5S
 FDI0yMHJ8nUUJhHRIzK/kPbN+EKuuNFAWj9xOn83W2Zhni+YwP51UHFq63eb0IwRt9WsQ7mOZRe
 ZYsJMev/1kbnwJ6obPJqNnGwGUNe+iap+Qnt2hZ8dG0Zakl4l0R/niIzdzOhaK049/7zBdKqj8N
 /oid4cF1sYAPObq7x7dqaCjYl+gWD5QhVS+GclgBS5CcGJaeUDs+N0MdO3lk6+n9h9Qe2Xau6Si
 VYpmVgQa9hDJMTAyx4tWTs/r3/ZzkRyQ2acjRFqKjtDLBmbEeMRqizC4RWowRmgSroFo2Nqhge3
 weXJaLxNJe53Jlnt+ILv0K5JjKWcEtmni1eIk2jxemTqZEJvDAaXfnwea/xJJL+GpN6ppf4LXn9
 ALp4rUVmah1VodQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

btrfs_punch_hole() calls file_modified(), which skips the c/mtime update
for FMODE_NOCMTIME files. But btrfs_punch_hole() then updates c/mtime
itself in two places: after it replaces the extents, and in the
partial-block path. Also, when extent_info is NULL,
btrfs_replace_file_extents() updates c/mtime for each transaction.

nfsd sets FMODE_NOCMTIME while a client holds delegated timestamps. Thus
a DEALLOCATE from the holder advances the server's ctime, and the times
that the holder returns cannot move it back.

- Add btrfs_should_update_cmtime() and use it in btrfs_write_check() too.
- Replace btrfs_replace_extent_info::update_times with an update_times
  argument to btrfs_replace_file_extents(). This lets the NULL
  extent_info (hole punch) case skip the update.
- In btrfs_punch_hole(), skip the c/mtime updates for FMODE_NOCMTIME
  files.

The reflink caller that passes a NULL extent_info for a trailing hole
now also honors no_time_update, as clone_finish_inode_update() does.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/ctree.h   |  2 --
 fs/btrfs/file.c    | 28 +++++++++++++++++++++-------
 fs/btrfs/file.h    |  1 +
 fs/btrfs/inode.c   |  3 +--
 fs/btrfs/reflink.c |  6 +++---
 5 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 00d4c4184e76..56d8e36a54ff 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -402,8 +402,6 @@ struct btrfs_replace_extent_info {
 	 * existing extent into a file range.
 	 */
 	bool is_new_extent;
-	/* Indicate if we should update the inode's mtime and ctime. */
-	bool update_times;
 	/* Meaningful only if is_new_extent is true. */
 	int qgroup_reserved;
 	/*
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 94475976d8cf..eab20cc6e18e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1024,6 +1024,17 @@ void btrfs_check_nocow_unlock(struct btrfs_inode *inode)
 	btrfs_drew_write_unlock(&inode->root->snapshot_lock);
 }
 
+/*
+ * Return whether a modification through @file should update c/mtime. Like
+ * file_update_time(), skip it for S_NOCMTIME inodes and for files opened
+ * with FMODE_NOCMTIME (e.g. by nfsd while a client holds delegated
+ * timestamps).
+ */
+static bool btrfs_should_update_cmtime(const struct file *file)
+{
+	return !IS_NOCMTIME(file_inode(file)) && !(file->f_mode & FMODE_NOCMTIME);
+}
+
 int btrfs_write_check(struct kiocb *iocb, size_t count)
 {
 	struct file *file = iocb->ki_filp;
@@ -1053,7 +1064,7 @@ int btrfs_write_check(struct kiocb *iocb, size_t count)
 	 * need to start yet another transaction to update the inode as we will
 	 * update the inode when we finish writing whatever data we write.
 	 */
-	if (!IS_NOCMTIME(inode) && !(file->f_mode & FMODE_NOCMTIME)) {
+	if (btrfs_should_update_cmtime(file)) {
 		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 		inode_inc_iversion(inode);
 	}
@@ -2356,6 +2367,7 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
  * The end offset is inclusive (last byte of the range).
  * @extent_info is NULL for fallocate's hole punching and non-NULL when replacing
  * the file range with an extent.
+ * @update_times says whether to update the inode's mtime and ctime.
  * When not punching a hole, we don't want to end up in a state where we dropped
  * extents without inserting a new one, so we must abort the transaction to avoid
  * a corruption.
@@ -2364,6 +2376,7 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 			       struct btrfs_path *path, const u64 start,
 			       const u64 end,
 			       struct btrfs_replace_extent_info *extent_info,
+			       bool update_times,
 			       struct btrfs_trans_handle **trans_out)
 {
 	struct btrfs_drop_extents_args drop_args = { 0 };
@@ -2504,7 +2517,7 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 		 */
 		inode_inc_iversion(&inode->vfs_inode);
 
-		if (!extent_info || extent_info->update_times)
+		if (update_times)
 			inode_set_mtime_to_ts(&inode->vfs_inode,
 					      inode_set_ctime_current(&inode->vfs_inode));
 
@@ -2636,6 +2649,7 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 	u64 ino_size;
 	bool truncated_block = false;
 	bool updated_inode = false;
+	const bool update_times = btrfs_should_update_cmtime(file);
 
 	btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
 
@@ -2738,14 +2752,15 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 	}
 
 	ret = btrfs_replace_file_extents(BTRFS_I(inode), path, lockstart,
-					 lockend, NULL, &trans);
+					 lockend, NULL, update_times, &trans);
 	btrfs_free_path(path);
 	if (ret)
 		goto out;
 
 	ASSERT(trans != NULL);
 	inode_inc_iversion(inode);
-	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	if (update_times)
+		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	ret = btrfs_update_inode(trans, BTRFS_I(inode));
 	updated_inode = true;
 	btrfs_end_transaction(trans);
@@ -2762,10 +2777,9 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 		 * for detecting, at fsync time, if the inode isn't yet in the
 		 * log tree or it's there but not up to date.
 		 */
-		struct timespec64 now = inode_set_ctime_current(inode);
-
 		inode_inc_iversion(inode);
-		inode_set_mtime_to_ts(inode, now);
+		if (update_times)
+			inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
diff --git a/fs/btrfs/file.h b/fs/btrfs/file.h
index d7df81388cbe..18ebc8c2d6d2 100644
--- a/fs/btrfs/file.h
+++ b/fs/btrfs/file.h
@@ -30,6 +30,7 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 			   struct btrfs_path *path, const u64 start,
 			   const u64 end,
 			   struct btrfs_replace_extent_info *extent_info,
+			   bool update_times,
 			   struct btrfs_trans_handle **trans_out);
 int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 			      struct btrfs_inode *inode, u64 start, u64 end);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index abaa33471456..a6ce83a94fe6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9132,7 +9132,6 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.file_offset = file_offset;
 	extent_info.extent_buf = (char *)&stack_fi;
 	extent_info.is_new_extent = true;
-	extent_info.update_times = true;
 	extent_info.qgroup_reserved = qgroup_released;
 	extent_info.insertions = 0;
 
@@ -9144,7 +9143,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 
 	ret = btrfs_replace_file_extents(inode, path, file_offset,
 				     file_offset + len - 1, &extent_info,
-				     &trans);
+				     true, &trans);
 	btrfs_free_path(path);
 	if (ret)
 		goto free_qgroup;
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index b5d2c094941d..f67350bba9b9 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -556,10 +556,9 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
 			clone_info.file_offset = new_key.offset;
 			clone_info.extent_buf = buf;
 			clone_info.is_new_extent = false;
-			clone_info.update_times = !no_time_update;
 			ret = btrfs_replace_file_extents(inode, path,
 					drop_start, new_key.offset + datal - 1,
-					&clone_info, &trans);
+					&clone_info, !no_time_update, &trans);
 			if (ret)
 				goto out;
 		} else {
@@ -656,7 +655,8 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
 			btrfs_set_inode_full_sync(inode);
 
 		ret = btrfs_replace_file_extents(inode, path,
-				last_dest_end, destoff + len - 1, NULL, &trans);
+				last_dest_end, destoff + len - 1, NULL,
+				!no_time_update, &trans);
 		if (ret)
 			goto out;
 

-- 
2.56.0

