Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61BD45198C;
	Mon, 21 Sep 2026 08:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789980942; cv=none; b=HKkI+SpDnAA5u2fRUObNyx8qvhjiWKaLg4sfsKjAlOUstXI8IYbT2gcTIGJxgGiRpSm+6u5P2rP9RPeNR26vIfbyrxHZC8kWRBvy7RJ/dNETo1Hd9eA/i3Zf86ZxnJ3G3x9o7W9bNx/QMv6e8gvIak4cqrTUuu+GHsZBOyCgNdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789980942; c=relaxed/simple;
	bh=wwJTDz9Uzfxd9Bg8IUD8fQZih2yNeP2TcCJ4lIkJ3t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQ5jBw5KmtvRsRRtNBrdIfji8LA6jmPBcpTChekISxRK7F/5kd0lEwwWldTqrWGyYjYRFVr1Z3rXjN/77/o2j1r8cLIJKKXJUtbmjC4f4dah/lbndMZ0oEiwHr24qKYL3nj+IQN9rSarOUKArLvLL0mRMeYjEqFjmXz4iZBB7gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 33f6f2e0b59a11f19a56ed5b684f684d-20260921
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
X-CID-O-INFO: VERSION:1.3.19,REQID:2600c5fb-48a5-4426-80e1-fb9b184bae61,IP:-15
	,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:2600c5fb-48a5-4426-80e1-fb9b184bae61,IP:-15,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:58c89e394f8cdb0823d8b38cd2a3c502,BulkI
	D:260921165534ZM72NWJT,BulkQuantity:1,SF:10|66|78|81|82|102|127|865|898,TC
	:nil,Content:0|15|50|99,EDM:-3,IP:1,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,B
	EC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 33f6f2e0b59a11f19a56ed5b684f684d-20260921
X-User: liuxixin@kylinos.cn
Received: from [127.0.1.1] [(123.150.8.42)] by mailgw.kylinos.cn
	(envelope-from <liuxixin@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 124804405; Mon, 21 Sep 2026 16:55:32 +0800
From: Xixin Liu <liuxixin@kylinos.cn>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, mason@kernel.org, linux-kernel@vger.kernel.org, liuxixin@kylinos.cn
Subject: [PATCH 1/1] btrfs: free remap records when balance stops early
Date: Mon, 21 Sep 2026 14:48:00 +0800
Message-ID: <cb7acb099780.1789973253.git.liuxixin@kylinos.cn>
In-Reply-To: <cover.1789973253.git.liuxixin@kylinos.cn>
References: <cover.1789973253.git.liuxixin@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: patches/scripts/send-local.py

Balance queues metadata remap records on a stack list. They are freed
only after the remap pass. Early scan failures return with records still
linked, so they leak.

Free still-linked records on the early exit path. Reuse the same release
path as the remap pass end. Records without a block group are only
unlinked and freed. Records with a block group return that reference the
same way the existing end path already did.

Fixes: 81e5a4551c32 ("btrfs: allow balancing remap tree")
Signed-off-by: liuxixin <liuxixin@kylinos.cn>
---
 fs/btrfs/volumes.c | 65 ++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4ddabadc9..4c1e54c8d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4403,6 +4403,38 @@ static int cow_remap_tree(struct btrfs_trans_handle *trans, struct btrfs_path *p
 	return ret;
 }
 
+static void free_balance_remap_chunks(struct list_head *chunks)
+{
+	struct remap_chunk_info *rci, *tmp;
+
+	list_for_each_entry_safe(rci, tmp, chunks, list) {
+		struct btrfs_block_group *bg = rci->bg;
+		bool is_unused;
+
+		if (!bg)
+			goto free_record;
+
+		/*
+		 * This is a bit racy and the 'used' status can change
+		 * but this is not a problem as later functions will
+		 * verify it again.
+		 */
+		spin_lock(&bg->lock);
+		is_unused = !btrfs_is_block_group_used(bg);
+		spin_unlock(&bg->lock);
+
+		if (is_unused)
+			btrfs_mark_bg_unused(bg);
+		if (rci->made_ro)
+			btrfs_dec_block_group_ro(bg);
+		btrfs_put_block_group(bg);
+
+free_record:
+		list_del(&rci->list);
+		kfree(rci);
+	}
+}
+
 static int balance_remap_chunks(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 				struct list_head *chunks)
 {
@@ -4442,35 +4474,7 @@ static int balance_remap_chunks(struct btrfs_fs_info *fs_info, struct btrfs_path
 	btrfs_commit_transaction(trans);
 
 end:
-	while (!list_empty(chunks)) {
-		bool is_unused;
-		struct btrfs_block_group *bg;
-
-		rci = list_first_entry(chunks, struct remap_chunk_info, list);
-
-		bg = rci->bg;
-		if (bg) {
-			/*
-			 * This is a bit racy and the 'used' status can change
-			 * but this is not a problem as later functions will
-			 * verify it again.
-			 */
-			spin_lock(&bg->lock);
-			is_unused = !btrfs_is_block_group_used(bg);
-			spin_unlock(&bg->lock);
-
-			if (is_unused)
-				btrfs_mark_bg_unused(bg);
-
-			if (rci->made_ro)
-				btrfs_dec_block_group_ro(bg);
-
-			btrfs_put_block_group(bg);
-		}
-
-		list_del(&rci->list);
-		kfree(rci);
-	}
+	free_balance_remap_chunks(chunks);
 
 	return ret;
 }
@@ -4710,6 +4714,9 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		}
 	}
 error:
+	if (!list_empty(&remap_chunks))
+		free_balance_remap_chunks(&remap_chunks);
+
 	if (enospc_errors) {
 		btrfs_info(fs_info, "%d enospc errors during balance",
 			   enospc_errors);
-- 
2.43.0

