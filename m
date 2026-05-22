Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD7B3B7B7A
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779440596; cv=none; b=URyJj6fDQUPtyp6lcAQoNdj+8L6W0FF3ncydC+e9mWnLzLq9O/S3sHdPffQ1yWljD6WaL+aDpboh6CTGIP+MVWMVFNzSmtc1U01DeAbaPOMyTRtyyBLEAn6bEuV2UV4lRBn7QAmRveoxQD5ukjsmhKUF/KzqgvjW7uJcLFq8HZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779440596; c=relaxed/simple;
	bh=4BPTa/aiM22FaTev4nmPNy7YVzThiuLutAcVOQIGPFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmruNHS2HOqCVHS0EZdCUg2NJ9t8yKTmEc8vM+VodxlyanicxhOa76OnAy8pUXgxDyOGfrpc4AvDQGx7rFQjFyBkgczNBPWqwOIuxUqrK49bOGioo9C93Al0kB8dkZOad8yRvH4jV/hhG+SjBOOk9DLNMIfF+71vbO7/5MtNNcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QaG+spFq; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QaG+spFq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779440595; x=1810976595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4BPTa/aiM22FaTev4nmPNy7YVzThiuLutAcVOQIGPFY=;
  b=QaG+spFqMh4xeO0kWSfWXa34IDwGfsaR+KsLGFW7Z5rL7IUtwwpVLDZj
   wbvejjj4lnSk7fcvarIX8jT+5ymXTx6dD34+zqOzUcwT/6ypThdSsdBFV
   KLmvGWScPwpJ5OzG907WIjUiNk6nUa+/YPRaNPbnF/SKXOdH51rWAsVPP
   5k5BACgHJbQJj54fX/gq2tXBYVt/Ns6lEgbefNVnBRWJcmokV5vsAh9Ga
   6PP0+wiDI/7BEJ92J+TFAwE/MWHieqa1zXdYQTYiwxzf/8JvD9FFMYkqa
   J7JNSevapZDXQ2Av99J57epXuvueMdztz6yS28YidQLGVuD+AmnNWsuXO
   Q==;
X-CSE-ConnectionGUID: GJY/AGrvTPSfpxg97b+u0w==
X-CSE-MsgGUID: pqU7XjqMSNSxA2HnAjVm1g==
X-IronPort-AV: E=Sophos;i="6.24,162,1774281600"; 
   d="scan'208";a="147475601"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 May 2026 17:03:11 +0800
X-CSE-ConnectionGUID: A1YvVp46SwS4nOroHnMv2A==
X-CSE-MsgGUID: Hd3ynQP8TG2k9KsQZfv83g==
IronPort-SDR: 6a101bce_10IBRMJ2OiiZ1t6tofZePWU6XDelkwwkIb8Hct35e50CiHp
 b5UIKQeBVqpAUpIhlkvHl1Eb0RKomzj6BimojMA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2026 02:03:09 -0700
X-CSE-ConnectionGUID: u55lUwQdRaidkIYzpk4pSA==
X-CSE-MsgGUID: hhxqaEUVRJa+omCOFglpqw==
WDCIronportException: Internal
Received: from wdap-b6euub3vgq.ad.shared (HELO neo.wdc.com) ([10.224.19.8])
  by uls-op-esai1-o.wdc.com with ESMTP; 22 May 2026 02:03:08 -0700
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
Subject: [PATCH v3 4/5] btrfs: zoned: don't account data relocation space-info in statfs free space
Date: Fri, 22 May 2026 11:02:46 +0200
Message-ID: <20260522090247.27445-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
References: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't account the free space in a data relocation space-info sub-group as
usable free space in statfs.

This is misleading as no user allocations can be made in this space-info
sub-group. It is only a target for relocation.

Fixes: f92ee31e031c ("btrfs: introduce btrfs_space_info sub-group")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fb15decb0861..a0dbc0d2213f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1739,7 +1739,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int mixed = 0;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
+		    found->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC) {
 			int i;
 
 			total_free_data += found->disk_total - found->disk_used;
-- 
2.54.0

