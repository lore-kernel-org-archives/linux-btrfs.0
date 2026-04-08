Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7608635F163
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775667837; cv=none; b=TvAEQvtwb7SP8Yfofbu1sgD5l137/7rJDViJyRlssUhSA2bwwzKrx7pIAAgk42aEMPZN2Sj7EvfcDvLLFLXhdxqsl0SzEBJ3RcQEDYs3Brz6DVFodlJXuYYSIjqMDID57knPZ0RBLGqe0wnxwsq9D8zZXCkivFAEqiH99fY0MQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775667837; c=relaxed/simple;
	bh=ygujxzLVB9+/C+KDiCt51tARUYchO5ZNDu41RkMPUZY=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=PcbCD7xHdgAajQz41a0nkIIjzeqo6liiG95RUl5MEwbfqr3T3I32hR3x0PDNBiPwZ21gXiXILY9Z78u13ZQzRmpKQ/IXFcj9bEFvZBMF16v6dan2f5pMMdG4YYJRnc4HEka3riDvccDKA/pySkxbjhg1aP1qcmpkAVNhFZz4Ey0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=h3gbygwF; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="h3gbygwF"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id C504531AC92;
	Wed,  8 Apr 2026 18:03:52 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1775667832;
	bh=+HVxaK4eq2IdT+FTgRpAvHdvPw813y7M3aTBnhqxE2c=;
	h=From:To:Cc:Subject:Date;
	b=h3gbygwFGD5litRXy7hWWvPLlXo+V3sSka4wBWIqkdVaVPeZV6dC4ngX7b1ofUs72
	 cHdbP0/JLshfbCdairul48t+4P9i+uRiFXf3hFWArvpG3Xx1JN38PmhX1TX+kQM2dq
	 nJseW2f5lR7gjhSHKYkn6InKltXkkJ4TEPGYdUI4=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org,
	boris@bur.io
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH v2] btrfs: abort transaction in do_remap_reloc_trans() on failure
Date: Wed,  8 Apr 2026 18:03:44 +0100
Message-ID: <20260408170349.130997-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

If one of the calls made by do_remap_reloc_trans() fails, we can leave
the remap tree in an inconsistent state. Abort the transaction if this
happens, to prevent the corrupt state from reaching the disk.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
Changed to abort in place, so that line numbers get properly logged,
rather than at the end of the function.

 fs/btrfs/relocation.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a7cf5d9cf1de0d..6cad6b4064fbea 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5035,21 +5035,27 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 
 	if (bg_needs_free_space) {
 		ret = btrfs_add_block_group_free_space(trans, dest_bg);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
 			goto fail;
+		}
 	}
 
 	ret = copy_remapped_data(fs_info, start, new_addr, length);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		goto fail;
+	}
 
 	ret = btrfs_remove_from_free_space_tree(trans, new_addr, length);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		goto fail;
+	}
 
 	ret = add_remap_entry(trans, path, src_bg, start, new_addr, length);
 	if (ret) {
-		btrfs_add_to_free_space_tree(trans, new_addr, length);
+		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
 
-- 
2.52.0

