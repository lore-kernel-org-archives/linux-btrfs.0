Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262FD202C48;
	Tue,  7 Jul 2026 05:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403805; cv=none; b=d/HA6UIyj02pzcKv8oMf3KVCCp6VRGDv+gjZQbhv7ScUQDSUYNICcMnHmkIqgo4LwWYJctW34o/qrwXPhKNtnfSOVDNk0lQbrc5HVRGT+kYbbXfP5bW4ArpapxF+AzRPdyk+Iwf45dK1fVtmD3BkPm+wowbYDzBCq7xlm7rODPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403805; c=relaxed/simple;
	bh=Pek9pUUGg9wxclBXEnf+43X2zUXzy1SnNCe/+6uWTSc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RnwWHRgqKpWu0RIFAVnW9xW8WSSMtXL42M+BFm9lxN4Gm35xIAOlubRjV+vXhf5nUgRn5Jv4FvYfq4D42yY1oa6yWHjAEzAzhgflWIjQFb7ll3VSmCZJtjuzljeIUKCPg0d97i87FjguhaRMVy+P0vbUAzC9PYjfjhE5QhBpO6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=KA1t6IlS; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="KA1t6IlS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783403745;
	bh=is52q75PDAFF2OLzQqTLhnMw5S3qdz5mrNnV0zNv0Xg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=KA1t6IlSBO+qHuZnxwjfYF88piQRE8H4RcZH7Zz/mhbUsBlCz9g/dtA6W3w76VXV+
	 WGgwh75/dt4U37TGO/CUFxrDfAtE5itS8JJHG7/slFJCGB74sFNlodIp+PGFvRVXmK
	 L+KVVarKKwkcEeCa9RdlaOb8TgJTY0nJqgZlD1iE=
X-QQ-mid: zesmtpgz9t1783403725t72cd87ed
X-QQ-Originating-IP: QziwHSi5WNtRjQxhG4WsHi56Vz8pIGE5c3T2G5RryDs=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 07 Jul 2026 13:55:19 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2635168879926810141
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Boris Burkov <boris@bur.io>,
	Matthew Wilcox <willy@infradead.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH v2] btrfs: add verity Merkle folio to page cache after reading it
Date: Tue,  7 Jul 2026 13:55:17 +0800
Message-Id: <20260707055517.570586-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260706053907.544337-1-chenyichong@uniontech.com>
References: <20260706053907.544337-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Oa2shA1LYpbMNWxALg5t39Ed83MGzU3h0tdOEYKiwnDNECV8nhowv6YI
	7FwrcPRK4gkvQqIg7msrl+wzKFzKOUyR/lAdDAIsZIPxcgMwN0tBnHjRYZMo5pTm3ne4W6s
	j/G0wgjuGM6ChnOLmXctpaORWMpCwsKqrdWkRly6C6ovk3VfQBIlnJ9P+wFQQTke+VBZlcG
	2+RDYPvnV+nJzgEiyFeE+K6kVvtkXuNkMbv3HSPhQD4DGkaqLyaQuOezCTqPBPeqHahvt5U
	vIKAAxZxQYdACor20VLkHiz00hnklx/bqNDum5tXaqIWT288xf5RLnL6jcamZ3jb+M1l34d
	u1BaxxuFa4g8NLJEPO30+Vw5CCMaieil5mxY7TjWNPOWbVOdXohjA3/469PgJPMUzb+C0um
	t1+Y0dS3SmjyN5xPSIrLmO16GmXAY/lR4amWtPasiNr9XqqnijMOMAuKyNnBWjQcDOvY+wn
	hEhTLGUqDofna8BCYF/3UfneCV6z/TIw0gJd4MuqrWZc+rO/m2jla2hGbv9hicweHcD2zTI
	pvSuf2+nQeyrQZJQxZElIrY6uO2oiq4GvKij+Wlqqsx13jgoNTwJ4UJFOWDttJyqoHnYnXt
	qyVtY9Ns40HshPq4XJxVhFAYB5l4qvyDpMOfqucvNgHdH2xdCiirnQdFvhMbDTtKZ3oZmZG
	jBHAoGsO1Z43HcU8zidqezsR4Zqetp7GvlYvESCXTFJQKKUbFGBeJJGC0bFk9jgAOuO5Kde
	M6jhOR1kGXMLsjzGpr+/eHEBJWblk8PLf8vsIKeBuw7ibeac66jXfl6QvR/zIwcF/P+uqw1
	fFAqGezyyYs2mZ344PDkzrn/G/FFuv4mZIFmz9Pnuv84GhdfO2PABklNESDuzrUzOj1T9p5
	8tcBT7X2/8S5bWayNjMm3GwxpOOF3WWFRWPGZjjW+e1iw38u6HQAhpsfhZoq7M0LfOTinyr
	PTv9un1YGEVsyX5VBFs7gkOSBMhnjUa8MrFVwsyvqhtJknHzIUdN/uzIyHp9cS0yuPf+1Mi
	SyNzt2nh0hRUmiEHbCfB4+4Dh2QERg1rX9y5PU1f74BV0p6FJLcllMBP6r/h2F/LrE/CjDG
	ESqbLQSWU4+
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

btrfs_read_merkle_tree_page() allocates a folio and adds it to the page
cache before reading the Merkle tree data from btree items.

If read_key_bytes() fails, the folio is still locked and present in the
page cache.  A later read can find the locked, not-uptodate folio instead
of retrying the read.

Avoid installing the folio in the page cache until after the Merkle tree
read has succeeded.  This keeps the failure path simple: the newly
allocated folio is not visible to the page cache yet and only needs to be
released.

Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
v2:
- Avoid calling filemap_remove_folio(), which is not exported.
- Add the folio to the page cache only after read_key_bytes() succeeds.

 fs/btrfs/verity.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 983365a73541..d705ce3b386a 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -735,15 +735,6 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	if (!folio)
 		return ERR_PTR(-ENOMEM);
 
-	ret = filemap_add_folio(inode->i_mapping, folio, index, GFP_NOFS);
-	if (ret) {
-		folio_put(folio);
-		/* Did someone else insert a folio here? */
-		if (ret == -EEXIST)
-			goto again;
-		return ERR_PTR(ret);
-	}
-
 	/*
 	 * Merkle item keys are indexed from byte 0 in the merkle tree.
 	 * They have the form:
@@ -759,6 +750,15 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	if (ret < PAGE_SIZE)
 		folio_zero_segment(folio, ret, PAGE_SIZE);
 
+	ret = filemap_add_folio(inode->i_mapping, folio, index, GFP_NOFS);
+	if (ret) {
+		folio_put(folio);
+		/* Did someone else insert a folio here? */
+		if (ret == -EEXIST)
+			goto again;
+		return ERR_PTR(ret);
+	}
+
 	folio_mark_uptodate(folio);
 	folio_unlock(folio);
 
-- 
2.51.0
