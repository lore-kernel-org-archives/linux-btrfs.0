Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EABE38AC78
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 07:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782716941; cv=none; b=L6FswRIeRNdBRV8zopxpp/1AG9ZlWuU6iuwsp7fiUJhmKNFY1sNNQhcD50zBqHdhQC3ygXWaXJIRav3cqk1geK5PzgJWySY6WXYDcUOOEGgxjtCuDTYki4tmZIDPOES0Zmm9gOR4ez2dDW7RGf5kBc8idqmuZ7LwMJinB+RvLBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782716941; c=relaxed/simple;
	bh=yBYTQLhyd7kYYdfcMI/SCUTQSrA12boOZKaY3RrPiS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FJ7MidYh/ANTmeer4z4wOyLJiPsfNN7hwr5alt582xbPB0hDDtPElOt4wmGw07XasV34f4TKyYXp3T+wuYy9lz6bIvGBdK3PijohZwMtlL6smKmnyD8m2MqubG66DFxWRU0ROXblIn8Fj7+XgsOXw9Obo0vy7bql5MMcFxPQA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=aJpa2s3x; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="aJpa2s3x"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4gpcnw2lvZzKLxl00;
	Mon, 29 Jun 2026 15:08:52 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1782716932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ccG4dFq/bWxjMvgya81Q4aOtHyQslinlYtXWcncL+dU=;
	b=aJpa2s3xMJiG8C4s4fmloMqYf/mHWPhhXuhGCYtJqAraGe07JKmuIyDsstckrsqryyjFuO
	6Yh5y1UeEK4JEoMtbeNUNuz/3F8r+epetJp925zuMGunvA4zywHVhrAuNqCATpgn09/8UA
	CdVNsHYWr8J/6+ggG+6lUpIemSHUNYY=
From: Dave Chen <davechen@synology.com>
To: linux-btrfs@vger.kernel.org,
	dsterba@suse.com
Cc: cccheng@synology.com,
	Dave Chen <davechen@synology.com>
Subject: [PATCH] btrfs: fix u32 to s64 type conversion in dirty_metadata_bytes accounting
Date: Mon, 29 Jun 2026 15:08:43 +0800
Message-ID: <20260629070843.4116053-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Auth: pass
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
Content-Type: text/plain

The percpu_counter dirty_metadata_bytes is updated by negating eb->len
and passing it to percpu_counter_add_batch(), whose amount parameter is
s64.  Since commit 84cda1a6087d ("btrfs: cache folio size and shift in
extent_buffer"), eb->len is u32.  The u32 result of -eb->len, when
widened to the s64 parameter, becomes a large positive value instead of
the intended negative value.  For eb->len == 16384 the counter adds
+4294950912 instead of subtracting 16384.

The counter therefore grows on every metadata writeback instead of
shrinking by the extent buffer size, permanently exceeding
BTRFS_DIRTY_METADATA_THRESH and causing __btrfs_btree_balance_dirty()
to trigger balance_dirty_pages_ratelimited() unconditionally, adding
unnecessary writeback pressure.

Cast eb->len to s64 before negation at both call sites so the
subtraction is performed in signed 64-bit arithmetic.

Signed-off-by: Dave Chen <davechen@synology.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7d604524e83c..de5785117a47 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2004,7 +2004,7 @@ static noinline_for_stack bool lock_extent_buffer_for_io(struct extent_buffer *e
 
 		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
 		percpu_counter_add_batch(&fs_info->dirty_metadata_bytes,
-					 -eb->len,
+					 -(s64)eb->len,
 					 fs_info->dirty_metadata_batch);
 		ret = true;
 	} else {
@@ -3774,7 +3774,7 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 		return;
 
 	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
-	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -eb->len,
+	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
 				 fs_info->dirty_metadata_batch);
 
 	for (int i = 0; i < num_extent_folios(eb); i++) {
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
