Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205C340F8C3
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541919; cv=none; b=YBpY/JPgmNyVpA0H/+euLOk3OYt58NXXAIPkK4sOdJmcs368m9FtraFTLuVFPwHho+PUQvgvqW4T8Qh4pa4MUQYJ4YhIRmMC1LUCMT3HJWXi620yRQOhfX+06hTbK3KXD3jqgzDBo3Rw/BdSN0ZS3C7aoeVFYwlBMQfR2J/S2QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541919; c=relaxed/simple;
	bh=54z5lK5BqLSIXvhOuHIXNsn0yyxdwj/uHKziCi4oZ48=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BCrW9jO3qTLXGjp2nZAntKN66RUiNcoyG7S47Xnlc/L9h7Ot6PixfReITBDYZu3BcHnBdUXeDBTvw62bCj7zY7Ug0DKaZ7X2mvIV0LYLxnpjQV6iPADyrVBOAw+PNXMrnPzg34O39KiCeWcybp7ehuZ5X3aVk1Op6cVdvlKw5Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oS+HDsq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oS+HDsq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F0A1F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781541917;
	bh=wZ+Z4TYa/FtIUK0PKARuMPL8Ko1Ml6y9GHtbMPf5RGk=;
	h=From:To:Subject:Date;
	b=oS+HDsq5/yu7lB216T7VtuEM5WShdf5AYgL7MHz6TMFLOxRgEu2PhUIh8uZ4T7d0f
	 7S7MlpteoXJwTyjBSbTNYsc1O7P4RsdDALr8Pu3GYihU3FVdLFWmaWRZ+eLR5tt90S
	 CcIqAq+cGTPwMw3doYUPrqcUKuDIJyFDPAz5y6Z3pB1Yweu2ji+RPcUdwxVRtXahhe
	 qRnAV6T9VcdVS4OXe/bFI22CJo3KxUj+eMVZNV+FU1G7H02ntDdlAQS76xmzU/Jfvj
	 23TuJ1X3wuRxLiu/A6mMzFdBA6uQDOBQx9c7SIrFPpgyhACw9j3ApGsqfB7F6LuF3N
	 Ft2gy1xOs5yog==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: send: fix comment for SEND_MAX_DIR_UTIMES_CACHE_SIZE
Date: Mon, 15 Jun 2026 17:45:14 +0100
Message-ID: <6b47f0a447d1997cea8ef6e5dd6009a3df99fd33.1781541886.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The comment is wrong, because it's not about storing the ID of new
directories that were already created, instead it's about storing utimes
values for directories (both new and existing). The comment is wrong
because it was copy pasted from SEND_MAX_DIR_CREATED_CACHE_SIZE, but
forgot to update it afterwards.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3ae480c7474b..a3c8f2d889bb 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -130,10 +130,10 @@ static_assert(offsetof(struct backref_cache_entry, entry) == 0);
 #define SEND_MAX_DIR_CREATED_CACHE_SIZE			64
 
 /*
- * Max number of entries in the cache that stores directories that were already
- * created. The cache uses raw struct btrfs_lru_cache_entry entries, so it uses
- * at most 4096 bytes - sizeof(struct btrfs_lru_cache_entry) is 48 bytes, but
- * the kmalloc-64 slab is used, so we get 4096 bytes (64 bytes * 64).
+ * Max number of entries in the cache that stores utimes values for directories.
+ * The cache uses raw struct btrfs_lru_cache_entry entries, so it uses at most
+ * 4096 bytes - sizeof(struct btrfs_lru_cache_entry) is 48 bytes, but the
+ * kmalloc-64 slab is used, so we get 4096 bytes (64 bytes * 64).
  */
 #define SEND_MAX_DIR_UTIMES_CACHE_SIZE			64
 
-- 
2.47.2

