Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4102B3BE641;
	Wed, 19 Aug 2026 02:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787108120; cv=none; b=RYucpQ3VvSNNpG3+oXXjkMte8YJUQRkI/g/LkuIFxzCMWvTmmx0nx/t0/0xeZpv6doL4YI/YHolT29XQdlIJSvPXUOxulBxRPyL9wCj8NlpgYbCMsg4+ccXYSwY40CGj6D9D9g/RfJ9Pk1xYx0ZFhSxy9nvjGI5sUZQo73iOjKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787108120; c=relaxed/simple;
	bh=/BZgphADD4jkk8+IowTObDmG06/OV4sjdSe/OvZCrdA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TkOE0eflpoJTdYduuZDtQhe0OknapJkJeVHM+jQYXtnosC9iqOtzrXMSSN7conYPgCkNv6U9anp0KV8yFcXznMxGpXT6lOthC1oYE+ELOC3fA8XgMDmK3tQNbUEF93IrUwfM86XzjU3olpU8PdCs4663+Jfwrkn4bSjSD2An3/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dxaSs4gO; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dxaSs4gO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=aj
	+mMzto6/ld+2zss3dyiMGrXhj8aEFPW/OOLgnTdpc=; b=dxaSs4gOhftOEp5f7F
	3YhPhb65/10CoDjXbG1wZPEVSwF5XSSIG1YSFnz3xdccJoFF6KUu0zAfYiaT0gb8
	ahSGFxAO4r5d10Q23OyV1qRwWWuHCTQwJ4MYJAZZuGMKcSdSVQgq9muCr7aP9INd
	beaT7Zt6+f+yTnIf7g3xvXvDo=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAnxADwGoVqdX4FMA--.6093S5;
	Wed, 19 Aug 2026 10:54:57 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com
Cc: quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH v3 3/5] btrfs: unlock inode and extent in caller when uring read extent fails
Date: Wed, 19 Aug 2026 10:54:34 +0800
Message-Id: <20260819025436.1949152-4-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:PSgvCgAnxADwGoVqdX4FMA--.6093S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr1UWry3ZF45Zw4rArW5Wrg_yoW8tw4kpr
	47Aas8JayDJryqgFykKw4ku34fKa1kJay7JrZ5Jw4fA3WDtrn3KFyIk3WqkF1ktFW8XF90
	qr4Y934DZw47AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jpg4fUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QHCU2qFGwHIHQAA3Z

btrfs_uring_read_extent() runs only after btrfs_encoded_read() has
taken the inode shared lock and the extent lock.  On failure it used to
unlock in out_fail, and a pages-array allocation failure returned
-ENOMEM without unlocking at all.

Unlock in the caller instead on all failure returns, matching the
copy_to_user() error path.  The deferred -EIOCBQUEUED path still unlocks
in btrfs_uring_read_finished().

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 fs/btrfs/ioctl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 39bd9788e895..8f598b134bc1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4552,7 +4552,7 @@ static void btrfs_uring_read_finished(struct io_tw_req tw_req, io_tw_token_t tw)
 	size_t page_offset;
 	ssize_t ret;
 
-	/* The inode lock has already been acquired in btrfs_uring_read_extent.  */
+	/* The inode lock has already been acquired in btrfs_encoded_read(). */
 	btrfs_lockdep_inode_acquire(inode, i_rwsem);
 
 	if (priv->err) {
@@ -4618,7 +4618,6 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 				   struct iovec *iov, struct io_uring_cmd *cmd)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
-	struct extent_io_tree *io_tree = &inode->io_tree;
 	struct page **pages = NULL;
 	struct btrfs_uring_priv *priv = NULL;
 	unsigned long nr_pages;
@@ -4674,8 +4673,6 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	return -EIOCBQUEUED;
 
 out_fail:
-	btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
-	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	kfree(priv);
 	for (int i = 0; i < nr_pages; i++) {
 		if (pages[i])
@@ -4818,6 +4815,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 					      data->iov, cmd);
 		if (ret == -EIOCBQUEUED)
 			goto out_acct;
+		btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
+		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	}
 
 out_free:
-- 
2.25.1

