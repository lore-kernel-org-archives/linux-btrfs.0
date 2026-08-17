Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BF632B131;
	Mon, 17 Aug 2026 05:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786945789; cv=none; b=Go+JhqhkswbNatnK3u9thBkn23q4WBuXN0UCKU5IEWPm6USCuv+ioCqed7A67/tDPMnlg55khvJRLRGY/yUWOr9hfvHufqZi7eZaGs+yle6/Dp2f1OKIgGyTT/MyqQfrCcjvfZgEjD9uoE9CcOTla2FvWHqtAnhJ2M3iMcJciiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786945789; c=relaxed/simple;
	bh=F5q/I7cvNXHtGancq7EFSWyDxG8bSC0oT4oQHh9Mtp4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FdMbzpatBxSwwTtB4zZ/r2oPZHaO5VTxNcv0Hh8wXjEp8z7sHOoGuCBNxkTdoEN3g/a/oQQ4GXQ2tyxIWgPh9Dmcrd9oEAXTgVMJ97TJ5vNGO8qI4q3u9gpmADXZWJN4TjLEC00hHnBXcCA8OFrf7x1ogP2GoLt3w8h+JYMUoi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ciUS1Gn9; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ciUS1Gn9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1786945738;
	bh=SkbNifsjxjBkaPmj/dQjh8kjO9bLukJgcbShyG/06c8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ciUS1Gn9wOp6FUlAhx/gxFiPFVMAA7SX+uLuipV8Y0dsGgeiOmU7FtuHpWKiU9pMi
	 7wa8qaxxJTKk/AfUkHoT5WuGOkaXsM0fLu+jYGP0P53LPbZ/6/dZGDAry4sS860s00
	 KXySFtoofeCX699tIXLu9cxdJrBht/T47EfREjpc=
X-QQ-mid: zesmtpgz7t1786945721td90343d5
X-QQ-Originating-IP: Sk3dy6EaP4XG5nN2pxMdugk++Pow/cUKwJauQeAFWbw=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 17 Aug 2026 13:48:39 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11438748642682863973
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: boris@bur.io,
	willy@infradead.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH v5] btrfs: retry verity reads for not-uptodate Merkle folios
Date: Mon, 17 Aug 2026 13:48:37 +0800
Message-Id: <20260817054837.1740374-1-chenyichong@uniontech.com>
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
X-QQ-XMAILINFO: Mqr9yFX+hq1OIM4VFXVwhbYHsSxxo4Qaj3+RIOLmnZIoq7XeCdhwcbHd
	0P9wiasNt/L7NAgMk/eT51SyoIZTjZGDeqhb/p9zT9qtZWlDz+xTCDkomXsOpMSLVHllNiS
	ELZRkNgSkrn7QgW1YinhJqV16w3cYiIxTZhOUsomFjNpuJEMzM0LuKw5HYhhBEvVZLBNfLX
	KkLh1uQFrXwQD+3r7PicaCqrohjxmnT2/927ZILmRmKtDV3m/4lQ/rSUjk1JV3MMfQRP7Zd
	XkSmKKvkF0PVug9aT0zUYUiQbPnldxv5nc5Y6k8BzAFhEFuSUD21UrEFz8dSZC3dsPPgPIf
	2xXOKvot7LqNrlzbe0euxItiu7LMdiAoHQ5rBN8Z3/xL1Wk8omhElZ9qht6pZj0Y96IhJgN
	Z9DpVFxpVPB+vN0tfaNrs00Spu4CPWF5SBJKb2HZ+lmjKNIYxevmNqeYi3qlFFvBYF1BRz9
	EaqKP2xsTGnV7CLXFs3ccRRyAJcnXMH0bMoHwPToGzXCPPnSqAbnZJOODlDczb7QvFzEECs
	VpPjq2pRWar2ReuJJCjpwfbJUlSsuGMGT/k7aqCJjnN6S6RnmBlK48Uh8KH3IgIfSAlMnD4
	NDEPxtglHDEFVgLy2yHMxEt/qb9OFk30BKkWt2eG4WEFeRZRyV212wPP2PZ1zbij2kI8+xY
	bPZwoEeJnJ8Yr43RMX9BAJiYzNw0Rf49ZZrHqw60P7KWYnbIUKRqWurEJiYKg5qCAG5apr4
	4Zo3QcCdWqdgJxAFGMIw1GxRmTaexIgK+P+aOJG136NYBU7cTw/Y2zAqUnJEOuZW5WvWM6D
	fG0LJBzeq8WDDf02437G3QHXWBkAi3BXqx8fdkbCNF9u94FZChJxxvhJB7NflakpyLUYMz6
	pdL7gdJnTPSe5P+u3H0wdEytA95/ZuORHFRXZRFAm7XUQ7bv0M788HgBygONoakIzlyxWK7
	McwcztGjUPzfn6b2SXNfq3kcYzY/93mYB8hoyTuV6lpaX2G78Co8F5S7Zh65GDjHoYZFPAF
	bpCPximA1En7nfj9F0+jQKYzSnrkn+sWIyG6tQaHUe4JXspXZv0/F3MCGDxqA=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
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

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
v5:
- Drop the Fixes tag, as Matthew pointed out that 06ed09351b67 did not
  introduce the original !uptodate-page handling.

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

