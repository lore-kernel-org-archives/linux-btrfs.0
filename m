Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5614D35838E;
	Tue, 14 Jul 2026 01:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783992545; cv=none; b=uATzHKPSCoGsOkCGmyq0FhwBjBNOYLUxTNOefRmUlqCRuqnbiTOMnHVd22bzuMKhS+jPrfNMlu3fl4bfF+13q+ryCWxHhaSMCaKiO+fUEtL9+p1SvgZwoCA6bHJqZa73MyubepCFM0elNdBpz3S8DW4h/4brNwTkfzPmPuBZoTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783992545; c=relaxed/simple;
	bh=xiGmbZS2q8z07TBSIZg/s6Vi3v2Qeyog3bfm1NB43VU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rmjuMPxp4f00BAJWD7SLv5et4fdgjpiVQzAYdAaYPqcupdCLzqDuU3vkgphKQnEUuXJYd1ApcBDjSsM9PiOVQi7WiqJSMdXihN9B6LDN8JEXwA1foX+x6sqYIjkDvc0EvLrArM5GCcy0yf4vEPgzcfTdcpgo5zyGpfdAKPr+7gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 601be8ec7f2311f1aa26b74ffac11d73-20260714
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4c0c6443-c314-4dc1-9dbf-ca3d8366f048,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:d9871548647a2517d22abf9d2d8d699e,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 601be8ec7f2311f1aa26b74ffac11d73-20260714
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 714837992; Tue, 14 Jul 2026 09:28:53 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: Add missing sctx check in cleanup path
Date: Tue, 14 Jul 2026 09:28:50 +0800
Message-Id: <20260714012850.611545-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add sctx NULL check in the for loop condition of the sort_clone_roots
cleanup path for consistency with the else branch

Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Suggested-by: David Sterba <dsterba@suse.cz>
---
 Change in v2:
 -Uses the same pattern: for (i = 0; sctx && i < clone_sources_to_rollback; i++)
  ,suggested by David
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3ae480c7474b..297704edf1b4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -8251,7 +8251,7 @@ long btrfs_ioctl_send(struct btrfs_root *send_root, const struct btrfs_ioctl_sen
 	}
 
 	if (sort_clone_roots) {
-		for (i = 0; i < sctx->clone_roots_cnt; i++) {
+		for (i = 0; sctx && i < sctx->clone_roots_cnt; i++) {
 			btrfs_root_dec_send_in_progress(
 					sctx->clone_roots[i].root);
 			btrfs_put_root(sctx->clone_roots[i].root);
-- 
2.25.1

