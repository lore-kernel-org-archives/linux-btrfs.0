Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D754E3DDDD1;
	Thu,  6 Aug 2026 08:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006300; cv=none; b=uTSpsNBiHbIkEBRJZtGSc3zS2QG+Jfb+JHu7ThkpYNSG/QGWpcbHEdnbe1Uufio6Um7hht+MSllqczfL7hxskK+WyDoQmJgz6xl0nfGXrT3GuOW1Ww9kR3y07onc1Z4s7zxjpNgwUFgRGoCLwAh7EVHFAODjX2XcG+Qp4iHn9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006300; c=relaxed/simple;
	bh=Im/Ms/iMEeJEid+fXr3LhiLKYI3NdybImUMBj7zpzG8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o+7g38Ba4ftkO7k4Dl86iATFjbIfhQxJHDlw/QkPnPA7xvVZMR3WiW0L6dh84p2pjwVJukvRDjplpFSm+oTfUFvfLut/rAG5qanJc7sqiDNaQbcYiih928cu791m8AfNSpnrrkn0ds1jMMngCs4VjjwDdyFSqQftngT1HitqqhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lRG4e1GF; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lRG4e1GF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=WG
	wqu3iaLyjczKS1gm1uSbNl8hnv5+61oZ8Rzt0KTtI=; b=lRG4e1GFlI2BwBUho8
	KXOYh37qfSqZ8HnUDfi/AV/INfITz3mAByIA6gjUYJ0gpNaaC8jBOe8SMWl3JG6x
	XmWA4/rwoyTNKi42cTWx1w/AkfaqLCypn5psQsyG62zPvS727V8Rc2WwC+7eQ+ak
	PR5UIE6ViofC4PxXXnZfezi4k=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDXGqvjSnRqmYLmMA--.78S6;
	Thu, 06 Aug 2026 16:50:53 +0800 (CST)
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
Subject: [PATCH v2 4/7] btrfs: use IO_URING_F_COMPAT for uring encoded iovec import
Date: Thu,  6 Aug 2026 16:50:38 +0800
Message-Id: <20260806085041.1410576-5-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wDXGqvjSnRqmYLmMA--.78S6
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF4xKr1DCFy3tw1fZF13urg_yoW8Cr4Dpr
	yYkr43JFWDArsFyrykAay09w18ursIkayDC34xAF1xJryYyryftr4xKas5KFy0yFWkA3WU
	tryjvr90yw4qvw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j53ktUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwg2FFmp0Su18iQAA3Q

The uring encoded paths select args32 from IO_URING_F_COMPAT, but then
call import_iovec() for the iovec array. import_iovec() keys off
in_compat_syscall(), which is false when first issued from SQPOLL or
io-wq, so a compat ring can misread the iovec list as native layout.

Pass the same IO_URING_F_COMPAT flag into __import_iovec() instead.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Fixes: e32dcdb0af9f ("btrfs: add io_uring interface for encoded writes")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 fs/btrfs/ioctl.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 39bd9788e895..939c4a9d47b6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4759,9 +4759,10 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 		}
 
 		data->iov = data->iovstack;
-		ret = import_iovec(ITER_DEST, data->args.iov, data->args.iovcnt,
-				   ARRAY_SIZE(data->iovstack), &data->iov,
-				   &data->iter);
+		ret = __import_iovec(ITER_DEST, data->args.iov, data->args.iovcnt,
+				     ARRAY_SIZE(data->iovstack), &data->iov,
+				     &data->iter,
+				     !!(issue_flags & IO_URING_F_COMPAT));
 		if (ret < 0)
 			goto out_acct;
 
@@ -4914,9 +4915,10 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 			goto out_acct;
 
 		data->iov = data->iovstack;
-		ret = import_iovec(ITER_SOURCE, data->args.iov, data->args.iovcnt,
-				   ARRAY_SIZE(data->iovstack), &data->iov,
-				   &data->iter);
+		ret = __import_iovec(ITER_SOURCE, data->args.iov, data->args.iovcnt,
+				     ARRAY_SIZE(data->iovstack), &data->iov,
+				     &data->iter,
+				     !!(issue_flags & IO_URING_F_COMPAT));
 		if (ret < 0)
 			goto out_acct;
 
-- 
2.25.1

