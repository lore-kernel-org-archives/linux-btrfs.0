Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AECB271450;
	Mon, 17 Aug 2026 02:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786933224; cv=none; b=tuHSWxY+L17IieryEcH5aw8yEeS4MfMNTy+1fuesuozRn0bGmFqeHZOVfZckq8bF7Jj3oIrGIbmIiFDpJDr2Wwxb5cn8KyUE2e3kucEYjm/fGKBVLkgDXpWlFxl3TB92iqQIn88UY2IwxSVTkgl92wk8PNglf/y7Av4lC+Acwf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786933224; c=relaxed/simple;
	bh=tZsCNsmURDsgnw+Pi/Tf240qHhK7CXHODyN/g3TBD/g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EjrxJ81zQXfocaWivIDcuSoQ/omZZ6H3kjlzM6ps8LVpKnDmuOiOOgSbs6e1psMKhD2UyS0vP671sc9V09+bYOSjHiU6+4Wf45jOpn07XLb1MDNXk2IkeyVtijNJDjkUr5kZbCJZFyYReLKaW2lW1seOraWjykqZo188gfOOsAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2f5be17499e211f19a56ed5b684f684d-20260817
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e8dda2f1-4d86-450f-bfbc-df2430ff5722,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:7c4a2104bc1a4635c55fee67e42fb3fd,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:n
	il,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LE
	S:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2f5be17499e211f19a56ed5b684f684d-20260817
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 223089269; Mon, 17 Aug 2026 10:20:16 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com,
	lizetao1@huawei.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: handle highmem folios in read_key_bytes
Date: Mon, 17 Aug 2026 10:20:12 +0800
Message-Id: <20260817022012.19658-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 32-bit systems with highmem, folio_address() can return NULL for
unmapped highmem folios. When this NULL is passed as the dest parameter
to read_key_bytes() with a non-NULL dest_folio, it violates the function's
contract (which requires dest to be non-NULL when dest_folio is provided).

The original bug had two symptoms:
1. Unsigned len underflow when len -= copy_bytes executes (infinite loop)
2. The folio remains uninitialized because the copy block is skipped

Fix requires two changes:

1. Change "if (!dest)" to "if (!dest && !dest_folio)"
   - Prevents the "counting-only" mode when dest_folio is provided
   - Fixes the underflow/infinite loop

2. Change "if (dest)" to "if (dest || dest_folio)"
   - Ensures the copy block executes when dest_folio is provided
   - Allows kmap_local_folio() to properly map the highmem folio
   - Actually writes data to the folio

Without the second change, the highmem folio is not populated even
though the read succeeds, causing subsequent fs-verity verification to
operate on stale or uninitialized data.

Fixes: 884937793db5 ("btrfs: convert read_key_bytes() to take a folio")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/btrfs/verity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 983365a73541..80bc945c7dcb 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -351,7 +351,7 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 		}
 
 		/* desc = NULL to just sum all the item lengths */
-		if (!dest)
+		if (!dest && !dest_folio)
 			copy_end = item_end;
 		else
 			copy_end = min(offset + len, item_end);
@@ -362,7 +362,7 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 		/* Offset from the start of item for copying */
 		copy_offset = offset - key.offset;
 
-		if (dest) {
+		if (dest || dest_folio) {
 			if (dest_folio)
 				kaddr = kmap_local_folio(dest_folio, 0);
 
-- 
2.25.1

