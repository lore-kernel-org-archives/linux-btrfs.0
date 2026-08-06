Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC30421232;
	Thu,  6 Aug 2026 08:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006289; cv=none; b=iWpFoZmyf8T5qeICRJfTUSdtYNwMNufMXra/yNZRadXGuzRJL0UL1UbGxPaksswwr9BZd2JH8OamqCEi5k2SmrMtOvs7FZfYxshwk+VGJHtpvW+9/iq/rRKsxTrpos1mzOghw0XseNaCrME7eT9rgezPqecnGw5fTF8Wyi7dxJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006289; c=relaxed/simple;
	bh=gpWbi5xPYbDTGiRvo7kfsl9oSrqaCRkkKyxw+el9dwI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XgiOldLwYG7/HfW4VD9AyOd4tnOIYUOEy5WdJI3VqKBPylnK6iZ5mLlpjIMUM3Z5D8vni8ApJ0Y5ipWTl12Tc2hUgNj7JusHY92hw9ksag8LspPPxtFFC+VsRXW5yUKaRg2pa4HhPLd7TDuEJFRXfFvM0F7y3tpbwSZBrungApY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=cCV/ETcx; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="cCV/ETcx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=m1
	izihZNpH3d0lIO2J5mhAqiK1WmzIkpLYnhLRiJBns=; b=cCV/ETcxNWQO2/A0Qg
	ODtRFsWvDOMyBAyIjwirIw0iz9wAAyf2OE/FDhXvT3LYFIjy1umVzU2HfGkERKXj
	qhZ10zJ3PMyLSooGqWYey2ZWjLKkwZgCmSUkj0RnAu/NzVAXnotvj9+quRVn3a6x
	ZoupuIjRARHK8KDeHwmeQ9opw=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDXGqvjSnRqmYLmMA--.78S2;
	Thu, 06 Aug 2026 16:50:47 +0800 (CST)
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
Subject: [PATCH v2 0/7] btrfs: fix io_uring encoded IO cleanup and compat
Date: Thu,  6 Aug 2026 16:50:34 +0800
Message-Id: <20260806085041.1410576-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXGqvjSnRqmYLmMA--.78S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xCw4kuF1fGF47WFyDJrb_yoW8AFy7pF
	W3CFW3tryDJwn7tFs3Ka1UCr1fXws7Jay7X392qw4fAF15AFyFvrWjkF9YgrykXFy8tayj
	qr1jqryq9w1UAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UD8nOUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgeDFGp0Sud8BwAA3a

Fixes for the io_uring ENCODED_READ / ENCODED_WRITE paths:

1. Fast bio completion could call endio and still return a negative
   errno, so the caller and btrfs_uring_read_finished() both cleaned
   up.  Always return -EIOCBQUEUED after endio.

   Link: https://lore.kernel.org/linux-btrfs/20260630091609.3414-1-samsun1006219@gmail.com/

2. btrfs_uring_read_extent() failure skipped kfree(data->iov).

3. SQPOLL / io-wq leave in_compat_syscall() false; export
   __import_iovec() and pass IO_URING_F_COMPAT for the iovec import.

4. Unlock inode/extent in the caller on read-extent failure, including
   the pages alloc -ENOMEM path.

5. Do not leave btrfs_uring_encoded_data in the cmd PDU across
   -EAGAIN (leak on cancel); drop the unused REISSUE restore.

v1: https://lore.kernel.org/linux-btrfs/20260805021135.1896609-1-yangxiuwei@kylinos.cn/

Changes in v2:
- unlock in the caller (Qu Wenruo)
- address further error-path issues raised on the v1 review
- export __import_iovec(); use IO_URING_F_COMPAT
- no PDU stash across -EAGAIN; drop REISSUE helpers

Testing: xfstests btrfs/333 passed.

Yang Xiuwei (7):
  btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
  btrfs: free iov when btrfs_uring_read_extent fails
  iov_iter: export __import_iovec
  btrfs: use IO_URING_F_COMPAT for uring encoded iovec import
  btrfs: unlock inode and extent in caller when uring read extent fails
  btrfs: don't stash uring encoded data across -EAGAIN
  btrfs: drop unused uring encoded IO REISSUE stash helpers

 fs/btrfs/inode.c |  7 +++---
 fs/btrfs/ioctl.c | 67 ++++++++++++++++++++++++++------------------------------
 lib/iov_iter.c   |  1 +
 3 files changed, 35 insertions(+), 40 deletions(-)

-- 
2.25.1

