Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D2413777E
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 04:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781582715; cv=none; b=jGYHUNVAtuJD8UKvw3nxhMWXg+ZNmzbGM/rSMUJudWbNhvPO8X4kykSOtu+hbWLytoiZwauBeTCE8q+HjT6IpCynSp2yj1c4lNhpTzRi8gByt/UkoSFgkxn3PN7JiaIXJXyBcMFZBT+kLM1VvNrzg+5ZJhtEk2albDnpLltVPkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781582715; c=relaxed/simple;
	bh=sYOF7LmfSzGyTWSpAWadhLQL8Ep4SkivHEeaEEXhgB0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=idSU2c8GjS9AGSpHDTE4OWSGhAAuEWommE39y/GPFGvP4y97s8oAmEHFyznclIKFmy51DCKdsuLK+GiU8Z41YgrmE9lOGbINJungm7A9K3/G6w2SnjO+Oaz1i+K2wRNJHXI7a+X8a4kVijl/qDuHB8fGV61WheREBdMqEw8CjcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=rQDstJ80; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="rQDstJ80"
Received: from 97097ad21e24 (unknown [10.17.41.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4gfYKr50fxzK6Xy7S;
	Tue, 16 Jun 2026 12:05:04 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1781582705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1rGketJSqzxbJJknv/7uq+PSOiH+QwDQxiCWkp228BM=;
	b=rQDstJ80O97+eB8D+Pc4aWXrsif0uHVGh5Al6VtX/jtCdrp8lhOufJp+Ju7h58diiXeDRY
	6ga0m64jOTDc3JbW2Pe4jHkc8x5MVQhRsmq1QBbd5YIeqiEwesEClsFavqd5qneB8xS0E2
	qOJdxBU26YeiV3FRoqxWsf+N09rXUOs=
From: You-Kai Zheng <ykzheng@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: You-Kai Zheng <ykzheng@synology.com>
Subject: [PATCH] btrfs-progs: re-enable tree search v2 ioctl
Date: Tue, 16 Jun 2026 12:04:26 +0800
Message-ID: <20260616040426.1920745-1-ykzheng@synology.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Auth: pass
Content-Type: text/plain

Commit d73e69824854 ("btrfs-progs: temporarily disable usage of v2 of
search tree ioctl") turned off TREE_SEARCH_V2 detection because it led
to an infinite loop in load_chunk_info() (reachable via 'btrfs
filesystem usage', reproducible by mkfs-tests/001): from the second
item in the returned buffer the data read back as all zeros while
nr_items was non-zero, so the search key never advanced.

The root cause was not the kernel ioctl but the user space accessor
btrfs_tree_search_data(): args2.buf is declared __u64[], so adding the
byte offset to it advanced the pointer by 8 bytes per unit. The first
item at offset 0 happened to be correct, but every subsequent item
pointed past the valid data and read zeros, which fed a zeroed key
back into the search and spun forever.

Fix the accessor by casting args2.buf to a char pointer before adding
the offset, and restore the tree search autodetection so callers use
the v2 ioctl when supported.

Tested on Linux 7.1.0; the whole mkfs-tests group passes with the v2
ioctl enabled.

Signed-off-by: You-Kai Zheng <ykzheng@synology.com>
---
 common/fsfeatures.c  | 6 ------
 common/tree-search.h | 2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/common/fsfeatures.c b/common/fsfeatures.c
index 2b19bd6e..9dcd237e 100644
--- a/common/fsfeatures.c
+++ b/common/fsfeatures.c
@@ -708,14 +708,8 @@ int btrfs_tree_search_ioctl(int fd, struct btrfs_tree_search_args *sa)
 {
 	/* On first use check the supported status and save it. */
 	if (!tree_search_v2_initialized) {
-#if 0
-		/*
-		 * Keep using v1 until v2 is fully tested, in some cases it
-		 * does not return properly formatted results in the buffer.
-		 */
 		if (btrfs_tree_search2_ioctl_supported(fd) == 1)
 			tree_search_v2_supported = true;
-#endif
 		tree_search_v2_initialized = true;
 	}
 	sa->use_v2 = tree_search_v2_supported;
diff --git a/common/tree-search.h b/common/tree-search.h
index 35eecbe0..1e2fd5cd 100644
--- a/common/tree-search.h
+++ b/common/tree-search.h
@@ -27,7 +27,7 @@ static inline struct btrfs_ioctl_search_key *btrfs_tree_search_sk(struct btrfs_t
 
 static inline void *btrfs_tree_search_data(struct btrfs_tree_search_args *sa, unsigned long offset) {
 	if (sa->use_v2)
-		return (void *)(sa->args2.buf + offset);
+		return (void *)((char *)sa->args2.buf + offset);
 	return (void *)(sa->args1.buf + offset);
 }
 
-- 
2.54.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
