Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC9B35DA56
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859756; cv=none; b=WkEXYhAkuR78xVh0AMj/twGsAuHzc3ge+Jge2vJ/IDX74mNyILf3eJ74+x2f6rDA0kWwJ+rdLaaaWNw59c3Ced/RYUpz47S5XPTXO0LU6IwIhWUCOT6e1VnJnZDzEKVZKYhY+phN/PAUfC8sY1ZwYqbzWN0bik/3dFqUpz2umeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859756; c=relaxed/simple;
	bh=mPIy2dVw43ZuJNGhVSfngNe4e4Lpm1CaTgbpt4YEgLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPrW8YsbKPsnzCVhKNGYtNirbxwPZ4uyuK1FMoX7DZczFDozQxFp61dEm9cxKgpHG5NGY+EU1kVCQwgo6m/KLnt3j8j8ChPORQKwWNGELIY1b+ExJlmWEiFCh1A6zT3/A+VYtZuZ/iQeF9p7r+gDRjFLBcdPkfx0pm0FW2PdYZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GrAdOi7o; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GrAdOi7o"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859755; x=1813395755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mPIy2dVw43ZuJNGhVSfngNe4e4Lpm1CaTgbpt4YEgLI=;
  b=GrAdOi7oFN6R4vNJylgom6nGEJhKqqZybJNg5NbH1CWbasyw7xYX5Op7
   TYISuz0+Nl1gEPDho0LY4M6+xVgD9RVSzIHym7g+DofIye47Tf4bQ2RGV
   OOCUK1HZfsxyt22ZtEOWbvwX7FIjdjwbTJPNQpvFaHGfJW5RMuSctMOOg
   IigcECPmIEs++37O5SYUD5sALSreO5ghm4hGDR1uq/CXYGFNbCY9GXp9e
   RYbUIuNv0/kG1OT5CsMXhkRugYmgmTNGK0GmnUmis0YUKLnBLTfczl4VE
   khcZVL0S3IX30auXgkL6CaW0C0BMZz0bg41Zeo5LXSML4Mr0CkKo40Jzp
   A==;
X-CSE-ConnectionGUID: RGTWbqGwRf6f4280zUaEIg==
X-CSE-MsgGUID: 6lgvigwTSv2MWk/3gh4ryQ==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951282"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:28 +0800
X-CSE-ConnectionGUID: ZK6lGORvTV6Gm0WJN5TM0A==
X-CSE-MsgGUID: byQKyWBwTES6n7LHhhE60Q==
IronPort-SDR: 6a3505a3_/Oc0lIeRCiAAbuWnzuHw/6tnWDVODUPPnHQe7VN2RfqY79z
 iCm0oWGh0gJGyIq+YcZKm1Caw+TkUXO9tGL1bvw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:27 -0700
X-CSE-ConnectionGUID: 1vDFXt0PTA+YRW894jsoHw==
X-CSE-MsgGUID: oPGSzwWRRdqTpTk4B/atUg==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:27 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 11/15] btrfs: tests: add a RAID5 RAID-stripe-tree read test
Date: Fri, 19 Jun 2026 11:02:06 +0200
Message-ID: <20260619090211.497100-12-johannes.thumshirn@wdc.com>
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

Add test_read_data_and_parity, which inserts the data and parity
stripe-tree items of a 3-device (2 data + 1 parity) full stripe and
verifies that btrfs_get_raid_extent_offset() and btrfs_get_parity_extent()
resolve the expected device and physical addresses - the stripe-tree
lookups btrfs_rst_raid56_read() relies on.

Teach btrfs_insert_one_raid_extent() to insert a
BTRFS_RAID_STRIPE_PARITY_KEY item so the test can populate a parity item
without going through the bdev-dependent insert_parity_stripe_work() path.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/raid-stripe-tree.c             | 12 ++-
 fs/btrfs/tests/raid-stripe-tree-tests.c | 98 ++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 30ea066161f6..abe0ad10ee87 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -341,7 +341,9 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_key stripe_key;
 	struct btrfs_root *stripe_root = fs_info->stripe_root;
-	const int num_stripes = btrfs_bg_type_to_factor(bioc->map_type);
+	const int num_stripes = (type == BTRFS_RAID_STRIPE_PARITY_KEY) ?
+		btrfs_nr_parity_stripes(bioc->map_type) :
+		btrfs_bg_type_to_factor(bioc->map_type);
 	struct btrfs_stripe_extent AUTO_KFREE(stripe_extent);
 	const size_t item_size = struct_size(stripe_extent, strides, num_stripes);
 	int ret;
@@ -356,7 +358,13 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	trace_btrfs_insert_one_raid_extent(fs_info, bioc->logical, bioc->size,
 					   num_stripes);
 
