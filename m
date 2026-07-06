Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CB03BE16A;
	Mon,  6 Jul 2026 05:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783316437; cv=none; b=WI6szvD7B1x2ofMUTd3YKfbhVazJteUK67GJuL7tD4gxI+Qjw4CuFanJ2eNR5FsOz40Glb0ywGkni5NmF16cgRa+EwFos8d88Wmze/AIxuYtg7eTTFc39e5ZqZoPnN0TdJIGsElgx/qt582rVxsfsVPm84BA0jC9DWXBTeaYJDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783316437; c=relaxed/simple;
	bh=Fm7su7aIi+uCg3I/H+ELSoLTt1CJWRvlP6EZLfh3xOI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fCZaAwit1lBHF3cWP+IHKNTMhddTbiHxknM+K72kX3J/gP0TLiHFRidjhKIhxeY5G0+hUfvyhtkX80Gn9ap24OxjfUoh2IQ1rz2kB9AbjMsCro4Sx+riTo8r5835yVxGE38yY8dOd982XfzEfecpuXTWg6QxVsvIdLdFQaKzJcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=OUV/u70U; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="OUV/u70U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783316369;
	bh=9cjPwTR0Pza02ViKagjaOwTn5xtpiIaliQYY89fPuYw=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=OUV/u70UVgjhPet4TTQYGzBzpNKIifHOmCIsuGX9BkZMq7S7onVWdXEJQh5PnoOPX
	 xb+pZUZj5Q8BP/k51zb2fA0CWDBmSVM4k55BLIbuQGIa7nZ6t81rkWYr+6zKVzM2Sd
	 7upFuwdnUmpqYG2sa6pMS+xibHbKdnzd4i9xo0qg=
X-QQ-mid: esmtpsz20t1783316352tedbeae98
X-QQ-Originating-IP: Us1pDhsF41zZnwjDTvg2Eu2pnBAXiHdexia7WjC93Ac=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 06 Jul 2026 13:39:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13615665003812104110
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Boris Burkov <boris@bur.io>,
	Matthew Wilcox <willy@infradead.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] btrfs: remove verity Merkle folio from page cache on error
Date: Mon,  6 Jul 2026 13:39:07 +0800
Message-Id: <20260706053907.544337-1-chenyichong@uniontech.com>
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
X-QQ-XMAILINFO: OPbPBgDYDz6mhueWiCVBoP9h+vLDwBFgmQ2qIK/QgUPT0lP2yNw6Lccl
	Y/6l30mbtF2+BK+DFQ1b8PI4EsXAyhpESM0XxsLLcD6jdRshQG4ISjtszIlpFqR1SEghpRQ
	0XF8dJQv08F+v+mBnrSwmwS8NGZ+ydRnomzCcZDpL65bGXztGSRkEUE7QO9qswII6hjEErU
	2wHZVhW8/VDfliQw/O2j5N6idzRIgVMfrDZ+vHw/V2ASGFHXyPVJpVFejbe/VDONAhUxnot
	A+/SysYhBUrpH17Z+Z+4Xo7+3VxzvYzVTJYuRtNoSG7Qu6iDPirkCfwuKBj/XEO9AGqwzzr
	t3EMvSv+hyAEA7k8SnkmFV1pyCpj/IBqQ9AfKa3jWumqrI75knkwDVENNAjWe+BObGvOQFb
	W5qXH3dOgZaUabEb16p1Xj3BZuEhK6dwSQ7LiTIZRmbtxXF9cFxb9Q/+xfMF+WIgt1z8D2l
	Q7huiH6c1R0rQR+A6SeCqNwVl2rUnyHBr79nszwtDFz+r0mgECGOY6quRcA5UIgNB8v/Rsk
	gAkfO+JdfgUaU771bozA5/rVvBzpcPIw3jIsP/7mpzYc4kK/BUmrpcAUMXhAnl8nI8CD6D/
	FYpU7WRvmbPCXV+RpC+uTGREgwkeOX6MqRS5C8OtwT5HiWO+3Us7coXb55BDKQ8I/0dFIGq
	ucYgqe0fKeolCgWBjQwQhkwzjuJKAQo9FJ4c7YSkj0oYwM534/9Hi72Jp0VBVGXubSPwz/+
	R5fibVtSvg77F5GBjPIF9MHPr20y9z9+W/AGHukdwo5jaqR1oQHDTh5WRr+Ngl1iQD7bBdl
	3wfVbegGMup0g6gkQMSE/nJQfWGTKQL/yvj+IvlGoBA1KcpQh2ZQiE6DIcZHdXgWrlGcqdu
	mCB4gfHWk6tFObVBxPtBAHR1BZ6ivbHgEbhO166MgvnLfeooBYLlspZ0HV8/3TdM0n3TQg2
	A1z7tzk3WEFa3P3ca6sDGG2EAKKLrmsva7p2CnV1LyirX1CzWcdAk3WMJ/YrnePpytvjnfd
	Q1q9jd3452Dbeus4SmH7y5MCqU/vc=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

btrfs_read_merkle_tree_page() allocates a folio and adds it to the
page cache before reading the Merkle tree data from btree items.

If read_key_bytes() fails, the folio is still locked and present in the
page cache. Drop it from the page cache and unlock it before releasing the
allocation reference so a later read can retry instead of finding a locked,
not-uptodate folio.

Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/btrfs/verity.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 983365a73541..99468791a98e 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -753,6 +753,8 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
 			     folio_address(folio), PAGE_SIZE, folio);
 	if (ret < 0) {
+		filemap_remove_folio(folio);
+		folio_unlock(folio);
 		folio_put(folio);
 		return ERR_PTR(ret);
 	}
-- 
2.51.0

