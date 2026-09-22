Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985AB4AA1FC
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 20:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790108054; cv=none; b=DGc5nChnyXrKwXFUwx7gH+CZJZfNGm13cHPMqNorQEc390zlAlS3q1FY0UqJ1GSTzuB1CFO+tO4d3fCsYvEQHSzi+1L8LXgszfwda1Jm+Drfcv7iSCBntrMfvv491dmysVryInjWeV9BnvA/u/oHMn44HYWaTo/35N5tNARglwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790108054; c=relaxed/simple;
	bh=5UKG/dP6lznnkMEnlKiK0Wkfa01qdud7YXhwbaIE/SA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hYlkbG2LmAQWRpKd/0V9CeliCqgONLl0t0d+E7GvAw7KUNWjB04J7YXwaJnabKF2wDSljtNbpZPeS3lY5vtzIdi0ki25+6Qe5w+ndtKpYL/+JcFNELBHeg7eHh5VOqbVEsi9yHu8fVMz5jx0iQ9/vEsz+Y99SMbU0t5zDC0Czzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nlThqyHH; arc=none smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nlThqyHH"
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-805c194bc92so466134a34.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 13:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790108047; x=1790712847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kIUFR2gU20VOIZQL1+09vW5Rk2cw6uqT6OqRrJtWoJo=;
        b=nlThqyHHdEXYe2rHSzrgLNuzf8DaRejjE2zV0vTHySBoQ2J7WLoV49CATGHXKZ3qEo
         s8Vu/60kOLx9D1iDQhBC78o84U9WfbsimQyo0GDxjb+DOr1u4UwO2LBCKYL9U+PUwH+i
         xh/wg/bU3u3IbZSskuXg5ZiXgIzy0zwAqt9brWGAes2fJgq8W+WVEb4O2OSWwwLGvUTj
         lOGF3rD/uwZufj4k8a6+9New0kww1nJ3bWwXk88FMZRmNoNg5Zyf7mr9WVOE3lXLAQcE
         /25e1SKI1qa+rOUczqEz0yBvpTTN0lBJPHSmmS9byxGZbWas2DzVUTo8ZROoQ4oWiGaI
         r/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790108047; x=1790712847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kIUFR2gU20VOIZQL1+09vW5Rk2cw6uqT6OqRrJtWoJo=;
        b=tdaCYzzmUcYw+nNedwq/XWqDBuXveMUNf4tHoWxlGsh39XvsISTk8Vp9beTiOuYQig
         o4G5756xXxvIjoNpfYp5lVNbdVBOgMFYvizbhCiNYlCOgDzGzNp4T4OJ5HOZ+tRlMF3Z
         06/DGNi8ygjWxsO8YcO02qPW3cJJ/6c/RqXpC1NCBQL0Q+h+2pAcFVShce0DlusXnLBq
         NgnDU37a6gVh0ThbgjsL2jn8YOqjYtEOfunw9V/NqwgqOsk3swLUCgAEgjneopOjszXC
         g2b+b37SqothGYZDuJwDNVHtO/738H3OoBocduA7AHQoHKNjS0jLP78AZ/KgVVoEWhq7
         afTA==
X-Forwarded-Encrypted: i=1; AKwUvBylJrZFBKkQSmf2DOTO/OSPq7Ad0j+myuKMf62TAVycnteLHL+pq4XsL1vJoH8BtVhJrqRqBZx8U+z75Q==@vger.kernel.org
X-Gm-Message-State: AFuF++mBZ9V3iUjJzcuieLVsfRaaYdvFjVadDLBsD0HcS6F/VBCTk9QD
	SmoQoaRaWcCGSp3zjAjj8LqolrU1Et37/p93xQCQXGlTS1HMECsHjHNg
X-Gm-Gg: AYBFou1+ZK0tsN0EkktuDQ4Bmc9FHpAtulkRHpD1FMic1bQKEPZJSgxZ1A5a/ANy0t2
	+BvIIzGh6UdDbHAAfSOshzv6BWr/OLCBC60qaqdoIGLbi0yaKwp5G6YETHGa+5Jswe5XXTIJXFt
	gajJ6dSX2KUC1cApstHosP1+EEbcnVJFKR50/jUEJxI4hSi4KJWJLH9SwBhs91aTcZzw9yuiVMb
	gNq8aedlVfA42jxQqfOSiqcyXtABFn6et9qe5G/f1/3APNP+PgKMlnabku8fITieMM+EW7Os+Em
	cVLWCObek7xbP4eyPyyMN2Tuswx896VA5nVuYElpt40s84aoJ/Rx43fAhcZfQrwWXnxynwC15Uv
	vyolrH4HX2RgWfbjvdxk2JWK1OQNYwYwPNT6//pNK01afT8AXeS5MoyNPpYlmyeYlbOFlZxWpSe
	92LZzjDUSLfz1bKBXdkypXjCUn9cwAtTTDXj1Gqpwj3v1s91DWUNGH7zzkKxOl+R8tRum54aTSV
	A8sqnnK1/pEXPnG6w+LHhr1RzC5vNyn62Q6g79x3DykG/5ZMNQ=
X-Received: by 2002:a05:6830:452a:b0:806:dbd8:9929 with SMTP id 46e09a7af769-815f1f4fa19mr750798a34.15.1790108047153;
        Tue, 22 Sep 2026 13:14:07 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:44::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-81603ad13f7sm621240a34.7.2026.09.22.13.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 13:14:06 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: dsterba@suse.com
