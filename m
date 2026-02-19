Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ECB33D4F9
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2026 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771518128; cv=none; b=FH36ZCLG07kKxte0vVgdnoZDsieKCKVVXcmr+FiN/qPZakxBhL3E6dzuojFX1mnld3vH+c43c7oUC2BMVbv1+gCgDXAjADCd0RhMqQkZ7tBQUVOogbZ3l0tFnNOuUyBI9Sj0bi/7E7ZSM9UdcMXS0Q6jlWgg2ovV89+qN1OpOEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771518128; c=relaxed/simple;
	bh=2u+QuXyRnRBWWXrPVdNd9N6FQqG1Y+FKePA8Hc0w7Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=AVWJLAaMlg5Dz09upL1JRk2LHeiEN4V6m96cWmwYgcaek1V12nPO4Ui54vNeKmTRwGz8FTbu5azV+zKjroqUsaZ4Ru+cMP/zE8I6QS2iZoUzlEDCYwcJgNXxxf8wALFKXJFnYxewVAuP0imPBwmVrHZr/mmUpUWxu5XwtJ9sXMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=CU8XMNQV; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="CU8XMNQV"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 9180A304017;
	Thu, 19 Feb 2026 16:21:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1771518116;
	bh=huY5bV0NJ+ADNZPe8pjNckz24UaYhTL4bttJnXu6B6A=;
	h=From:To:Cc:Subject:Date;
	b=CU8XMNQVXJhdlixgkNisixX0OJjbQj43J4IKT8rLESq8VeXgF81ryK1iMQGyBiCBU
	 gF04aCgHXULk5+8dm4wDNM660pyjIDTKpMJdmhQXdh0bY2hw9kkeC2mSivcUTYZUmF
	 4f6bDa6iR//YTlbkLq4qdRX/7RZ3K6mczMf1hKow=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Chris Mason <clm@fb.com>
Subject: [PATCH] btrfs: fix transaction handle leaks in btrfs_last_identity_remap_gone()
Date: Thu, 19 Feb 2026 16:21:46 +0000
Message-ID: <20260219162151.5567-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_abort_transaction(), unlike btrfs_commit_transaction(), doesn't
also free the transaction handle. Fix the instances in
btrfs_last_identity_remap_gone() where we're also leaking the
transaction on abort.

This fixes a bug introduced in "btrfs: handle deletions from remapped
block group" in for-next.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
Suggested-by: Chris Mason <clm@fb.com>
Link: https://lore.kernel.org/linux-btrfs/20260125125129.2245240-1-clm@meta.com/
---
 fs/btrfs/relocation.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8a8a66112d42..f2abc5d625c1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4715,6 +4715,7 @@ int btrfs_last_identity_remap_gone(struct btrfs_chunk_map *chunk_map,
 	ret = btrfs_remove_dev_extents(trans, chunk_map);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
 		return ret;
 	}
 
@@ -4724,6 +4725,7 @@ int btrfs_last_identity_remap_gone(struct btrfs_chunk_map *chunk_map,
 		if (unlikely(ret)) {
 			mutex_unlock(&trans->fs_info->chunk_mutex);
 			btrfs_abort_transaction(trans, ret);
+			btrfs_end_transaction(trans);
 			return ret;
 		}
 	}
@@ -4742,6 +4744,7 @@ int btrfs_last_identity_remap_gone(struct btrfs_chunk_map *chunk_map,
 	ret = remove_chunk_stripes(trans, chunk_map, path);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
 		return ret;
 	}
 
-- 
2.52.0

