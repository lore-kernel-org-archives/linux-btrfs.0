Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651E744E66F;
	Mon, 21 Sep 2026 08:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789980942; cv=none; b=GgiRNTOMIBmlVKsLCfWUQNjFFnvAuncILeSXgDCWWMwbwmaIBOUYEQIdBJO2fGmQxW7Kk69zLD4ipOqtriumQmpk8ak4zZCp1W0s0JYEnzDWKqfiauGhrGRzLrf9lhy0oah9TyqoLUglSPOtUyaBO18Zxct29chXJPA89cSqqGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789980942; c=relaxed/simple;
	bh=rk5EK2rqWIOwZvSdPHi2xcIqCTmhiKljnl1sW/FfLNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H+Xs2eBeIxy+ny0n1Mkw7bj4fqv71VDa0zKXXs9SQmVCrNjFaGBNXTww6Ir2M9fyZGm7XubJLy2UtK1CRlukFU/VA2eOztb7LqTfDpwVtVTEa4pNMbODAFtPsofVXJvN9zhAPS4H7dNaDh2kCRf01Biqz+wArRQlXwrUle19pF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3296e68ab59a11f19a56ed5b684f684d-20260921
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_LOWREP, SA_EXISTED
	SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ebaf168c-ac8e-4bb9-994e-b9169b463a0a,IP:-15
	,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:ebaf168c-ac8e-4bb9-994e-b9169b463a0a,IP:-15,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:c2bb026d49d2d0ab4857e59115ff9274,BulkI
	D:260921165534ZM72NWJT,BulkQuantity:0,SF:10|66|78|102|127|865|898,TC:nil,C
	ontent:0|15|50|99,EDM:-3,IP:1,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3296e68ab59a11f19a56ed5b684f684d-20260921
X-User: liuxixin@kylinos.cn
Received: from [127.0.1.1] [(123.150.8.42)] by mailgw.kylinos.cn
	(envelope-from <liuxixin@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1438667807; Mon, 21 Sep 2026 16:55:30 +0800
From: Xixin Liu <liuxixin@kylinos.cn>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, mason@kernel.org, linux-kernel@vger.kernel.org, liuxixin@kylinos.cn
Subject: [PATCH 0/1] btrfs: free remap records when balance stops early
Date: Mon, 21 Sep 2026 14:48:00 +0800
Message-ID: <cover.1789973253.git.liuxixin@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: patches/scripts/send-local.py

Hi,

This patch frees leaked remap records when balance stops early. Early
error returns left kmalloc records on the stack list. Share one free
helper at the remap pass end and on error when the list is non-empty.

Tested on linux-next next-20260914 for cancel and complete cases.

Thanks,
Xixin Liu

---
liuxixin (1):
  btrfs: free remap records when balance stops early

 fs/btrfs/volumes.c | 65 ++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

-- 
2.43.0

