Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2AF3B530A
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 02:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785895927; cv=none; b=aUuTCmtPsiP4pZQrch/EDcwTdhBg/sF1fH8eT7XhPF0V3not9JQ15yyUJVZ1ABELjfknDK345eZrwnVnK/B2Q5ktgUWTiwQ+Lli1Utm3533OM9tYFegpniMvr250xFu0+vpQR/xG++CzpHhgpVSYS0Mw7jpL3PSqGjTb3vfLVkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785895927; c=relaxed/simple;
	bh=UR6Q75kaIoRh0QC3MX6poxK17wa2d1T+dd6T+zwZwC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RYAST3Mkhq6hncN3bJhbCYmq5oBlZVQDytb3a5Es70kexSQZTl6Zz8/ZEZ43tGwpxTI4R1ZdLCbLTZIG8/Dg5gxgWTq/qFh2kgeSYlcagIypiRn0xo9HLi14EOP2UqLNJJyefGSlV0RQeaUhVwCGiYsbaHknatgankur+58ziiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=j/wuGvkv; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="j/wuGvkv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ez
	9HrIE9e6r7XA5Om/8+sgqbjIrbte6YDzvu6Y22ZFc=; b=j/wuGvkvgOP08iLxJK
	KLJyZfWCl8bAPOEWVIvfY2yEANFhdm+MP7dKlpXprTzEGTh1jMkBP1efyJh9k6le
	GV8pfU8r+G7zWKR3WGpQUVAgr77IrVbkoY1QrTAO1WBmIhZIvqj7RR+xZ5dSm1Q2
	a0+TY1WzzLT7oFlKRWCvj3k0Q=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDX3_LZm3JqukrpNA--.22607S4;
	Wed, 05 Aug 2026 10:11:42 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Mark Harmstone <maharmstone@fb.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Yue Sun <samsun1006219@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
Date: Wed,  5 Aug 2026 10:11:34 +0800
Message-Id: <20260805021135.1896609-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260805021135.1896609-1-yangxiuwei@kylinos.cn>
References: <20260805021135.1896609-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX3_LZm3JqukrpNA--.22607S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF4rCw13KF43JryDAw1xGrg_yoW8Ww4Dpr
	1DCFy5Gw4DA34vvFWkKa1qgFyfJa1kJa9rXFZYk3y3A3W7tFnIvryIkFyYgr1qqr97CrWY
	vrWY9ryDu3W7ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j42NtUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwh5V5Wpym9771wAA3d

If all bios finish before btrfs_encoded_read_regular_fill_pages()
returns, it calls btrfs_uring_read_extent_endio() and previously
returned the I/O status.  A negative errno then made
btrfs_uring_read_extent() unlock and free while
btrfs_uring_read_finished() did the same again.

Return -EIOCBQUEUED so only the deferred path cleans up.

Reported-by: Yue Sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/linux-btrfs/20260630091609.3414-1-samsun1006219@gmail.com/
Suggested-by: Jens Axboe <axboe@kernel.dk>
Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 fs/btrfs/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b446c3014b24..8e3cee3845e6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9411,7 +9411,6 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 	struct completion sync_reads;
 	unsigned long i = 0;
 	struct btrfs_bio *bbio;
-	int ret;
 
 	/*
 	 * Fast path for synchronous reads which completes in this call, io_uring
@@ -9458,10 +9457,10 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 
 	if (uring_ctx) {
 		if (refcount_dec_and_test(&priv->pending_refs)) {
-			ret = blk_status_to_errno(READ_ONCE(priv->status));
-			btrfs_uring_read_extent_endio(uring_ctx, ret);
+			int err = blk_status_to_errno(READ_ONCE(priv->status));
+
+			btrfs_uring_read_extent_endio(uring_ctx, err);
 			kfree(priv);
-			return ret;
 		}
 
 		return -EIOCBQUEUED;
-- 
2.25.1

