Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637FC344D9D
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859749; cv=none; b=GNNkwFhODPflBNLCQCtn0wzUnbkEYQppz1U/OZr8B4V/euQaacXjJpO5O3jOAKzRoqAGOhdR6Zys9W34w+ceypxRv/+2EySMAmYL+tXRH+43pcEDYUXOfhP/MovmS63JJSOkD1TOPamMXhpSFkmGs6Y0b4D/k3u5KbFWpR1f9hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859749; c=relaxed/simple;
	bh=yT5LAYQpTvVOg1KxUCLfqK192qtTw2H1TELKp9owrVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGn7zjWmfocqusYqfgO7Qsnn+ySDS7KKLatuOqRsb6D7dnnlsnDj3yUvqgNDJIZIlaelvO6Iyg42umuEke6/1kIYHbZhO+Gu/OmWDZTcWBkYVHjVjNnp3sNNjLhdjppJiF6FQm0piQm85c9Xg1Az5mMlupJB/l+OtHPAWBuoUpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SCQ1DiML; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SCQ1DiML"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859749; x=1813395749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yT5LAYQpTvVOg1KxUCLfqK192qtTw2H1TELKp9owrVI=;
  b=SCQ1DiMLgTCWW9TVK0nzlw19wNyuMs10GaxMiS7Qz8KOHmEWiENEnj+M
   FbVIlJl7MKkCgMfE9QTk2fq6xf9J4L52I2X49cJHZ1a7+HStnRorHAp8w
   u7gaGjQKC+G6x/hid79DHAimZq7ptoVirUfdIDGSahKz9iCDFLeOzVpC8
   6qv/EJ7ZMrRk6pU0R4gCBNhyA+aT4pcSZqwgpYyT/jLzNgKb5gw8yEmYd
   LiZyKjv5m8Fm8nloJTTdJvtwFSumrd8BOmAW1we/N7tKOFZQWi9x3yICk
   Jdn7LhPqnDzVp4Fe9T6Gf5V/qvuVHCAzYgRNbdnhLSmmOA6r5ovXA+3th
   g==;
X-CSE-ConnectionGUID: aa4JZhskTS60CxspwFdVxA==
X-CSE-MsgGUID: Euufrr6pTqC8oOT74H/pOA==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951270"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: 4A4CjAOCS6yJ75jxer5hSg==
X-CSE-MsgGUID: hY7hQ9kIQcirXIzO99agHA==
IronPort-SDR: 6a350599_EV4SpoKufHHba1sTgWDpm0uIp1zA4AMjFXaOdsD3G7mL+/D
 P/RWOY+0GmLSDwZ2/0a3OtJW+tYsa1aA50SojpQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:17 -0700
X-CSE-ConnectionGUID: XcdJsdWGTr+aspAauSXkzw==
X-CSE-MsgGUID: ZGDzv6IjS8OWlXnKmk8bhA==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:16 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 02/15] btrfs: pass the key type to btrfs_insert_one_raid_extent()
Date: Fri, 19 Jun 2026 11:01:57 +0200
Message-ID: <20260619090211.497100-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_insert_one_raid_extent() always inserts a BTRFS_RAID_STRIPE_KEY
item. To let it also insert the RAID56 parity item (a
BTRFS_RAID_STRIPE_PARITY_KEY) in a later patch, pass the stripe-tree key
type in and use it for the inserted item. All callers insert data items,
so pass BTRFS_RAID_STRIPE_KEY. No functional change.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/raid-stripe-tree.c             |  6 +++---
 fs/btrfs/raid-stripe-tree.h             |  2 +-
 fs/btrfs/tests/raid-stripe-tree-tests.c | 28 ++++++++++++-------------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 8592fa76728e..1a6ebd10849a 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -334,7 +334,7 @@ static void fill_raid_stride(struct btrfs_io_stripe *stripe,
 
 EXPORT_FOR_TESTS
 int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
-				 struct btrfs_io_context *bioc)
+				 struct btrfs_io_context *bioc, u8 type)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_key stripe_key;
@@ -360,7 +360,7 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	}
 
 	stripe_key.objectid = bioc->logical;
