Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6948431E84A
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415224; cv=none; b=GYoSubvGbozHG8bEz5afgCzyOApW5Mf5Tvviw15fuF1+L6c4Ci4Lk2dAAhhk9QFvQyFme86Vn6J8nblZzAvo6nteMzPKUE29cXLn2g/QH+kdeOy+HQ9r6h7h/8/aLneEaKZS2mu7kQJE6ro0v3Wzw/TLJwaE+0ZDZEHAOEid+70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415224; c=relaxed/simple;
	bh=yfysTt+oEZFkmMVD+GZQStI2ILxuYTAxWQ1SF+NBUFo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOmYCkZvco+tnDY7H+1/moVycZ8CN/WnfRacAdDcU7z4hS1TG1OYb8lPmsd/5CaySl4KvEXPPQ3+YEyJa9cEb8xfr94FUKTYcF8XZnbf5aelhgHZbtH62tlm+Zectj9Ak0PjBJ/ELdEdYrJPo3L+HpLJ/GfS75PLOkMg622xE+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1Wbu9n/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1Wbu9n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2421F00A3D
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782415223;
	bh=yrnhj0nX3zabXRSsYUNN25tuxSS6zsfhMEhEYy1BqUA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=o1Wbu9n/0iUOzJGZjqgJxZeae7+JTgN3iiyycaKyxieXJGPUQSjUtgsVr2CcUgbpX
	 glbprPtrsDLDHa3Km/XYrK4fvFpMT7XFOpGNtxxbEMcMHwv6DfFae0HE4qGGjQ3zB8
	 wZKANxys0BjozNpErUxMHWxVzualWau06TfQF9OR89I1Cn3MSuZS2emHqLY4iHukrU
	 hSL5tWxYTXwzFn8OQkLDY4EtXYMpWmtCjauAbqXY+q3CMlxo21W/h3hpskhMd165BC
	 eA2XDSwI6pWCpbbx4rszqpI5MWoU9Ir9aNtGG8hT3aU/UJd2lh3qSsZ2qwrTw2wPck
	 0n/q759wCK5iQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: defrag: use a single list for each loop in defrag_one_range()
Date: Thu, 25 Jun 2026 20:20:13 +0100
Message-ID: <20e1226097db10e92c2059cb5ce51205348362a7.1782321584.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1782321584.git.fdmanana@suse.com>
References: <cover.1782321584.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no need to have one list for each loop to defrag each subrange and
then another one to free each subrange (struct defrag_target_range).
We can do it in a single loop, freeing each subrange after defragging,
plus no need to delete each subrange from the list since we immediately
free it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/defrag.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 0697b285e05f..ad1d04d8f165 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -1234,16 +1234,12 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 	if (ret < 0)
 		goto unlock_extent;
 
-	list_for_each_entry(entry, &target_list, list) {
+	list_for_each_entry_safe(entry, tmp, &target_list, list) {
 		defrag_one_locked_target(inode, entry, folios, nr_pages, &cached_state);
 		if (entry->start > last_defrag_end)
 			btrfs_delalloc_release_space(inode, data_reserved, last_defrag_end,
 						     entry->start - last_defrag_end, true);
 		last_defrag_end = entry->start + entry->len;
-	}
-
-	list_for_each_entry_safe(entry, tmp, &target_list, list) {
-		list_del_init(&entry->list);
 		kfree(entry);
 	}
 unlock_extent:
-- 
2.47.2

