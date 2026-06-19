Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE71C321F5F
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859749; cv=none; b=OSDoUpI6VMHU/YDMbQPC79+zBgqLUISCpXQOiWQzet9QnfZ9gRIUdQWTQniJFCWrTivQ4om1EVBJAa8HcWtCUb0whO2etVtezywHFjMcuZzYdJ6+u7i3tDRZKNxwjL1FnEDvuqJC1zRGg4RN9b8JcV9vVabbIBZmIlFdvotAiNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859749; c=relaxed/simple;
	bh=KueDKfYvI4Zr/76+LhKguOoy9ItYVabs5PyhugqlERM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtQP/zmmXcFaLJTeoWLkoOqc5wvBTc+jtDKDgn25TiHFCliDMMHrjb9FsR+4aKTByYmt1NNr3UHvoP89a6IlVdAssG4Bp3YdcIWNtuMr0MPXeY1BV1sk7vgnr7/K3T15f1BBAS+1iNOJvXWbygnHd4ct9Jy4UxRGTZvPELR1pZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nM6YCU02; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nM6YCU02"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859749; x=1813395749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KueDKfYvI4Zr/76+LhKguOoy9ItYVabs5PyhugqlERM=;
  b=nM6YCU02mJjxo6SV8R0OD6M3LmTQxfmVfhXA2YRXUW1qpN/wqIh17XgK
   fmS8d0VmtvR7eK/x6cOUf03hj6ZeefJXH9abBknW7N7rLZmPzUQSJQZcK
   hYnIvgAAZ8Xu0N8FSSOT3p5OqjSd/ceKqe/zyTT6w4wivTecapukttCvc
   z2NNnYGtQKFNUjil9s6UfmJBWPhU0wMZoIpdxXbT8o7cml6QJKDxMWm5I
   DKUMfWpZJKjFVr/MnKifhoymHge3ASCLMaI5ZLyquBHPldPtDXTejPZJ4
   uYSRKDweGzJhlMW/6O+mCycCJ7gWLeCE+cqHTsAPz2twgoEpw1VchgPhF
   g==;
X-CSE-ConnectionGUID: Le7ci1gLTjqIP381iDht8g==
X-CSE-MsgGUID: +DnmMxdRTWWZHYEnNLvzwA==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951269"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: Cos4IOZeTwqGkUmn269fcA==
X-CSE-MsgGUID: WHRfUBCXT06B5Mqhzq3Auw==
IronPort-SDR: 6a350598_vHbiccGFWud8Vw17FTbqlV4Ixiuj2ifIRJPfYJbr66yv1/3
 sUeBHIHKFu4B5qSBVm1zBgj12+DTsmWqP0BiwAw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:16 -0700
X-CSE-ConnectionGUID: 5/NLH0rER4mU01imRBpoKA==
X-CSE-MsgGUID: LqdAzHo1SairK7yvoUnOYA==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:15 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 01/15] btrfs: factor out filling a single raid_stride
Date: Fri, 19 Jun 2026 11:01:56 +0200
Message-ID: <20260619090211.497100-2-johannes.thumshirn@wdc.com>
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

Move the code filling a single btrfs_raid_stride from a stripe into a
helper, fill_raid_stride(). No functional change, but it is a preparation
for the parity strides.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/raid-stripe-tree.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 454a95bf542a..8592fa76728e 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -322,6 +322,16 @@ static int update_raid_extent_item(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static void fill_raid_stride(struct btrfs_io_stripe *stripe,
+			     struct btrfs_raid_stride *raid_stride)
+{
+	u64 devid = stripe->dev->devid;
+	u64 physical = stripe->physical;
+
+	btrfs_set_stack_raid_stride_devid(raid_stride, devid);
+	btrfs_set_stack_raid_stride_physical(raid_stride, physical);
+}
+
 EXPORT_FOR_TESTS
 int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 				 struct btrfs_io_context *bioc)
@@ -344,12 +354,9 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	trace_btrfs_insert_one_raid_extent(fs_info, bioc->logical, bioc->size,
 					   num_stripes);
 	for (int i = 0; i < num_stripes; i++) {
-		u64 devid = bioc->stripes[i].dev->devid;
-		u64 physical = bioc->stripes[i].physical;
+		struct btrfs_io_stripe *stripe = &bioc->stripes[i];
 		struct btrfs_raid_stride *raid_stride = &stripe_extent->strides[i];
-
-		btrfs_set_stack_raid_stride_devid(raid_stride, devid);
-		btrfs_set_stack_raid_stride_physical(raid_stride, physical);
+		fill_raid_stride(stripe, raid_stride);
 	}
 
 	stripe_key.objectid = bioc->logical;
-- 
2.54.0