Cc: boris@bur.io,
	loemra.dev@gmail.com,
	fdmanana@suse.com,
	wqu@suse.com,
	linux-btrfs@vger.kernel.org
Subject: [PATCH v1] btrfs: add LOGICAL_INO_V2 flag for avoiding the tree modification log
Date: Tue, 22 Sep 2026 13:12:57 -0700
Message-ID: <20260922201258.874070-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At Meta, we use the LOGICAL_INO_V2 ioctl to estimate sharing-aware space
usage. We sample the logical address space and resolve each sample back
to the inodes which reference it. The measurement is statistical, so
with enough samples it gives good bounds on real usage.

Currently in the LOGICAL_INO_V2 ioctl path, iterate_extent_inodes()
(which can walk backrefs either against the current trees or against the
commit roots) acquires a tree modification log sequence number when
walking the current trees, since those trees are being modified while
the walk is in progress. The log is then enabled filesystem wide for as
long as any such walk is running, and is only disabled again once the
last walk has finished.

While it is enabled the cost impacts the whole filesystem, not only the
caller. Modifications of interior nodes of the extent tree and of
subvolume trees have to be recorded, serialized on a single filesystem
wide lock. Delayed refs with a sequence number at or above the oldest
active one can not be run (the run path bails out with -EAGAIN in
btrfs_run_delayed_refs_for_head()), and metadata refs above it can not
be merged, so they accumulate and that work is deferred to transaction
commit.

Currently, userspace has no way to ask for anything cheaper. Whenever a
transaction is running, the walk uses the tree modification log, even if
the caller would tolerate results that could be up to one commit interval
stale.

Give userspace this option by adding BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT,
which makes the backref walk use the commit roots and therefore never
enables the tree modification log. Behavior is unchanged unless the flag
gets explicitly passed by userspace. iterate_extent_inodes() already
takes a search_commit_root argument for this, which scrub, send and the
data relocation warning path all pass as true. The flag simply plumbs it
through to userspace.

Assisted-by: LLM
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/btrfs/backref.c         |  6 ++++--
 fs/btrfs/backref.h         |  3 ++-
 fs/btrfs/ioctl.c           |  9 +++++++--
 include/uapi/linux/btrfs.h | 10 ++++++++++
 4 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 1be632c742bd..364ec3ad7d8a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2549,7 +2549,8 @@ static int build_ino_list(u64 inum, u64 offset, u64 num_bytes, u64 root, void *c
 }
 
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
-				void *ctx, bool ignore_offset)
+				void *ctx, bool ignore_offset,
+				bool search_commit_root)
 {
 	struct btrfs_backref_walk_ctx walk_ctx = { 0 };
 	int ret;
@@ -2575,7 +2576,8 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 		walk_ctx.extent_item_pos = logical - found_key.objectid;
 	walk_ctx.fs_info = fs_info;
 
-	return iterate_extent_inodes(&walk_ctx, false, build_ino_list, ctx);
+	return iterate_extent_inodes(&walk_ctx, search_commit_root,
+				     build_ino_list, ctx);
 }
 
 static int inode_to_path(u64 inum, u32 name_len, unsigned long name_off,
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 179791de6b19..f8dc8a3723cf 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -226,7 +226,8 @@ int iterate_extent_inodes(struct btrfs_backref_walk_ctx *ctx,
 			  iterate_extent_inodes_t *iterate, void *user_ctx);
 
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
-				void *ctx, bool ignore_offset);
+				void *ctx, bool ignore_offset,
+				bool search_commit_root);
 
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 52aab510aea0..63257f8fb897 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3286,6 +3286,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	struct btrfs_ioctl_logical_ino_args AUTO_KFREE(loi);
 	struct btrfs_data_container AUTO_KVFREE(inodes);
 	bool ignore_offset;
+	bool search_commit_root;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3296,6 +3297,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 
 	if (version == 1) {
 		ignore_offset = false;
+		search_commit_root = false;
 		size = min_t(u32, loi->size, SZ_64K);
 	} else {
 		/* All reserved bits must be 0 for now */
@@ -3303,10 +3305,12 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 			return -EINVAL;
 
 		/* Only accept flags we have defined so far */
-		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET))
+		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET |
+				   BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT))
 			return -EINVAL;
 
 		ignore_offset = loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
+		search_commit_root = loi->flags & BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT;
 		size = min_t(u32, loi->size, SZ_16M);
 	}
 
@@ -3314,7 +3318,8 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	if (IS_ERR(inodes))
 		return PTR_ERR(inodes);
 
-	ret = iterate_inodes_from_logical(loi->logical, fs_info, inodes, ignore_offset);
+	ret = iterate_inodes_from_logical(loi->logical, fs_info, inodes,
+					  ignore_offset, search_commit_root);
 	if (ret == -EINVAL)
 		return -ENOENT;
 	if (ret < 0)
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 0a13baf3d8d1..b6f196bfa600 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -732,6 +732,16 @@ struct btrfs_ioctl_logical_ino_args {
  */
 #define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
 
+/*
+ * Resolve backrefs against the commit roots instead of the current trees.
+ *
+ * Resolving against the current trees is more expensive for the filesystem as
+ * a whole, not only for the caller. Callers that do not need to observe the
+ * currently running transaction should set this. The result can be up to one
+ * commit interval stale.
+ */
+#define BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT	(1ULL << 1)
+
 enum btrfs_dev_stat_values {
 	/* disk I/O failure stats */
 	BTRFS_DEV_STAT_WRITE_ERRS, /* EIO or EREMOTEIO from lower layers */
-- 
2.52.0

