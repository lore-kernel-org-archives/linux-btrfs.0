Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EB2360ECF
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859750; cv=none; b=U1qh0bhtnUsdBaIhDhFj/2qsdSGg4IO5q6IYuZldZda7KlfdPNfC+d2bf2M5msp3/WeXtmc+6jYh9NHkFNRFh5SZsGJle8X9uiVg4ReOoCuWWyTCgmieaBtXvifBCSsgWbzVJ6Q3knLg8NmQ66U/291dpGlVm3zKXT2jLZCvPIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859750; c=relaxed/simple;
	bh=5dX8pGhTqwvHkLDoBz/1MUmAbJl8wMMT9gdmoUADNuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebO+sHlH68Imcw5XcjkO0sMpNZU3FQotdec+sJLS+Jl5D6Mt0cZbq29DR9bAB2OjMx2QGKNKK4IxW1lxBOUnqiX4PLljufgHpTn6MHB6X4YLt1boKahrlyJ1MF/OUM/SeQtzjYVeDr4VMV9bmnCJhwjkbtZtISTHeYHQdZo6EK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GZLNlC2L; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GZLNlC2L"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859750; x=1813395750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5dX8pGhTqwvHkLDoBz/1MUmAbJl8wMMT9gdmoUADNuQ=;
  b=GZLNlC2Lz7O0zW/DmjkbjoqWo4kcqAyajjqKs1bc5Rire88E+34T1Oin
   wFfmVtYHCq2UydoYZ8sYBEvsc04Kw9sDG7yj2fYOufx9Gr6IX5YdYwj0o
   4/BwgWVbIvTW8G1AkTMzgAeO9v60ERBGns4Z2pXQTkzYC7MnU7o4kpk+z
   /aeqPLEKSNWjUJzaZ3IhT5rGXU5woyYXJqn7fkWptM5KXPYThfmv+9ZDL
   JOXFzUhA+yK7L5gz3pixDqphlhLroLWUYv3BaADvgCx4Qv5KcPRwdb4b6
   vtNh88OMHpZ/ZRBi1BfJVe3chMeJiwNfA60s0AxmATVvMZ+dayBnhmHhC
   A==;
X-CSE-ConnectionGUID: gUPilvcgT62zEkyS4/jmfA==
X-CSE-MsgGUID: ubenfqZhRNuJNLw2/pq6rg==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951271"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: MxGUjYPASPGceMwF74WMIQ==
X-CSE-MsgGUID: 087lio70T4GwaSnIWE4glw==
IronPort-SDR: 6a35059a_3CN2VxLBXvqG8iwr8YUqmW6sFJ+cpZRWwQIXtkeSxpE81X6
 osxneIT0Ev5mgBLPwTId0gb1RnRuJdqs3AUSOlQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:18 -0700
X-CSE-ConnectionGUID: bvt3x9mbQ6eXaf+VJArC7g==
X-CSE-MsgGUID: r9rJFVV6RSmz7PKdtXHO0g==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:17 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 03/15] btrfs: introduce BTRFS_RAID_STRIPE_PARITY_KEY
Date: Fri, 19 Jun 2026 11:01:58 +0200
Message-ID: <20260619090211.497100-4-johannes.thumshirn@wdc.com>
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

Introduce BTRFS_RAID_STRIPE_PARITY_KEY. This key will be used to hold
parity information for a specific (logical, length) tuple inside the RAID
stripe-tree.

The parity information will be encoded in 'struct btrfs_stripe_extent'
containing one or more 'struct btrfs_raid_stride'. As this is the same
on-disk format that DATA stripes use, reuse 'print_raid_stripe_key()' to
pretty print the item.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/print-tree.c           |  2 ++
 fs/btrfs/raid-stripe-tree.c     | 10 ++++++++--
 include/uapi/linux/btrfs_tree.h |  1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 87e60a2d4bd8..2698b9184281 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -416,6 +416,7 @@ static void key_type_string(const struct btrfs_key *key, char *buf, int buf_size
 		[BTRFS_UUID_KEY_SUBVOL]			= "UUID_KEY_SUBVOL",
 		[BTRFS_UUID_KEY_RECEIVED_SUBVOL]	= "UUID_KEY_RECEIVED_SUBVOL",
 		[BTRFS_RAID_STRIPE_KEY]			= "RAID_STRIPE",
+		[BTRFS_RAID_STRIPE_PARITY_KEY]		= "RAID_PARITY",
 		[BTRFS_IDENTITY_REMAP_KEY]		= "IDENTITY_REMAP",
 		[BTRFS_REMAP_KEY]			= "REMAP",
 		[BTRFS_REMAP_BACKREF_KEY]		= "REMAP_BACKREF",
@@ -571,6 +572,7 @@ void btrfs_print_leaf(const struct extent_buffer *l)
 					btrfs_item_size(l, i));
 			break;
 		case BTRFS_RAID_STRIPE_KEY:
+		case BTRFS_RAID_STRIPE_PARITY_KEY:
 			print_raid_stripe_key(l, btrfs_item_size(l, i),
 				btrfs_item_ptr(l, i, struct btrfs_stripe_extent));
 			break;
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 1a6ebd10849a..48436b056191 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -413,6 +413,7 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 	BTRFS_PATH_AUTO_FREE(path);
 	struct extent_buffer *leaf;
 	const u64 end = logical + *length;
+	int type = BTRFS_RAID_STRIPE_KEY;
 	int num_stripes;
 	u64 offset;
 	u64 found_logical;
@@ -422,7 +423,7 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	stripe_key.objectid = logical;
-	stripe_key.type = BTRFS_RAID_STRIPE_KEY;
+	stripe_key.type = type;
 	stripe_key.offset = 0;
 
 	path = btrfs_alloc_path();
@@ -440,6 +441,10 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 	if (ret) {
 		if (path->slots[0] != 0)
 			path->slots[0]--;
+
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
+		if (found_key.type != type && path->slots[0] > 0)
+			path->slots[0]--;
 	}
 
 	while (1) {
@@ -456,7 +461,8 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 			goto out;
 		}
 
-		if (in_range(logical, found_logical, found_length))
+		if (in_range(logical, found_logical, found_length) &&
+		    found_key.type == type)
 			break;
 
 		ret = btrfs_next_item(stripe_root, path);
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index cc3b9f7dccaf..7b2f5f4cf78c 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -284,6 +284,7 @@
 #define BTRFS_CHUNK_ITEM_KEY	228
 
 #define BTRFS_RAID_STRIPE_KEY	230
+#define BTRFS_RAID_STRIPE_PARITY_KEY	231
 
 #define BTRFS_IDENTITY_REMAP_KEY 	234
 #define BTRFS_REMAP_KEY		 	235
-- 
2.54.0

