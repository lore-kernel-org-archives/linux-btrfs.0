Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20A436F42A;
	Mon, 17 Aug 2026 05:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786944983; cv=none; b=SMVoSbqDoeIq+pkNco3WioCGS8pUUUEXa9EvOvCdl+Kdo6fpkTPhPGdAHAAgW/jZptD+Jcg+7a5BxDBeJo056hSYpQ3sIDHEWT6zT1t60WXf2TnZ7fF9VSnDw6CZu7Gmxhr7SN2Nrv5Z/7BtOTQPiK0ZdQ85qvMsi46JjGglGM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786944983; c=relaxed/simple;
	bh=a3mLCeadm+oaZbBM2X81GMYCyptHjBJzTxSm49iL2Bo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oY+qejNFHD56hVudCdVSEeTs7lDrJw0mL5kN+ToohZ4GiK0s0dPQLhUzCw0etBcxXV+DNEeL27c6Pgzp9rRiLTmutFTzbxrsRngNvpzqv0adMhPX7/2Iy5Z0/Rs1/b6EotimNvsgeuyunt2tlq6AQytkedzEUO9QODUpr43Wctk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8e351d3099fd11f19a56ed5b684f684d-20260817
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:da3e4e69-58ce-4730-a80b-05184e3179b8,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:7db8b62,CLOUDID:90d0539738e3061aa5ba7060263fe76e,BulkI
	D:nil,BulkQuantity:0,SF:102|136|850|865|898,TC:nil,Content:0|15|50,EDM:5|-
	100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8e351d3099fd11f19a56ed5b684f684d-20260817
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1899340916; Mon, 17 Aug 2026 13:36:11 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com,
	boris@bur.io,
	willy@infradead.org
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: fix missing folio_unlock in read_merkle_tree_page error path
Date: Mon, 17 Aug 2026 13:36:07 +0800
Message-Id: <20260817053607.46939-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

filemap_add_folio() adds the folio to the page cache and leaves it locked.
If read_key_bytes() fails, the error path only calls folio_put() without
first unlocking the folio, leaving it permanently locked in the page cache.
This causes subsequent attempts to lock this folio to hang.

Fix by adding folio_unlock() before folio_put() in the error handling path.

Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/btrfs/verity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 983365a73541..4431656140f8 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -753,6 +753,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
 			     folio_address(folio), PAGE_SIZE, folio);
 	if (ret < 0) {
+		folio_unlock(folio);
 		folio_put(folio);
 		return ERR_PTR(ret);
 	}
-- 
2.25.1

