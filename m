Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2168041D64B
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 11:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784203045; cv=none; b=QAL9GaOSA8yvTRvFgVvqev984Cr+tMlhd1cTF0ZKUmKdIeuA7m/51QYYMpma4h8z2pie7VRw5l4iyyIq2aCyQJytVPstNqzINzn107mFoI9/8n3vVFoLiUFbFBcSfKqgSTyqjKKVTqwA3lPV8TF7mLnlyJhZj3NnGLCpssTL6pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784203045; c=relaxed/simple;
	bh=znlNi3DzKa4tU+LJfbL10zLHA8+G3qg+aZ6cF3wh8ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hkfo8VRPUIrTMh0hDCdThKguCP1fYlz9azWBpelHws+oofTzgAWc/hObZQ/eBsJLFNuJki5OmYGzt4H9RIzbu0wq8PfN03PnDH1pmB+IqwOh4BVJL8KfvCyhLhCcr1RvOjpnRZLsdQMJk+1geV33up+2VguJHd2A5IDXiEox8FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cVR4fjLQ; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cVR4fjLQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784203043; x=1815739043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=znlNi3DzKa4tU+LJfbL10zLHA8+G3qg+aZ6cF3wh8ZI=;
  b=cVR4fjLQZLwD/DnfSlMUhxlBSw131REJFAWBzbz9MciglGks1394X2ex
   /b74vvyWE6nuls1pAyXrtdE5cayA5Bdfl2o0CGX8BS5GtEodgppuyW+zf
   GOesPHip6spn+ErUUsndWrNUeK8glpx7J6pkPMDZu2/yrMQctqhQ6Orbo
   WLh3CT0EM/gIwVuHjWYg8/1SsshBjl2g354RKUr514tOhZkVzjHtVjYtN
   nyEe6cWz0rh1bMQKSDnzQowGW4JZVJiqLzof2IZro4iOCZBOjI8zwJSU+
   s9gpJrBWK0nf2XmBB4ASzznTbNV1hLNSvi+syjEi1IoT46nQo1gWDCvme
   A==;
X-CSE-ConnectionGUID: LBgdlbrIRKykDbABDPMvfQ==
X-CSE-MsgGUID: iZpox4xrQMOkebI0iVfthg==
X-IronPort-AV: E=Sophos;i="6.25,167,1779120000"; 
   d="scan'208";a="150860086"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2026 19:57:14 +0800
X-CSE-ConnectionGUID: 9oh5UaS2R22ou4w0/S1+hg==
X-CSE-MsgGUID: xcgLL2s/REOM5Icf8XGq7A==
IronPort-SDR: 6a58c714_5LOSM/mA49q0ZL/1uSykXUTZdRqbwD78dJXmx+efz3QvpCo
 7NKrR1hU+3yhJ6mya/72aa/nsfNecjUdwLKrPYA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jul 2026 04:57:08 -0700
X-CSE-ConnectionGUID: cyntEd6cQAGgPdawxMPWZg==
X-CSE-MsgGUID: lEFtO3zUSrmilOBJjFaxDA==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 16 Jul 2026 04:57:07 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 4/5] btrfs: walk waited ordered roots in place
Date: Thu, 16 Jul 2026 13:56:55 +0200
Message-ID: <20260716115656.1319295-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
References: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like the previous change for btrfs_wait_ordered_extents(), walk
fs_info->ordered_roots in place instead of splicing it onto a private list,
so the roots with pending ordered extents stay visible while we wait.

No functional change intended.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/ordered-data.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 11aa7e8efe04..ddd21aa5c640 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -836,19 +836,22 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, u64 nr,
 			      const struct btrfs_block_group *bg)
 {
 	struct btrfs_root *root;
-	LIST_HEAD(splice);
 	u64 done;
+	u64 remaining;
 
 	mutex_lock(&fs_info->ordered_operations_mutex);
 	spin_lock(&fs_info->ordered_root_lock);
-	list_splice_init(&fs_info->ordered_roots, &splice);
-	while (!list_empty(&splice) && nr) {
-		root = list_first_entry(&splice, struct btrfs_root,
-					ordered_root);
+	remaining = 0;
+	list_for_each_entry(root, &fs_info->ordered_roots, ordered_root)
+		remaining++;
+	while (remaining && nr && !list_empty(&fs_info->ordered_roots)) {
+		remaining--;
+		root = list_first_entry(&fs_info->ordered_roots,
+					struct btrfs_root, ordered_root);
+		list_move_tail(&root->ordered_root, &fs_info->ordered_roots);
 		root = btrfs_grab_root(root);
-		BUG_ON(!root);
-		list_move_tail(&root->ordered_root,
-			       &fs_info->ordered_roots);
+		if (!root)
+			continue;
 		spin_unlock(&fs_info->ordered_root_lock);
 
 		done = btrfs_wait_ordered_extents(root, nr, bg);
@@ -859,7 +862,6 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, u64 nr,
 
 		spin_lock(&fs_info->ordered_root_lock);
 	}
-	list_splice_tail(&splice, &fs_info->ordered_roots);
 	spin_unlock(&fs_info->ordered_root_lock);
 	mutex_unlock(&fs_info->ordered_operations_mutex);
 }
-- 
2.54.0

