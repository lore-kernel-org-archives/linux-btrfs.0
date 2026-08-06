Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7DF3DDAFD;
	Thu,  6 Aug 2026 08:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006298; cv=none; b=k171eYxwqq98wcdGdty7Ld9tTAfxC2uSM2IUxZTgcnY3TAuoe6tPsosnNrXgAS43193rDhRA60gvwUT+90acCbrEU+iVvkmKJa6lwl8rBeBjw6M6In1q+pE1VTNoac4O08mpIF7lMwUp/yS+zlHHru5HPpHlpA893kHy0nNQShM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006298; c=relaxed/simple;
	bh=OMVgJ4Xdw0JHvZYd1QbVV/IrRfTrplrOtOhOa58KW64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HwYxuJRXSaixYL6rZftqhHz6dMOYbbR2p0RW6EpXeIslvoIsdQXDp2erRHW9xv+vJpfoL1UZhLuzbXb7LYxkasQNOGy3oonVJ3Md2BH2961VKkfg2/5YO9IpwcJkgR5f1on7tQ+jpyKPX8Z9p4JMBFM9HqgNouwdvRibTJaTXtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XHVQN7ak; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XHVQN7ak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Mu
	Pq1XQTtCjXHAH64tPDFXn9oXPOY+WqiHnIU4tJGtA=; b=XHVQN7akmiJ51P4zz5
	+pa0UJoQvSDgndJKmODWlT7IzY+3lkq+VxrMDByf8XkcTtM+scjLpvU+f7LgkWHF
	dHO2lj4+sajLUUtvf2UsBCWCYI26dSxMH+Ie8gNg5raZkvN2SKG8z0G78KA49jSB
	J8jSdLfx3Mw+p0G3obm+eZQQY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDXGqvjSnRqmYLmMA--.78S8;
	Thu, 06 Aug 2026 16:50:56 +0800 (CST)
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
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2 6/7] btrfs: don't stash uring encoded data across -EAGAIN
Date: Thu,  6 Aug 2026 16:50:40 +0800
Message-Id: <20260806085041.1410576-7-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wDXGqvjSnRqmYLmMA--.78S8
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF1rZrW5ZryfKF47Jw43ZFb_yoW8KF4kpr
	WYkF98trW5Arn7JF95JFs5GFWFg395ta17C3y3ArWxAryayFn8ta4S9w1rKr10kFy0yFyj
	vF4aga98Cw1qyaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5xhLUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwhCGF2p0SvB8xgAA3d

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
index b576887469bb..995a84ca86b7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4790,7 +4790,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 	ret = btrfs_encoded_read(&kiocb, &data->iter, &data->args, &cached_state,
 				 &disk_bytenr, &disk_io_size);
 	if (ret == -EAGAIN)
-		goto out_acct;
+		goto out_free;
 	if (ret < 0 && ret != -EIOCBQUEUED)
 		goto out_free;
 
@@ -4832,8 +4832,10 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 		add_rchar(current, ret);
 	inc_syscr(current);
 
-	if (ret != -EIOCBQUEUED && ret != -EAGAIN)
+	if (ret != -EIOCBQUEUED) {
 		kfree(data);
+		bc->data = NULL;
+	}
 
 	return ret;
 }
@@ -4862,6 +4864,11 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
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
@@ -4931,11 +4938,6 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
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
@@ -4961,8 +4963,8 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
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

