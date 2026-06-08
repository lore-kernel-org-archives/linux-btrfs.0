Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7642135BDC2
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917565; cv=none; b=Z/Klhu0GLs5zBzlfQHBtJZO+S28mH7qhF8CmrynmfA7qE9/AW6tqGoyhwATucTRwwMO3CXfafiEWW+Yanj2entD/6FovlfeyruRQAL3kptX8mZY02cQIHku33YodftLyrPp9j5FBdjiI/4PNRlDNNJPnE/V28ZrbnCzr9fanzqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917565; c=relaxed/simple;
	bh=7U/YAb7EFmRa4oFmfA62cEua5L6ngSPR6ktdoE47Ag0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGhTm5aNSsU3nXIJjVZvoEkF45FYo0r1+fKzqF3wBUuv0jgNU67/u2GIsLjEoJU9YvkQ1jJGOqqwXfQxKZ+hzHpyPMrWIqetLXQmV4Q3QaY8PcxIiF+tO3YfMs4FGzh6Eqxq4B4XjFA3hq0kki7F3ku+fLImyVzOyUMWDQikNXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mRCwVTEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRCwVTEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC89E1F00898
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780917564;
	bh=ChhvI+QVilq/1AoPi6b5fih5qIFQ0Z03IqDil67FRfc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=mRCwVTEY5rdHhQ2iqpDrB5BDxGDVv81jWxBiBmgrKhtM/ALxse8wR9tW8+z5AwwWb
	 ygz7YdJci+l93kcX+FcHJpTShTpnTQZ8476B0A4ciB390NajTaqp+K1TW85RVRIrWw
	 PMEKZ0yGO40/97/XGMPAAx7MqS6QpLWuLPDVMEwG94l8fQv1oLZYKxuQTEwdHqjhSE
	 5bM22Q1GMBez+54iVmioeLhrPaukdPSH3OXJt4jxlEqwElcVPr16q7KeGZUMMkw+7G
	 TJtcqZSYqy9htc1xSQT+UimtHST95mfQFdKDav2lSfz7nn+B0gEv3Fn7DdS4W+cDko
	 OKeT/BuNy2W/A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: validate properties before setting them
Date: Mon,  8 Jun 2026 12:19:18 +0100
Message-ID: <cc5c17fc35878826dddbd22f08b68dd2dd1cd34f.1780916663.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1780916663.git.fdmanana@suse.com>
References: <cover.1780916663.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We set the xattr and then attempt to apply the property. If the apply
fails we then attempt to delete the xattr to avoid an inconsistency.
However we don't verify if the deletion succeed, so if it fails we
leave an inconsistency between the state in the btree and the in-memory
inode.

So address this by validating first if we can apply the property, then
set the xattr, then apply the property, and this last step should not
fail since the validation succeeded before - assert that it does not fail
but leave code to attempt to delete the xattr if it happens, and then
abort the transaction only if the xattr delete failed.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/props.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index adc956432d2f..bb77d46376d4 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -127,14 +127,24 @@ int btrfs_set_prop(struct btrfs_trans_handle *trans, struct btrfs_inode *inode,
 		return ret;
 	}
 
+	ret = handler->validate(inode, value, value_len);
+	if (ret)
+		return ret;
 	ret = btrfs_setxattr(trans, &inode->vfs_inode, handler->xattr_name, value,
 			     value_len, flags);
 	if (ret)
 		return ret;
 	ret = handler->apply(inode, value, value_len);
-	if (ret) {
-		btrfs_setxattr(trans, &inode->vfs_inode, handler->xattr_name, NULL,
-			       0, flags);
+	/* We validated before, so it should not fail here. */
+	ASSERT(ret == 0);
+	if (unlikely(ret)) {
+		int ret2;
+
+		/* Try to delete xattr, if not possible abort transaction. */
+		ret2 = btrfs_setxattr(trans, &inode->vfs_inode, handler->xattr_name,
+				      NULL, 0, flags);
+		if (unlikely(ret2))
+			btrfs_abort_transaction(trans, ret2);
 		return ret;
 	}
 
-- 
2.47.2