-	if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+	if (type == BTRFS_RAID_STRIPE_PARITY_KEY) {
+		const int nr_data = bioc->num_stripes - num_stripes;
+
+		for (int i = 0; i < num_stripes; i++)
+			fill_raid_stride(&bioc->stripes[nr_data + i],
+					 &stripe_extent->strides[i]);
+	} else if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
 		int stripe_nr = btrfs_bioc_to_stripe_nr(bioc);
 		struct btrfs_raid_stride *raid_stride = &stripe_extent->strides[0];
 
diff --git a/fs/btrfs/tests/raid-stripe-tree-tests.c b/fs/btrfs/tests/raid-stripe-tree-tests.c
index 746372eee7e5..f78e548d29d2 100644
--- a/fs/btrfs/tests/raid-stripe-tree-tests.c
+++ b/fs/btrfs/tests/raid-stripe-tree-tests.c
@@ -11,8 +11,9 @@
 #include "../raid-stripe-tree.h"
 #include "btrfs-tests.h"
 
-#define RST_TEST_NUM_DEVICES	(2)
+#define RST_TEST_NUM_DEVICES	(3)
 #define RST_TEST_RAID1_TYPE	(BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_RAID1)
+#define RST_TEST_RAID5_TYPE	(BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_RAID5)
 
 #define SZ_48K (SZ_32K + SZ_16K)
 
@@ -1070,6 +1071,100 @@ static int test_simple_create_delete(struct btrfs_trans_handle *trans)
 	return ret;
 }
 
+static int test_read_data_and_parity(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_io_context *bioc;
+	struct btrfs_io_stripe io_stripe = { 0 };
+	u64 map_type = RST_TEST_RAID5_TYPE;
+	u64 logical = SZ_1M;
+	u64 len = BTRFS_STRIPE_LEN;
+	const u64 data_physical = logical;
+	const u64 parity_physical = logical + (RST_TEST_NUM_DEVICES - 1) * (u64)SZ_1G;
+	int ret;
+
+	bioc = alloc_btrfs_io_context(fs_info, logical, RST_TEST_NUM_DEVICES);
+	if (!bioc) {
+		test_std_err(TEST_ALLOC_IO_CONTEXT);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	bioc->map_type = map_type;
+	bioc->size = len;
+	bioc->num_stripes = RST_TEST_NUM_DEVICES;
+	bioc->full_stripe_logical = logical;
+
+	for (int i = 0; i < RST_TEST_NUM_DEVICES; i++) {
+		struct btrfs_io_stripe *stripe = &bioc->stripes[i];
+
+		stripe->dev = btrfs_device_by_devid(fs_info->fs_devices, i);
+		if (!stripe->dev) {
+			test_err("cannot find device with devid %d", i);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		stripe->physical = logical + i * (u64)SZ_1G;
+	}
+
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
+	if (ret) {
+		test_err("inserting data RAID extent failed: %d", ret);
+		goto out;
+	}
+
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_PARITY_KEY);
+	if (ret) {
+		test_err("inserting parity RAID extent failed: %d", ret);
+		goto out;
+	}
+
+	io_stripe.dev = btrfs_device_by_devid(fs_info->fs_devices, 0);
+	len = BTRFS_STRIPE_LEN;
+	ret = btrfs_get_raid_extent_offset(fs_info, logical, &len, map_type, 0,
+					   &io_stripe);
+	if (ret) {
+		test_err("lookup of data RAID extent [%llu, %llu] failed",
+			 logical, logical + len);
+		goto out;
+	}
+
+	if (io_stripe.physical != data_physical) {
+		test_err("invalid data physical address, expected %llu, got %llu",
+			 data_physical, io_stripe.physical);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	io_stripe.dev = btrfs_device_by_devid(fs_info->fs_devices,
+					      RST_TEST_NUM_DEVICES - 1);
+	len = BTRFS_STRIPE_LEN;
+	ret = btrfs_get_parity_extent(fs_info, logical, &len, map_type,
+				      &io_stripe);
+	if (ret) {
+		test_err("lookup of parity RAID extent [%llu, %llu] failed",
+			 logical, logical + len);
+		goto out;
+	}
+
+	if (io_stripe.physical != parity_physical) {
+		test_err("invalid parity physical address, expected %llu, got %llu",
+			 parity_physical, io_stripe.physical);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = btrfs_delete_raid_extent(trans, logical, len);
+	if (ret)
+		test_err("deleting RAID extent [%llu, %llu] failed", logical,
+			 logical + len);
+
+out:
+	btrfs_put_bioc(bioc);
+	return ret;
+}
+
 static const test_func_t tests[] = {
 	test_simple_create_delete,
 	test_create_update_delete,
@@ -1079,6 +1174,7 @@ static const test_func_t tests[] = {
 	test_punch_hole,
 	test_punch_hole_3extents,
 	test_delete_two_extents,
+	test_read_data_and_parity,
 };
 
 static int run_test(test_func_t test, u32 sectorsize, u32 nodesize)
-- 
2.54.0

