Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793205173;
	b=kcASJv05IpfHHGocG9QvafXesTnfGXEEfuWz6h0dW2Xc/sEqmsMeq/3puQ1uFlxCvWX4
	 Cpfalj96XyFi4BDUq3I+m9QVm+hdnb0sbOHBRSDu0CEd3XIlbtlR0b10jkNnWIb0qOk1G
	 YztQTXAKilZb4eX+jRUlOc42cTEIst2Z0Y2/q6fuTD81ILn9DXbhb3UweIaQ5nBKQE/jr
	 IXQEBIlpB15T5MSeLU1LLfQ2OXVKXbJZ2v6kjScr9ny2dznNOrruaCU1iQuE0ouSP/EF9
	 gE4xMU9syQ5UU9MbaiDsqZAQa5kCgT88Zu6r3uKM1H/pqi6T5O82cfCiHnaNLqXWXEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793205173;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MmcWHwwRgmDiWen8pYW+CbOrzjWxPRj5Cso+ewEcKgM=;
	b=LXppwKBVk98JHgpX3ilDvAWLG9OQiYBf06dyYRI/n68A6564ip3PgfkhHQrRhMBTHqEx
	 dtQUcpysZ90TNUr6e8Xc7EHdY+gNGCBZerLueSKpyplqHzJdY72c/3pfkmfI0lBFMrtaz
	 4hAVhuhD42e2Iaxb6yqbPNUNXtrRA92VjUz2gnWK9DAFkw3QORmEEdyO/dNGln4akT49S
	 0Q6o4R6y5KpUote8XzqLhAaKhwRPJTtB0p222fI+fUYpe3G74L7bITX+EeqbJ9hfMT8Zi
	 hCJaSvT7ONXmWZLliORe2ysoo4SxgzWPGs6pF6gGDVMc0Jrc+c2qv7llaGXx7DIorMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ih+tkfYY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B70B606A327
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ih+tkfYY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9301F1F01825
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793205173;
	bh=MmcWHwwRgmDiWen8pYW+CbOrzjWxPRj5Cso+ewEcKgM=;
	h=From:To:Subject:Date;
	b=ih+tkfYY5qY/DxQR9u4ZCC+Fm25dgaXKhrSnPynfTkA00Ndb+UEi9W+u9c16hvhiS
	 8fOmBptxRrsZdh9rfL6d7EspvaV3NIDm3QwXX1rz1f6evYlksArJ8mg3fBU6/VsfZp
	 oQvHZGo5N7RXXISw9F1P9NRihufzk3kulIH7FAw39VZIJVIMAw6dZPmTM9Lj5J6LFI
	 DrkGV3K/XjKBRgVcNFBPJn6xj7d7IPkJ/0yEd5DP2bZDxtuXNl1H8/EelMMsOOIN0T
	 EMl65EuQbkvSDb+vZo4Ur1gXMhfUjuJ7ZCVZ87v8RVqUZ0ilf2Yu2quG/TAV9bGirV
	 j2KDHi7rviw6w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: zstd: prevent leak of workspace below maximum level
Date: Wed, 28 Oct 2026 16:32:48 +0000
Message-ID: <c305694d12ec20fc431cffd4cc718efb1a3823d9.1793204767.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When putting a workspace we always protect the workspace for the maximum
level from reclaim, since it can be used not just for that level but as
well for any level below it. However the logic is flawed because if we do
the put for a workspace at level 10 for example (maximum is level 15) and
there is currently no idle workspace for the maximum level because all
are currently being used, we don't add the workspace to the lru list and
that can result in leaking it if we don't get more compression or
decompression requests for level 10 or any level below 10.

Fix this by skipping the addition to the lru list only if the level of
the workspace matches the maximum level too (besides the list of idle
workspaces for the maximum level being empty).

Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/zstd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 9235aa7b922e..b686f67d52ec 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -347,7 +347,8 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_info, struct list_head *ws)
 	/* A node is only taken off the lru if we are the corresponding level */
 	if (clip_level(workspace->req_level) == workspace->level) {
 		/* Hide a max level workspace from reclaim */
-		if (list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
+		if (workspace->level == ZSTD_BTRFS_MAX_LEVEL - 1 &&
+		    list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
 			INIT_LIST_HEAD(&workspace->lru_list);
 		} else {
 			workspace->last_used = jiffies;
-- 
2.53.0

