Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E4B3C00B0
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2026 12:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768913420; cv=none; b=Dvkx0v3fkxTRcup6o5ShajGQc7wKWqtvdJ9iayWJu32N3etRtQCJ16WlVK0rg/CJ0mqyESDqjDi7P13j6ZBEYI5tBnVRhv1biSgqCDdqyfJvmPULkSSPZFquoqV5dqAwHWVntkNv11HHIQqALyn3pfo6x/S5aIUm1gqHffNgS94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768913420; c=relaxed/simple;
	bh=iHpapYmCPRQBesvU2Zjl+JI2P//7RwZ7khmi5XSNCKk=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=FG0bUFdGFahLFgpR4gRrQCTYkpxVdLV9SUluO1hL780LjpPnRMu+Ik+TyN6h9lMXLTd9BgjrtC0FsfTBGuZxss8B6BZTkUFveeSQE33XAW+PajYLFpbi32bvCOQQvZZpNAzygYIUyLYHFCmUruda5KE4Vf/zX3RIUlTV2jQnvSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=cD4YVRm3; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="cD4YVRm3"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id E775F2F6B8E;
	Tue, 20 Jan 2026 12:50:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1768913405;
	bh=XbRGQL0gzl07yD3eql6++7UIEx2PstZwriXxU5ZKfOI=;
	h=From:To:Cc:Subject:Date;
	b=cD4YVRm3uFXC+a6uVZb616sa1YRJ/krZwVDb5LxCONpAFG3Axr9oylI7Uv3lUIECK
	 HbQJyR6HEiOSsR+8urS8iU/y0PwKMxRAY1r8yPP03OcfBV8jIUf6Kvnx1yLfNWxtEu
	 1EihnwZV6k1CYPp3ltrj2YwSHcc+d/YEYFGskk5c=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: avoid spurious -Wmaybe-uninitialized warnings in do_remap_reloc_trans()
Date: Tue, 20 Jan 2026 12:49:58 +0000
Message-ID: <20260120125000.26588-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

find_next_identity_remap() sets the values of the start and length
pointers if it returns 0. Some versions of GCC are unable to analyse
this properly and give spurious -Wmaybe-uninitialized warnings, so
initialize the values in do_remap_reloc_trans() to avoid this.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/relocation.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 065db3f7840e..da4749d6bfa0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4940,7 +4940,8 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 	struct btrfs_root *extent_root;
 	struct btrfs_key ins;
 	struct btrfs_block_group *dest_bg = NULL;
-	u64 start, remap_length, length, new_addr, min_size;
+	u64 start = 0, remap_length = 0;
+	u64 length, new_addr, min_size;
 	int ret;
 	bool no_more = false;
 	bool is_data = (src_bg->flags & BTRFS_BLOCK_GROUP_DATA);
-- 
2.51.2

