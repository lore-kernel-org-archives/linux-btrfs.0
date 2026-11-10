Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269474;
	b=czb76/35vVyrDcWxsP2KwZnABEzghAR7s7mlla1QKWRZn8UcGWRMt/6kBaldZxdPFxx2
	 YpFMruY3iOhtM3YAMWJWn/XItBL/hdl54S3V3IYFhMik44+KCjRKZPQCnRTX/vgQ5TKUe
	 inM/iyMfNZhK6eMEb26d9lsBKhXJjgYkBodMx99JtRmeGC5Qv9631325o1nG6qIrS67Oy
	 Z+Zrrrvx2anU8CzjsJ/rE8ZHt7kW9TuUGMF3ScFPFGwnxwiusDqDxOCC/23sN0U4RW5NX
	 5vLZ/j8zLK5KegwtC9PF5W8rf7hYba2Xj75LQIUq6W4oEKsTI6WwuEGMvnr37AiMB1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=iXl2tTZcW7PLOjyF4CcvO84zkQBjn8agAyejPd3khAo=;
	b=J0VfMTtKCQwBft2lk4kd8aCQO3Nq6dQf828jSHfavgFf6ogVuJpRrwrPu963bfORgWeE
	 nfMR82zcWU7xPo6z0/DeDO8KC7W4LXCUfWD/gfqcR7xDw172Q8eDkJmHswjrp/m2RDb26
	 1gqANKTQh1lAYShHGCn+PbZ5QLFNOqf2nPoULNYdVgA1GXGgexVn5MLfA8HdIwrtocgJX
	 GZWtQIZ0TzTC0zP87K2+KJbP1Xzjt2HfAuNVsRzcQPG4vNsibyPgmHrsEklrfog5S+KDI
	 KbOYUPBYovZd8bXZZe8Ay45zxP07yXjTnEbHhttdvJAsNMgnZU0Lhw0Iml79kda535w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dj3Aj0QN;
	arc=none smtp.remote-ip=74.125.224.132
Received: from mail-yx2-f4.google.com (mail-yx2-f4.google.com [74.125.224.132])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF27A606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 00:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF27A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dj3Aj0QN
Received: by mail-yx2-f4.google.com with SMTP id 956f58d0204a3-67603b254bbso315543d50.1
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 16:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794269473; x=1794874273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iXl2tTZcW7PLOjyF4CcvO84zkQBjn8agAyejPd3khAo=;
        b=dj3Aj0QN65v9zeIWjIWQ0SNooO+dpp2yasyFP+l3HG1t8o0RMDtgb69Kho1qcfilGD
         UaExBLP2V2bTcZpADBgyEss7aNBvEEWtdIU9EjrpXQeE1Hv/0R84GzbVcgKiNnlGO7nS
         3PFAvGTDA8jE9A0ud4jrYM8TqvkrOhXZpDWtofm72HSBWiGyM2IdBK+ozriC/4MNai2Q
         KkEZTgvJi0jUIOuJPuCUjMJiW8mgpu1tlXVgDZYfdJptL3z5XIGYakvhRpU+GupZNzJ8
         dTZHlTnK8ULRIEnK/j3jMk8lC4abqSvfYv8j6QVGduYBD9l+mhNksYasjTwaTTO9n0DU
         qjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794269473; x=1794874273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iXl2tTZcW7PLOjyF4CcvO84zkQBjn8agAyejPd3khAo=;
        b=vu+m4Oym0Wwi9Jt4y1H5nC7Btj0qaAvz4hsCwAzRtFpb8bCvAc8evbYA27hajx/rgv
         +6x6eISeAWeE9pDaK2XS+55NfvhWAKZWk3+mDvzwxqG0Lvx5H02a5wERuGBu6FvHEaMq
         NHUuOJyxQcUnPgrDmp346pMgIl0dQ+NBohq+p1MNaDmNv24RxcPiMR3qvY+rI0IUoF6V
         e+qa0Kq77BZiaKb9CRyNH9SBBvCkcr4Trq+TZMywwT2jHQtcKb9oHPWyisB9VjEg7vvn
         OEwrMKBHGglzBozQ+ogXVbeRQ4SB+TX6d7FxgvR08JHxvamjrTv8mMci+YL5qm6H3DC1
         5gBQ==
X-Gm-Message-State: APuU4Z9CEUsILwMfMb4V285HgqH+HOFi9LkCvBpfOKRyTaG2pzbyUg2D
	Id8QgMsSF+DZT6gRwsoP5Da3b5v7WshkO7BcyH5NzJPQ9ZDQ1MglreydccN+dJW3
