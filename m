Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC5A4968FB
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013063; cv=none; b=oKBzPaSzEo+/HnEmGmMmaK2X9FZMcjFHydG7BNWwXEwTyP8PgXjx9CeXU3ATISPVUVcRstS3Tai+7XMdfoRJzMASFv/tUV9c+DlydSvHRDPt55gN+hV0ETDaU5WLc0C6hdN86QZ5qGlKsn9nznn2eRLILq3Dq64R3IIg2raPfUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013063; c=relaxed/simple;
	bh=yYQTCTdUEkX9emXBwk//QID0a1Y1QnVOVAs8IPOngnE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saVBl6iFWW0hskwgKCiUhuackckT9xCcO1gBFJFBK616OSE/HhqwjtCRMhJEIzS5viIBITlso7LuiTFNuZfR77fGOL0Tq8LUYzSMHUhSPiG2Hs6NX4SnzbvKtvT1oEG/tNPdEdosQcoTTksf4/Ez/aOjsWtbRVZjcdbgUlUlcdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=koCh/rtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="koCh/rtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1E0C4CEF1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013063;
	bh=yYQTCTdUEkX9emXBwk//QID0a1Y1QnVOVAs8IPOngnE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=koCh/rtOrjdm2wUSPNWOzLk1hbrqs5lvPQuQyHtBb0lBmyHUvvd+HzVqHIlwdXuw9
	 NSinRFSXhM97EndEgQfweaRJHPsKFcX4NDD52vF3vN9eON6/sf3WMt61vstIcru1sh
	 my2WgpCrO7jw8JWdTTYSjGuc+mQop83MKVDsLRJ7SodLldTAZZZN1GTp/irOaa/pg0
	 ocmo1a9CC+25BD/qVmH979hLfd/5BSrYFFpIhsnpUhkSvLar5JDoeV7Yi0TEzNoTRz
	 J3Jj45yGInNg/hY/O/fOVFaB7aNdMRA9xWwiBnnnuHqu/H+gi1tXDlfhan+kjludjS
	 iimhm2wXNMQEw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 16/19] btrfs: remove out label in finish_verity()
Date: Wed, 21 Jan 2026 16:30:42 +0000
Message-ID: <da7079a4e1d84644f89351a5ae3d6243de983625.1769012877.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1769012876.git.fdmanana@suse.com>
References: <cover.1769012876.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no point in having the label since all it does is return the
value in the 'ret' variable. Instead make every goto return directly
and remove the label.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/verity.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index a2ac3fb68bc8..06cbd6f00a78 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -525,23 +525,21 @@ static int finish_verity(struct btrfs_inode *inode, const void *desc,
 	ret = write_key_bytes(inode, BTRFS_VERITY_DESC_ITEM_KEY, 0,
 			      (const char *)&item, sizeof(item));
 	if (ret)
-		goto out;
+		return ret;
 
 	/* Write out the descriptor itself */
 	ret = write_key_bytes(inode, BTRFS_VERITY_DESC_ITEM_KEY, 1,
 			      desc, desc_size);
 	if (ret)
-		goto out;
+		return ret;
 
 	/*
 	 * 1 for updating the inode flag
 	 * 1 for deleting the orphan
 	 */
 	trans = btrfs_start_transaction(root, 2);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		goto out;
-	}
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	inode->ro_flags |= BTRFS_INODE_RO_VERITY;
 	btrfs_sync_inode_flags_to_i_flags(inode);
 	ret = btrfs_update_inode(trans, inode);
@@ -554,8 +552,7 @@ static int finish_verity(struct btrfs_inode *inode, const void *desc,
 	btrfs_set_fs_compat_ro(root->fs_info, VERITY);
 end_trans:
 	btrfs_end_transaction(trans);
-out:
-	return ret;
+	return 0;
 
 }
 
-- 
2.47.2

