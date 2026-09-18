Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE38147124B
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789752473; cv=none; b=Yff0hz6vGMSppc344Is/1PWjQtPkUD7v9nfOQlk03B2zefZD0cyRn6606FyavJ//3E/jj8evASeUrFNKjTUnbvbOLFoGUdnrrCDI1IeMMPs4DvHT1IQ6p+g1UO3vbFSnfZR4wsPk1E9nccwTvl8o4ZikgIl6NjmkwoPvQJwKOjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789752473; c=relaxed/simple;
	bh=NVWoo9QpujHWvM+0n3IKiNFUxDa22fA9HS++0gMwSu4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEd18qcIQ5O0sbogUhg+eSqm3Fnp6EhwhE8dLHqgYxsay00gJxjn1GwA3tTdft+GnSKcGbBkowYLTagPbXQH+ktQXcwg5Pp06b1tyDJMrC9Ki9baVKNl3fthosIeQ2HPUMeWFUjdPZq7zWNQbZyFMaXW5IEeJq8Ko3NC+aaa/Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IawtY5nj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IawtY5nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BC91F000FF
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789752468;
	bh=zG++MvJ/9sR/iHroQMF5ruDso3LBMZh2yRlFcSVE8nE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=IawtY5njcvaejrYbv27mUqIleBXNfcAh3azKeG97OzXh7XhNWVYEttHoXSgGhJZoo
	 8vw8pV0nB2Wq0FMROvZcs8WMAPnC8uoNsWmqaWD0Idx5l9Tkz09bEGyJFMn82nTDht
	 3REJ2rvMgYd0Wadp+QQ/T1S3Ur3SyOy8TKwI/2Co1rKiKHI382x0ZTkelmKfWRoZb4
	 /2fT9PYXJYuinL+UFwK38LMiH0XCD8shO0Shb6UBlO/oXM+ZaAh9CxSrmCP91paizQ
	 d0A591y25GWWWvilfTOEbiyjyvkce6bNzgRpdyz3te6WIi5CcW/rFG0fNPgOoHraPZ
	 jauZtI3ls7u4Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()
Date: Fri, 18 Sep 2026 18:27:45 +0100
Message-ID: <72339bf1ef0db3133efd882eca2ef8644e675981.1789752327.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <d2bc9a10e82d87166dbd60797a93a69560f02411.1789750133.git.fdmanana@suse.com>
References: <d2bc9a10e82d87166dbd60797a93a69560f02411.1789750133.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If in btrfs_tree_mod_log_insert_root() there is an error in the call to
tree_mod_log_insert() (the only possible error is -EEXIST, which means we
have a bug or some memory corruption maybe) we free all the nodes in the
'tm_list' array but we don't remove them from the tree-mod-log rbtree,
which can result in use-after-free bugs later.

So make sure we remove the nodes from the rbtree before freeing them after
an error.

Fixes: 5de865eebb83 ("Btrfs: fix tree mod logging")
Assisted-by: LLM (found the bug)
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Fix racy removal from rbtree on error (not holding the lock
    fs_info->tree_mod_log_lock).

 fs/btrfs/tree-mod-log.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-mod-log.c b/fs/btrfs/tree-mod-log.c
index a8094928f4c9..9536ab0449e0 100644
--- a/fs/btrfs/tree-mod-log.c
+++ b/fs/btrfs/tree-mod-log.c
@@ -483,10 +483,17 @@ int btrfs_tree_mod_log_insert_root(struct extent_buffer *old_root,
 		goto out_unlock;
 	}
 
-	if (tm_list)
+	if (tm_list) {
 		ret = tree_mod_log_free_eb(fs_info, tm_list, nritems);
-	if (!ret)
-		ret = tree_mod_log_insert(fs_info, tm);
+		if (ret)
+			goto free_tms;
+	}
+
+	ret = tree_mod_log_insert(fs_info, tm);
+	if (ret && tm_list) {
+		for (i = 0; i < nritems; i++)
+			rb_erase(&tm_list[i]->node, &fs_info->tree_mod_log);
+	}
 
 out_unlock:
 	write_unlock(&fs_info->tree_mod_log_lock);
-- 
2.47.2