X-Gm-Gg: AYBFou2/ik+zMpSTEqJdcIBKpObhGY7eXnHBW3oegA3QkERaZjwlJgvCsZClaBP6Qcs
	GlRau08SpnCHUKzHXryZxh3+5dWd9dyYO+oVnFpgcs5oT+3Ji/MtZ3jn9aVlRCWtZWT/mZ9awN0
	i+ZZGQVeIdd8K/QSjrbka0Zb21oic+cANC9oNBmcWYSOHzv0lWQXLBgUSqWuHbdOrufionddQF4
	evRPQjyiOud/Z7GmwoInnlIXqgcz6aBwefT344nC/cF+lqvdkiyCsVpcsg4IQXatjNHNQZIwsbb
	LVmGLEZGXWPMH5A23RaQJW7mlFOLkP3tEf7QzqHFSZ43EWz0WXEdCeexS/3+r8HE9Dy0Lut/g9P
	6y0qCbdlquOZqzWxgogOXcumMgkCMkCVjB9wX4ND26UemKedyIIcrTThQZgyAuXeIfh0FNdKss6
	VSs7zIjcUt7ur34+t2zZnUewjGm0v3oiHsjYZlUbPfVtsSSRoShLN6Wec8HF62Sn9Bz5E5cQNA6
	1FgGmXKiYWmA2TfoMctHiDZW+OGlpPxq/mN1wa/SqIa5H25DWuuV2toIbJxrZK9h9TpkI8t17cl
	6bYAG4mEEwG0mM9vKxztb53v
X-Received: by 2002:a05:690c:e3cb:b0:8b0:e13c:2856 with SMTP id 00721157ae682-8b3929a2a60mr6883827b3.5.1794269472837;
        Mon, 09 Nov 2026 16:11:12 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3933a6554sm6864577b3.12.2026.11.09.16.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 16:11:12 -0800 (PST)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH] btrfs: keep a logged extent allocated when its ordered extent fails
Date: Mon,  9 Nov 2026 16:11:09 -0800
Message-ID: <54da67463c57f41302f8456a8a7a1190dcb65ae2.1794266796.git.loemra.dev@gmail.com>
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

A fast fsync doesn't wait for its ordered extents to complete. Once their
IO is done it logs the new extents, with the checksums from the ordered
extents, and syncs the log. Until an ordered extent completes and inserts
its file extent item, the log is the only thing referencing its extent.

If the transaction aborts before that, the ordered extent fails to join
the transaction and its error path returns the extent to the free space
cache, even though the log still points at it. Writeback keeps going
after the abort, so a page dirtied earlier can get allocated that range
and overwrite it. When the log is replayed on the next mount, the file
points at the overwritten blocks with the old checksums, and every read
fails with a csum error while btrfs check reports no problems.

  fsync                    completion of X            writeback

  write X, wait for IO
  log X, sync the log
                           transaction aborts,
                           X returned to the
                           free space cache
                                                      allocate X,
                                                      overwrite X
  mount: log replay points the file at X, with X's logged checksums

Fix this by not freeing the extent of a failed ordered extent that a fast
fsync logged (BTRFS_ORDERED_LOGGED). Release its reservation but keep the
range out of the free space cache until the next mount, when log replay
takes a real reference. clean_log_buffer() already does the same for log
tree blocks when it has no transaction.

The transaction that logged the extent also must not commit, since the
commit would drop the log, the only record of the fsynced data. It can't
have committed yet because it waits for this ordered extent. Every
failure after joining the transaction already aborts it, and a failed
join means the transaction already aborted or the filesystem already has
an error, unless allocating the handle failed. In that case there's no
handle to abort with, so set the error with btrfs_handle_fs_error().
Once the filesystem has an error, the commit fails to write its tree
blocks and never writes a superblock.

A completion can also fail while the fsync is logging: the log already
points at the extent, but the completion checks BTRFS_ORDERED_LOGGED
before the fsync sets it and frees the extent. To close that window, set
BTRFS_ORDERED_LOGGED and check BTRFS_ORDERED_IOERR under the ordered
tree lock. The error path sets IOERR before checking LOGGED, so either
it sees LOGGED and keeps the extent, or the fsync sees IOERR and fails
logging, which forces a full commit instead of a log sync.

This depends on "btrfs: wait for ordered extent IO in fast fsync", which
stops a fast fsync from logging ordered extents whose write failed. So
only failures after the IO is done, from an abort or a failed join, reach
the new path, and a plain write error doesn't force the filesystem
read-only.

Without this patch, delaying and then failing reads on the device while
fsync-heavy writers and writers that never sync are running left
persistent csum errors after log replay in 5 of 24 runs where the
transaction aborted.

Fixes: 487781796d30 ("btrfs: make fast fsyncs wait only for writeback")
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
This applies on for-next with Josef's "btrfs: data integrity fixes" v2 [1]
and depends on "btrfs: wait for ordered extent IO in fast fsync" from it.
That patch keeps a fast fsync from logging an ordered extent whose write
failed. Without it, a plain write error with no abort could reach the
new path with BTRFS_ORDERED_LOGGED set, and this patch would force the
filesystem read-only over it. With it, only an abort (already read-only)
or a failed handle allocation gets there, so a backport needs both.

[1] https://lore.kernel.org/linux-btrfs/20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com/

 fs/btrfs/inode.c    | 57 +++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/tree-log.c | 21 ++++++++++-------
 2 files changed, 60 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 19b1eba2dd84..c8af19a05405 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3170,6 +3170,30 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 					   update_inode_bytes, oe->qgroup_rsv);
 }
 
