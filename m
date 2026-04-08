Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583993BB9F3
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 13:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775654014; cv=none; b=HtznAmmapNGeQMsgioOKKI60heG1EsDebnCpJdj4Zg9mKoRIdfxhyIQdoigiRpQgIbAB1OF16gkP73httvZjo/coc8Kvl7HOkuaCsEQKY4tTLNWSjMEZrcDWo+W1YgUwN1kq8NP/QUX7WNcnEDS0c5kc5rMMZyjaM6xVluwaero=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775654014; c=relaxed/simple;
	bh=EddFShLXkyNm29sBRo6sK1jtIegp9VSb9MeZgGpA1E4=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=ax8ZTsjOPvx3p+MwAgMxrvO9eYCzNqUsEsso0zS4PSIyYHXDxixgj9esBhBQDoT2RuuHukiIJbDTjUfxVSIW/7Gyyse6yMLrcMpglUHK62E+BZPWsSiXrYYon9WYnduSyhwo0B384oziLNFesrxCS1cm1hjj3WqREApifPCIjXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=hfTRMdSa; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="hfTRMdSa"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id CFA4331AB18;
	Wed,  8 Apr 2026 14:13:25 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1775654005;
	bh=nNrdaCGD+s2k1Vf1PeJfywoUHZBXr1OHGmdmbhh5l0o=;
	h=From:To:Cc:Subject:Date;
	b=hfTRMdSaO5TdIygQvoBECu3R6sOUaoRyuwjcM2UB39VIQ7Hr+aBukG1KyuCZPVhwr
	 rxvHhsM/SQmXdEKH9Wxtg0g1Vp+qPTYr2N8vWBOoUXXcu6/1+nwiE3WBzPe5N+lRo+
	 XTJiqPVtL1uuaGYmJROjEe7wtxaECIBErvQW5es4=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <maharmstone@fb.com>,
	Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: don't clobber errors in add_remap_tree_entries()
Date: Wed,  8 Apr 2026 14:13:20 +0100
Message-ID: <20260408131324.92442-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Harmstone <maharmstone@fb.com>

In add_remap_tree_entries(), we only process a certain number of entries
at a time, meaning we may need to loop.

But because we weren't checking the return value of btrfs_insert_empty_items()
within the loop, this meant that if the last iteration of the loop
succeeded but a previous iteration failed, we were erroneously returning
0.

Fix this by breaking the loop early if btrfs_insert_empty_items() fails.

Fixes: b56f35560b82 ("btrfs: handle setting up relocation of block group with remap-tree")
Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/relocation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ad433b7ca919aa..a7cf5d9cf1de0d 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3876,7 +3876,7 @@ static int add_remap_tree_entries(struct btrfs_trans_handle *trans, struct btrfs
 		ret = btrfs_insert_empty_items(trans, fs_info->remap_root, path, &batch);
 		btrfs_release_path(path);
 
-		if (num_entries <= max_items)
+		if (ret || num_entries <= max_items)
 			break;
 
 		num_entries -= max_items;
-- 
2.52.0