-	stripe_key.type = BTRFS_RAID_STRIPE_KEY;
+	stripe_key.type = type;
 	stripe_key.offset = bioc->size;
 
 	ret = btrfs_insert_item(trans, stripe_root, &stripe_key, stripe_extent,
@@ -387,7 +387,7 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 		return 0;
 
 	list_for_each_entry(bioc, &ordered_extent->bioc_list, rst_ordered_entry) {
-		ret = btrfs_insert_one_raid_extent(trans, bioc);
+		ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 		if (ret)
 			return ret;
 	}
diff --git a/fs/btrfs/raid-stripe-tree.h b/fs/btrfs/raid-stripe-tree.h
index 69942ad43140..3c67d814640f 100644
--- a/fs/btrfs/raid-stripe-tree.h
+++ b/fs/btrfs/raid-stripe-tree.h
@@ -31,7 +31,7 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
-				 struct btrfs_io_context *bioc);
+				 struct btrfs_io_context *bioc, u8 type);
 #endif
 
 static inline bool btrfs_need_stripe_tree_update(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/tests/raid-stripe-tree-tests.c b/fs/btrfs/tests/raid-stripe-tree-tests.c
index a7bc58a5c1e2..746372eee7e5 100644
--- a/fs/btrfs/tests/raid-stripe-tree-tests.c
+++ b/fs/btrfs/tests/raid-stripe-tree-tests.c
@@ -77,7 +77,7 @@ static int test_punch_hole_3extents(struct btrfs_trans_handle *trans)
 		stripe->physical = logical1 + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -98,7 +98,7 @@ static int test_punch_hole_3extents(struct btrfs_trans_handle *trans)
 		stripe->physical = logical2 + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -119,7 +119,7 @@ static int test_punch_hole_3extents(struct btrfs_trans_handle *trans)
 		stripe->physical = logical3 + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -253,7 +253,7 @@ static int test_delete_two_extents(struct btrfs_trans_handle *trans)
 		stripe->physical = logical1 + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -274,7 +274,7 @@ static int test_delete_two_extents(struct btrfs_trans_handle *trans)
 		stripe->physical = logical2 + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -295,7 +295,7 @@ static int test_delete_two_extents(struct btrfs_trans_handle *trans)
 		stripe->physical = logical3 + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -396,7 +396,7 @@ static int test_punch_hole(struct btrfs_trans_handle *trans)
 		stripe->physical = logical1 + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -536,7 +536,7 @@ static int test_front_delete_prev_item(struct btrfs_trans_handle *trans)
 		stripe->physical = logical1 + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -557,7 +557,7 @@ static int test_front_delete_prev_item(struct btrfs_trans_handle *trans)
 		stripe->physical = logical2 + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -676,7 +676,7 @@ static int test_front_delete(struct btrfs_trans_handle *trans)
 		stripe->physical = logical + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -785,7 +785,7 @@ static int test_tail_delete(struct btrfs_trans_handle *trans)
 		stripe->physical = logical + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -907,7 +907,7 @@ static int test_create_update_delete(struct btrfs_trans_handle *trans)
 		stripe->physical = logical + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
@@ -953,7 +953,7 @@ static int test_create_update_delete(struct btrfs_trans_handle *trans)
 		stripe->physical = SZ_1G + logical + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("updating RAID extent failed: %d", ret);
 		goto out;
@@ -1027,7 +1027,7 @@ static int test_simple_create_delete(struct btrfs_trans_handle *trans)
 		stripe->physical = logical + i * SZ_1G;
 	}
 
-	ret = btrfs_insert_one_raid_extent(trans, bioc);
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
 	if (ret) {
 		test_err("inserting RAID extent failed: %d", ret);
 		goto out;
-- 
2.54.0

