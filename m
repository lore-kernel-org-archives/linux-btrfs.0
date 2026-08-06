Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851E8421228;
	Thu,  6 Aug 2026 08:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006291; cv=none; b=LAcDl+GuMEwXsxkon7GPDCtmvaVoSALIQVULhRZdT4RaTCM7vblVWnIwgM8eNDGDO6dUz7TtPGGvYP/Di19lltuk7TMhL0bn2/mBneAzz7H4+fy3O9kbeY2IKnPQNaw+zSM04oza2QF0h37ZlLhg/kNaWQHMLRXw/6QHBSB0c30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006291; c=relaxed/simple;
	bh=UR6Q75kaIoRh0QC3MX6poxK17wa2d1T+dd6T+zwZwC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pu2BB12own0ekzNV49hVeHKQxxw0IkAUsqBOTrrQlzAARocg2kL9bxijJN2woVV8sv+G89yYVx9w7i8MKXVbR4j2kh/JP93WlSUswIyMbEyk/XlTiX6Yw4/kgkYvIjQTlgjF4iM8midiQ/E9QKuiV+tZPgwhw09V5idAWNxW0Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HpoWAvVR; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HpoWAvVR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ez
	9HrIE9e6r7XA5Om/8+sgqbjIrbte6YDzvu6Y22ZFc=; b=HpoWAvVR0XXnuUzMNG
	Ai0nzVtQ/D29s/CFAdKzoSzEM5WVtKLZE/ukEjpryCHXud8f7fxmS2LyZSgIfaiH
	5XhQoOeMzoTq2f5v4bXYIVswLnrzXLjyNOLoPmqaaKTmZ3O+B4Lv6s7LWf36H0zK
	QCDGeGQzKs2ynfSLldF4OzyCo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDXGqvjSnRqmYLmMA--.78S3;
	Thu, 06 Aug 2026 16:50:49 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Mark Harmstone <maharmstone@fb.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Yue Sun <samsun1006219@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 1/7] btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
Date: Thu,  6 Aug 2026 16:50:35 +0800
Message-Id: <20260806085041.1410576-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260806085041.1410576-1-yangxiuwei@kylinos.cn>
References: <20260806085041.1410576-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXGqvjSnRqmYLmMA--.78S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF4rCw13KF43JryDAw1xGrg_yoW8Ww4Dpr
	1DCFy5Gw4DA34vvFWkKa1qgFyfJa1kJa9rXFZYk3y3A3W7tFnIvryIkFyYgr1qqr97CrWY
	vrWY9ryDu3W7ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UK1v-UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QmEFWp0SukrVgAA3x

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

