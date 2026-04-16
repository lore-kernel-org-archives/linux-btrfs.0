Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1CD257423
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776361453; cv=none; b=n8DU+AG2IoE5t0Jx7ms9s35YuYse12aloKwZA+kaIR6JdL/+WMZ72Oq/CrJeYfDZdSiCMZ+k498uJIDIEhkuoUh3XxIx+iKcrdpPj19YwT94nFlsY5LjoEokX/nZjkEwE28K0obvvB1YibZmRirrcXmWifmW3XcWNUuCDVmuj1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776361453; c=relaxed/simple;
	bh=UQpG4pknwQhQ8/jo0nMaduj9Yro6Cm8OBKcwC2bkgIg=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=R2s0JxleVd3OsatqfYcNGo18lPCxrgcQ5tkWru+xrebDX23wL5lxmYtZ6aQylW2k9Cjp+LzwtTRNMPAPFczdG4CtuqePyrKTNtz7o9C/GGV4GrIoGSAuehaR/SI/+EJspXi/uSXrra0CtXMfWsaVhbQfQlfvrGTs8yA3kDTxTO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=Pn93DSgj; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="Pn93DSgj"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id B574531E3D3;
	Thu, 16 Apr 2026 18:44:00 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1776361440;
	bh=xOW12QrhSrdisluGnGznJDyD4lUTjXxHQgiOVrLvCkM=;
	h=From:To:Cc:Subject:Date;
	b=Pn93DSgjyrksgpeNhX/+0qEsDVfL0vEgZIf8C/UYO5vCzBYkKjx4TumArHzTgQPhm
	 yie+zzJG1UI7HzaiPxfL5xRE9CyVkK4ZszB0yXc5XHRk5a5GgpJfIXk0UznmFOnbkX
	 s15SkR69oEY3JbUplORnTnI/qdmHcTyDo7sTNT30=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: fix double-decrement of bytes_may_use in submit_one_async_extent()
Date: Thu, 16 Apr 2026 18:43:51 +0100
Message-ID: <20260416174359.262120-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

submit_one_async_extent() calls btrfs_reserve_extent(), which decrements
bytes_may_use. If the call btrfs_create_io_em() fails, we jump to
out_free_reserve, which calls extent_clear_unlock_delalloc().

Because we're specifying EXTENT_DO_ACCOUNTING, i.e.
EXTENT_CLEAR_META_RESV | EXTENT_CLEAR_DATA_RESV, this decreases
bytes_may_use again. This can lead to problems later on, as an initial
write can fail only for the writeback to silently ENOSPC.

Fix this by replacing EXTENT_DO_ACCOUNTING with EXTENT_CLEAR_META_RESV.
This parallels a4fe134fc1d8, which is the same fix in cow_one_range().

Fixes: 151a41bc46df ("Btrfs: fix what bits we clear when erroring out from delalloc")
Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 36bbf2297a9987..abedaeb45189a2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1204,7 +1204,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 				     NULL, &cached,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DELALLOC_NEW |
-				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
+				     EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV,
 				     PAGE_UNLOCK | PAGE_START_WRITEBACK |
 				     PAGE_END_WRITEBACK);
 	if (async_extent->cb)
-- 
2.52.0

