Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058C1390CB4;
	Wed, 22 Jul 2026 02:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784688955; cv=none; b=IPWiFqjyHYX2YCbXpZzSi2uC4656YY08OL+IB2He9vCxQlMpA+gGuZDUcWyzrpm22HZIfA5CEQij+fwXFVVVpUk26JW3itfjmF9bFdZcJAANPtgigziVpeByJkyv1UgfpNaZvBUzaPvzwN6QYUO7bkeEffkIlKjea80WH78kRq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784688955; c=relaxed/simple;
	bh=5WmrYCnHswAV6gOPjDVcohIx/F1VtpZqqOUSlPGLSNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bgwPGRwpiOGCp9BujOxh3khsoAfo25WIj7cddiX2l1Fj+eCpH6IoLpng0Leh9Nzfr/5VKzFHueneS9zpyEt9PJ/dVJzxru3uou0O5HbEuckK08L/omR1h5z2Q7d2XcM5oT4FOsemEnMyjWDq0nrWt33A7yH3I+htSKP7yat2ojs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=jOYTJ0gT; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="jOYTJ0gT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784688896;
	bh=5z2NFCD7uwvQ9aEVx0qETNbEzHoeryVqIAmA5QhLmi8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=jOYTJ0gT7C8R/ku3QXpdW/yMJzRzKU9a+7kgVhyLMpvMo58l9QQgL2OxjO9k9b1nx
	 hOwRt5x2PZIFvhYu3VxZAK9ttJS03xmkFqt0O3A3HnmV3nh+JKFraa24MJVdAd2OET
	 Fb1VSr+WH0obG3ZPjYw1emsh3qpWnU4jkC7Ae/8M=
X-QQ-mid: esmtpsz19t1784688879tb657f3d9
X-QQ-Originating-IP: pqggaNU5xEv3Fejq//XWqolNvGwmowI8eEUmYAUDvOE=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 22 Jul 2026 10:54:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12053945533611148655
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Boris Burkov <boris@bur.io>,
	Matthew Wilcox <willy@infradead.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH v4] btrfs: retry verity reads for not-uptodate Merkle folios
Date: Wed, 22 Jul 2026 10:54:35 +0800
Message-Id: <20260722025435.1493093-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NGizNBd3uSau8WknIU3/9Sjl7zg237X+pjY5tNMUQxabIXznXGcUAdVC
	ShcTfJoEDgHRVJqIA3AUveeu3cgiy329RqsnZkBcmkZ/fZoJRNGv41h4+lcdY0/FEzuKuEn
	EfczsW1N7ZT6UXRDKK8juIDHPQhfDOI+lxMAiEe+gIVy7RfbkmGFFZBIqLhoo93e3e1dK6q
	bGYXNmWCXtmNeIgp7g3cxnZjkD5t0h3M0MClKTU+gO79NriMxwc9cBsZS8+IoVW6+iMdaS0
	HTMgBTkTf7qE1OzS9m4uolyuoaqnLRuVzW4O6zWqD6vOD4qDTgU0NXMn3S8y6CwKe6oxuyn
	Mya5IlUwiWsKYMcMwlBNC1WibUFjYiDS9Yxr/mw7EkTrCwfU4yQXi6tiA/b+d5gWy9quZ5F
	QpZq8XU4J9srZuyDlj3+df9C2tTmpr6Pd817bUluUKRrxcMFzfrFnABT40FcLexHmz2IGa0
	bfueO4kiKuuapQYyNAMNw4Faj8/DEJaXsWXgw0qcNwqY2p6xbsan8aJDIXgfmlYbm06LLjW
	kvYSTIySlVuzksm/sqdOD19jSTfr0hU7yklz632npz4F8ZLB7Xz4vE4R00+MagC73WLNyMz
	WJvEDniRkYOArDsvIexkI0MvCxFLKrOlZNeDrEa/c6DdCukwfbAD8bg2rpm2by4/T1JCLcJ
	cfuRCBfik4aWMjWZpCsAegqdA4B410Oz0ykSsXdCvDDEgczmmZQJzeWkVqQl3RThZC5q46F
	lwRsE+1INw4DYZA2WC8HHqjSqmwLZ/9Q5Vcm9HtWuZ4ZkR2pbgS9NFqpVp6x4Fk8RXOYvgX
	4P1K4UBB7+fxh6RCcqgk/BqZs7+v4Pi820U/L1NTz6iD+S9hX5qPFeOp2kX+F/RzkhLGHAu
	z6Ac/REiwfC3JUFsgvgWE+b5k3RE/NX09Fb/GXQDK75KCVuKg6x5UDPbCgdyJBd4ysvu1nT
	OfwePR6mmuMrk2JLb6LwUc4QUN7w1Ao8/ofvOLaQ3fjfXLwJBw1CikFu8EZ8YMs5HZfbxR7
	RJJGuQkEz77+HP2H3ikJJsSVRLuT8h0h0/fT2/mkf0Sc7NFIGuGZBSunqi9MpgqxbL/Sxb1
	i+49sFCjCwhvD8XM+rG01IvETNl2qsKRA==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

btrfs_read_merkle_tree_page() can find a folio in the mapping that is not
uptodate.  After taking the folio lock, the current code treats that state
as a read error and returns -EIO.

That can make a previous transient read failure sticky.  If the failed read
left a not-uptodate folio in the mapping, later callers find that folio and
fail instead of retrying the read.

Keep the existing page-cache insertion and locking order, but retry the
Merkle item read when a not-uptodate folio is found in the mapping.  Also
unlock the folio when read_key_bytes() fails so that a later caller can
lock it and retry the read.

Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
v4:
- Add a comment explaining the locked uptodate recheck.
- Add Boris' Reviewed-by.

v3:
- Keep the existing filemap_add_folio() and read ordering.
- Retry the Merkle item read when a not-uptodate folio is found, as
  suggested by Boris.
- Unlock the folio on read_key_bytes() failure so later callers can retry.

v2:
- Avoid calling filemap_remove_folio(), which is not exported.
- Add the folio to the page cache only after read_key_bytes() succeeds.
---
 fs/btrfs/verity.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 983365a73541..1133a56c0568 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -720,14 +720,18 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
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
+		/* Another reader may have filled the folio while we waited. */
+		if (folio_test_uptodate(folio)) {
+			folio_unlock(folio);
+			goto out;
+		}
+		goto read_folio;
 	}
 
 	folio = filemap_alloc_folio(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS),
@@ -744,6 +748,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 		return ERR_PTR(ret);
 	}
 
+read_folio:
 	/*
 	 * Merkle item keys are indexed from byte 0 in the merkle tree.
 	 * They have the form:
@@ -753,6 +758,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
 			     folio_address(folio), PAGE_SIZE, folio);
 	if (ret < 0) {
+		folio_unlock(folio);
 		folio_put(folio);
 		return ERR_PTR(ret);
 	}
-- 
2.51.0

