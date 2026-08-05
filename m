Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447F536308D
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 02:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785895922; cv=none; b=fagTUmbvH826S0vJmVyGXPQOXKfVn9X0gYVj/BKR+w4XblqkpdMgBL6++LadvqOeSrt3sOxfr+Y0u4Kjo3yiuL1FyU74KoD3n5caLU8YE985pBB2Yh/0YPrINK17BQRXG36fE+XcgnQFLWCIuKh2xYj7U/kVKoKTJO0m9nFnjUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785895922; c=relaxed/simple;
	bh=N++zADuD+ZZHfBsuJBy/+yyvah7D+eoaMBMe8HtIwwg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AeRcqySVi490EpGTD0QyQ/+PkOyHo7ppAvF48RXhew4aFy8mzKYEWWGPUL4dI7Q66ODtyEtdNY9zsVufPz/XbEQj56RiGKqWH6fJ34clR9GsZOZ+7XU1DKr/BMaEyqlVkIZrQXYqXrYjXhFHVZuZC3LFCwdYCiMUBeeEh5B8P8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=oni9HFL4; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="oni9HFL4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=rB
	FPlfEOVoaJAaDGc8aUuWIR4iDk1EDPl44C7tjYFZk=; b=oni9HFL4PtdZPDfAZa
	j8YTvMkkPjyYyeOJKi7i7R99wWvNOHmG1UAVE0gopS+sI0robooGlLD8W20vGo2M
	N0fyBf7izvgXVXCuE+pQDmcOdKeW4dOTNWmCJL3EjCzFM7VDuNCJt5rsoEZ7AdZN
	QgBSJx+T2Cwh1HggOrkAmBjto=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDX3_LZm3JqukrpNA--.22607S2;
	Wed, 05 Aug 2026 10:11:37 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Mark Harmstone <maharmstone@fb.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 0/3] btrfs: fix io_uring encoded read cleanup paths
Date: Wed,  5 Aug 2026 10:11:32 +0800
Message-Id: <20260805021135.1896609-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX3_LZm3JqukrpNA--.22607S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUCF4DXr1UCr4rKFyrCrg_yoWDWwb_WF
	1IvF98Xw12qan8JaykKr18XFW5Kw4j9F1Ygwn8KFW3ZFy7A3ykXr1kZw1kXw4rWa129rn8
	Wrn8A34rAw12vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8g18PUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRtU5Gpym9vvIgAA3-

Three related bugs in the io_uring ENCODED_READ path:

1. pages array allocation failure returned -ENOMEM without unlocking
   the inode and extent locks taken by btrfs_encoded_read().

2. If bios completed before fill_pages returned, endio already queued
   btrfs_uring_read_finished(), but a negative I/O status made the
   caller clean up as well.  This matches the GPF reported by Yue Sun;
   patch 2 follows Jens Axboe's suggestion.

   Link: https://lore.kernel.org/linux-btrfs/20260630091609.3414-1-samsun1006219@gmail.com/

3. After btrfs_uring_read_extent() failed, the caller skipped
   kfree(data->iov) by always jumping to out_acct.

Yang Xiuwei (3):
  btrfs: unlock inode and extent on pages alloc failure in uring read
  btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
  btrfs: free iov when btrfs_uring_read_extent fails

 fs/btrfs/inode.c |  7 +++----
 fs/btrfs/ioctl.c | 18 +++++++++++-------
 2 files changed, 14 insertions(+), 11 deletions(-)

-- 
2.25.1

