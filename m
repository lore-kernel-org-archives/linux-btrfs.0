Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E692376A07;
	Tue, 11 Aug 2026 18:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472114; cv=none; b=meU1udXidzo8lTEPNAyX9zqswRlvnHR0fcfSV4fwf31RK2TK6t4HXArC7FTiwwx4Dxs7mTdQfpfVQMhunC4RVJhHZshkQDQZu6N7xXucpRFUE0cxHjC9aMYS0RNZJmtwE2C+T/2eX61K4qpnMqX8mO9p9EueMgZ7ruvBNRcSj2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472114; c=relaxed/simple;
	bh=z8frzW3+GWYNL1Dql899xeHXBn+IosONCZIVli05JSk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TqDgk1O1ruZblOM8YbmKqi5+ewSHhFGRWXU0SobVnHv5P1wLSO759PkuK9Xi5Uo/+eS2/jaYFZSzc22Dda9WAF6iNw1xPhNUqUuBVlU7F4EYjf/DYyT0IREC6MCZQzKUUTSnegjS41Amm1LLcTAZnhquuxzJB9x1/yI57Mj5sns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYyPntYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYyPntYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07B21F00A3E;
	Tue, 11 Aug 2026 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786472110;
	bh=habuHpxE/FIf7mktmFmbUjmAGBxkdmZecj+7Q8PaLgM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XYyPntYSlAdbCDQbNuBzwZNZPfMmgIs4JXvy3VVZ1ivMV4q/wm1nXb3QcKjhe36K4
	 ZmPtrRPMLQVbUEp40KtTqfxwc2ngIkbZwK8lB/YdHLz/OGyZy9l96ZEnpKP4XSEbNf
	 1IIkCiLhj5DMQYglAqkJNfAyOCM9K2NuSYQdWh+G8kiAZg3DYRg1+c1Rn3WS4Kzmbh
	 Oe/PV3rbSybeHlVkCykgy4J0W9Gr4FYDi+P9X6j9j/qk9V+49Vri1UahzCjBaKAchc
	 xA2aeXUnj/pk/y4vBut3z97tSZWimJY3hEraO7HoGYto1fh2pYPf5/VcfJALhF27lA
	 /6urMLRA9+xMQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 11 Aug 2026 14:14:55 -0400
Subject: [PATCH v3 2/6] btrfs: use an on-stack path in
 btrfs_del_orphan_item()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-btrfs-enomem-v3-2-46a993fc3fe5@kernel.org>
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
In-Reply-To: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1772; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=z8frzW3+GWYNL1Dql899xeHXBn+IosONCZIVli05JSk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqe2aqT4grwQmMOHzzZ3+LmwXm+Vwjdm89NCwPo
 Ge6xyDjs46JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCantmqgAKCRAADmhBGVaC
 FU4HD/41ywTjbFqkHkAykTQ5S2MaSb69ZPlXodA6lRjNh5r7pEUK8DzPKARbFK8sSBU1V6Q2Put
 /Eypcq7tSKfFtFlgsc5T9lmbYv8LKyWEGCESrBRiXIjU/+jj1EGIKmmUuVjqzM9+waKrkAebnmk
 fWkQzLgNHuzOyHGU4adNi5Aiu2fexAKyexMNGgJ9VP4K/e1VTxC1iv3qupdJcRJPd66xKtqf2xn
 OTl1bD1IslSpi57nlnOgsAksW3kf+oo6YuPg/UbdPGgc1h3Ajk5w5HnYsv1g47h78aK0WwZsZRG
 kAntU9MZtt0Vdr3JsyoDUQxUR6tjBG/7Szom+8x26iq792p5Q6Wq1MQUXwb7ooEvO7r4rNFtfPm
 ojXIiCq2Uw5Pl4XpfnWMRSvCuTeur3WvTnkGAZfsUW14a/o/91obsk9n/p6yTi65Q03sRe73yay
 Ubx2gPEcvjqTurGrLbQhX7rutXzQOLPiqzEe2a2hBn4osYpfmNShDDgrWkACcI/dFsxksOld2UW
 eOztJS1aIjEzJIO+pCrtnn9QwCHxVTo+4o1IDrTfkdtqfRhV5A7J8CVfM2o9BCG1H0J0z7vqRTx
 KWThuHSVewxq+nzemLyTSmI0J/F8DL4F85VhTgtO+VFu8BTD3sdkmn0nvCe7cvumPHw5naVnyjo
 Puc90S28LVVY04A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

btrfs_del_orphan_item() allocated a btrfs_path with btrfs_alloc_path()
which returns -ENOMEM on failure. It is called from btrfs_orphan_del(),
and btrfs_link() turns any error from it into a transaction abort. So a
path allocation failure there (reachable via linkat() on an O_TMPFILE
under memory pressure) turns a recoverable error into an abort.

btrfs_path is only ~112 bytes, so allocate it on the stack instead.
Unlike the insert case there are multiple exit points after the search,
so release the path via a common out: label.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/orphan.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/orphan.c b/fs/btrfs/orphan.c
index 72e1adec39d8..ae1685f26dec 100644
--- a/fs/btrfs/orphan.c
+++ b/fs/btrfs/orphan.c
@@ -25,23 +25,24 @@ int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
 int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, u64 offset)
 {
-	BTRFS_PATH_AUTO_FREE(path);
+	struct btrfs_path path = { 0 };
 	struct btrfs_key key;
-	int ret = 0;
+	int ret;
 
 	key.objectid = BTRFS_ORPHAN_OBJECTID;
 	key.type = BTRFS_ORPHAN_ITEM_KEY;
 	key.offset = offset;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
 	if (ret < 0)
-		return ret;
-	if (ret)
-		return -ENOENT;
-
-	return btrfs_del_item(trans, root, path);
+		goto out;
+	if (ret) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = btrfs_del_item(trans, root, &path);
+out:
+	btrfs_release_path(&path);
+	return ret;
 }

-- 
2.55.0

