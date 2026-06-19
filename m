Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8691935F5E1
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859759; cv=none; b=OW2MxytbXVixCD45UBAnb/x73Le/Hu4iuN5apo3AoPwItNBBy8lu+MpZ4xH6bgsOcv01xpjutlckm4fcvdQLDhtAh7IERMuGJ1ZhoZ6oeWHPdkumLJhRCU2+Vhzsx3rEI5kz+ajaErz9BSejkWNbEXYFbVmknANSx0VoUzr3NMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859759; c=relaxed/simple;
	bh=zRNfiK+IbWsN7MxaFLFBNNLRqCnBilfY3PFSswKETbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLb/orCPcqR3hqwqzZQYzAsbfnd++s/Fc+DCU0OHFujcgUq7VsXQ/OKMsS59SKYv+qt07cBA75dRyyp7hlytQ8fqxunYi7dhZkX56r9JCDrzAs5ij52AOYVmeYDNd+mx8NxhC2klbYcy9MSL4Ojl+i4IWmEW1wsjaottcZW8dOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AVEh4Yx/; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AVEh4Yx/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859757; x=1813395757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zRNfiK+IbWsN7MxaFLFBNNLRqCnBilfY3PFSswKETbg=;
  b=AVEh4Yx/TENoURAORYjpq3rvr1V1hpb7R5Vz2uHGdF28h8cDxqcfSEql
   CzMU5JeKYkcEzxpNbKX/b/jjXn7ZLbi3OawiXL1f4z+XyxpU28h4s7S3r
   69SghE6gn+82QEjaITljPoAkGhLBXFbrubgmMwvcdQWcGH4mMXmwAURCp
   4txRu8TpoKUGUUzN9gzvOH4ynck0EVwofBGMqYPrgTSymmZv++RTTRi/N
   9YOFdRXrsyFukOeSN4guhuCzBolINdkK2ufnr/Do2B/z+RHd9zTiQPDIO
   /1n5H8tEzHf58WKNbPmF9CmAsqZqPkUt6offLN4Atlb2BxrJcCtad9aWP
   Q==;
X-CSE-ConnectionGUID: 5JTGI8OrT6CmlJsln5CiBw==
X-CSE-MsgGUID: MrpbgP/hRzS9l0tNabG1ug==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951287"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:32 +0800
X-CSE-ConnectionGUID: Y7cPoatrSWOrTOk51BUlTw==
X-CSE-MsgGUID: KtC2FluUSgenphqBA0F8iA==
IronPort-SDR: 6a3505a6_6lTJDNod4F1qOgT10OxMnFf+I8wpfsCbLEaFhU6I1b7XR6b
 JvNrjXnanu+J+gd1blZNS78QbSiNSoGnqwwM2VA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:30 -0700
X-CSE-ConnectionGUID: OAeLIUnnT9aGz0hmtID4yg==
X-CSE-MsgGUID: xqLzoXtpTt+eNm4p9iMKTQ==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:30 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 14/15] btrfs: tests: add RAID5 RAID-stripe-tree create/update/delete tests
Date: Fri, 19 Jun 2026 11:02:09 +0200
Message-ID: <20260619090211.497100-15-johannes.thumshirn@wdc.com>
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

Add stripe-tree unit tests for the RAID5 profile, mirroring the existing
RAID1 create/update/delete coverage but exercising the data and parity
stripe-tree items of a 3-device (2 data + 1 parity) full stripe:

 - test_raid5_simple_create_delete: insert the two data stripes and the
   parity stripe of a full stripe, verify each resolves to the expected
   device/physical via btrfs_get_raid_extent_offset() and
   btrfs_get_parity_extent(), then delete.

 - test_raid5_create_update_delete: overwrite the full stripe with new
   physical addresses and verify the data and parity items were updated in
   place.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/tests/raid-stripe-tree-tests.c | 218 ++++++++++++++++++++++++
 1 file changed, 218 insertions(+)

diff --git a/fs/btrfs/tests/raid-stripe-tree-tests.c b/fs/btrfs/tests/raid-stripe-tree-tests.c
index f78e548d29d2..6a4e298e3f9a 100644
--- a/fs/btrfs/tests/raid-stripe-tree-tests.c
+++ b/fs/btrfs/tests/raid-stripe-tree-tests.c
@@ -32,6 +32,29 @@ static struct btrfs_device *btrfs_device_by_devid(struct btrfs_fs_devices *fs_de
 	return NULL;
 }
 
