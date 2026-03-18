Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3F133D51A
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 07:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773818232; cv=none; b=VAYNaFsAzR4RpttKC2Ovcmgf7EKCBoy6dSYCgEbmHOCuNNaKuIU9/lnb4NMRqJQUjbaRnGOgBLhfZEGAleGNEQLP95+PU0RQId1ioS+AFvZXHK5ISBzPIS7ykU+R8+FqhlPjbIiONuBZdzIV3n7KEb5UEPCa95IdYzA/0jg3iuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773818232; c=relaxed/simple;
	bh=x1Jfje1icMUM629FUkcNmc6H5eZSd8v9huoPr4Av7o4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IMosPBxWCVhOSkLamDSLdpq4kVyObJteJ2I948mBQzzkZioVfLqSOB4kZdX24lyQf58gCPvDNeMC5jCWL563H7IKKGnXKS12UShbpJJWOi29h5TUlxNbjZ85stHfxGI5SHRaD15vJ3xnZh38gAuFbbwFHiCFxcec7BvEB7K4qtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fqr7zhOI; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fqr7zhOI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773818228; x=1805354228;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x1Jfje1icMUM629FUkcNmc6H5eZSd8v9huoPr4Av7o4=;
  b=fqr7zhOI+vP8mW+GMnGPikWxgJUq9VBeDvkesEyIujIrwyI3X3VF9wYq
   G88BHmuni/zHUXT5kohp/UVhzjdp35lk75H5TI8o062dzihJo5nkMFDw+
   1EzY+LiAq9B863eRvrKeT44IKXQe9u1xRJJHj+qB5wdkTj2ZLXlXtiZb9
   CZLBw0yXRLjqesVP6JRhJHBMqnNcEX3EQsueluhai7pO9Bcwi0jLQNP8c
   3iL/7HvWneOh4kYVi60bfjvvyhEDhfGJJLxn4+yIYw5myFFhZNm2l5zNm
   wxZk+t+yw9oKh+zJX5556x7qxOBgie3RUE6W0YaMaCHrCfucZMGgywlAE
   Q==;
X-CSE-ConnectionGUID: LDPNRbENSiGVC1h4M/FEmQ==
X-CSE-MsgGUID: A4HLQoLHQdi3FS8QudbabA==
X-IronPort-AV: E=Sophos;i="6.23,127,1770566400"; 
   d="scan'208";a="143880547"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Mar 2026 15:17:03 +0800
IronPort-SDR: 69ba516f_1TNzOeYILXf6bfYV+D4oovxZvzXQTIFUbVN9mLXfrSaZOL/
 7R+XNxh5yBqzS2FK6kUKtA24gglBPry9OcPrbPw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Mar 2026 00:17:04 -0700
WDCIronportException: Internal
Received: from wdap-hjmxrb8qvs.ad.shared (HELO neo.wdc.com) ([10.224.26.2])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Mar 2026 00:17:04 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] btrfs: decrease indendation of find_free_extent_update_loop
Date: Wed, 18 Mar 2026 08:17:00 +0100
Message-ID: <20260318071700.356403-1-johannes.thumshirn@wdc.com>
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

While at it change a

if () {
}
else if
else

pattern to all using curly braces and be consistent with the rest of btrfs
code.

Also change 'int exists' to 'bool have_trans' giving it a more meaningful
name and type.

No functional changes intended.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v1:
- Fix typo in commit mesage
- Add Filipe's R-b
- int exist -> bool have_trans
- Add punctation to th eone comment without
---
 fs/btrfs/extent-tree.c | 111 +++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a55b910c755b..c42cfe531a5e 100644
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
+		bool have_trans = false;
 
-			/* Check if allocation policy allows to create a new chunk */
-			ret = can_allocate_chunk(fs_info, ffe_ctl);
-			if (ret)
-				return ret;
+		/* Check if allocation policy allows to create a new chunk. */
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
+			have_trans = true;
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
+		if (!have_trans)
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

