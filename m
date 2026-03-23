Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB502AD00
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 03:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774237465; cv=none; b=mmggzzNNQ4J64P+wxdseTNx187H1iP06uMCAIrCm5DJzm2+VIVr3f0PVSnJEbVTUQWr4K5TDoWMZbeHkezxXeaWz/B2h2bDZXUDeE7z0EC4WTvoj7QFbFAOIr53lh8SzUggMZL3xWbkQJ8kGY8+gsUsSbQDzDVdrDoSmKemNWJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774237465; c=relaxed/simple;
	bh=cTKcu7zPKYpyCfjuaYCQDWviogJqzqYlD3nGx70xww4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cjSfbGQIjvRZbDrYbM96To4Ia7vmSCQ6KSzwwvMs1Y347NPZZMmTxYN7ii0Po9ejKF0fjZ/4lL9/7I8QHsAl1pouNR25TsTGvgi2D/pRT4idk7GQ4UYI3jjrxVgBTx4k0U6wdSuU8Yd//R44X+eF0IMDJbdKNC7HvYfAaLJRSTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=iImZ81YN; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="iImZ81YN"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4ffJv33M3mzHVLpFC;
	Mon, 23 Mar 2026 11:44:15 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1774237455; bh=cTKcu7zPKYpyCfjuaYCQDWviogJqzqYlD3nGx70xww4=;
	h=From:To:Cc:Subject:Date;
	b=iImZ81YN4DpCt6WL7F4WDcwLyxaBH5dI3IN9ba6oZEzorRxlIm8Am9vbyFpSOO4ix
	 EuQtuivxM1yxt9z2jh9dKYEVwB7t6+7ojw45RoCOuGxPjAzzg3ZD67V1YSMDqHbrPj
	 PCLXRrUb/taWoj9GWTIh4jjuq1XKT5t/ihWaGhZ0=
From: Dave Chen <davechen@synology.com>
To: linux-btrfs@vger.kernel.org,
	dsterba@suse.com
Cc: cccheng@synology.com,
	robbieko@synology.com,
	Dave Chen <davechen@synology.com>
Subject: [PATCH] btrfs: fix unnecessary flush on close when truncating zero-sized files
Date: Mon, 23 Mar 2026 11:43:22 +0800
Message-ID: <20260323034322.105163-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
Content-Type: text/plain

In btrfs_setsize(), when a file is truncated to size 0, the
BTRFS_INODE_FLUSH_ON_CLOSE flag is unconditionally set to ensure
pending writes get flushed on close. This flag was designed to protect
the "truncate-then-rewrite" pattern, where an application truncates a
file with existing data down to zero and writes new content, ensuring
the new data reaches disk on close.

However, when a file already has a size of 0 (e.g., a newly created
file opened with O_CREAT | O_TRUNC), oldsize and newsize are both 0.
In this case, setting BTRFS_INODE_FLUSH_ON_CLOSE is unnecessary because
no "good data" was truncated away. The subsequent filemap_flush() in
btrfs_release_file() then triggers avoidable writeback that disrupts
the normal delayed writeback batching, adding I/O overhead.

Fixes: a41ad394a03b ("Btrfs: convert to the new truncate sequence")
Signed-off-by: Dave Chen <davechen@synology.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a6da98435ef7c..73902056c1c50 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5434,7 +5434,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		 * zero. Make sure any new writes to the file get on disk
 		 * on close.
 		 */
-		if (newsize == 0)
+		if (newsize == 0 && oldsize != 0)
 			set_bit(BTRFS_INODE_FLUSH_ON_CLOSE,
 				&BTRFS_I(inode)->runtime_flags);
 
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
