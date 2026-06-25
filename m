Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CB831F98E
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415226; cv=none; b=SIePYPn8LsTBtdNMtvk0xutwEOiZaGPqqnGg3nUvWJdZLPvrxLmORKEYCuQO6q5wgfVaJNWWiSED1mI0zq0LNIMsndiDejTmJp6qhcLVA5mSaziXLf18ATjVtQOOc3Jy05nDIE1LYHE2k1vd+CR1M6ncT1h7IbpVs0vDv7Xe/Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415226; c=relaxed/simple;
	bh=PZQydo4eltJYYKeQ/7M6hAnr56Zy/HQqCzwL/Llc+QA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qerZPZBw2ZDgjzuzWWGQ7ClJsJGEw3kNUtMsZDUKBbX8uFl11k0T/CLJW6VyrQFSS2DAmfuIAfYJXzIBGrKE0XS4VrbfxdMpOWZW7rEr7kju8DafQI34uvM+k+6DncTWHUZY7ORM4jzb6TX/drslrOw5yVcRJr0z+w4StNbysaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dghQSbAR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dghQSbAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5878F1F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782415225;
	bh=+5Zso770QEO0ndT4CicLZWfN3DMqgyERTgQ1Dzjj2ns=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=dghQSbARCBR8rhCbGDe/M83Ag00wbswykTl+/rRP8GGJclQQ420OAhfzB907VTBw3
	 yoxvcMQvyQ3ZYW/EMa95itilLdjEWuY820ZEwQLUY0QRl62X65yeCYUeqYZ0giZtv+
	 KewqsH0zRHAFcFViG5sgbk5kE0YjKsD7vn+CIHQuD6EiJDT/qBC07ZpsFnvVygb+hg
	 l6ZWFujOT9wrp9DJfby3rfiRsPZV9cwczns7fhc8Gh0ZPm1l+dk1mIOAHs5W3tLFGB
	 7YTRC282+zeHx7n3ZipPm5hfi6GZ8OZqayJLbTtN4GKiPEExTr5rVw3nRXIz6fCYcl
	 Z69zU20YwSveA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: defrag: remove pointless list_del_init() in defrag_one_cluster()
Date: Thu, 25 Jun 2026 20:20:16 +0100
Message-ID: <d8b39c1c786efa00d5de3d5ca999e23fcbc6c277.1782321584.git.fdmanana@suse.com>
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

There's no need to call list_del_init() against each entry when freeing
the list, as the list is local and we are freeing the entry.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/defrag.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7b3f779775a0..6ec5dd760d42 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -1319,10 +1319,8 @@ static int defrag_one_cluster(struct btrfs_inode *inode,
 				      inode->root->fs_info->sectorsize_bits;
 	}
 out:
-	list_for_each_entry_safe(entry, tmp, &target_list, list) {
-		list_del_init(&entry->list);
+	list_for_each_entry_safe(entry, tmp, &target_list, list)
 		kfree(entry);
-	}
 	if (ret >= 0)
 		*last_scanned_ret = max(*last_scanned_ret, start + len);
 	return ret;
-- 
2.47.2

