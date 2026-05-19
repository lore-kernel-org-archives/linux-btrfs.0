Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A85133CEA2
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779205786; cv=none; b=UGvpBISau3WmQlA3cwKrLoN9aGwxu96snz/XiZClMmjFwXpMrSyWiRG9cOIyWDvjMZ0KpcjEE41J+/c5jyuzCa4f5Ue5QEN0+kq7zQCcZau78gY3j5AOQruCw/kJFvDUJn2sMCJapRqen1q7ZRBk1MQUru7I6gx0ylwE7k0fHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779205786; c=relaxed/simple;
	bh=QIwxj31/5VBzDMVxffgyoQVY+bNsJfwI8ursT3USiUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRhgMG2FdDNqV6AbEcPZ37T4LjIv8t8YF24fVjauwa52m4jwAeooLI9SP0aNMuRWLLLbVBAdhZCcsCHzDAImaw8n0F68cJ8hc+3GcDywfdPVVtI5hGZZRvLUpjDYsQ3whg+kWuIEUEPgM7xm1c9diRBwnr/H04N7T5IHKcrjc1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UZVmiezf; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UZVmiezf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779205784; x=1810741784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QIwxj31/5VBzDMVxffgyoQVY+bNsJfwI8ursT3USiUw=;
  b=UZVmiezfaq0WrgLG4gAKVuKxpdsrPSGYsSgj/A3d9XByjdWiAW3DG10o
   TYZn+s+HP95d0wSdFiN1SSZKxYwpxpQrGyDZVs7+KEEnc7I0OY0on+FS3
   PUShdi+gZfSsHyCTaO/KAR2Z65Xe7Es5N799YImKcdbyoMtkvkRybH2e/
   ejj/0R7Y7MIZOd6ALWB1zi77TpPN71Fb4u3i4aLsD7a6PV6e15VLOxmFm
   Au2PrZLtGW4RWQCPnDH7xaRzqUfPgfokSbI7MCOp0OKWfDrQpVSVc21xQ
   Gjj9PCYHDLcYjlZ//oM9x58H3XoRy26bRRr9wauGXGab11NTfj8/EFt3x
   Q==;
X-CSE-ConnectionGUID: 4OYDMGsnQcGnVkS1fdWjLg==
X-CSE-MsgGUID: hs48l/79SBusmM8SxaVKfw==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="146893474"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2026 23:49:35 +0800
X-CSE-ConnectionGUID: 4xiL7cG3RtuAo3lI8FjnRw==
X-CSE-MsgGUID: qKirw4htRKKr1LKdmCVgXA==
IronPort-SDR: 6a0c8689_WXm2pa2cKoZxuVsQ6AtSjadkN/gbWbmLwcpeDB9ar4WX+OM
 BAToagF7rojsjhMKuYI2pkFMWbNW9GJRNUtKkUg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 08:49:28 -0700
X-CSE-ConnectionGUID: xuZCxZp0SFuCuN86sqDhLA==
X-CSE-MsgGUID: uqlnPxfLT6q4YY2ei3DhGA==
WDCIronportException: Internal
Received: from wdap-koukjqvp2n.ad.shared (HELO neo.fritz.box) ([10.224.19.38])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 May 2026 08:49:25 -0700
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
Subject: [PATCH v2 4/5] btrfs: zoned: don't account data relocation space-info in statfs free space
Date: Tue, 19 May 2026 17:49:01 +0200
Message-ID: <20260519154902.223445-5-johannes.thumshirn@wdc.com>
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

Don't account the free space in a data relocation space-info sub-group as
usable free space in statfs.

This is misleading as no user allocations can be made in this space-info
sub-group. It is only a target for relocation.

Fixes: f92ee31e031c ("btrfs: introduce btrfs_space_info sub-group")
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

