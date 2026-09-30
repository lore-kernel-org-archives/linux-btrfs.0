Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366654F96C8
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783266; cv=none; b=bxwnkzXHCvtDPxHT4TyKFvwPbEFxifNKlowFqnN7XB8f8w5EnGINUuDTCUPhEiaGmMHDDk/rainoPwsZrldOqSDZDmppSzR8crxSMHPVUhRwTlogdtcOzBd3RX8fa9hGvmvWKGpyFhSjdPKn60LlljFrH1/U6ZMY7MHpJC6+wS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783266; c=relaxed/simple;
	bh=IEOMRGsey5g89GTpMU+xeuE2TtiYItHnl8x2bcaJvag=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Utq2fNU7bPBd5zBRr4huntM6oPxyV/3wiatG0ZxVD8uoYXGdfU07h0gNHMXYRIbXbE80oKM1J+BzmXM64j3IRAqlxWPTn/MVf+y9kvnByRhaEJTFcPS5GMz91YnMNEMJNs881AKsUZPPFKS/mSQlklVw2gPK0OXqAC8Csi56bLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQlxI+O7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQlxI+O7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC48C1F0089B
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790783262;
	bh=e6J3Iiwlh9RzePAilhxW+yiVpnM7EpZsmSr8DX2vPLg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ZQlxI+O7uW0BdDRizpg6gB6raT+i94y3oC6XtuigEgHOS5XHTu49rNXaEl6FGh35S
	 2LFlfsInWCs1jzem3j1pZysL7pHWnKUHZZ27/oJKQ5SNxlJixrUgCsTEFvkSgxaPEs
	 NL+Z/spspjjGlkHJI4Q9gj6pW0yxw+CaJU0rIDsaDbjN1j4bkn4U8MHzc+6c03uLA0
	 /ofXiRW/T9Rmmz7ZRu1Jr0PrV9hmjuy51fYCQlhB+RjRFbZQxHDOV97Zl7d+Fygb3n
	 sFI6P7ar0cvqbNaNI0HnZ4znXVKzw/7V1O2eUsJb8vQxTpSMpz+5ZeW1lgvdi8oDnQ
	 vVoEvVeY+tVAw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: remove pointless qgroup assignment in block_rsv_release_bytes()
Date: Wed, 30 Sep 2026 16:47:36 +0100
Message-ID: <96ac7f9f3c72adaa2ee1922b2f3cc0663f59e166.1790783086.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790783086.git.fdmanana@suse.com>
References: <cover.1790783086.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If num_bytes == (u64)-1, there's no point to set qgroup_to_release to
block_rsv->qgroup_rsv_size as later on we will overwrite that value
without ever reading the variable before that. So simplify things and
remove that assignment.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-rsv.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 55e84ff0932e..fd604631b9ca 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -111,10 +111,8 @@ static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 	u64 ret;
 
 	spin_lock(&block_rsv->lock);
-	if (num_bytes == (u64)-1) {
+	if (num_bytes == (u64)-1)
 		num_bytes = block_rsv->size;
-		qgroup_to_release = block_rsv->qgroup_rsv_size;
-	}
 	block_rsv->size -= num_bytes;
 	if (block_rsv->reserved >= block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
@@ -128,8 +126,6 @@ static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 		qgroup_to_release = block_rsv->qgroup_rsv_reserved -
 				    block_rsv->qgroup_rsv_size;
 		block_rsv->qgroup_rsv_reserved = block_rsv->qgroup_rsv_size;
-	} else {
-		qgroup_to_release = 0;
 	}
 	spin_unlock(&block_rsv->lock);
 
-- 
2.47.2

