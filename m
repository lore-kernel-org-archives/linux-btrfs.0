Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B1A517BBB
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753576; cv=none; b=TMvnm3zDFDzlvF0/8M/p+xttF9ckusbouaOhuPPDw9iPMduuH1gxTdc/g0fm3yugxhYJgZeMhi0cPlLsCsKInPGiFcdEFnHHT6i9setvZljBzOPW3SVvZOSSrc5u904YAqU8Fjn3fVqfA25xr8U7VhkCeJ5T/+BgnNHEKvo0cTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753576; c=relaxed/simple;
	bh=hcon/4hy4+PTLCJ7yr/NsmQKW2c9Gv3oM0/lReuxC2U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3P7cJ69T3pxhPZ6UjO2zlrqSuA69efSQJQVEgULlgC1BSQ1nHxFsJxvybdqLi2NxQ37sqzSk0ZR9RvdseBJ0vhwXAwu2iQXR67OkZmCRH62ZNTOkCsZISx9ZD/bFDjwH8qCt8m2bx9IF4U8rdaUyTDiEwOODr62uBfGfacn+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxmtR2rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxmtR2rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371F51F000FF
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789753567;
	bh=fYNp7n04TPIi0UNMo1b3ULt7KGUcTwf1RegSfNFuxl4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=fxmtR2rhQ/KsKhQnU+FkExmP0e55F+39VFvDd/khVlUVX/Tp/ud3vcJSJ7rtcICg+
	 M+Nb68Yf0ZIgkmA6TmAsqmk+DfZgJqLy0Ng6nW+PcrP67lVf1fV9uRj+0AHjecrvZA
	 oBFvtFpoN8PuL5O6jjyCZlTr2r/ITfTu3yESGIUo7QagickDc4KOmjqz0Aemj3DNbU
	 hFjRZnkLnbfUfMoH/6cwFMfn9Kf8G3x6h6V2/EA/0qQlMxk1PsMi+40xglORjHyjuT
	 qsQGwHxsQD08JPGMZeibPJrVK2NyWyk+CuPrHff0L+llh3RRVGJVduBNGcy1y2GWxH
	 Ds6QB0VHgRDHg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()
Date: Fri, 18 Sep 2026 18:46:04 +0100
Message-ID: <e553cb89017b4e712b518b2e6ce4fb6f94b85a9d.1789753525.git.fdmanana@suse.com>
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

V3: Fix wrong label to jump on error (shashiko).

V2: Fix racy removal from rbtree on error (not holding the lock
    fs_info->tree_mod_log_lock).

 fs/btrfs/tree-mod-log.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-mod-log.c b/fs/btrfs/tree-mod-log.c
index a8094928f4c9..bfa348d6483f 100644
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
+			goto out_unlock;
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

