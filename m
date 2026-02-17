Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F422136BCF3
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771351786; cv=none; b=Je7WSPgyo9FsBWJncHPVSRA9mSwwSPUBkGV+hhsEKwyI3QLNqxc1l4BcoNIJvQNGuweikWUkS/42v3duhK9DEBApT2Pe9Ev2D3k8QRwBJm0+/BxgA1GAmRUhSMYtZ2pGf3iXyjgl67BotYnbPndxnLVb+aru+FrSMB7ihUve+d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771351786; c=relaxed/simple;
	bh=gHXnPfpdVVl0C1lzxZDDQ90faUDf5+b2WDShKj3MbB0=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=C3DZ2PQV+SzvPB2O+O9IU45dlSVeBbQABlGJfrUsxyOYhnrl4G2QxmUn3rugNz1F6m7zw0xLeTAffY4LjPO5PLNbvEbPYXu6Qmx6ads9zeKq9zfa05Ajea0Ia24pQ0oe86Wm0n2HgrPSu8KJYoYyuPMzR3c0GQHLsNdiu6pPjI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=EvMh6tXX; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="EvMh6tXX"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id B30CB3030D4;
	Tue, 17 Feb 2026 18:09:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1771351778;
	bh=XKO6Bu8e9HkDMfo173jH+1cxDWWxnSPATaUEcbfEBPg=;
	h=From:To:Cc:Subject:Date;
	b=EvMh6tXX2tMuq/Y2Zc5fqgwWJ7YPs09ZRdX8lkd7PC6u+SPbnCTBflD+XUCL4Eh3o
	 z4Nbec60E252Oa7pVaxNoJ6yjIs8tBO3NsbLrT/asJqWQ+BcNofpOfdCQmSPweP+oX
	 Elh/Zr7plkRawjEdcYApu5X8z+bfm67GxcRlQ/do=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org,
	wqu@suse.com
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: fix error message in check_extent_data_ref()
Date: Tue, 17 Feb 2026 18:09:07 +0000
Message-ID: <20260217180933.15805-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a copy-paste error in check_extent_data_ref(): we're printing root
as in the message above, we should be printing objectid.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
Fixes: f333a3c7e832 ("btrfs: tree-checker: validate dref root and objectid")
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 9774779f060b..ac4c4573ee39 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1740,7 +1740,7 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
 			     objectid > BTRFS_LAST_FREE_OBJECTID)) {
 			extent_err(leaf, slot,
 				   "invalid extent data backref objectid value %llu",
-				   root);
+				   objectid);
 			return -EUCLEAN;
 		}
 		if (unlikely(!IS_ALIGNED(offset, leaf->fs_info->sectorsize))) {
-- 
2.52.0

