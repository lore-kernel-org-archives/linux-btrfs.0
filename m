Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D404E360EE8
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859758; cv=none; b=aDOBEZa3QJRfTDNrqnV4GHAO/XAn5OS2DgvZ3Jt6FkAta+yEtQFOUrDMzPh6iGEnHNf43aDbaxGG322Kf70XE+nf8rbHlcVmN1o5589E6wV+HNhjd/dvMr5QYxjKzubNQq1RPUIQrSe/QF6lfOtBZs88Sol9jhoiJEyevhZtEDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859758; c=relaxed/simple;
	bh=NjAKO9ZpXEIh3bmYvFOvdo3T89fX7V5KeQcUlqVADHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EanJe953uQGdfdUCyQgw0fMCMv1NXfdja8dlNQd1Z8dlWSXmeWU6Z+H4H88Qp1g00s6irnAI2uaWvZgWj/Psy/F3AcsddTPlF2XRC0pwzqEAc/qWftdggOMVwz06bVzR1PeWyPv9MHD1wCssvM7E3ZznHAZLs9BgzVmzhiqJ5fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KFCY13Pk; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KFCY13Pk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859758; x=1813395758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NjAKO9ZpXEIh3bmYvFOvdo3T89fX7V5KeQcUlqVADHI=;
  b=KFCY13PkbWluVJpA5SGmo7FPBeg6uvY8mwmKlGI5Ktqa9PiMwP8wbPb4
   gRY2mnZdQFIRVUfvQULB1KobdEkOxrOo+wowdTzw7OXMlGuW0QYB8+DA4
   7R7sgzJ06T8teNXO7VDS5e/tCyMO8wKamA+r8l/UWUOA/AVWUt/PpoUs1
   RBsxgoVOWIghlFyZTPrPzMXDS8if9V2fPUAwtHSROUvieQOYC637udCC0
   E/JQ+PkewTQRVv2ZsTRyC41RnYOugzbURNUKvRSnJRfNCedGOWHueihf8
   M39Lk3MJbyrkHpKj25MqYWDB4l3OwLnH6+cKHePW70RYipCy1hRo9RfrZ
   g==;
X-CSE-ConnectionGUID: EH+Bi7X6RFu2LN+qWoA7IA==
X-CSE-MsgGUID: 231RHo7KSzeJxwZsUYcrgg==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951290"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:33 +0800
X-CSE-ConnectionGUID: OLvfBNHJRwmQsM7Sa4XnAw==
X-CSE-MsgGUID: tr953gulR+iBQjlsNo0thg==
IronPort-SDR: 6a3505a8_hAqOoObjvLAu/7v3ef9qMGOpD5fkJHsPj9cipy8RywlVqFj
 JRqMfKJmdk2PHmkNMbj6Z5ry3XICZJOP6FiSTgA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:32 -0700
X-CSE-ConnectionGUID: AgrBJZ7tRdCe8QCOtKB4ng==
X-CSE-MsgGUID: QG+TIzLXR6209Glwa6AMbg==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:31 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 15/15] btrfs: search commit root when relocating on RST
Date: Fri, 19 Jun 2026 11:02:10 +0200
Message-ID: <20260619090211.497100-16-johannes.thumshirn@wdc.com>
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

Relocation rewrites both the data and the RAID stripe tree inside the
running transaction, so for the duration of a balance the live stripe
tree is mid-update. Reads issued on behalf of the data relocation inode
must not observe that in-flight state: a stripe item may be
half-rewritten or about to be removed, and resolving a data column or
parity location against it would point at the wrong device offset and
corrupt the relocated copy.

Like the other relocation read paths, RAID stripe-tree lookups for the
data-reloc inode therefore have to resolve against the commit root - the
last committed, self-consistent tree - rather than the live one. Thread
the rst_search_commit_root hint from the data-reloc inode through
btrfs_map_block down to each per-column and parity lookup so relocation
reads always see a stable mapping.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/raid-stripe-tree.c | 4 ++++
 fs/btrfs/volumes.c          | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 310c5b906cfa..8d3e8414e2df 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -1137,6 +1137,7 @@ int btrfs_rst_raid56_read(struct btrfs_bio *orig,
 		bioc->logical - (full + (u64)target * BTRFS_STRIPE_LEN);
 	const u64 len = orig->bio.bi_iter.bi_size;
 	const int order = get_order(len);
+	const bool commit_root = btrfs_is_data_reloc_root(orig->inode->root);
 	struct btrfs_io_stripe pstripe = { 0 };
 	struct folio **folios = NULL;
 	struct bvec_iter iter;
@@ -1159,6 +1160,7 @@ int btrfs_rst_raid56_read(struct btrfs_bio *orig,
 		u64 dlen = len;
 
 		dstripe.dev = bioc->stripes[target].dev;
+		dstripe.rst_search_commit_root = commit_root;
 		ret = btrfs_get_raid_extent_offset(fs_info, bioc->logical, &dlen,
 						   bioc->map_type, 0, &dstripe);
 		if (ret)
@@ -1193,6 +1195,7 @@ int btrfs_rst_raid56_read(struct btrfs_bio *orig,
 			continue;
 
 		s.dev = bioc->stripes[i].dev;
+		s.rst_search_commit_root = commit_root;
 		ret = btrfs_get_raid_extent_offset(fs_info, slogical, &slen,
 						   bioc->map_type, 0, &s);
 		if (ret == -ENODATA) {
@@ -1223,6 +1226,7 @@ int btrfs_rst_raid56_read(struct btrfs_bio *orig,
 	}
 
 	pstripe.dev = bioc->stripes[nr_data].dev;
+	pstripe.rst_search_commit_root = commit_root;
 	ret = btrfs_get_parity_extent(fs_info, full + off_in_stripe, &plen,
 				      bioc->map_type, &pstripe);
 	if (ret)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 51023bfaf9dd..3211f00538a6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7274,6 +7274,12 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 	bioc->map_type = map->type;
 	bioc->use_rst = io_geom.use_rst;
 
+	if (io_geom.use_rst) {
+		for (int i = 0; i < num_alloc_stripes; i++)
+			bioc->stripes[i].rst_search_commit_root =
+				smap && smap->rst_search_commit_root;
+	}
+
 	/*
 	 * For RAID56 full map, we need to make sure the stripes[] follows the
 	 * rule that data stripes are all ordered, then followed with P and Q
-- 
2.54.0

