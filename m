Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A404908D1;
	Thu, 15 Oct 2026 07:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792048311; cv=none; b=kgGcJ4m5VOZa4gIWFkPo9WmuiQjMQTTKUGYBq8iSdhcsPN2jTZLLJx5awF/c/PlR22rJhKk7Ye8LQ/af8PWSZC36oCWQcQw87vKnnyO9bQbWsCovvD0a1yt7PSEpjm+XpwM2NMZi5eZRuSkbf83RUXoBd2uiiXqptEK8G3uek0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792048311; c=relaxed/simple;
	bh=GT7sDCXITABokia3XhC6ZU5UMtZeLtdIIOdtvJw/Zis=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e8r8HoH0cLHXX+bugNmJ9R5qqH/ool5tHM2RPD2ouTcl8F1uB3yd6BEZrpyLJ+Qn2yRZFCFb8wcch9z8B3llbNkX0dqgptRejk+6T20zK0sxupaqlWMqOPBWx0+g4kfdOAJRPFrTzXCzCwVID2hNezRuLujm3LmnPKaCEbdFABY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=anVGI1N3; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="anVGI1N3"
Received: from localhost (gyproxy-mailtls1-entmail-virt216.gy.ntes [IPV6:2409:8d28:39:f54:403e:4083:f623:91af])
	by smtp.qiye.163.com (Hmail) with ESMTP id 51223b4cd;
	Thu, 15 Oct 2026 15:11:31 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: verity: return error from btrfs_orphan_add in begin_enable_verity
Date: Thu, 15 Oct 2026 07:11:28 +0000
Message-Id: <20261015071128.3319350-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa13e66ddac03a2kunmfc98b02167272
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTB0dVhlNHRgaSR5NH0xISVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSEJBHU5PQU9LSB5BT0tDSEEdTUlIQUJKGh
	1ZV1kWGg8SFR0UWUFZT0tIVUpLSEpMTUNVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=anVGI1N3hZJXnN6IgGoSd37p7+HwZHVYh73JG5lG5XxrZxj44WtlE6CtxgG3Rq83nlA65nfqxwEidgKIoGDDmk2YITahUnzmOWq1HpIbRi+9s1Jp9jnXTlIihiza9f4AOm4Hn3n5WkZr7COklnQpJ7+ms+VQpbZzI9NJPDD+KMI=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=LYphTqGMrkmNiWbMOtzHMbORmjEVtNFv7ZLeMtQHIrM=;
	h=date:mime-version:subject:message-id:from;

btrfs_begin_enable_verity() ignores the return value of
btrfs_orphan_add() and unconditionally returns 0. When inserting the
orphan item fails (e.g. -ENOMEM), the error is swallowed and the
caller continues to build the Merkle tree even though the orphan item
was never written and BTRFS_INODE_VERITY_IN_PROGRESS was not set,
leaving the on-disk state inconsistent.

Propagate the error to the caller so that fsverity_ioctl_enable()
aborts before building the Merkle tree. The transaction is already
aborted inside btrfs_orphan_add() on failure and released by the
unconditional btrfs_end_transaction(), so only the return value needs
to change.

Fixes: 705242538ff3 ("btrfs: verity metadata orphan items")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/btrfs/verity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 600337a84fbe..d92c9dab0293 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -615,7 +615,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_end_transaction(trans);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.34.1

