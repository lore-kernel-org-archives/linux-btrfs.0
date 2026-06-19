Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731CA352C4F
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 06:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781850610; cv=none; b=WJauRzyKOZFqIp7x8r4D7zaaZAe8RXsYAtk/FRa+j47Yi7rOudliXeY7jtGeu5eF1vNRoEjT6O8BRq6cS4G9W46J4fvbMrSB3WbcKOlNerwBIuagQRTg9Ao4on+2YKOBOZmLujXuc9lYCibkd2WBbWrR+gok/qApTCtXs79G4is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781850610; c=relaxed/simple;
	bh=rqujFwLTy0ZHF8HAupIOIME2uB/w0FUb3RDAYBAJLpk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qDi3k9BeMh4KpWvXNw6rBTt9bqhplP/Sv9n3B57Sk79GZfWjewTywIeJ5fMeLznZTDlJnjvAQhgD/3v6fVPwyj8RhIXlbcib1e7WN667q89fUtCt82qG3nauPIRlEUSQvYY/BhXI6pvNmMSFPUelTkm4NpCQsmqI8mIiE/mCVBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=aoXYjOEo; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aoXYjOEo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781850610; x=1813386610;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rqujFwLTy0ZHF8HAupIOIME2uB/w0FUb3RDAYBAJLpk=;
  b=aoXYjOEoo7WTZW/9sSZBhKqIe3hjXsLunUVbYjsJ744Zvz9JEjb/TVZD
   O4FzTKFjsjN03WpnZWjQD7fEXV3MiRNNgQeXDfIkuhul+yPqo40qtwThV
   MvHBQDtaLFoyuKs/YHh9uAPWXM//RqcFglPp04yhDCv//Jj53F5ZU6c7u
   pXEjeaHj1PUOy8pNTVn6N5wcYtWHM5bGj8HoOO656QLEl2l5QUVTsZo0j
   PRCEh8kRHMc5HYr8TGPSLhDWeHT6ajLGJMoMl5YM7sKLC2mFuOEhVIUJG
   /37LQLJwt5CtkbhGs0biQoJ+oCjuks36Wa4BHzBBF3fzz7SSPYby7BYsp
   Q==;
X-CSE-ConnectionGUID: GcRZTd9pT3CI3n04Ozkoxg==
X-CSE-MsgGUID: h3xjEeFNReqsqHiNhMaxJw==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147944284"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 14:30:04 +0800
X-CSE-ConnectionGUID: 1iyv8059RGSIVjPtjmOH1A==
X-CSE-MsgGUID: RaeW+VmFTsKFzWK+i+KKoA==
IronPort-SDR: 6a34e1cd_cs3ibUsvLHnAPZoKEiCiduavU6fatRPirPRBRL4/mDLd6cQ
 gmvjUrTWrY8qaIsASwZxFC3XDGW6wSffFndGCUA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jun 2026 23:29:33 -0700
X-CSE-ConnectionGUID: RomFlf/rTzyrVdgtdqGqYw==
X-CSE-MsgGUID: 7EM4gkxSQXmb5miqggTzWA==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 18 Jun 2026 23:29:33 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: decentralize transaction aborts in create_reloc_root
Date: Fri, 19 Jun 2026 08:29:28 +0200
Message-ID: <20260619062928.447838-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Decentralize transaction aborts in create_reloc_root(), so that it is
obvious which call failed and what caused the transaction abort.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/relocation.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8cac49fa6f6f..62268c8145c5 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -720,21 +720,20 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_root(trans, fs_info->tree_root,
 				&root_key, root_item);
-	if (ret)
-		goto abort;
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		return ERR_PTR(ret);
+	}
 
 	reloc_root = btrfs_read_tree_root(fs_info->tree_root, &root_key);
 	if (IS_ERR(reloc_root)) {
 		ret = PTR_ERR(reloc_root);
-		goto abort;
+		btrfs_abort_transaction(trans, ret);
+		return ERR_PTR(ret);
 	}
 	set_bit(BTRFS_ROOT_SHAREABLE, &reloc_root->state);
 	btrfs_set_root_last_trans(reloc_root, trans->transid);
 	return reloc_root;
-
-abort:
-	btrfs_abort_transaction(trans, ret);
-	return ERR_PTR(ret);
 }
 
 /*
-- 
2.54.0

