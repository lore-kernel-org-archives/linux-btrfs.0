Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD58343D8A
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2026 16:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771518800; cv=none; b=kDOObbf6zr+0k3vX2PQ7A1qtd/6H3Sxro9IvrOctiosu0Pis8pwGRKMr5DhJFqe315VNQ7AHlAkJEhcZfgGd+dTpvmPr6R+9S0eDRAxot2tlL8TzTbmIHJC/df6bALdbTpQM4oSj8mX9BhYlxmTRxnhkFldaSDiZBv42el1BW2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771518800; c=relaxed/simple;
	bh=rE++ykcub4v7ytwi3d5/cg5ATouTzMpA7tDHykiMY6o=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=TwtRrVcxt7CiOLM1SW45IRtdG5MvF83LKKhPHyriqx/IrWdjD+bzxh/8J1NwqD0Vs+v5VzfYV+QvFVdgH4bjW0MnLPhx0ejulAAGUv6F1pYh50W/w7lkMsY0eVo9T0vn7ty1ciwicwUKEKdcxGdnz8UQWJrAeula/VtPGfNCdIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=CrV6sZ3d; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="CrV6sZ3d"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id DD4BA304031;
	Thu, 19 Feb 2026 16:33:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1771518796;
	bh=euNcyjL/p0ER/3YkNVUBVDriyq+/5iR1OMvM8qVKc/I=;
	h=From:To:Cc:Subject:Date;
	b=CrV6sZ3dApxqoQ/YMWsCPGSTRiWGp2dVqYONlTjyKSTslh9afGhmfAAlxXGvhBCw4
	 KCvTxTHSeLJEikGiaHKlTabg9thx/DDDhVHKeCSM0w2hPCoi6+lxbxpIlH5mhKJ/+8
	 7sYepa6ts09fOB0yH4PhBTGM8d13OPqzM3cDaj3g=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Chris Mason <clm@fb.com>
Subject: [PATCH] btrfs: add check in remove_range_from_remap_tree() for a NULL block group
Date: Thu, 19 Feb 2026 16:33:08 +0000
Message-ID: <20260219163313.15888-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check in remove_range_from_remap_tree() after we call
btrfs_lookup_block_group(), to check if it is NULL. This shouldn't
happen, but if it does we at least get an error rather than a segfault.

This fixes a bug introduced in the patch "btrfs: handle deletions from
remapped block group" in for-next.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
Suggested-by: Chris Mason <clm@fb.com>
Link: https://lore.kernel.org/linux-btrfs/20260125125129.2245240-1-clm@meta.com/
---
 fs/btrfs/relocation.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f2abc5d625c1..679e551707f5 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -6003,6 +6003,9 @@ static int remove_range_from_remap_tree(struct btrfs_trans_handle *trans,
 		struct btrfs_block_group *dest_bg;
 
 		dest_bg = btrfs_lookup_block_group(fs_info, new_addr);
+		if (!dest_bg)
+			return -EUCLEAN;
+
 		adjust_block_group_remap_bytes(trans, dest_bg, -overlap_length);
 		btrfs_put_block_group(dest_bg);
 		ret = btrfs_add_to_free_space_tree(trans,
-- 
2.52.0