+/*
+ * The log may already reference this extent, so keep it out of the free space
+ * cache until log replay at the next mount.
+ *
+ * The transaction that logged it must not commit either, since that would drop
+ * the log. Every failure after joining it aborts it, and a failed join means it
+ * already aborted or the filesystem already has an error, unless allocating
+ * the handle failed. In that case set the error here, so the commit fails to
+ * write its tree blocks and never writes a superblock.
+ */
+static void keep_logged_extent(struct btrfs_ordered_extent *oe, int error)
+{
+	struct btrfs_fs_info *fs_info = oe->inode->root->fs_info;
+	struct btrfs_block_group *bg;
+
+	if (!BTRFS_FS_ERROR(fs_info))
+		btrfs_handle_fs_error(fs_info, error, NULL);
+
+	bg = btrfs_lookup_block_group(fs_info, oe->disk_bytenr);
+	ASSERT(bg);
+	btrfs_free_reserved_bytes(bg, oe->disk_num_bytes, true);
+	btrfs_put_block_group(bg);
+}
+
 /*
  * As ordered data IO finishes, this gets called so we can finish
  * an ordered extent if the range of bytes in the file it covers are
@@ -3373,18 +3397,31 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		    clear_reserved_extent &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
+			const u64 disk_bytenr = ordered_extent->disk_bytenr;
+			const u64 disk_num_bytes = ordered_extent->disk_num_bytes;
+			bool logged;
+
 			/*
-			 * Discard the range before returning it back to the
-			 * free space pool
+			 * A fast fsync may have logged this extent. Pairs with
+			 * the end of btrfs_log_changed_extents().
 			 */
-			if (ret && btrfs_test_opt(fs_info, DISCARD_SYNC))
-				btrfs_discard_extent(fs_info,
-						ordered_extent->disk_bytenr,
-						ordered_extent->disk_num_bytes,
-						NULL, true);
-			btrfs_free_reserved_extent(fs_info,
-					ordered_extent->disk_bytenr,
-					ordered_extent->disk_num_bytes, true);
+			spin_lock(&inode->ordered_tree_lock);
+			logged = test_bit(BTRFS_ORDERED_LOGGED, &ordered_extent->flags);
+			spin_unlock(&inode->ordered_tree_lock);
+
+			if (ret && logged) {
+				keep_logged_extent(ordered_extent, ret);
+			} else {
+				/*
+				 * Discard the range before returning it back to
+				 * the free space pool
+				 */
+				if (ret && btrfs_test_opt(fs_info, DISCARD_SYNC))
+					btrfs_discard_extent(fs_info, disk_bytenr,
+							     disk_num_bytes, NULL, true);
+				btrfs_free_reserved_extent(fs_info, disk_bytenr,
+							   disk_num_bytes, true);
+			}
 			/*
 			 * Actually free the qgroup rsv which was released when
 			 * the ordered extent was created.
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e15b26f9b920..bd04dceca700 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5455,23 +5455,28 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	 * before it commits and wipes out the log trees, otherwise we would
 	 * lose data if an ordered extents completes after the transaction
 	 * commits and a power failure happens after the transaction commit.
+	 *
+	 * A failed ordered extent keeps its extent allocated only if it sees
+	 * BTRFS_ORDERED_LOGGED. It sets BTRFS_ORDERED_IOERR before checking, so
+	 * if we see IOERR here it may have already freed the extent, and this
+	 * log must not be synced.
 	 */
 	list_for_each_entry_safe(ordered, tmp, &ctx->ordered_extents, log_list) {
 		list_del_init(&ordered->log_list);
-		set_bit(BTRFS_ORDERED_LOGGED, &ordered->flags);
 
+		spin_lock(&inode->ordered_tree_lock);
+		set_bit(BTRFS_ORDERED_LOGGED, &ordered->flags);
+		if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
+			ret = -EIO;
 		if (!test_bit(BTRFS_ORDERED_COMPLETE, &ordered->flags)) {
-			spin_lock(&inode->ordered_tree_lock);
-			if (!test_bit(BTRFS_ORDERED_COMPLETE, &ordered->flags)) {
-				set_bit(BTRFS_ORDERED_PENDING, &ordered->flags);
-				atomic_inc(&trans->transaction->pending_ordered);
-			}
-			spin_unlock(&inode->ordered_tree_lock);
+			set_bit(BTRFS_ORDERED_PENDING, &ordered->flags);
+			atomic_inc(&trans->transaction->pending_ordered);
 		}
+		spin_unlock(&inode->ordered_tree_lock);
 		btrfs_put_ordered_extent(ordered);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int get_inode_size_to_log(struct btrfs_trans_handle *trans,

base-commit: 5e79ca7342fb6e8c7ead78abc422d24396cff1cf
prerequisite-patch-id: 4a028e5abff0520f479d35aa5cb8a1bc5091d1ac
-- 
2.53.0-Meta

