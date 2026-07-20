Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1164A3B47E6;
	Mon, 20 Jul 2026 06:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784528978; cv=none; b=bvk0odyJmJCWffjvVOERLwsbBBbv9XGvoyhfLv8kJWE7FjK808+iTJf/LfzuTE6VPoJuohm75f9AyslbXThvjlC+T5dMCUYP47JLR+YW4bJzssTWRb0P4PyE/zyrPgfe09pEQqM3f6tV88zJkf43l0QRxzxHJ9/wI2aUS3PUHlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784528978; c=relaxed/simple;
	bh=srn0C3heaNf8f204PsJ0vg41vSRNndq1F52IMlPEoLo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gKxDIM7Gz7CP478IqlOgdFUGiQouO9ROu0Y3yVsKOzMHobNdOgY2fj4tgH3pPVkOpH84KmjncSDtYGnvTYcaFL3Jya0ZnPGAjvqhEI7JPWmRLafPGo9qMzJQceuLB8QLITx4ytM9CtRDnkCRp+x03OUhQIx6NlaLsM9285VulBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=HxKibxTK; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="HxKibxTK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784528921;
	bh=h6iFys/sSUcmRL/DQINVLpIR7K06yK6ffHl9rdSKDVw=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=HxKibxTKEXQaVhAqRtvQj4TY0IpBvHee86XvK66BfEQCOawogv/d9PH1mipbcBB3C
	 eDh3GSsMP/x2cvP8krJnGpfOYr3e2gCkNJKhdPxJe93u8ccRo7RAa07zVd3V33TLPG
	 DyE6H2D4bfWshlQKDteh7Dm517buYQwDF/uOqEJs=
X-QQ-mid: zesmtpgz5t1784528903tec7aefa0
X-QQ-Originating-IP: USccg2UbXD09TZn/OV+lVMCb23WGHoZiqwOSPB8aisc=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 20 Jul 2026 14:28:22 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2364953285312802444
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Boris Burkov <boris@bur.io>,
	Matthew Wilcox <willy@infradead.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH v3] btrfs: retry verity reads for not-uptodate Merkle folios
Date: Mon, 20 Jul 2026 14:28:20 +0800
Message-Id: <20260720062820.1386340-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MoEG5H4I8hqM+Ebdbto9Ely/uQ90HVyFz91tvwMRpmEC0jknvbIS74cn
	5VvJ5sbk57ruGLKN6/fBFUv6f9UaXuaGFDkM6BhVnpabgoRicchEODTn8ofTBx3F3olKQPc
	EhVEA6RVfWuC+AB/kWeKwApB3tHqxhtsC3xxaqq+eUDyhGSGcwRMaQTkpdO6Gla7jT4Dpjr
	6nNxVrZmGKHpQeZYdpISnW2Jl1GhbDUAMQzHo/4KEYH3RvkojYfmozN3vrYJTC5xZw8BYqA
	4bRwikDeVs8p5/sQ1agzZ33hIEVK+ZCpeBG8SVeJJvXI9eM66QQvZviyf6epToE2lS+DFQ/
	Lqz//Iy4B7G8f9zErep3I3QJpmRQWh4LMEf7ZpKRUPPca9NPJ+PwpCGLvDn6LttmxK4C56v
	zjuJ95Zsc1sUkXG6m40fkjx8SOHpo0lHodB4PJdyK0y1JJk4ZLtPTrGHdD8BNyRCauWN1JT
	rDdoNHJPq8ZFLFYCBF7mGYkp60qL5zttI/HDY0cQTzW7QCVDb4husZKpYsma+uILg4fwg4U
	tQVBNpOoDoCBUBfSx8bWlIpJSY6lykpy7fblkc3rV8Kz6ogRjUzXCkH19jfPIkKc5GdHhNi
	7pNjIiZrpJRlWa4HqmbRxwQPhIahASbVC8cCTfF+hVIX3Q54ZySzouJhrCt1Wz8SAuPSz4i
	Zve4FqiMt35La5li2xQpOqCtMBdOsnqmDFkWechpxdzRJAlBYqr4J/a4W3k98Zb36WS+cCc
	ClY7s4acNtdBZM8gSrjrw+G55oztKIt8QT1Z5xrbN7SU7bUkshIIcu/a1d87mv9v49SdU0g
	Jqa9cRDm8CfwqusKrpTXe+92wb/y2W+K/rbX3Q7Wa8K8gaCZJAMkZ5g+yx8c+c1oigXU1rf
	X8BFk3sNg5ABcT9Lq00VXZHAwbOaRJJPbbenrVviPoHpNOGGB6OH6OYi3xOavxClCkn7j1O
	H0YHlIUUcHrRM8vQ19RGs/DQJdTkxPLScTdMLk8JPVqL4bqtre2JvjD7DhpwHmfTMylaIKm
	3cWUAwhORirkhn677SMyuaNqjW0dar7IyHCDxQ5wtbmnwO88Gh
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

btrfs_read_merkle_tree_page() can find a folio in the mapping that is
not uptodate.  After taking the folio lock, the current code treats that
state as a read error and returns -EIO.

That can make a previous transient read failure sticky.  If the failed
read left a not-uptodate folio in the mapping, later callers find that
folio and fail instead of retrying the read.

Keep the existing page-cache insertion and locking order, but retry the
Merkle item read when a not-uptodate folio is found in the mapping.  Also
unlock the folio when read_key_bytes() fails so that a later caller can
lock it and retry the read.

Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
v3:
- Keep the existing filemap_add_folio() and read ordering.
- Retry the Merkle item read when a not-uptodate folio is found, as
  suggested by Boris.
- Unlock the folio on read_key_bytes() failure so later callers can retry.

v2:
- Avoid calling filemap_remove_folio(), which is not exported.
- Add the folio to the page cache only after read_key_bytes() succeeds.

 fs/btrfs/verity.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 983365a73541..25f021b04ce4 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -720,14 +720,17 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 			goto out;
 
 		folio_lock(folio);
-		/* If it's not uptodate after we have the lock, we got a read error. */
-		if (!folio_test_uptodate(folio)) {
+		/* Folio was truncated from mapping. */
+		if (!folio->mapping) {
 			folio_unlock(folio);
 			folio_put(folio);
-			return ERR_PTR(-EIO);
+			goto again;
 		}
-		folio_unlock(folio);
-		goto out;
+		if (folio_test_uptodate(folio)) {
+			folio_unlock(folio);
+			goto out;
+		}
+		goto read_folio;
 	}
 
 	folio = filemap_alloc_folio(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS),
@@ -744,6 +747,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 		return ERR_PTR(ret);
 	}
 
+read_folio:
 	/*
 	 * Merkle item keys are indexed from byte 0 in the merkle tree.
 	 * They have the form:
@@ -753,6 +757,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
 			     folio_address(folio), PAGE_SIZE, folio);
 	if (ret < 0) {
+		folio_unlock(folio);
 		folio_put(folio);
 		return ERR_PTR(ret);
 	}
-- 
2.51.0