+static int init_raid5_bioc(struct btrfs_fs_info *fs_info,
+			   struct btrfs_io_context *bioc,
+			   u64 full_logical, u64 base_physical)
+{
+	bioc->map_type = RST_TEST_RAID5_TYPE;
+	bioc->num_stripes = RST_TEST_NUM_DEVICES;
+	bioc->full_stripe_logical = full_logical;
+
+	for (int i = 0; i < RST_TEST_NUM_DEVICES; i++) {
+		struct btrfs_io_stripe *stripe = &bioc->stripes[i];
+
+		stripe->dev = btrfs_device_by_devid(fs_info->fs_devices, i);
+		if (!stripe->dev) {
+			test_err("cannot find device with devid %d", i);
+			return -EINVAL;
+		}
+
+		stripe->physical = base_physical + i * (u64)SZ_1G;
+	}
+
+	return 0;
+}
+
 /*
  * Test creating a range of three extents and then punch a hole in the middle,
  * deleting all of the middle extents and partially deleting the "book ends".
@@ -1165,6 +1188,199 @@ static int test_read_data_and_parity(struct btrfs_trans_handle *trans)
 	return ret;
 }
 
+/* Insert a full RAID5 stripe: two 64K data stripes + one parity stripe. */
+static int insert_raid5_full_stripe(struct btrfs_trans_handle *trans,
+				    struct btrfs_io_context *bioc, u64 full)
+{
+	const u64 stripe_len = BTRFS_STRIPE_LEN;
+	int ret;
+
+	bioc->logical = full;
+	bioc->size = stripe_len;
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
+	if (ret) {
+		test_err("inserting data stripe 0 failed: %d", ret);
+		return ret;
+	}
+
+	bioc->logical = full + stripe_len;
+	bioc->size = stripe_len;
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_KEY);
+	if (ret) {
+		test_err("inserting data stripe 1 failed: %d", ret);
+		return ret;
+	}
+
+	bioc->logical = full;
+	bioc->size = 2 * stripe_len;
+	ret = btrfs_insert_one_raid_extent(trans, bioc, BTRFS_RAID_STRIPE_PARITY_KEY);
+	if (ret) {
+		test_err("inserting parity stripe failed: %d", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/* Verify a RAID5 data or parity stripe resolves to @phys. */
+static int check_raid5_stripe(struct btrfs_fs_info *fs_info, u64 logical,
+			      u64 len, u64 devid, u64 phys, bool parity)
+{
+	struct btrfs_io_stripe io_stripe = { 0 };
+	int ret;
+
+	io_stripe.dev = btrfs_device_by_devid(fs_info->fs_devices, devid);
+	if (!io_stripe.dev) {
+		test_err("cannot find device with devid %llu", devid);
+		return -EINVAL;
+	}
+
+	if (parity)
+		ret = btrfs_get_parity_extent(fs_info, logical, &len,
+					      RST_TEST_RAID5_TYPE, &io_stripe);
+	else
+		ret = btrfs_get_raid_extent_offset(fs_info, logical, &len,
+						   RST_TEST_RAID5_TYPE, 0,
+						   &io_stripe);
+	if (ret) {
+		test_err("lookup of %s extent [%llu, %llu] failed: %d",
+			 parity ? "parity" : "data", logical, logical + len, ret);
+		return ret;
+	}
+
+	if (io_stripe.physical != phys) {
+		test_err("invalid %s physical, expected %llu, got %llu",
+			 parity ? "parity" : "data", phys, io_stripe.physical);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Test a simple RAID5 full-stripe create and delete on a 3-device (2 data +
+ * 1 parity) filesystem: insert the two data stripes and the parity stripe,
+ * verify each resolves to the right device/physical, then delete.
+ */
+static int test_raid5_simple_create_delete(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_io_context *bioc;
+	const u64 full = SZ_1M;
+	const u64 stripe_len = BTRFS_STRIPE_LEN;
+	const u64 base = SZ_1G;
+	int ret;
+
+	bioc = alloc_btrfs_io_context(fs_info, full, RST_TEST_NUM_DEVICES);
+	if (!bioc) {
+		test_std_err(TEST_ALLOC_IO_CONTEXT);
+		return -ENOMEM;
+	}
+
+	ret = init_raid5_bioc(fs_info, bioc, full, base);
+	if (ret)
+		goto out;
+
+	ret = insert_raid5_full_stripe(trans, bioc, full);
+	if (ret)
+		goto out;
+
+	ret = check_raid5_stripe(fs_info, full, stripe_len, 0, base, false);
+	if (ret)
+		goto out;
+	ret = check_raid5_stripe(fs_info, full + stripe_len, stripe_len, 1,
+				 base + (u64)SZ_1G, false);
+	if (ret)
+		goto out;
+	ret = check_raid5_stripe(fs_info, full, 2 * stripe_len, 2,
+				 base + 2 * (u64)SZ_1G, true);
+	if (ret)
+		goto out;
+
+	/*
+	 * Delete the data stripes. The parity item cannot be removed via
+	 * btrfs_delete_raid_extent() in the test fs_info (it detects parity
+	 * profiles through the chunk map, which does not exist here); it is
+	 * reclaimed when the dummy fs_info is torn down.
+	 */
+	ret = btrfs_delete_raid_extent(trans, full, stripe_len);
+	if (ret) {
+		test_err("deleting data stripe 0 failed: %d", ret);
+		goto out;
+	}
+	ret = btrfs_delete_raid_extent(trans, full + stripe_len, stripe_len);
+	if (ret)
+		test_err("deleting data stripe 1 failed: %d", ret);
+
+out:
+	btrfs_put_bioc(bioc);
+	return ret;
+}
+
+/*
+ * Test overwriting a RAID5 full stripe: create it, then re-insert the data and
+ * parity stripes with new physical addresses and verify the stripe-tree items
+ * were updated in place (exercises update_raid_extent_item() for both the
+ * data and the parity keys).
+ */
+static int test_raid5_create_update_delete(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_io_context *bioc;
+	const u64 full = SZ_1M;
+	const u64 stripe_len = BTRFS_STRIPE_LEN;
+	const u64 base = SZ_1G;
+	const u64 base2 = 4 * (u64)SZ_1G;
+	int ret;
+
+	bioc = alloc_btrfs_io_context(fs_info, full, RST_TEST_NUM_DEVICES);
+	if (!bioc) {
+		test_std_err(TEST_ALLOC_IO_CONTEXT);
+		return -ENOMEM;
+	}
+
+	ret = init_raid5_bioc(fs_info, bioc, full, base);
+	if (ret)
+		goto out;
+
+	ret = insert_raid5_full_stripe(trans, bioc, full);
+	if (ret)
+		goto out;
+
+	ret = init_raid5_bioc(fs_info, bioc, full, base2);
+	if (ret)
+		goto out;
+
+	ret = insert_raid5_full_stripe(trans, bioc, full);
+	if (ret)
+		goto out;
+
+	ret = check_raid5_stripe(fs_info, full, stripe_len, 0, base2, false);
+	if (ret)
+		goto out;
+	ret = check_raid5_stripe(fs_info, full + stripe_len, stripe_len, 1,
+				 base2 + (u64)SZ_1G, false);
+	if (ret)
+		goto out;
+	ret = check_raid5_stripe(fs_info, full, 2 * stripe_len, 2,
+				 base2 + 2 * (u64)SZ_1G, true);
+	if (ret)
+		goto out;
+
+	ret = btrfs_delete_raid_extent(trans, full, stripe_len);
+	if (ret) {
+		test_err("deleting data stripe 0 failed: %d", ret);
+		goto out;
+	}
+	ret = btrfs_delete_raid_extent(trans, full + stripe_len, stripe_len);
+	if (ret)
+		test_err("deleting data stripe 1 failed: %d", ret);
+
+out:
+	btrfs_put_bioc(bioc);
+	return ret;
+}
+
 static const test_func_t tests[] = {
 	test_simple_create_delete,
 	test_create_update_delete,
@@ -1175,6 +1391,8 @@ static const test_func_t tests[] = {
 	test_punch_hole_3extents,
 	test_delete_two_extents,
 	test_read_data_and_parity,
+	test_raid5_simple_create_delete,
+	test_raid5_create_update_delete,
 };
 
 static int run_test(test_func_t test, u32 sectorsize, u32 nodesize)
-- 
2.54.0

