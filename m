Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECEA421233;
	Thu,  6 Aug 2026 08:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006290; cv=none; b=b0U9K1Bqe8zbnims1AqmCrasWpUW7kyjDARF/H9GC8LebCRH8gAh5NEGf+sqWwRJzxIcRMhA8og87tDRAqNkK9BFI7ZFT1tWOajK1uuhiewOthAQYubu+FgWX6BvE9JAx5+eJyAzvTRaw6xtoLSNO2n/1lyLcCmyLM3b8pmZ5AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006290; c=relaxed/simple;
	bh=R0lpckM8RKENJYnuAnbrhZvptfzXfB9rVWIi8QZot5E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mlrl4KfS2bVWQZ2hcr9HyMxENe7x2Zfe0Jbixlt7LIeqlhx1i6DdJcQAwv3L8TbhFn3+GcaV1JwUF7BJStBxHJQxubTPgnnRU2tshC25IMaC/qVaSwJ163pZyWobkBCt3BkegohQFkqeTnxLgBAD7FRTVsoHaJrWY/khqIId/ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NpDIqiNx; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NpDIqiNx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=+S
	DriBVNb4zmqpUefdRYPla2gQz0zANF5elW+NmMMJE=; b=NpDIqiNxHeZXju71Fm
	mSTdm9OtYdqrMRgfFCFUrFuyeDYZ9pai/8QFtKJHkzG9+9YQkIl5rumhU1ikBwE0
	hvoTs6XEe9maFzvPAWBcFghg5PKfX1uz64cg/3TOkdKD14OryaLbbTYrqdIxAUUX
	9NsXO+HMK7zHhxoKqQlm5ScbM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDXGqvjSnRqmYLmMA--.78S7;
	Thu, 06 Aug 2026 16:50:54 +0800 (CST)
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
Subject: [PATCH v2 5/7] btrfs: unlock inode and extent in caller when uring read extent fails
Date: Thu,  6 Aug 2026 16:50:39 +0800
Message-Id: <20260806085041.1410576-6-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wDXGqvjSnRqmYLmMA--.78S7
X-Coremail-Antispam: 1Uf129KBjvJXoWxJFy3tw1UZrW8KFW8Gw1kuFg_yoW5Wrykpr
	47Cas8tayDJ347WFykKw4Du34fKa1kJayUJrW5Xw4fA3Zrtr93Ka4IkF15KF1vgFW8JFyS
	qr4Y9w1DXw47AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5xhLUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6Q+FFmp0Su8ryAAA3t

btrfs_uring_read_extent() runs only after btrfs_encoded_read() has
taken the inode shared lock and the extent lock.  On failure it used to
unlock in out_fail, and a pages-array allocation failure returned
-ENOMEM without unlocking at all.

Unlock in the caller instead, matching the copy_to_user() error path.
out_fail only frees the local priv/pages allocations, and the pages
array failure joins that path.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 fs/btrfs/ioctl.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 939c4a9d47b6..b576887469bb 100644
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
@@ -4626,8 +4625,10 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 
 	nr_pages = DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
 	pages = kzalloc_objs(struct page *, nr_pages, GFP_NOFS);
-	if (!pages)
-		return -ENOMEM;
+	if (!pages) {
+		ret = -ENOMEM;
+		goto out_fail;
+	}
 	ret = btrfs_alloc_page_array(nr_pages, pages, GFP_NOFS);
 	if (ret) {
 		ret = -ENOMEM;
@@ -4674,12 +4675,12 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	return -EIOCBQUEUED;
 
 out_fail:
-	btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
-	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	kfree(priv);
-	for (int i = 0; i < nr_pages; i++) {
-		if (pages[i])
-			__free_page(pages[i]);
+	if (pages) {
+		for (int i = 0; i < nr_pages; i++) {
+			if (pages[i])
+				__free_page(pages[i]);
+		}
 	}
 	kfree(pages);
 	return ret;
@@ -4819,6 +4820,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 					      data->iov, cmd);
 		if (ret == -EIOCBQUEUED)
 			goto out_acct;
+		btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
+		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	}
 
 out_free:
-- 
2.25.1

