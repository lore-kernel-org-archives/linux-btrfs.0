Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01C738737A
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773393578; cv=none; b=GZOhawnikcEI3ZqyCG1oscuKkE/SGbcwda5XtPqSWkybA6GfofPo3tIi1xzuYN0OfavONoZGAgvJ1IopfdQ0hg0iGMqlpv2C5bVdONOhnjJ3cygXI8nM3AxEq5ad58gV5RQkhePswtRwbBfEFU1fnvuKRFMnF81d0sD7Q7U9Rt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773393578; c=relaxed/simple;
	bh=FWu6tPjDmTZWot86Gn2D7mJtq0N2N8QUEU4pkK23KDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBk278y5jQKWcdBhftLuNMDN+HdIG2fY7RhcXK0qTobklKrzth2YS4X+fIpyc7amVNRouimdwyg2hZxiCK3Rw36SAS0V6z/4JoUnRnzQoLBHJdzHol7BA3bQWeiU3g0w33jJYjY33WjYDGSya+YW1r2PrJ7Ctu3FjyvlrSPbPiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OP77kA3K; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OP77kA3K"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aec9255e04so6947985ad.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 02:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773393577; x=1773998377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDCQazt9i8yqJpCaeowDxLqYJ0vL7DVtVMhK6VL3FYA=;
        b=OP77kA3KHnBn1o46G1k9VIzM5cS/QNO4cSHkQbbJponJzzHQo8yELjTDdSn87LPexd
         PQvpIZpg0piTKnwNw7HOoZrdfvEE3GVT/VpMiR45YIqaluIn4LjC0lViGDq2dlOzOoF0
         QonSQHAO+l0cNFWLqmaT7MwKym7E+89buMSkAtANhkrk8x/mJLcFEdaNgaY0UHnfXoy5
         DS0mo9YdJkEk2zslVVl19Rq8BVToAsGmAI2SWLpc/Mfo/cktVxTSLm1Z/LT9PEk+pIrX
         OZuptU3niV24o45i5/ei7m45900dTiq+ep31zMcmXcGTByL2a0v9o+2AWTMLGhJnRGM2
         ZyQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773393577; x=1773998377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YDCQazt9i8yqJpCaeowDxLqYJ0vL7DVtVMhK6VL3FYA=;
        b=TEnDa5gXY08nSdqMeylFkSbNgXmijN42gmGNPBaTF3LD9uo6wfnPPrui4F9AEF/ugd
         DvBRBXssaX/h5Usy1Y6pwBvExNtitl3ZNsngFcgQGcDlxuRTujjIb4A/05vJmkmz7jK+
         B05ZEsWwm4niU/AMFDW6BhO0Y/k91D438khkjOla/jsdVS7mY5pADRVODxNudnS5zpJh
         076BLXrCVjN2pYCvC5YNdM01prZ2OJugKouvlNLWZfdI4225LDk6puViQ8BXGppiLytM
         9XMubgaw8Kfc3Y8f7cFdrlCcYFNMWey+GwHtNfrEUFGqedpn9TnkUMX2RPZdQNb5gxN2
         Dgqg==
X-Forwarded-Encrypted: i=1; AJvYcCVdJA++2hF8bQ9PsmP2f1AqCtVYbTjSgJ23CMxjeeXuKYaX3waEbZkxwfYv3Ehql1MvA+8pnDZEsFFTlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfIEbNkEI4lXRHnNm1LEzQtY+4k5CnB6vbu4LhCX9UDWLQQbpA
	Ic5G8wunnQOShBvO4cEaLft8OzoMFsluK4MfZnw50viNaLPKDDX3QGMR
X-Gm-Gg: ATEYQzzaSs3Eac5/XyM449ooxF2nJuoIBQr+3/zsrcgIVGSvK09ahkinRZPhdQK2eFt
	uQvUvmd5je5OXZcU6GeArIsJoXDeK8Aquc+kbYqeKrLwOYPn+04C9lc0YdVU7ingIyHuM4gxcfR
	0wbO19/2o7GxidngBIQ2pGsHU6ndGpvZtAJ/yF+WFz3IlXJk3ksi4fizEpea2JGPW+fmnDEp4cn
	eHQP0TXLtPjALywXYo5kwgG5chB9JKR5vallq46wi4XWioQdAm4720PtBlLhXfeHWcbnaWHEVqW
	3IUyvA3lQt1ecby5PJWib9QNiSk1KWAcoQFtsDBLnSWLvlfLSxtcFbvUhlHP5f8wHIjwVw6oxsQ
	X0uFGbUa94NsnDTuZDpWDCO9iu2+fM2eFoJduWfr3bjxaMMy0Pr7nwiuw/H/7y7n4rlmMIX9LP1
	kce8qnR1TwMp6A5hTywCy2smq+jA7OF9+IZa/abyGtMBVCUHTQ9FQYKbmUUBNCmFhQXaG6BsM=
X-Received: by 2002:a17:903:181:b0:2ae:456d:b836 with SMTP id d9443c01a7336-2aecac98716mr23178895ad.47.1773393576883;
        Fri, 13 Mar 2026 02:19:36 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ee1d8sm16742135ad.55.2026.03.13.02.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 02:19:36 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com
