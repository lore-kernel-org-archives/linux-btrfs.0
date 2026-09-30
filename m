Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7283C0A07
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 06:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790750649; cv=none; b=k5LL1m7sn46zgbB80bRBDCMJsGph1Z36/7338BtbB5MIGtw3o3meey5mDS1xnzVd+FOVHFb/oJPz5PFp8Ypb1Avjn3MHXTjmg4vRrhsPoLcAMV18Y2PHy2ouMxhiORQ26kbDHJoAHLG4hXUWN19kR+4V8wIVbZbyYqESECrTv4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790750649; c=relaxed/simple;
	bh=QhJWWg9S1iK6q2+2GxtDtB3p+dNIPt6zRwl8DQOZ+Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSqieyeNJp5EIvTErhklUBOoIQHmVPzsyYuOgRli0l/oRwminDeDeCcuJa7UP4iOvf+lmQ7EJb825VWYDapBVF4qy+X6tkdFwPDnAA5TKoP+dh7uZ/wUUOXxQrdRGuKoVEGw2n5coxTpZTWfDyEaptAg1ikV2F57blyFaVL2xds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4bcc1b46bc9a11f19a56ed5b684f684d-20260930
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	SA_TRUSTED, SA_EXISTED, SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e30cc6f0-87c1-4ebd-aef5-070baf7df2b8,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:e30cc6f0-87c1-4ebd-aef5-070baf7df2b8,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:e917cb7c0fac63eeb76be4e51d51cabc,BulkI
	D:260930144354DP4IK3Q5,BulkQuantity:0,SF:17|19|66|78|81|82|102|127|136|865
	|898,TC:nil,Content:0|15|16|50|99,EDM:5|-100,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4bcc1b46bc9a11f19a56ed5b684f684d-20260930
X-User: liuhuan01@kylinos.cn
Received: from fs [(39.144.26.197)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1209159758; Wed, 30 Sep 2026 14:43:50 +0800
From: liuh0329 <liuhuan01@kylinos.cn>
To: wqu@suse.com
Cc: linux-btrfs@vger.kernel.org,
	liuhuan01@kylinos.cn,
	quwenruo.btrfs@gmx.com
Subject: [PATCH v3] btrfs-progs: receive: fix unused variable warning without LZO
Date: Wed, 30 Sep 2026 14:43:28 +0800
Message-ID: <20260930064327.49205-2-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <dc67e026-1af8-44e6-adc6-f4c2e398f93e@suse.com>
References: <dc67e026-1af8-44e6-adc6-f4c2e398f93e@suse.com>
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

Move the sector_shift declaration to the LZO-specific code path so it is
only declared when LZO support is enabled.

Fixes: 345731fff32d ("btrfs-progs: receive: optional build for lzo, zstd")
Signed-off-by: liuh0329 <liuhuan01@kylinos.cn>
---
Changes in v3:
- Drop the extra scope and move sector_shift declaration directly to its
  only usage as suggested by Qu Wenruo.

Changes in v2:
- Move sector_shift declaration to its only usage, as suggested by Qu Wenruo.
- Add a local scope for sector_shift.

 cmds/receive.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/cmds/receive.c b/cmds/receive.c
index 49103ea3..f592a044 100644
--- a/cmds/receive.c
+++ b/cmds/receive.c
@@ -1186,7 +1186,6 @@ static int decompress_and_write(struct btrfs_receive *rctx,
 {
 	int ret = 0;
 	char *unencoded_data;
-	int sector_shift = 0;
 	u64 written = 0;
 
 	unencoded_data = calloc(unencoded_len, 1);
@@ -1220,7 +1219,7 @@ static int decompress_and_write(struct btrfs_receive *rctx,
 	case BTRFS_ENCODED_IO_COMPRESSION_LZO_32K:
 	case BTRFS_ENCODED_IO_COMPRESSION_LZO_64K:
 #if COMPRESSION_LZO
-		sector_shift =
+		int sector_shift =
 			compression - BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12;
 		ret = decompress_lzo(encoded_data, encoded_len, unencoded_data,
 				     unencoded_len, 1U << sector_shift);
-- 
2.54.0

