Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B29D41D64F
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 11:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784203043; cv=none; b=sF6/8nzE2eP4CYiaDfHfCDCJKS7cRyHxzYLLYapn7/LUen8k3eh3WbH9WgDuEwgVt6yVBXXxnI2gnHcQUl/0bUspd+1ABBfbPkTIovOR/eidf6/b1ERsKmD/8SPqYDRt9PwIDVe4CddRhcpkCuPcV6JDqfX84G8G8SfTt6xwQkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784203043; c=relaxed/simple;
	bh=GYcPvzTjgvoleuYioCjk5j+YTrGqvnWJamWjm4lKoBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ew68ucig07glFqK5qii2ZjTtc5Bw5donqRmzP+PgbZHMR6YhKMQVRtlKGbbYL60ov/nITOo40OENUMd2c5HqOO14aSNAfCOFRdEGfL8p1+Xb2cUc7Iak1dCJY+gnTrTRT2GVbq72knxvzjtwCGh4/fqEQs6a+aG8AGI+skPklWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=B1Bd2lIL; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="B1Bd2lIL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784203041; x=1815739041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GYcPvzTjgvoleuYioCjk5j+YTrGqvnWJamWjm4lKoBM=;
  b=B1Bd2lILJVleJwFeHyRICXmPtrF24kTX1I3ClG6/voXXfWSxlOFW6hZr
   a7M6HtKp2s8+2zr729rfd77MXJwNnFwWxqK64sfk7kjFv+iWEzfu1d1U5
   dsAUqmtIaKf747aMebCeQ6VWwy+dvrk2YqmzlV40LuHoC2KuUExI0tubl
   p4g4jNN8x/YCGfaQzfHhtc+CoIcqgG5IHqgeDRwI3sLkycTydws/avW/p
   TOA7E6pbRKyaShQQ2s+oBvr7ANctKGDwcAAvCjX1y2PXsl6e6Agt853O0
   N5qwn+MuvJ6AmEXD9M8dOlNXn98mYbu/jnnr8g1YOPlouSQsPQvvngJ1W
   Q==;
X-CSE-ConnectionGUID: RBs49EnXRnaAhmMlxgaKvg==
X-CSE-MsgGUID: mXBvsTf1SP+JSHwFgeeJdw==
X-IronPort-AV: E=Sophos;i="6.25,167,1779120000"; 
   d="scan'208";a="150860082"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2026 19:57:14 +0800
X-CSE-ConnectionGUID: ebULmiQITdyev4HxflxHxA==
X-CSE-MsgGUID: oQMLUEwkTl6yF4myBaUsCA==
IronPort-SDR: 6a58c70e_ZPJTd1vF/fN4BXjHydlKmIU18u9YanA7fp7o0BKQBYe+5f0
 uHI/enCCp6HOzQknwtRyU3jG0fuwui4KP4UAWLA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jul 2026 04:57:02 -0700
X-CSE-ConnectionGUID: NWzgT2a8T6OiI1h/qhOK6g==
X-CSE-MsgGUID: F1cIB4+nSe+W3jcP+k44kA==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 16 Jul 2026 04:57:01 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/5] btrfs: factor out dirty-clearing part of btrfs_clear_buffer_dirty
Date: Thu, 16 Jul 2026 13:56:52 +0200
Message-ID: <20260716115656.1319295-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
References: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split the dirty-clearing part of btrfs_clear_buffer_dirty() into a helper so
a later caller can reuse it while bypassing the zoned zero-out deferral.
No functional change.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 47 +++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 647b109ef61b..4dd8fc5ad247 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3788,6 +3788,32 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 	release_extent_buffer(eb);
 }
 
+static void __btrfs_clear_buffer_dirty(struct extent_buffer *eb)
+{
+	struct btrfs_fs_info *fs_info = eb->fs_info;
+
+	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
+		return;
+
+	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
+	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
+				 fs_info->dirty_metadata_batch);
+
+	for (int i = 0; i < num_extent_folios(eb); i++) {
+		struct folio *folio = eb->folios[i];
+		bool last;
+
+		if (!folio_test_dirty(folio))
+			continue;
+		folio_lock(folio);
+		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
+		if (last)
+			btrfs_clear_folio_dirty_tag(folio);
+		folio_unlock(folio);
+	}
+	WARN_ON(refcount_read(&eb->refs) == 0);
+}
+
 void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *eb)
 {
@@ -3812,26 +3838,7 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 		return;
 	}
 
-	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
-		return;
-
-	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
-	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
-				 fs_info->dirty_metadata_batch);
-
-	for (int i = 0; i < num_extent_folios(eb); i++) {
-		struct folio *folio = eb->folios[i];
-		bool last;
-
-		if (!folio_test_dirty(folio))
-			continue;
-		folio_lock(folio);
-		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
-		if (last)
-			btrfs_clear_folio_dirty_tag(folio);
-		folio_unlock(folio);
-	}
-	WARN_ON(refcount_read(&eb->refs) == 0);
+	__btrfs_clear_buffer_dirty(eb);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
-- 
2.54.0

