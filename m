Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C600366054
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917567; cv=none; b=ZOu414+LQu7cik1/5WURK8LyGn7W8A4YBhH/h32aHnI1vRe3B2L4vxfne/IPZYAk7C5CyX3GxY0i8ip8Pk7H99edpDnjrDssy0t04NPNhlpwX6X8GiuNDdl0Xa9CwXXrwUT9I76pahKN1N3zeKS5Sngt8lT6bgO6uoVTQzsR3rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917567; c=relaxed/simple;
	bh=fpVssjg+4XJthCf9WKkoPFsWxlikgXoKl5knbALFZ+Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0y8nYGJxnAfJlDCvFkg70qIR3XlelM3Ie2Z279mi5Q6p4PxA3zbjXGtfLJ5PgPKHUBnDJ/2JkOFSQvPcecyfGNFkZPqsSt2LflqkxHIukjKtyDvNmwsCWFmiuR1Z6RsAKsx224ifLEHqoKuYlM3zZMf6qFI6RA5dicK3M6Lhdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJfXli7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJfXli7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA0F1F00893
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780917566;
	bh=SdKMTIje5rKGie8BYElSUNwRGBEeXevypdB1EUDelcg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=HJfXli7CSOO7lUCAWpRDdxv+ukLec48oCvkS6SOxYATYucLZovMQQdGnvlWk6fE2A
	 jfSB3H4JsFns3Txag/Gnc4+7xfjHy5H/OwCReNupRTNO6qRQZMDm2gllFaOZOMld8O
	 BPc1q2qdtWImnZLG8kJHGjTzQV00golO29JzlzNGNRlLobDWpxBuQNCjnuguYkFnB1
	 tVWRdOEXOzgb7hCNi81fz8Iy0srGH020WoWcO8ZiJxNLS6iDfgQHsrvFmQ+7OS6lq3
	 /hWnHmlbkdXxtfICQQKBVP/YrJYkkxR5vOb7Nry9HV79N7AjXCZC/tjRElAproqyzO
	 tPoBOqhmoctqA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: fix transaction abort logic in btrfs_fileattr_set()
Date: Mon,  8 Jun 2026 12:19:20 +0100
Message-ID: <409fe4bb0e89f04f195deee7c3e6f5005269d7e8.1780916663.git.fdmanana@suse.com>
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

There's no need to abort the transaction if we failed to set or delete a
property, as we haven't done any change. However we need to abort if we
set a property or delete a property and then fail to update the inode
item, as that would leave the inode's state in subvolume tree
inconsistent.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4b49b7e08425..c691dd48102e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -289,6 +289,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	int ret;
 	const char *comp = NULL;
 	u32 inode_flags;
+	bool prop_set = false;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
@@ -401,16 +402,15 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	if (comp) {
 		ret = btrfs_set_prop(trans, inode, "btrfs.compression",
 				     comp, strlen(comp), 0);
-		if (unlikely(ret)) {
-			btrfs_abort_transaction(trans, ret);
+		if (ret)
 			goto out_end_trans;
-		}
+		prop_set = true;
 	} else {
 		ret = btrfs_set_prop(trans, inode, "btrfs.compression", NULL, 0, 0);
-		if (unlikely(ret && ret != -ENODATA)) {
-			btrfs_abort_transaction(trans, ret);
+		prop_set = (ret == 0);
+		/* If ret == -ENODATA ignore and proceed to update inode item. */
+		if (ret && ret != -ENODATA)
 			goto out_end_trans;
-		}
 	}
 
 update_flags:
@@ -420,6 +420,12 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	inode_inc_iversion(&inode->vfs_inode);
 	inode_set_ctime_current(&inode->vfs_inode);
 	ret = btrfs_update_inode(trans, inode);
+	/*
+	 * If we set a property or deleted one, we must abort if we fail to
+	 * update the inode, to avoid persisting an inconsistent state.
+	 */
+	if (unlikely(ret && prop_set))
+		btrfs_abort_transaction(trans, ret);
 
  out_end_trans:
 	btrfs_end_transaction(trans);
-- 
2.47.2

