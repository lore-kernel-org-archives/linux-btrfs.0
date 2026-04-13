Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E6C392C52
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 06:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063189; cv=none; b=PslG2Phxg5QYCvtv+ivkyGlbSpiTUnwAzuqrbcwmyiNR9+vJyicJxFqGDXTPBunk1xyjAPBE7EZ0jNkjDqMwvHZa3atBMBPYS5ZAjuBmVOMMiKagqTjU7RQGS/iUcAPp0A69k5ZkuvBehTdsbYBmsn36bbgsPZjwcFwecFG3Kfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063189; c=relaxed/simple;
	bh=xHDDHB5rQjz+W2Lukda4FSnS/Iol9RAHNxjdwLHBNu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bxIpUG2FiCofgMlmS5wJWFcCnTarEPXas0Dsmq1sNcGXSy5EiJbV6X8+iP2ekUmm8ebUU/0KaKneZmhcreLS9q/qMzOxrSsgtkk69+uBK72XOXK8vARzsdwR3gUpT4jh/kFtcm88xCbRq18DYAyKvX+VEdESXnXPqQllFvDFCz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=e0enbG4P; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="e0enbG4P"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776063178; bh=xHDDHB5rQjz+W2Lukda4FSnS/Iol9RAHNxjdwLHBNu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0enbG4PKQtjNMHmla3bH9EWEEfQ/B+ef+h2QAgHip+Z+ENgCEsni+VjRTM+bOyAt
	 w5W0pMQWd9eNG1tsH8TeAskmM5MGF8WpCjmc4I2XkN6tlwTXt5yztM73R7M2IJu3iQ
	 sjgaNl6WO5AUijsa6CB4c/vylcW037xjKI0teilo=
To: linux-btrfs@vger.kernel.org
Cc: robbieko <robbieko@synology.com>
Subject: [PATCH 1/6] btrfs: copy devid in btrfs_partially_delete_raid_extent()
Date: Mon, 13 Apr 2026 14:52:32 +0800
Message-ID: <20260413065249.2320122-2-robbieko@synology.com>
In-Reply-To: <20260413065249.2320122-1-robbieko@synology.com>
References: <20260413065249.2320122-1-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
Content-Type: text/plain

When btrfs_partially_delete_raid_extent() rebuilds a truncated/shifted
stripe extent into newitem, the loop copies the physical address for
each stride but forgets to copy the devid. The resulting item written
back to the stripe tree has zeroed-out devids, corrupting the stripe
mapping.

Fix this by reading the devid with btrfs_raid_stride_devid() and
writing it into the new item with btrfs_set_stack_raid_stride_devid()
before copying the physical address.

Signed-off-by: robbieko <robbieko@synology.com>
---
 fs/btrfs/raid-stripe-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 2987cb7c686e..5c519e161331 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -45,8 +45,11 @@ static int btrfs_partially_delete_raid_extent(struct btrfs_trans_handle *trans,
 
 	for (int i = 0; i < btrfs_num_raid_stripes(item_size); i++) {
 		struct btrfs_raid_stride *stride = &extent->strides[i];
+		u64 devid;
 		u64 phys;
 
+		devid = btrfs_raid_stride_devid(leaf, stride);
+		btrfs_set_stack_raid_stride_devid(&newitem->strides[i], devid);
 		phys = btrfs_raid_stride_physical(leaf, stride) + frontpad;
 		btrfs_set_stack_raid_stride_physical(&newitem->strides[i], phys);
 	}
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
