Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F2D3ACF03
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276629; cv=none; b=Sb3vyquQ6NPeW+wlBOjoZgviTCTM5P2XvFY9NTNcDm+6mSVFzObyxWizp9EjCWA546WGPkhMxy21p3/gwu9S7Dqm3yOYBH/pYtFQiPEMGsrhFimKjsmzz92LC76keIUZwAZsLMKcFSvCHBaCECfr3OjAacRo9zWzChTVstjWEcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276629; c=relaxed/simple;
	bh=+bI3zP1rTbTcBOXh9egfRlQhKyyJI0SOzUQDH6QvLIY=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=gNVTqrvereNxEH3iAP34eriV2vLaV84anrsO45zHkhhY1kzvgebSz5DvNrkYgHTmsPDvUN5kL2/ng4QaLQdpolHTfPxRIL0jSRbAwDzwvncoewUQMIR1c/PWLMRwZUa031QAgIysmnHPZvBXY1uaNg7ZVWjS2roY9o0o5uLj/Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=NELzgD5u; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="NELzgD5u"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 6AFC9313E65;
	Mon, 23 Mar 2026 14:37:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774276625;
	bh=e8J9kbnHQxIwX7aEKFVHPFasPYyIThb8YrIthMk2X74=;
	h=From:To:Cc:Subject:Date;
	b=NELzgD5umgIGXdBg62Bh4cS85wSCF5/QwQHHlTxiN08yFqMpxBJrSkuHVvX3x2qOa
	 Q2k8FwvQziFWd19bjgoHM+1cH752CwFVn6FE7oCvIfmoiuvj2O7KwLgtaRvRDdfHvN
	 Kqq5nzVfgo7vj9JMWxzNO8laGRL8q1luIxfHGhiI=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: fix bytes_may_use leak in do_remap_reloc_trans()
Date: Mon, 23 Mar 2026 14:36:51 +0000
Message-ID: <20260323143704.119969-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

If the call to btrfs_reserve_extent() in do_remap_reloc_trans() returns
a smaller extent than we asked for, currently we're not undoing the
bytes_may_use change that we made. Fix this by calling
btrfs_space_info_update_bytes_may_use() again for the difference.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
Fixes: fd6594b1446c ("btrfs: replace identity remaps with actual remaps when doing relocations")
---
 fs/btrfs/relocation.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1c42c5180bddd5..c0bd6db6011965 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5000,6 +5000,12 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 		return ret;
 	}
 
+	if (ins.offset < remap_length) {
+		spin_lock(&sinfo->lock);
+		btrfs_space_info_update_bytes_may_use(sinfo, ins.offset - remap_length);
+		spin_unlock(&sinfo->lock);
+	}
+
 	made_reservation = true;
 
 	new_addr = ins.objectid;
-- 
2.52.0

