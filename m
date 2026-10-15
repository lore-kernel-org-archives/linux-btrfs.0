Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F9149B1E8;
	Thu, 15 Oct 2026 06:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792047220; cv=none; b=J5WWBvbpd2qMjobcaoapfmTXgGE6LiVbgb/MjU/dA9KvXUyxvpbEPxNa3M80y3zOzNCm7JZSKtzb7OdBxmP0lc09HUujaQ2LH4nFUhamB0uvHtNj3/kqrjFBlmPck4MWiNpIxNY+zm/2BR/QP+YIKXy4JizCnet5jo3hYBTBgf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792047220; c=relaxed/simple;
	bh=u0zZLgjvMUtGeW/0Bear4a8EU0D1B8F9V3SruXJ2gpc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BZWqjKmJGG8k2+L24ofsxlZIWfFHru6iyKhqs1CDTwvu+Sy8zuEZCU/pVc/MBHKT9Zdtxv2T4j46m1MdsXg7AmZ2+ImBZK6VXxdrurZKz2lG7grUHHA5q6B7R6zWC/QpffuS7xXqi4lxB3aOObShsOdABbWXpY0HVCg2ByZj9Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=ZoikVs21; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="ZoikVs21"
Received: from localhost (gyproxy-mailtls3-entmail-gy2-virt38.gy.ntes [IPV6:2409:8d28:39:f54:403e:4083:f623:91af])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5120e68e6;
	Thu, 15 Oct 2026 14:53:23 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()
Date: Thu, 15 Oct 2026 06:53:19 +0000
Message-Id: <20261015065319.3246988-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa13e56427f03a2kunmf9a1bd3266560
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDQh1LVh4dTExNHUJPQkgYTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSEJBHU5PQU9LSB5BT0tDSEEdTUlIQUJKGh
	1ZV1kWGg8SFR0UWUFZT0tIVUpLSEpMTUNVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=ZoikVs210S/dlXHvN9NqlAIz9Aw9YB7ONCTVlziDxqcmKdfQtqFb7Id6F+OaOs48skYBXwXeTkP/wQJj6jCg3qwIHJUUfPEHRt34cHLMfsWZy3ZZllcrrca2mcWHZ7aFvo678nrCE4k4G0SUPZgWHzD/UTMg1hp/pAclVdNgpGA=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=rzY09oL3yGajClh+vhdmj/YIWUtz4T+eXn2BSYITCzg=;
	h=date:mime-version:subject:message-id:from;

btrfs_sysfs_add_block_group_type() sets up a NOFS context with
memalloc_nofs_save() because kobject_add() performs GFP_KERNEL
allocations deep in its call chain, and the function may be called
while holding a transaction handle or a lock required for a
transaction commit, where reclaim could deadlock.

Every other return path of this function calls memalloc_nofs_restore()
except the early return taken when another thread has already created
the kobject for the same raid index (this can happen when restriping).
Taking that path leaves PF_MEMALLOC_NOFS set on the calling task, so
all subsequent memory allocations performed by that task remain
restricted to the NOFS scope, which may lead to unexpected allocation
failures or deadlocks later on.

Restore the NOFS context before returning from that path.

Fixes: 49ea112da0e6 ("btrfs: do not create raid sysfs entries under any locks")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/btrfs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 39cb01ee441a..71b1ec6c0643 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1857,6 +1857,7 @@ void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache)
 	if (space_info->block_group_kobjs[index]) {
 		spin_unlock(&space_info->lock);
 		kobject_put(&rkobj->kobj);
+		memalloc_nofs_restore(nofs_flag);
 		return;
 	} else {
 		space_info->block_group_kobjs[index] = &rkobj->kobj;
-- 
2.34.1

