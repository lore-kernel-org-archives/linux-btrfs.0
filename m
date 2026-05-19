Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B111A33A6F2
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779205785; cv=none; b=VlabtHQ8yYGt55nWbjzV8UTHDPD9IwnU/dkS2o6yjWZygPAKMx9CeAKNzdT9Dm+VSPSwaiOh35hn+nr70PPhqy6lgmUhFc/QEgFF96VBTAFBEfbZHOd3Co0C5T2FAGdWmwB3FDcvdE6FkmosghSOhLfyvwjyXbnTQgLGaZjMxv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779205785; c=relaxed/simple;
	bh=Oyr4BBIkMa0fDzEHe7rAboT9/p89/36b4ZgxAhTirGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B82DOSi042BmQ4jEHt339tCHBplE59xlT27NkfLeL08Puz7z+WMAs1eatYPRARWOBoq/pRrctWAYuzS1ctH2itKYT4Q+jovqGf8P2csbvrgMb1JmsZ5/pyE56JGm+lQWRHXHv4/VaMMYu+sDuXPFD1SOTsc4RpPBTgDWQK9z7XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lLgwBVo0; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lLgwBVo0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779205784; x=1810741784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oyr4BBIkMa0fDzEHe7rAboT9/p89/36b4ZgxAhTirGo=;
  b=lLgwBVo0w0N774EAD4LLXlD3cds8x4HACM0F7nLGwYkWWJ3ZzY37pLrM
   rFGv5hQOhLp+3A9M1w5hqaG4du8CTVmsuiFF7GScXH4SW9cSUunRteuM/
   R2aDeTzQn/uAXoEiDAIcf2IOUbflnI5F/w4U4k6ODMAa2AELuOn02vzJO
   /69snL4vRIrKrnTw0cCSlWTIZcVBe3OOTASYdM/+920Tx1yai3B5FfV+k
   Q7e7cYY50GUArVy6J8WqZX++/W8PoSANrPy6IvmamcZ1IgBahoL7+1p2T
   K5Zdz6iodjDcWSLea2BgChHBWqOnWyGEdR+Zz6stsep5rbeaQOhFjU97B
   A==;
X-CSE-ConnectionGUID: SOuSkeqPR7KFsvMpPXrxoA==
X-CSE-MsgGUID: WQiWhJ5kTRCnKCss6n8yFQ==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="146893473"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2026 23:49:35 +0800
X-CSE-ConnectionGUID: +cnIhuULTUGTtrkpYwQjYQ==
X-CSE-MsgGUID: izMSpvybSYSlNQxEJsQ8Ig==
IronPort-SDR: 6a0c8685_bbSo4A4csoSYbr7+/LYIh22jiohm2jWRBypOzUvdOVcoYgw
 t/gkX3TSaEuvWfBDLojg/O2szf7qkmkKXhZ76fA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 08:49:24 -0700
X-CSE-ConnectionGUID: qUcJqIu4RFiwBROyG1hHuw==
X-CSE-MsgGUID: rmk6EDxdQX2h1iVMUdYqjg==
WDCIronportException: Internal
Received: from wdap-koukjqvp2n.ad.shared (HELO neo.fritz.box) ([10.224.19.38])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 May 2026 08:49:21 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 3/5] btrfs: zoned: always set data_relocation_bg
Date: Tue, 19 May 2026 17:49:00 +0200
Message-ID: <20260519154902.223445-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When searching for a data relocation block-group on mount,
btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
block-group. But it first checks if the block-group is empty and if yes
continues the search, and then checks if it is the first DATA block-group.

Reverse the order, first check if it is the first DATA block-group found
and skip, then check if the block-group is empty. This enusres that there
is always a DATA block-group set as data_relocation_bg in the filesystem.

Singed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 16dd87aa06f2..dcdd7f8d8406 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2784,14 +2784,14 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 again:
 	bg_list = &space_info->block_groups[index];
 	list_for_each_entry(bg, bg_list, list) {
-		if (bg->alloc_offset != 0)
-			continue;
-
-		if (first) {
+		if (first && bg->alloc_offset == 0) {
 			first = false;
 			continue;
 		}
 
+		if (bg->alloc_offset != 0)
+			continue;
+
 		if (space_info == data_sinfo) {
 			/* Migrate the block group to the data relocation space_info. */
 			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
-- 
2.54.0

