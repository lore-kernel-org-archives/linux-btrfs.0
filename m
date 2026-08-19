Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED5C3BBFB3;
	Wed, 19 Aug 2026 02:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787108125; cv=none; b=e+XzCU1N2/fSSmFi114t3pEuvk6+KdrUuNpVmM6FYaLcCbz3oUCaSmSQHqzt26R4YI40HC7YOPMj8cnrY+0qvjruNyf4Z9VQAuUsaDkidgyuAoIwhvbwCAjvdMFYW0ETpsgmGijJ7i/8S1hr0PsL7uzF5cbY+VrHihZ0EmI8bgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787108125; c=relaxed/simple;
	bh=mQGbTidsXkz5gEqMkC1FODgoiIv7JWHjwX9Kduy6JAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PVCcPon6TtyH9+OgWkF1oeHHd99wwNUbPOSf8PriBpO1vZgdgqqdQsEPAjO57FfTG9xz5EOEBZw+/IaWn+LxQ7ewimTNYeod9U62dmnZGsdshl66n31Y35yrD8yyz3AKucaVAXQXVtRlESq2PHMcOQmcpe7wd0n+/st3infUN+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lO4PvS7I; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lO4PvS7I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=zw
	ie5MIiKsfTJcQ8M/C1jwNTrLucZS70F4r+26+ZkU4=; b=lO4PvS7IPalq3acv9+
	S/gUWGIKlzK4KRYyR3V4vd/zzDPSjFwmChoGBxny3Y3GrOBUcwQNChT6rftMRocE
	O2B0ghVUeFzTwuZqYr6TzfN34bJoIXYemFlzQYAHcReDqRgzYBPg5BgFDQTKNiVs
	pSg5zQ1KWxCWpOr5hhZL5965Q=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAnxADwGoVqdX4FMA--.6093S6;
	Wed, 19 Aug 2026 10:54:58 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com
Cc: quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v3 4/5] btrfs: don't stash uring encoded data across -EAGAIN
Date: Wed, 19 Aug 2026 10:54:35 +0800
Message-Id: <20260819025436.1949152-5-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:PSgvCgAnxADwGoVqdX4FMA--.6093S6
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF1rZrW5ZryfKF47Jw43ZFb_yoW8KF4kpr
	WYkF98trW5Arn7JF95JFs5GFWF9395tw47C3y3ArWxAryayrn8ta4I9w1Fkr10kFyktFyj
	vay2qa98Cw4qyaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4XdUUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgLCU2qFGwLPaAAA3A

Returning -EAGAIN while leaving btrfs_uring_encoded_data in the cmd PDU
leaks if the request is cancelled or the ring exits before reissue.
io_uring does not free driver PDU allocations on cleanup.

Write: io_queue_sqe() always issues with IO_URING_F_NONBLOCK first, so
return -EAGAIN before allocating and free data on every exit.

Read: free on nowait -EAGAIN too; only -EIOCBQUEUED keeps the
allocation for btrfs_uring_read_finished().

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Fixes: e32dcdb0af9f ("btrfs: add io_uring interface for encoded writes")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 fs/btrfs/ioctl.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8f598b134bc1..a3ca15901cde 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4785,7 +4785,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 	ret = btrfs_encoded_read(&kiocb, &data->iter, &data->args, &cached_state,
 				 &disk_bytenr, &disk_io_size);
 	if (ret == -EAGAIN)
-		goto out_acct;
+		goto out_free;
 	if (ret < 0 && ret != -EIOCBQUEUED)
 		goto out_free;
 
@@ -4827,8 +4827,10 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 		add_rchar(current, ret);
 	inc_syscr(current);
 
-	if (ret != -EIOCBQUEUED && ret != -EAGAIN)
+	if (ret != -EIOCBQUEUED) {
 		kfree(data);
+		bc->data = NULL;
+	}
 
 	return ret;
 }
@@ -4857,6 +4859,11 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 		goto out_acct;
 	}
 
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		ret = -EAGAIN;
+		goto out_acct;
+	}
+
 	if (!data) {
 		data = kzalloc_obj(*data, GFP_NOFS);
 		if (!data) {
@@ -4925,11 +4932,6 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 		}
 	}
 
-	if (issue_flags & IO_URING_F_NONBLOCK) {
-		ret = -EAGAIN;
-		goto out_acct;
-	}
-
 	pos = data->args.offset;
 	ret = rw_verify_area(WRITE, file, &pos, data->args.len);
 	if (ret < 0)
@@ -4955,8 +4957,8 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 		add_wchar(current, ret);
 	inc_syscw(current);
 
-	if (ret != -EAGAIN)
-		kfree(data);
+	kfree(data);
+	bc->data = NULL;
 	return ret;
 }
 
-- 
2.25.1

