Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FA8316197;
	Tue,  7 Jul 2026 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415778; cv=none; b=MkYo7Cp+zaRjctrpTaO1lOXLRaXN0uD89jwvJMjdqzk7waZkToNJtmKoQ99epx+q65LycemECibluEzK4B7wflHGxNJ9ZD2uPNHt7/BAx2Vm3Xb46QG56xjY+LGuOVLqzVpblQwu2lTv+vl9xjf0+V/PgMuDw448hVlv8mGQIgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415778; c=relaxed/simple;
	bh=+k9NlimLL1ajeyCdrVJRBBbK4+fcDwkB13bDWQDP5Lw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bPhuRQYuF/H6tmvE/zCxVwYQfSjOqPLMmkokQ9awnbqnKIJwylYxxBdfzO5Bo6j4G0oZwLQl3/TKu6Kp5i+UYf2/+rkX/5SubrqQbpglwAfpTuwWZIKZQMiB5m1nO8QZ6CXE8i3WKt84ow21kB88ibIaPO1yvVTZWm3olvud/aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7dcec57e79e411f1aa26b74ffac11d73-20260707
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ae6f71e6-52e8-463d-a859-34f03ba0235f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:59aa1a6c8ba2b3ee9541dc2c9cecd4ae,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7dcec57e79e411f1aa26b74ffac11d73-20260707
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 49481697; Tue, 07 Jul 2026 17:16:09 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH] btrfs: Add missing sctx check in cleanup path
Date: Tue,  7 Jul 2026 17:16:04 +0800
Message-Id: <20260707091604.207222-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add sctx NULL check in the sort_clone_roots cleanup path for
consistency with other cleanup paths in the function.

Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3ae480c7474b..2d81fac03a3d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -8250,7 +8250,7 @@ long btrfs_ioctl_send(struct btrfs_root *send_root, const struct btrfs_ioctl_sen
 		free_orphan_dir_info(sctx, odi);
 	}
 
-	if (sort_clone_roots) {
+	if (sctx && sort_clone_roots) {
 		for (i = 0; i < sctx->clone_roots_cnt; i++) {
 			btrfs_root_dec_send_in_progress(
 					sctx->clone_roots[i].root);
-- 
2.25.1

