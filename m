Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3286B3A453E
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 09:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774344005; cv=none; b=qIvnx3quz4Y2c+ThNj2M/484wrCRr+Jnd91T4ml6ZZdqE6x5jXdJ4xisvXxb9svogXz9UsIzSCm9XRS9DsdHQvkhlm7dNE8iSpQuD9rdh0c6TTyIwTv6Iox3VjVrCLYyp3yJm7Aey4dZ1wi3H97iZEwPDjqxD0N2plWxQbE6pBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774344005; c=relaxed/simple;
	bh=p3bdazt4F12OhT4yNttbPfhMOLrrGmAvbvjrJLyH/nA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fl38EYIOUqCWxW/a04pOaOofltmzelJVn/6fwEDO8vRq7yF6QKQ4mLql7+r9Ae24DpUyb+Rl3AN9yHzNxu3uXxL8S0o4ki1DnYjyzq64gIYkJGflU58KyDNEICBCx6+620XpHHE8dqRDcTX+rifQ5/i/oYqWOBmSsygEM41+f5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q+uBdITy; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q+uBdITy"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2adff872068so17102085ad.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 02:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774343996; x=1774948796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R1UeBCmm5qx7DRZKH+TRJDv3MSAv2BY6DtyQVb7uE60=;
        b=q+uBdITyZsmBbSXJ6ge61bCgQkfjr9cHbvQ3VHfuYb22va9y9R/Vq4A0j0Ernulnkv
         Lj6VvckY97LzrpBGU+hMxo3GR8ZzJexdi9mo4t2coiGyHdxPtffMcbxhqY178wCHHlwi
         eBn5hGcQ7DWxX3lnZM41cbE+3DIjqhjNv+TKoHlyv3qob4Q+PvRwm8f2kUzUUouZ+rwk
         HLcIdbudlmw4RPwk31HXSRFMd255vKqZMEyxGKzcQZZ0+eNsdPg9BY46fNODrXWZ3io4
         7ORnNUlqbMwG10XhGjgHlIoFq5W7TMU5Tn3hvu7ZxdQbcJzFskp01n/qV2a1OdzArWxH
         Zhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774343996; x=1774948796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1UeBCmm5qx7DRZKH+TRJDv3MSAv2BY6DtyQVb7uE60=;
        b=PC3vR3IbqEp3HvAP1B5Pqyb3gJBrg81ArKQcS82GhhhFlBhO2v4QmNDt5fl8LK+uHb
         BZAPZpRstT4vmu+9DU+KVRzP3dJRzVS8kHKogSrkUf1O0XuKj471CRllF1fJjU3ETSZQ
         4fravunnE+x2ONErwuKiaLfhm1YvkaXKdMnJU9shx3UJDnWZHV2MIRofmPsYukg4CR5d
         WRsGlh4FPB4EcHDV9BRkC9MLsvEpl+XqeZ3SPsakRQ1bjSqyQyxcHFNeMspQxNI2xZoF
         43J/WQjdf1DATW1jMxCOszEaoyI70DCX1n+w9VYVT9roZ0W/4O0Us2+gx/MM+wrUmQ0C
         LVNQ==
X-Forwarded-Encrypted: i=1; AJvYcCU24TBoXXtV3mP/jYtZiSe1VHyCpWxkhThnQcAbjrUqnPVxVltiPW6QxxfjkOW0mTf/XT4uc8NEGcLw+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqZmGEe/PP/n8EkVHYRgL1U2SP9Mcsd9rG/HNCL/vZ+g/n7SqS
	E9J+1nzr1NOJr3u0at8h8Jz/a6BsQqUyWcMnuVWHHFry2NcGb4VHDRK3
X-Gm-Gg: ATEYQzyxsdZdw/pEnrkJzjFbI6ht7coet2kb18s0cXwaBqns+gpZXcjnqv2Nm1fuf1X
	Zs7fXGu7yaj5Jcdg8YIEtzdoOAXag0YpJlqUPjZn8k05JKGIyOQ00zPWv1PQTYnzuEazeqjZ/Ou
	k41iAfZHSVyBbSFlz87NWzDx8qECHVLZ+3StzX7f29dZkdy2F8w8IpmZJ58rBqhVCbyOlAZNYl6
	YnjHDb4gI7fYz9CZKOZCidTFuJms3SzJYXnplFBcTX+7O/LigB532D6FM6+Ef2ueeLquJQiA/ii
	QRgsG8dbkGv9J5lpC4tOGJXKj4E02PRiubcQDtsoKyFHnqEEPz8PEd57yxEoD4Q18GSA3s9jBPc
	yzMTE4XxHp4R2PULisxxLzHob984ujlZwa6FQ0pA+oTNyDgBGXske+oG5oGTuGhwkEofgiXBgWE
	53TiG9ts4tU4AqRipuQQ==
X-Received: by 2002:a17:902:e752:b0:2ae:cb0e:fd74 with SMTP id d9443c01a7336-2b0827a76d3mr146885405ad.24.1774343995940;
        Tue, 24 Mar 2026 02:19:55 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083655b5dsm172688005ad.52.2026.03.24.02.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 02:19:55 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: clm@fb.com
