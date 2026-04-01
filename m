Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14F33E022D
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 18:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775069705; cv=none; b=kFiZpDFJTS3hklN6CDLNSuD5DdD1dxlddxHI7ROotLta0Xwf+udauUCBalF8bSe4csEXLSHS/OgJs663zv2tn559B6ZWx8hqCtNcJlWqlVauFd0WNLlHCkHYgbA9PWWeUlunyDSEpVCj+scLE8TBqsYUQrmhhxNOAdTk/d69yaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775069705; c=relaxed/simple;
	bh=4mQo/OCsrgXOjrqns2ACIGLQ7LdVvWWvPddpmiJMyvo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VVWdFhC3ERwrqmqZ9XyYIZv82vDCQfcLIshe3Yhp0+PoUwRhJqvddZlpAW3SUWWHVVyGPP+16ZM06UFU32fwIEPSLQJh+MV/TXMaqu3wzCAoyfnkbBiOxL9WnTBDre9VH1RbIuE6m7zqWtlNePUoCcOLTYB8NsrLZiQ3hb/fL+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JjpvRDMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjpvRDMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1920BC4CEF7
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 18:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775069705;
	bh=4mQo/OCsrgXOjrqns2ACIGLQ7LdVvWWvPddpmiJMyvo=;
	h=From:To:Subject:Date:From;
	b=JjpvRDMw9TS75jN6L3nMe4scnXDWwwt+vz/luyDgvY1QaIbMEqVfKu3D1p6wUiWmM
	 ZoyYyHpy/k4NWEDABefXTqxH2p0Djfa0sgYEPdIrQqgvyr9y/ZfnyrCasxjxC6pddb
	 bwpPlfm1sGj3I4Pcr3kHcDQvyFDulJcsFCr3fJeffhJ+082t1KdPnsLE8+HVv75itJ
	 Opg7d+6YavZrz70614NKAeyUbs+loq7r5hWsXOREWyBfaRX2B2S+yhF+BeBRXorblX
	 pMCAtgWOvG2VzCaLP+OC1f9OMYaVCcV3MuZp5ZzOA+l7wS9SvJ3VXEniYEuNu6SbP1
	 KWATMKLATitfA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove duplicate journal_info reset on failure to commit transaction
Date: Wed,  1 Apr 2026 19:55:02 +0100
Message-ID: <fa5c062786a6a987ffc2643fc444ab9c106fbeb0.1775069670.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we get an error during the transaction commit path, we are resetting
current->journal_info to NULL twice - once in btrfs_commit_transaction()
right before calling cleanup_transaction() and then once again inside
cleanup_transaction(). Remove the instance in btrfs_commit_transaction().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c9c316ce4bdc..248adb785051 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2657,8 +2657,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_trans_release_chunk_metadata(trans);
 	trans->block_rsv = NULL;
 	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
-	if (current->journal_info == trans)
-		current->journal_info = NULL;
 	cleanup_transaction(trans, ret);
 
 	return ret;
-- 
2.47.2

