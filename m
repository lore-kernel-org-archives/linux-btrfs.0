Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1989B392C28
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2026 10:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015749; cv=none; b=SMFhxQ/af/tGOY1caBuec3ViqRjg2exKIfUdtLr3IB8cZYkEMUNKPDYP/dV07WNTp9YhI4QoCpugjtWgBlyXxihmXlM4xXoV5OwFd6e2paaDNMFxismTFjyW8zKoUIReC7C2AknT7+4QZD58sv9F2KA+rGNRIHw2yb0sN7Lx7Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015749; c=relaxed/simple;
	bh=rQMZb17AmZe8MelEYng6HviPHhEikUP5it68QLXt6FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=LPCQRTVkAJ1gIWM4s8F5C/wmarRAeG2oufh2K1wJDRFpYOz+JXmCSx16nM3sGOUKlDUO/Ftl18z7mk8MQgVr5F4zFggAe71mTOzRvUsUABAqZ7ZYoVL/PITDgVHmpfL5xqRGJtWmqvTkU1z29CMH7nvI7mQ5E1J1BdcSC1zX/AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=LL2N5C2v; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="LL2N5C2v"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 26D4B306F2A;
	Wed, 25 Feb 2026 10:35:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1772015737;
	bh=5UgOqhlwQqFt+d7OaLRFnswkKl7lhQBDOxCdJvxrnsg=;
	h=From:To:Cc:Subject:Date;
	b=LL2N5C2vNNCO0yuC5g52jPsVKbsBbcxOiQPUTUdXyWmvwXmXoVu6Zbbds2CgWX4kF
	 49gMmBH6wAOQjnG8eo7f8GhfinvRGQqJBIuYYSM5cv4MgirrHGOI2md3JSF/RhFJs/
	 4UPNMhsmv41rQwwlpkF9PnxnHHxj13QFqr9+ZYRc=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org,
	boris@bur.io
Cc: Mark Harmstone <mark@harmstone.com>,
	Chris Mason <clm@fb.com>
Subject: [PATCH] btrfs: fix potential segfault in balance_remap_chunks()
Date: Wed, 25 Feb 2026 10:35:31 +0000
Message-ID: <20260225103535.18430-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a potential segfault in balance_remap_chunks(): if we quit early
because btrfs_inc_block_group_ro() fails, all the remaining items in the
chunks list will still have their bg value set to NULL. It's thus not
safe to dereference this pointer without checking first.

Link: https://lore.kernel.org/linux-btrfs/20260125120717.1578828-1-clm@meta.com/
Reported-by: Chris Mason <clm@fb.com>
Fixes: 81e5a4551c32 ("btrfs: allow balancing remap tree")
Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/volumes.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e15e138c515b..18911cdd2895 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4288,17 +4288,19 @@ static int balance_remap_chunks(struct btrfs_fs_info *fs_info, struct btrfs_path
 
 		rci = list_first_entry(chunks, struct remap_chunk_info, list);
 
-		spin_lock(&rci->bg->lock);
-		is_unused = !btrfs_is_block_group_used(rci->bg);
-		spin_unlock(&rci->bg->lock);
+		if (rci->bg) {
+			spin_lock(&rci->bg->lock);
+			is_unused = !btrfs_is_block_group_used(rci->bg);
+			spin_unlock(&rci->bg->lock);
 
-		if (is_unused)
-			btrfs_mark_bg_unused(rci->bg);
+			if (is_unused)
+				btrfs_mark_bg_unused(rci->bg);
 
-		if (rci->made_ro)
-			btrfs_dec_block_group_ro(rci->bg);
+			if (rci->made_ro)
+				btrfs_dec_block_group_ro(rci->bg);
 
-		btrfs_put_block_group(rci->bg);
+			btrfs_put_block_group(rci->bg);
+		}
 
 		list_del(&rci->list);
 		kfree(rci);
-- 
2.52.0