Cc: dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	zzzccc <1539412714@qq.com>,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH] btrfs: add btrfs_inode_disk_i_size() helper to prevent torn reads of disk_i_size
Date: Tue, 24 Mar 2026 17:01:59 +0800
Message-Id: <20260324090200.3932789-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: zzzccc <1539412714@qq.com>

btrfs_inode::disk_i_size is a u64 field updated under inode->lock by
btrfs_inode_safe_disk_i_size_write(), but several read sites access it
without holding that lock.  On 64-bit platforms this is fine because
aligned u64 loads are architecturally atomic, but on 32-bit platforms a
u64 load is performed as two 32-bit loads which can tear if a concurrent
write updates both halves.

A torn read of disk_i_size is dangerous in the metadata-serialization
paths (fill_inode_item, fill_stack_inode_item) because the torn value
gets persisted to the B-tree on disk.  After a crash, fsck / mount would
see a file size that never existed:
  - If the torn value is too large, stale data beyond the real EOF is
    exposed (information leak).
  - If the torn value is too small (e.g. zero), file data is silently
    lost.

Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/btrfs/btrfs_inode.h   | 24 ++++++++++++++++++++++++
 fs/btrfs/delayed-inode.c |  2 +-
 fs/btrfs/file.c          |  2 +-
 fs/btrfs/inode.c         |  6 +++---
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 55c272fe5d92..7aff326bedbb 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -418,6 +418,30 @@ static inline void btrfs_i_size_write(struct btrfs_inode *inode, u64 size)
 	inode->disk_i_size = size;
 }
 
+/*
+ * Get the on-disk file size safely without holding inode->lock.
+ *
+ * disk_i_size is protected by inode->lock when being written (see
+ * btrfs_inode_safe_disk_i_size_write()), but several read sites access
+ * it without that lock.  On 64-bit platforms a plain READ_ONCE() is
+ * sufficient because aligned u64 loads are atomic.  On 32-bit platforms
+ * a u64 load can tear, so we take the spinlock to guarantee a consistent
+ * snapshot.
+ */
+static inline u64 btrfs_inode_disk_i_size(struct btrfs_inode *inode)
+{
+#if BITS_PER_LONG == 32
+	u64 size;
+
+	spin_lock(&inode->lock);
+	size = inode->disk_i_size;
+	spin_unlock(&inode->lock);
+	return size;
+#else
+	return READ_ONCE(inode->disk_i_size);
+#endif
+}
+
 static inline bool btrfs_is_free_space_inode(const struct btrfs_inode *inode)
 {
 	return test_bit(BTRFS_INODE_FREE_SPACE_INODE, &inode->runtime_flags);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 56ff8afe9a22..86be9d1bee55 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1841,7 +1841,7 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 
 	btrfs_set_stack_inode_uid(inode_item, i_uid_read(vfs_inode));
 	btrfs_set_stack_inode_gid(inode_item, i_gid_read(vfs_inode));
-	btrfs_set_stack_inode_size(inode_item, inode->disk_i_size);
+	btrfs_set_stack_inode_size(inode_item, btrfs_inode_disk_i_size(inode));
 	btrfs_set_stack_inode_mode(inode_item, vfs_inode->i_mode);
 	btrfs_set_stack_inode_nlink(inode_item, vfs_inode->i_nlink);
 	btrfs_set_stack_inode_nbytes(inode_item, inode_get_bytes(vfs_inode));
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a4cb9d3cfc4e..dcd306f669d8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -178,7 +178,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	if (args->drop_cache)
 		btrfs_drop_extent_map_range(inode, args->start, args->end - 1, false);
 
-	if (data_race(args->start >= inode->disk_i_size) && !args->replace_extent)
+	if (args->start >= btrfs_inode_disk_i_size(inode) && !args->replace_extent)
 		modify_tree = 0;
 
 	update_refs = (btrfs_root_id(root) != BTRFS_TREE_LOG_OBJECTID);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index afc5d75d2dcb..5c75c949e855 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -837,7 +837,7 @@ static inline void inode_should_defrag(struct btrfs_inode *inode,
 {
 	/* If this is a small write inside eof, kick off a defrag */
 	if (num_bytes < small_write &&
-	    (start > 0 || end + 1 < inode->disk_i_size))
+	    (start > 0 || end + 1 < btrfs_inode_disk_i_size(inode)))
 		btrfs_add_inode_defrag(inode, small_write);
 }
 
@@ -4264,7 +4264,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 
 	btrfs_set_inode_uid(leaf, item, i_uid_read(inode));
 	btrfs_set_inode_gid(leaf, item, i_gid_read(inode));
-	btrfs_set_inode_size(leaf, item, BTRFS_I(inode)->disk_i_size);
+	btrfs_set_inode_size(leaf, item, btrfs_inode_disk_i_size(BTRFS_I(inode)));
 	btrfs_set_inode_mode(leaf, item, inode->i_mode);
 	btrfs_set_inode_nlink(leaf, item, inode->i_nlink);
 
@@ -5455,7 +5455,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 			ret2 = btrfs_wait_ordered_range(BTRFS_I(inode), 0, (u64)-1);
 			if (ret2)
 				return ret2;
-			i_size_write(inode, BTRFS_I(inode)->disk_i_size);
+			i_size_write(inode, btrfs_inode_disk_i_size(BTRFS_I(inode)));
 		}
 	}
 
-- 
2.34.1

