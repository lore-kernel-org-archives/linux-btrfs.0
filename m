Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBE830D3FB
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 02:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785895924; cv=none; b=RKhMJsjrIB91XxhTanjO9Ow2pPcRcsKBaQwOz9vtQq2DF/91hFdWpbMa5LNK1ryTetIusDXzMWMi+9bTUw80p69P6PD7AlPVb62CWm0BeoZ49JdazlLizdgWhbH12G5bCLytyLuxfot9Z4JD7d1mff8IV5PBiRXv2vHiSEHjJVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785895924; c=relaxed/simple;
	bh=1Rpz3oRsCiqQm/f0JB9kO9ufnaPBJiy3uKtIfCFgm4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uuRbZt7CB2PeF3hlMoR/7qQvE+qyItHBqoSA5f2VPAgivYfrNMTcFEQJxYYcLNQvd+DujQ5pG2A7QSK6xN4D4Rw0NGbxepF3Vfto0EcbVMWn86ivTv/3oID3v2YaypBb6iUreSFUqbGIjKtoCBpu6tcifTBoKD//AwcNZXbrKYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LdnfnIw7; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LdnfnIw7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=VT
	eb5cDTOZA36SRkx2dNb2t6N1V85UjFigzQuBISNws=; b=LdnfnIw7BR1MMLVihY
	4LHlVCEGawq0yk2y/xLktxn4h//hAXt9HOlCm+qlZw8eqBwvxUaTLtHLMLKZYXRI
	wbZVA0Q6eXUIImd3+qJwEdM68Ck5RFoQsxcjRqVDdb19f6S8ppQEIISdsuiVKbik
	j858KTuKL/W7zPU3inh7APmtY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDX3_LZm3JqukrpNA--.22607S3;
	Wed, 05 Aug 2026 10:11:40 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Mark Harmstone <maharmstone@fb.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 1/3] btrfs: unlock inode and extent on pages alloc failure in uring read
Date: Wed,  5 Aug 2026 10:11:33 +0800
Message-Id: <20260805021135.1896609-2-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wDX3_LZm3JqukrpNA--.22607S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kry8CF1fAw47GFWfWrWruFg_yoW8Xr4Upr
	4xC3s0kayDJ347XFyftF4q9r1fGa1DtayUCr9rZw4Sv3W7JrWSgFyxKa4UKF10gF97GFna
	qrs0vw1DXa12vFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jc0edUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwhxV5Wpym9z7rgAA3k

btrfs_uring_read_extent() is only reached after btrfs_encoded_read()
has taken the inode shared lock and the extent lock.  If allocating
the pages array fails it returned -ENOMEM directly and left both
locks held.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 fs/btrfs/ioctl.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 68b33f365fda..c953e4409d5b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4626,8 +4626,10 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 
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
@@ -4677,9 +4679,11 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
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
-- 
2.25.1

