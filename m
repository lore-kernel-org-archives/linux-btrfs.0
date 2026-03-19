Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25973E958E
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773964155; cv=none; b=Hm+WoIWruTBxEdJHTY/QP3b6wJPBLtc6Eg0qh9uuYZaZe/kxvlZaKZQFtjF05NQYmtqashOADeNgmKtUT4/sC/ab/evYK68oIbokyFUNGifStMw8APQQc2dxGzl6eAt/T3ElFGVjGJmMcc9kgYEF40y4wdQcZobFWTtvBGVb37E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773964155; c=relaxed/simple;
	bh=rRD5ZludA6VlSKPhCxvU8WbOFoLdup/czN+fOv9PAkc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rwe3vMq0A2D0n8i/mL9HY3DjHRVxoYpIJ+8lgcvDtNPZJUjiRwoMM3xdQMVca5EGszQ6zlT/6cOGJYAs8TZHnhlGRhaDNBJLN6Z/Zm8B1j887cTSjTlgQEduHp3UpXCrObK4d0Ckeb9xf/G2QRg2y5b8UjW7OSICsmOIIt8G/No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hixm7et5; arc=none smtp.client-ip=209.85.128.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hixm7et5"
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-7982c3b7dfcso12993927b3.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 16:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773964152; x=1774568952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qJb6OZt1WAWED6nRaqGxNidc+dvuYdrMIW8g1vW0gjY=;
        b=Hixm7et5xw7sisdJ47WrD57XiaUsWibVmPEOblAaBly6eN3g/TDkgYZpy+O71FgERA
         Qb3G8F5IM5wsQKRy3ovwBBsqN/zTBuPBb0xdJn/k3Lb6kGTTRspMV5cLzHRaVNd2q1u1
         b3Qr5734nWcNRcXzk/HjTZNIK1kr0eZw0jMw2gy/Dy5tJvZ6n4Us7PyP+K602PeX8rtN
         ILpR/1q3pOWv7rBPXZw2SoajVl03HlzcK7ve2cdvwbQLPAN++vEGt/LwrFjOWrk4Tr/R
         uA3JCeaGzoUIchw0nQt1DR1Yoji5SDaqu4LEpwVjrV7gTcKXSw2ubUhOrmFBS2CDaP/L
         VsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773964152; x=1774568952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJb6OZt1WAWED6nRaqGxNidc+dvuYdrMIW8g1vW0gjY=;
        b=sirJDqfx/DeAgF1vZS5G6WcOQLlgE2Q0Yk3ieyNblMtA+kvY+eckMMCOLsrtqt4UYq
         vbuLKWfNs6jFVD2kdZ+LrN6/Fn3nUlhWy60VMt9QRoVwnmjKw+VsnqwUJ8QbtKXWpHw4
         1QWbGreQRqSQA79fBz3ZpeFie8Uziy1ISLBxNx5WOpyZDSGX05OVJaZuKpZDnelanoTK
         Cg9W1y26pjIRQNyGtdnxnLavfl8+OS8LKbD8WlMqhQ39oyjnwi3jjnQX/Q4/Gy9QQD0T
         vbnGye4KxT3Ta/d0bw5W0//k3zNpzB27y5WNeUlfqsZcrZXm/FjQvri+5u5ZYTpCpG7p
         PGfg==
X-Gm-Message-State: AOJu0YwNBydEH6glcfO41IKLzO43uQOSG92DmOmvKzvbLYdE+7Isk5w2
	pJX1fuRMwfoKzhqPqWQD6l1yeJsWm6xWisR7tuH9T17+Ao0x2F/DCLDGYuYKa/0v
X-Gm-Gg: ATEYQzyzOxH7qpXP9sULRCxe4SU04Me1z0hl0CfgLK2VP0plUfWnrGrt2pp1ZnOb8F6
	kUpUJzw4mOvX0ZIOAogDjl7IUeSBCBaj/ulTgP9iIp7h88NzCuMs9yyifHbKWie7aS1Idy075I3
	cwglUFCDHYWoShkaYZHM8xyhvcwz4xs8DHgYfdMVrk+P2hopeknwGYERkKkjyjLh+SRhyIawSkg
	OkoCWuBp+LdSMJxxG2UB4zcfqH2DOkHLA/9wWsCnKBVNsMlZRQ6okLRJX9wLiwqQUoTSElgGBJL
	w/gKIBlXL1AGm16Wbo24RK2FrTWLiuqPH69PdGbNETrqqP1p65Gl0m8zLqhCDSHEJcneNRJqZyr
	JS55IHFRi/cnSxApubQFPEdEOa6F8X1aC4+vdX6+PqI+ll1WocXk1eAN8jEGXH2bMXeldKTrxIF
	hhjKY8MkD5HTmCDVNxgg==
X-Received: by 2002:a05:690c:d88:b0:798:7821:8b8c with SMTP id 00721157ae682-79a90c25bc0mr11298657b3.49.1773964152283;
        Thu, 19 Mar 2026 16:49:12 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a9057ff43sm6160517b3.39.2026.03.19.16.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 16:49:11 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs: avoid GFP_ATOMIC allocations in qgroup free paths
