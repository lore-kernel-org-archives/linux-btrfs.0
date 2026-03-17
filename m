Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470733CB2EA
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 13:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773753933; cv=none; b=cpFRWCakFRSIUR/EWxHvS9PM54bam8NmL9naS/m2r72esv0yzT/PsPcyYDZymvKM2Ru3OfG4ybKDu1uNyuLc3t1f0xt/6Rgl70Qqe5zWgIFGztlYIjFfTukRKnkzE7PVA5JHb9IkA7QySo13je8ixQ7dh2OnqngzEpqpH6JGbK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773753933; c=relaxed/simple;
	bh=oU94TZYLxLO+mKwPpKUQSQEjVZLQD+3+8CmT7mAAP6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aCx8/Wi1iLzeCVal6BJV8Mo+DMYG6cJyHshYk/yDhDZNsbEDL+Sa9sbpCpbkGC44RGWOqD17YQAVCeK36zdn5w0ncf/6FXR1TzjX0ZEg44KYDRM1SMg27tDbpdOalQ4nlf5B+ygj1nestgHPFK0s+O4Lw3l4tOuC/btzP1HU8Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=q2Q0XgEh; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="q2Q0XgEh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773753931; x=1805289931;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oU94TZYLxLO+mKwPpKUQSQEjVZLQD+3+8CmT7mAAP6Q=;
  b=q2Q0XgEhV+T+91e0zrtXT3w7V845aJXUKD362Z9qQ6S3Vvn3ucDfML9Z
   iapVIy7SY9zM1PFShbX3LVFtCy174qcHOckwkIVGeItDqRKwPseDx3wEm
   0IEb4s0QRKc1NBUoXzjdE5nn0aV3g6Pk3d1BTD+mOhP8C+tCr1Q2aCHDs
   I27EJjwaeX3c0CzYVycGf5piCNLm5PSxKQPo17AQ9Lz/7Apa7I8Ge5QpR
   VSLfzpaqPwfeJ4xg4wetMiI+s+6RwRAjQuwHW4XW9dIvDE6D3wHf6j1Hz
   Ffeu0KkhFvkA/R9W1ZWnvSvZdDjvtMlR1U3Of1Yj09Sd3KQYEwKYNQGU2
   g==;
X-CSE-ConnectionGUID: UNdlzYIZSo+Im5+KG5UYOg==
X-CSE-MsgGUID: HpZHvE9zR6KVmCoJ+jAVnw==
X-IronPort-AV: E=Sophos;i="6.23,124,1770566400"; 
   d="scan'208";a="143210006"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2026 21:25:30 +0800
IronPort-SDR: 69b95649_B5YepvK4Gr9p0LGAriAiD02bWJ3Dc/yClmpVHKeZVqdy8GL
 IA6cK4Tf4fvlZ51RyvNkFTldb9qvlfBymudFUDg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Mar 2026 06:25:30 -0700
WDCIronportException: Internal
Received: from wdap-vh2k8asv8j.ad.shared (HELO neo.fritz.box) ([10.224.26.8])
  by uls-op-cesaip02.wdc.com with ESMTP; 17 Mar 2026 06:25:29 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: decrease indendation of find_free_extent_update_loop
Date: Tue, 17 Mar 2026 14:25:26 +0100
Message-ID: <20260317132526.299099-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Decrease the indendation of find_free_extent_update_loop(), by inverting
the check if the loop state is smaller than LOOP_NO_EMPTY_SIZE.

This also allows for an early return from find_free_extent_update_loop(),
in case LOOP_NO_EMPTY_SIZE is already set at this point.

While at if change a

if () {
}
else if
else

pattern to all using curly braces and be consistent with the rest of btrfs
code.

No functional changes intended.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent-tree.c | 111 +++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a55b910c755b..062fc1beb26b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4349,71 +4349,74 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 		return 1;
 
 	/* See the comments for btrfs_loop_type for an explanation of the phases. */
