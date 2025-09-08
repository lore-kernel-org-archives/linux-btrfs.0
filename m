Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D688D2FE053
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Sep 2025 09:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757325238; cv=none; b=CmckKu5pNYeyYE4eECLGQEbk1chqKtOYDBJNPxehGkpQqQBhiQDYthbyoDcoIt1D9DW4hhWDJtG65hLWvmpefeR92/Q7qZgaiREokNCzU8JMFK3KOji1PWWk5QyvRuCW0ca6j0FpgPZMDZE/H7zAICArJ30xWrCKmiPH2OgpA30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757325238; c=relaxed/simple;
	bh=MnItm0esiiBsh4+m6xljYe0QZ/22Hogi3WrUWp5GBn0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMd1jWSljnmlAPZt/MSw0ufpa9w/mNuroaC4I4Fxsw6iPzxaeVcN6TnN9nuA5ckJzjEoQPdrsMdf6aAVZvWkHoCnf+3PAT7Duo1yAgm6cRX19G7jcmQaOKk13c8tnLpMIjaZp3w54bPAR49Lt9hiGaZlAEIJ0aEr5SRR8jHZTPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyqvyBqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyqvyBqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A21C4CEF8
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Sep 2025 09:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757325238;
	bh=MnItm0esiiBsh4+m6xljYe0QZ/22Hogi3WrUWp5GBn0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LyqvyBqtT0ZscTqNupEkksXqpWUQ8/+fm7lfXhu/q0jK2CEhQv+y0Z5p0JN2tKnsf
	 ixdLTU5P+B3L5VEeu4RyW2sYCfCSy2ueEbjEN68y1wNNiAIkggpBeaYUh8XI/nO3kW
	 oYejdJT93SuA8FWICIW/zIZ1JPa9TXZjABFa9Gza5bjEi19Lhq2KWIkIBlD0AEJC6i
	 gefVL/2R0N+DuzSSTMIudc1BvA8cukYcdhljEYjBA4Amf6lOI+7mr13Ay3TaEPAzyx
	 8qDd4YTLFRwo7zjhy9DQ8CnAB0i+GxZEaCFPCGsR4Hd4edVbkdWN+6cjysNHX6Y7gL
	 JcP0LLFsyexaQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 30/33] btrfs: remove pointless inode lookup when processing extrefs during log replay
Date: Mon,  8 Sep 2025 10:53:24 +0100
Message-ID: <fc911be17a5e2c7826f5c7f354111af4e5ad3026.1757271913.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1757271913.git.fdmanana@suse.com>
References: <cover.1757271913.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

At unlink_extrefs_not_in_log() we do an inode lookup of the directory but
we already have the directory inode accessible as a function argument, so
the lookup is redudant. Remove it and use the directory inode passed in as
an argument.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6186300923b7..86c595ef57f4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1165,10 +1165,8 @@ static int unlink_extrefs_not_in_log(struct walk_control *wc,
 
 	while (cur_offset < item_size) {
 		struct btrfs_trans_handle *trans = wc->trans;
-		struct btrfs_root *root = wc->root;
 		struct btrfs_root *log_root = wc->log;
 		struct btrfs_inode_extref *extref;
-		struct btrfs_inode *victim_parent;
 		struct fscrypt_str victim_name;
 		int ret;
 
@@ -1202,20 +1200,10 @@ static int unlink_extrefs_not_in_log(struct walk_control *wc,
 			continue;
 		}
 
-		victim_parent = btrfs_iget_logging(btrfs_ino(dir), root);
-		if (IS_ERR(victim_parent)) {
-			kfree(victim_name.name);
-			ret = PTR_ERR(victim_parent);
-			btrfs_abort_transaction(trans, ret);
-			return ret;
-		}
-
 		inc_nlink(&inode->vfs_inode);
 		btrfs_release_path(wc->subvol_path);
 
-		ret = unlink_inode_for_log_replay(wc, victim_parent, inode,
-						  &victim_name);
-		iput(&victim_parent->vfs_inode);
+		ret = unlink_inode_for_log_replay(wc, dir, inode, &victim_name);
 		kfree(victim_name.name);
 		if (ret)
 			return ret;
-- 
2.47.2