Date: Thu, 19 Mar 2026 16:49:08 -0700
Message-ID: <44a36cda2b9cdc4a600c942c051f9e028239308b.1773941507.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When qgroups are enabled, __btrfs_qgroup_release_data() and
qgroup_free_reserved_data() pass an extent_changeset to
btrfs_clear_record_extent_bits() to track how many bytes had their
EXTENT_QGROUP_RESERVED bits cleared. Inside the extent IO tree spinlock,
add_extent_changeset() calls ulist_add() with GFP_ATOMIC to record each
changed range. If this allocation fails, it hits a BUG_ON and panics the
kernel.

However, both of these callers only read changeset.bytes_changed
afterwards — the range_changed ulist is populated and immediately freed
without ever being iterated. The GFP_ATOMIC allocation is entirely
unnecessary for these paths.

Introduce extent_changeset_init_bytes_only() which uses a sentinel value
(EXTENT_CHANGESET_BYTES_ONLY) on the ulist's prealloc field to signal
that only bytes_changed should be tracked. add_extent_changeset() checks
for this sentinel and returns early after updating bytes_changed,
skipping the ulist_add() call entirely. This eliminates the GFP_ATOMIC
allocation and makes the BUG_ON unreachable for these paths.

Callers that need range tracking (qgroup_reserve_data,
qgroup_unreserve_range, btrfs_qgroup_check_reserved_leak) continue to
use extent_changeset_init() and are unaffected.

Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
 fs/btrfs/extent-io-tree.c |  2 ++
 fs/btrfs/extent_io.h      | 23 ++++++++++++++++++++++-
 fs/btrfs/qgroup.c         |  5 +++--
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index b1b96eb5f64e..bdef41d492a3 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -195,6 +195,8 @@ static int add_extent_changeset(struct extent_state *state, u32 bits,
 	if (!set && (state->state & bits) == 0)
 		return 0;
 	changeset->bytes_changed += state->end - state->start + 1;
+	if (!extent_changeset_tracks_ranges(changeset))
+		return 0;
 	ret = ulist_add(&changeset->range_changed, state->start, state->end,
 			GFP_ATOMIC);
 	return ret;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c11890ae16c7..8696d13b043f 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -199,6 +199,25 @@ static inline void extent_changeset_init(struct extent_changeset *changeset)
 	ulist_init(&changeset->range_changed);
 }
 
+/*
+ * Sentinel value for range_changed.prealloc indicating that the changeset
+ * only tracks bytes_changed and does not record individual ranges. This
+ * avoids GFP_ATOMIC allocations inside add_extent_changeset() when the
+ * caller doesn't need to iterate the changed ranges afterwards.
+ */
+#define EXTENT_CHANGESET_BYTES_ONLY	((struct ulist_node *)1)
+
+static inline void extent_changeset_init_bytes_only(struct extent_changeset *changeset)
+{
+	changeset->bytes_changed = 0;
+	changeset->range_changed.prealloc = EXTENT_CHANGESET_BYTES_ONLY;
+}
+
+static inline bool extent_changeset_tracks_ranges(const struct extent_changeset *changeset)
+{
+	return changeset->range_changed.prealloc != EXTENT_CHANGESET_BYTES_ONLY;
+}
+
 static inline struct extent_changeset *extent_changeset_alloc(void)
 {
 	struct extent_changeset *ret;
@@ -213,6 +232,7 @@ static inline struct extent_changeset *extent_changeset_alloc(void)
 
 static inline void extent_changeset_prealloc(struct extent_changeset *changeset, gfp_t gfp_mask)
 {
+	ASSERT(extent_changeset_tracks_ranges(changeset));
 	ulist_prealloc(&changeset->range_changed, gfp_mask);
 }
 
@@ -221,7 +241,8 @@ static inline void extent_changeset_release(struct extent_changeset *changeset)
 	if (!changeset)
 		return;
 	changeset->bytes_changed = 0;
-	ulist_release(&changeset->range_changed);
+	if (extent_changeset_tracks_ranges(changeset))
+		ulist_release(&changeset->range_changed);
 }
 
 static inline void extent_changeset_free(struct extent_changeset *changeset)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 20173563231e..9db09a920bdb 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4357,7 +4357,7 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 	u64 freed = 0;
 	int ret;
 
-	extent_changeset_init(&changeset);
+	extent_changeset_init_bytes_only(&changeset);
 	len = round_up(start + len, root->fs_info->sectorsize);
 	start = round_down(start, root->fs_info->sectorsize);
 
@@ -4422,7 +4422,7 @@ static int __btrfs_qgroup_release_data(struct btrfs_inode *inode,
 	WARN_ON(!free && reserved);
 	if (free && reserved)
 		return qgroup_free_reserved_data(inode, reserved, start, len, released);
-	extent_changeset_init(&changeset);
+	extent_changeset_init_bytes_only(&changeset);
 	ret = btrfs_clear_record_extent_bits(&inode->io_tree, start, start + len - 1,
 					     EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
@@ -4677,6 +4677,7 @@ void btrfs_qgroup_check_reserved_leak(struct btrfs_inode *inode)
 
 	WARN_ON(ret < 0);
 	if (WARN_ON(changeset.bytes_changed)) {
+		ASSERT(extent_changeset_tracks_ranges(&changeset));
 		ULIST_ITER_INIT(&iter);
 		while ((unode = ulist_next(&changeset.range_changed, &iter))) {
 			btrfs_warn(inode->root->fs_info,
-- 
2.52.0