Cc: wqu@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2 1/2] btrfs: add tree parent check to btrfs_buffer_uptodate()
Date: Fri, 13 Mar 2026 17:19:23 +0800
Message-ID: <20260313091924.570554-2-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260313091924.570554-1-gality369@gmail.com>
References: <20260313091924.570554-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_buffer_uptodate() only checks whether an extent buffer is uptodate
and whether its generation matches the expected parent transid.

For callers that also need tree-parent verification, this is not enough on
a cache hit, because a cached extent buffer can be reported uptodate
without being checked against the expected level/first_key constraints.

Extend btrfs_buffer_uptodate() to take an optional
btrfs_tree_parent_check so cached buffers can be verified before being
reported uptodate.

For now all callers pass NULL, so there is no functional change. A
follow-up patch will use the new argument on the relevant cached-hit path.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/ctree.c       |  2 +-
 fs/btrfs/disk-io.c     | 14 +++++++++++---
 fs/btrfs/disk-io.h     |  3 ++-
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/extent_io.c   |  2 +-
 fs/btrfs/tree-log.c    |  2 +-
 6 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 561658aca018..c008b847200a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1493,7 +1493,7 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 			reada_for_search(fs_info, p, parent_level, slot, key->objectid);
 
 		/* first we do an atomic uptodate check */
-		if (btrfs_buffer_uptodate(tmp, check.transid, true) > 0) {
+		if (btrfs_buffer_uptodate(tmp, check.transid, true, NULL) > 0) {
 			/*
 			 * Do extra check for first_key, eb can be stale due to
 			 * being cached, read from scrub, or have multiple
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 900e462d8ea1..8773f1f7ea46 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -116,13 +116,21 @@ static void csum_tree_block(struct extent_buffer *buf, u8 *result)
  * detect blocks that either didn't get written at all or got written
  * in the wrong place.
  */
-int btrfs_buffer_uptodate(struct extent_buffer *eb, u64 parent_transid, bool atomic)
+int btrfs_buffer_uptodate(struct extent_buffer *eb, u64 parent_transid, bool atomic,
+			  const struct btrfs_tree_parent_check *check)
 {
 	if (!extent_buffer_uptodate(eb))
 		return 0;
 
-	if (!parent_transid || btrfs_header_generation(eb) == parent_transid)
+	if (!parent_transid || btrfs_header_generation(eb) == parent_transid) {
+		/*
+		 * On a cache hit, the caller may still need tree parent
+		 * verification before reusing the buffer.
+		 */
+		if (check && btrfs_verify_level_key(eb, check))
+			return -EUCLEAN;
 		return 1;
+	}
 
 	if (atomic)
 		return -EAGAIN;
@@ -1046,7 +1054,7 @@ static struct btrfs_root *read_tree_root_path(struct btrfs_root *tree_root,
 		root->node = NULL;
 		goto fail;
 	}
-	if (unlikely(!btrfs_buffer_uptodate(root->node, generation, false))) {
+	if (unlikely(!btrfs_buffer_uptodate(root->node, generation, false, NULL))) {
 		ret = -EIO;
 		goto fail;
 	}
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 57920f2c6fe4..aef106484dbe 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -106,7 +106,8 @@ static inline struct btrfs_root *btrfs_grab_root(struct btrfs_root *root)
 void btrfs_put_root(struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct btrfs_trans_handle *trans,
 			     struct extent_buffer *buf);
-int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid, bool atomic);
+int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid, bool atomic,
+			  const struct btrfs_tree_parent_check *check);
 int btrfs_read_extent_buffer(struct extent_buffer *buf,
 			     const struct btrfs_tree_parent_check *check);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dc4ca98c3780..54daa8672272 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5584,7 +5584,7 @@ static int check_next_block_uptodate(struct btrfs_trans_handle *trans,
 
 	generation = btrfs_node_ptr_generation(path->nodes[level], path->slots[level]);
 
-	if (btrfs_buffer_uptodate(next, generation, false))
+	if (btrfs_buffer_uptodate(next, generation, false, NULL))
 		return 0;
 
 	check.level = level - 1;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 14da72a9a950..93eed1d3716c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4574,7 +4574,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 	if (IS_ERR(eb))
 		return;
 
-	if (btrfs_buffer_uptodate(eb, gen, true)) {
+	if (btrfs_buffer_uptodate(eb, gen, true, NULL)) {
 		free_extent_buffer(eb);
 		return;
 	}
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 30f3c3b849c1..ff1a83d26598 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -456,7 +456,7 @@ static int process_one_buffer(struct extent_buffer *eb,
 			return ret;
 		}
 
-		if (btrfs_buffer_uptodate(eb, gen, false) && level == 0) {
+		if (btrfs_buffer_uptodate(eb, gen, false, NULL) && level == 0) {
 			ret = btrfs_exclude_logged_extents(eb);
 			if (ret)
 				btrfs_abort_transaction(trans, ret);
-- 
2.43.0

