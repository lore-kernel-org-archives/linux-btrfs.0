Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3473BED78;
	Wed, 19 Aug 2026 02:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787108128; cv=none; b=LXON+sdW5XFUA6TkP57NOR0fGVvo0CA4NKd4UGWDq1LjOHmeG9d52+FY86pwV/spZTbuYHE7XWWSGNi8MJLbhqiXOzbGt8kVm6OZO+EjfsJy7lVqwTY5Xc0/Kd7X57bNwLpfR0nkpORVDSd4NFUMoy/nN2KAFdadmTL20nBF4V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787108128; c=relaxed/simple;
	bh=D5JuQ7vJqVz7NRi1nj/PV7wjmCra2OgrrADeOP3VOcg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CDv2zYqM/IXBv6iLtgMg802O+75OjFe2bdxLQCLV3k6gLyRAWbrT3h2wXQNZaIQ3TrZpwNCWCvcn9RgLbwnkpC/T7zhtRFdu0gHVohjcGzNJby12LOy0yMPm9IpsE7G6M+RmEAg7Gh8/mjfkqsX/RZrkpuW0N+iDkxhKeoUdcKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=A/trw8lJ; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="A/trw8lJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=vJ
	e25sw0PPC+oy1P/xAvly2o9RIIwnxGHexg4HkzKgg=; b=A/trw8lJUEIEE1XftH
	iYTEQf3ereoJmDU0AoVfhY+QxlcF1td3h4311uXPC3g8BpKpYjVZv/7DHDf+6wSs
	BlHI3vmJPMpBlOl71A/PK8yvzYwFrvp0vVR46+aJNPFl+woxiqq8dHVXWJ4pWL0g
	gKFoqxqCuBM9Uzt62RQibXgB8=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAnxADwGoVqdX4FMA--.6093S3;
	Wed, 19 Aug 2026 10:54:53 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com
Cc: quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Yue Sun <samsun1006219@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 1/5] btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
Date: Wed, 19 Aug 2026 10:54:32 +0800
Message-Id: <20260819025436.1949152-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
References: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAnxADwGoVqdX4FMA--.6093S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF4rCw13KF43JryDAw1xGrg_yoW8Ww4Dpr
	1DAFy5Gw4DJ3yvvFWkKa1qgFySyan7JFZrXFZYk3y3A3W7tFnIvryIkFyYqr1qqr97GrWY
	vrWY9ryDu3W7AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UKjgsUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwh3BUmqFGv3OvwAA31

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
index 2534cd9284d5..953fd85d6437 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9592,7 +9592,6 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 	struct completion sync_reads;
 	unsigned long i = 0;
 	struct btrfs_bio *bbio;
-	int ret;
 
 	/*
 	 * Fast path for synchronous reads which completes in this call, io_uring
@@ -9639,10 +9638,10 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 
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

