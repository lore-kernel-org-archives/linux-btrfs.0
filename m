Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9F4377A93
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 07:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790666116; cv=none; b=Wumw3rPzir+AQ/q6CL2uPIIFNnrh343Lp0VRYPcLWLXPXi4YghpuMCbLkinMtMV6m4IVDFXVnGOcKS69dNJ0qihgJf2k30Ysfhj68ZwwRaVMnHCoU7Oxg+0P9UdU9Gm9lHVjkzIwB8M2/EXz4WDRmh0a/JiTsP6IzsycbP+3oUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790666116; c=relaxed/simple;
	bh=vfbxUg6SlYp2OeBFuOasI5dwETXS9AyxC2+3usPZmRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rFFn2eucpow4QGfzsbpXJe6GDu5PR9NtMuc/PnG8p1V4OE7yHrxQlBwm4286IesmpZEw7RYcsFFupSze3mzlwkP36mXX451bdF7W+UPU+8MR/FJRzlERKdscqd9Imi+Nr8HnIee7XdzS30kvvz+3zJqFnQKuuaA9wBoq0YIBxRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7cb0f56cbbd511f19a56ed5b684f684d-20260929
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	SA_TRUSTED, SA_EXISTED, SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:f5c34f6a-0512-4168-9960-de2f90d3c238,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:f5c34f6a-0512-4168-9960-de2f90d3c238,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:aa79655bdf9e1e18a6ffafb087518c48,BulkI
	D:260929134348DHO2SX9R,BulkQuantity:4,SF:17|19|66|78|102|127|136|865|898,T
	C:nil,Content:0|15|16|50|99,EDM:5|-100,IP:-2,URL:0,File:nil,RT:nil,Bulk:40
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7cb0f56cbbd511f19a56ed5b684f684d-20260929
X-User: liuhuan01@kylinos.cn
Received: from fs [(39.144.27.18)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1295927409; Tue, 29 Sep 2026 15:15:01 +0800
From: liuh0329 <liuhuan01@kylinos.cn>
To: linux-btrfs@vger.kernel.org
Cc: liuh0329 <liuhuan01@kylinos.cn>
Subject: [PATCH] btrfs-progs: receive: fix unused variable warning without LZO
Date: Tue, 29 Sep 2026 15:14:22 +0800
Message-ID: <20260929071421.1114640-2-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When btrfs-progs is built without LZO support, sector_shift is still
declared in decompress_and_write(), while all its uses are guarded by
COMPRESSION_LZO. This results in an unused variable warning.

Guard the declaration with COMPRESSION_LZO as well.

Fixes: 345731fff32d ("btrfs-progs: receive: optional build for lzo, zstd")
Signed-off-by: liuh0329 <liuhuan01@kylinos.cn>
---
 cmds/receive.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds/receive.c b/cmds/receive.c
index 49103ea3..14a9ba03 100644
--- a/cmds/receive.c
+++ b/cmds/receive.c
@@ -1186,7 +1186,9 @@ static int decompress_and_write(struct btrfs_receive *rctx,
 {
 	int ret = 0;
 	char *unencoded_data;
+#if COMPRESSION_LZO
 	int sector_shift = 0;
+#endif
 	u64 written = 0;
 
 	unencoded_data = calloc(unencoded_len, 1);
-- 
2.54.0