-	if (ffe_ctl->loop < LOOP_NO_EMPTY_SIZE) {
-		ffe_ctl->index = 0;
-		/*
-		 * We want to skip the LOOP_CACHING_WAIT step if we don't have
-		 * any uncached bgs and we've already done a full search
-		 * through.
-		 */
-		if (ffe_ctl->loop == LOOP_CACHING_NOWAIT &&
-		    (!ffe_ctl->orig_have_caching_bg && full_search))
-			ffe_ctl->loop++;
+	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE)
+		return -ENOSPC;
+
+	ffe_ctl->index = 0;
+	/*
+	 * We want to skip the LOOP_CACHING_WAIT step if we don't have
+	 * any uncached bgs and we've already done a full search
+	 * through.
+	 */
+	if (ffe_ctl->loop == LOOP_CACHING_NOWAIT &&
+	    (!ffe_ctl->orig_have_caching_bg && full_search))
 		ffe_ctl->loop++;
+	ffe_ctl->loop++;
 
-		if (ffe_ctl->loop == LOOP_ALLOC_CHUNK) {
-			struct btrfs_trans_handle *trans;
-			int exist = 0;
+	if (ffe_ctl->loop == LOOP_ALLOC_CHUNK) {
+		struct btrfs_trans_handle *trans;
+		int exist = 0;
 
-			/* Check if allocation policy allows to create a new chunk */
-			ret = can_allocate_chunk(fs_info, ffe_ctl);
-			if (ret)
-				return ret;
+		/* Check if allocation policy allows to create a new chunk */
+		ret = can_allocate_chunk(fs_info, ffe_ctl);
+		if (ret)
+			return ret;
 
-			trans = current->journal_info;
-			if (trans)
-				exist = 1;
-			else
-				trans = btrfs_join_transaction(root);
+		trans = current->journal_info;
+		if (trans)
+			exist = 1;
+		else
+			trans = btrfs_join_transaction(root);
 
-			if (IS_ERR(trans))
-				return PTR_ERR(trans);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 
-			ret = btrfs_chunk_alloc(trans, space_info, ffe_ctl->flags,
-						CHUNK_ALLOC_FORCE_FOR_EXTENT);
+		ret = btrfs_chunk_alloc(trans, space_info, ffe_ctl->flags,
+					CHUNK_ALLOC_FORCE_FOR_EXTENT);
 
-			/* Do not bail out on ENOSPC since we can do more. */
-			if (ret == -ENOSPC) {
-				ret = 0;
-				ffe_ctl->loop++;
-			}
-			else if (ret < 0)
-				btrfs_abort_transaction(trans, ret);
-			else
-				ret = 0;
-			if (!exist)
-				btrfs_end_transaction(trans);
-			if (ret)
-				return ret;
+		/* Do not bail out on ENOSPC since we can do more. */
+		if (ret == -ENOSPC) {
+			ret = 0;
+			ffe_ctl->loop++;
+		} else if (ret < 0) {
+			btrfs_abort_transaction(trans, ret);
+		} else {
+			ret = 0;
 		}
 
-		if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
-			if (ffe_ctl->policy != BTRFS_EXTENT_ALLOC_CLUSTERED)
-				return -ENOSPC;
+		if (!exist)
+			btrfs_end_transaction(trans);
 
-			/*
-			 * Don't loop again if we already have no empty_size and
-			 * no empty_cluster.
-			 */
-			if (ffe_ctl->empty_size == 0 &&
-			    ffe_ctl->empty_cluster == 0)
-				return -ENOSPC;
-			ffe_ctl->empty_size = 0;
-			ffe_ctl->empty_cluster = 0;
-		}
-		return 1;
+		if (ret)
+			return ret;
+	}
+
+	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
+		if (ffe_ctl->policy != BTRFS_EXTENT_ALLOC_CLUSTERED)
+			return -ENOSPC;
+
+		/*
+		 * Don't loop again if we already have no empty_size and
+		 * no empty_cluster.
+		 */
+		if (ffe_ctl->empty_size == 0 &&
+		    ffe_ctl->empty_cluster == 0)
+			return -ENOSPC;
+		ffe_ctl->empty_size = 0;
+		ffe_ctl->empty_cluster = 0;
 	}
-	return -ENOSPC;
+
+	return 1;
 }
 
 static int prepare_allocation_clustered(struct btrfs_fs_info *fs_info,
-- 
2.53.0

