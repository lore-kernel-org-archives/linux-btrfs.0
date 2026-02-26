Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA9A3ACEFD
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 14:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116452; cv=none; b=ChnwcLLeL0IMd5/Z9Mv0wyRNG7DKa2C3bwadYBDArTmNpII7d2KZeL7bYivs7cALJLhHKEh4ATgpOYww3Cak3Iu2+JLljGH+rYwc4Z8hEi/dBGsDPFdE7qVvvkc47AnFv3th8+DFuelgho3H3cOYGXQ0hl0IT74/JHqJVUAHIR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116452; c=relaxed/simple;
	bh=Dpm3Mjb7z+SgWYWXJF2eVY9mJYITCyy5sP+yjLRYEdU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6TvUPrpYa30sFjIF8VWWMTRWMkb585OLztemZ44Oy3YXG3d1m/Mo2RXvNlPkyE0d8SSW7AjGLE36ODcYmQlJEqWFenX40dVs6AoAHiUpquLTR357nmvQj3XhxJvIx3Pm1SdfcP7PyuWmkwhPwQozU1cW8ggIFh9DqQTwvlqT2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJPCG8wN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJPCG8wN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4560C116C6
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772116452;
	bh=Dpm3Mjb7z+SgWYWXJF2eVY9mJYITCyy5sP+yjLRYEdU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rJPCG8wNMw2bKy1D65RA/wJm7iYFeHJ6XLrnLnq1c6aYBLBF5DvXr+yYu05SZ1KfI
	 /S3DbRvUIIGwGC0naYXA7bNIR+iCRpj5Uxq/fXZSuPB+FfXJTHYhppbi/1P4gvY2eJ
	 SdRZ8SzfuzxER5mQOlScQIpmN2hPPe9YYHoy/VoLyVV2ShqHwW3pk+4GB17WLsAnEh
	 51i0gnd3FU/uQtB17EemuAS7EAcKo0qMDdUd4b/O/Sfetmm7IHrc4GWZwZzinmZrPu
	 4N8p/Bauo1gkoakP83RimfZyxijtQGBZ0u0KE7xaaKlJia9iMnCP6rrT/2icHP8MZN
	 V9VK7ChUdsolA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs: remove duplicated uuid tree existence check in btrfs_uuid_tree_add()
Date: Thu, 26 Feb 2026 14:34:01 +0000
Message-ID: <d81337ba97086fb9cc9ee7fecfc425d1d0fd82d3.1772105193.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1772105193.git.fdmanana@suse.com>
References: <cover.1772105193.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no point in checking if the uuid root exists in
btrfs_uuid_tree_add(), since we already do it in btrfs_uuid_tree_lookup().
We can just remove the check from btrfs_uuid_tree_add() and make
btrfs_uuid_tree_lookup() return -EINVAL instead of -ENOENT in case the
uuid tree does not exists.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/uuid-tree.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index f24c14b9bb2f..7942d3887515 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -35,7 +35,7 @@ static int btrfs_uuid_tree_lookup(struct btrfs_root *uuid_root, const u8 *uuid,
 	struct btrfs_key key;
 
 	if (WARN_ON_ONCE(!uuid_root))
-		return -ENOENT;
+		return -EINVAL;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -92,9 +92,6 @@ int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, const u8 *uuid, u8 typ
 	if (ret != -ENOENT)
 		return ret;
 
-	if (WARN_ON_ONCE(!uuid_root))
-		return -EINVAL;
-
 	btrfs_uuid_to_key(uuid, type, &key);
 
 	path = btrfs_alloc_path();
-- 
2.47.2

