Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031D535E1D1
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859751; cv=none; b=jFO573vvzlllNghMmUwjhp8ygKlDAg8cG7PTLrm8wTZK+3uiJTZwMuJMzyn8KofG7ZP/AjrhOishlV6unCr8rItRGw3YOdrh6rYdpmzlxaUC8HNhoY5s9pcstZTE/h0EWmXX9odcAffgqoM5FdPUuWRmUSKVyPcZin4jgTPSeTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859751; c=relaxed/simple;
	bh=XwriyZR6kQ+6tZoTHo0/LoarjPJT8ucaECN5c1uMtPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moDfpHiUkupZieOrqoqSrRq6yBDhJWx4LQwrzzo6FSO3zZD1Zs1WX76foX3uiVghb2Pe27nLADbYyuhLReZRSvsepMULTk7Fh4au4F3Exn1RqUTHGvek+sbOmjz1nHmYvpEQNqp7IougTQbR2XGk3WrwFoxGzhWYvGgrNvgyjrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JwUTu2Gs; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JwUTu2Gs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859751; x=1813395751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XwriyZR6kQ+6tZoTHo0/LoarjPJT8ucaECN5c1uMtPU=;
  b=JwUTu2Gsayyil3z5Z4LAg8jwN3mtuHvwH6RkXHMmUsnQk09GkCkRkycE
   oxP5WmQVgDeW3tVSWGWV1+LbhEvfEMJ6S0Ft+K+T0dgZavjAZyRjTUCAQ
   lKtHU2nmPf/hrmEXPKs5SXXOz2aaiFwzFJBMQ6Kw9IA1zvQZHOB3G36kg
   GHTPpjnmgo12FaJmlynCZRfjCJEootVW7vmMXMpj4tZn7L7UPmv4U82J8
   nQ13ijqg4i422/cqO2xFxuXQdMtALE/Gz/X70vYzvIQa+uE/IBKoZ6iSq
   YRmJ5x39NoA7ZY2gDk7+IAyeKu9z9ET/6JavRsTC2xFGbM2xF3nsLxy2t
   A==;
X-CSE-ConnectionGUID: JWNNparsSMG1GxUYH3H7cg==
X-CSE-MsgGUID: 5NFiqc+ZTuWfRtXDe74tVg==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951273"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: w1Mk4BnfRhyAlGhChvJ6oA==
X-CSE-MsgGUID: M9l9AdaGSTycUQMM66PT3A==
IronPort-SDR: 6a35059c_M7xlUC95WkKUScCjSfIynPERX3LzBnugg/PpFwU28G8IjLv
 WWu/QPbHHtT4CTs3TCH0EfCvs4zop9dEkU6+4WA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:20 -0700
X-CSE-ConnectionGUID: Q7qV/H7ZTNegbUF1fHE6Mg==
X-CSE-MsgGUID: If2iG4AKRuKPpXfNCbgY4A==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:20 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 05/15] btrfs: load raid56 block-groups
Date: Fri, 19 Jun 2026 11:02:00 +0200
Message-ID: <20260619090211.497100-6-johannes.thumshirn@wdc.com>
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

On mount btrfs_load_block_group_zone_info() recovers each block-group's
allocation offset and zone capacity from the devices' write pointers,
add the loading for for RAID5/6 block-groups.

Unlike RAID0, RAID5/6 on the raid-stripe-tree rotates the data and parity
stripes over the devices, so a device's zone holds a mix of data and
parity stripe units from different rows and the per-device write pointers
are not a set of monotonically filled data columns. Recover the logical
allocation offset from the sum of the write pointers instead: a full
stripe row writes exactly one stripe unit to each of the num_stripes
devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ab386b4afa72..fcc960727374 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1855,6 +1855,72 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 	return 0;
 }
 
+static int btrfs_load_block_group_raid56(struct btrfs_block_group *bg,
+					 struct btrfs_chunk_map *map,
+					 struct zone_info *zone_info,
+					 unsigned long *active,
+					 u64 last_alloc)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	const int nr_parity = btrfs_nr_parity_stripes(map->type);
+	const int nr_data = map->num_stripes - nr_parity;
+	bool has_conventional = false;
+	u64 wp_sum = 0;
+
+	if (!(map->type & BTRFS_BLOCK_GROUP_DATA)) {
+		btrfs_err(fs_info, "zoned: only data profile is supported for %s",
+			  btrfs_bg_type_to_raid_name(map->type));
+		return -EINVAL;
+	}
+
+	if (!fs_info->stripe_root) {
+		btrfs_err(fs_info, "zoned: data %s needs raid-stripe-tree",
+			  btrfs_bg_type_to_raid_name(map->type));
+		return -EINVAL;
+	}
+
+	for (int i = 0; i < map->num_stripes; i++) {
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
+			continue;
+		if (zone_info[i].alloc_offset == WP_CONVENTIONAL) {
+			has_conventional = true;
+			continue;
+		}
+		wp_sum += zone_info[i].alloc_offset;
+	}
+
+	if (has_conventional) {
+		bg->alloc_offset = last_alloc;
+	} else {
+		u64 row_bytes = (u64)map->num_stripes << BTRFS_STRIPE_LEN_SHIFT;
+		u64 nr_rows = div64_u64(wp_sum + row_bytes - 1, row_bytes);
+
+		bg->alloc_offset = wp_sum -
+			(((u64)nr_rows * nr_parity) << BTRFS_STRIPE_LEN_SHIFT);
+	}
+
+	for (int i = 0; i < nr_data; i++) {
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
+			continue;
+		bg->zone_capacity += zone_info[i].capacity;
+	}
+
+	for (int i = 0; i < map->num_stripes; i++) {
+		if (!map->stripes[i].dev->bdev)
+			continue;
+		if (!btrfs_dev_is_sequential(map->stripes[i].dev,
+					     map->stripes[i].physical))
+			continue;
+		if (zone_info[i].alloc_offset != 0 && test_bit(i, active)) {
+			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+
 EXPORT_FOR_TESTS
 int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
@@ -1886,6 +1952,8 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 		break;
 	case BTRFS_BLOCK_GROUP_RAID5:
 	case BTRFS_BLOCK_GROUP_RAID6:
+		ret = btrfs_load_block_group_raid56(bg, map, zone_info, active, last_alloc);
+		break;
 	default:
 		btrfs_err(fs_info, "zoned: profile %s not yet supported",
 			  btrfs_bg_type_to_raid_name(map->type));
-- 
2.54.0

