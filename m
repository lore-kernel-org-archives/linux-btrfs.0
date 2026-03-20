Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C931C2DCF4C
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 07:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773992109; cv=none; b=OKcrvXudIGUM8KX6kA9oVsAXnx+rB++/baOGv7hRo9GJrNLobr8awDtNwIqWlaB0aVT6j9vxExpAV8nDLscx30ewFSuIHStnWPTw1qkMHYdYd95TkMCi0mZcyrbO9y5t3zpxZR6R298Kc2ot4ykYjgohlfsEP5LiczcnW0+vbVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773992109; c=relaxed/simple;
	bh=GZUTJ/2qZ2mWsFx/n+ea/Zs+nm9q2YQYYXmBwMARMI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RplfBivb3L74pL1y9kv3K93uJNUXZmXtYN0DnUxXpLBa5V4sIiIj+sHnF5Iz560xQ02JKLMiNF9eLlRIiQtZU22CGfLQx2YhU2adTBAfOjbeNedgtjiwt+mmj4ytkLSW3IP9KBOfUNnC3J+9CqkAu/XxrRod9RYZ+//tjzilS0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kd6XD4vK; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kd6XD4vK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773992105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fpqV6Q3oWX0exloO8ArpJZS/9pNJDqn1+aFPMReXKRA=;
	b=Kd6XD4vKD6baKIm7Z89kx4sZqyVDmYeKl40JSfeC1IklAOLUNFvsUDJDfpce2PCtkEgxcc
	E8aGmXqxCjWUTQJBFhPV3tdJ8iqt1G1dZY9sIHkFs/2cN3VX2ElaUD6QqJ0f3BdMJdUC+6
	waV/Lb63Btl0/gonN4T3g4d5/z+0OJU=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: boris@bur.io,
	mark@harmstone.com,
	clm@fb.com,
	wqu@suse.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-team@meta.com
Subject: [PATCH 1/2] btrfs: additional gfp api for allocating compressed folios
Date: Fri, 20 Mar 2026 00:34:44 -0700
Message-ID: <20260320073445.80218-2-jp.kobryn@linux.dev>
In-Reply-To: <20260320073445.80218-1-jp.kobryn@linux.dev>
References: <20260320073445.80218-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

btrfs_alloc_compr_folio() assumes all callers want GFP_NOFS. This is fine
for most cases, however there are some call sites that would benefit from
different flags. One such case is preventing direct reclaim from occurring
during readahead allocations. With unbounded reclaim during this time,
noticeable latency will occur under high memory pressure.

Provide an additional API that accepts one additional gfp_t parameter,
giving callers flexibility over the characteristics of their allocation.

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
---
 fs/btrfs/compression.c | 9 +++++++--
 fs/btrfs/compression.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 192f133d9eb5..ae9cb5b7676c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -180,7 +180,7 @@ static unsigned long btrfs_compr_pool_scan(struct shrinker *sh, struct shrink_co
 /*
  * Common wrappers for page allocation from compression wrappers
  */
-struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
+struct folio *btrfs_alloc_compr_folio_gfp(struct btrfs_fs_info *fs_info, gfp_t gfp)
 {
 	struct folio *folio = NULL;
 
@@ -200,7 +200,12 @@ struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
 		return folio;
 
 alloc:
-	return folio_alloc(GFP_NOFS, fs_info->block_min_order);
+	return folio_alloc(gfp, fs_info->block_min_order);
+}
+
+struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
+{
+	return btrfs_alloc_compr_folio_gfp(fs_info, GFP_NOFS);
 }
 
 void btrfs_free_compr_folio(struct folio *folio)
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 973530e9ce6c..6131c128dd21 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -99,6 +99,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio);
 int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret);
 
 struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info);
+struct folio *btrfs_alloc_compr_folio_gfp(struct btrfs_fs_info *fs_info, gfp_t gfp);
 void btrfs_free_compr_folio(struct folio *folio);
 
 struct workspace_manager {
-- 
2.52.0

