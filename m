Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A683B9931;
	Wed, 19 Aug 2026 02:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787108120; cv=none; b=EX5U0XU66VNQqSsNPvoIXcagsWApyWJby0M2y356LBenpVQUOY0mTSgO4jWHcAO9+kO0pOcCp7D+jn/T+hxr0CNRQlEPvuHPBUqgB54X9FoiLKV4C4QDeNBXQPoEjIjfL/yopgc8+DTU6J9AEqRYIFp5HJoEN9+96nrN5L3Af0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787108120; c=relaxed/simple;
	bh=aHEdygA6UDl9EN6GgVbWj6yXeBMvUZ+SEfQh8J759vw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UAtn+IG52TQ3ho7TVOgNGefjy3riqLL1SSC/KK3tjX7ByehcJE5p0tKUK8oQKHfNhh+YG5vVUjs+O2JgMete7fB8g2AVgoRT7NqzgB38CJpKU4OsDmJFUCJ+8GmJ6PScyU3zIiXYZLbe1BOpJYbazYtPbHVLHHTdOzhW8tttA00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AU9LMI+x; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AU9LMI+x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=cL
	qjdKVutnpDvxedL5etDmJF+DMGO7ULYf4G5b9DLyI=; b=AU9LMI+xUo/BW7LIac
	EwOujt1T97Uqr2dANJBVe9lXoc/IykEfhSK96D5F3Yg+YDV5/XxFapVmtiQpIxUH
	DG1uuL5TvmPqk5z0ZwNEm0B2aqAIY8zqJi7RB1a7c8jE8cs/4ANb3ik9XYgUdvJl
	CmXfI6J3IcKGOAqZWLcoKjebY=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAnxADwGoVqdX4FMA--.6093S4;
	Wed, 19 Aug 2026 10:54:56 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com
Cc: quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v3 2/5] btrfs: free iov when btrfs_uring_read_extent fails
Date: Wed, 19 Aug 2026 10:54:33 +0800
Message-Id: <20260819025436.1949152-3-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:PSgvCgAnxADwGoVqdX4FMA--.6093S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry5Cw13JFW3tFyxAr4xZwb_yoWfCrc_XF
	n7Z34vqw47JF17uw1jkrnYqrWYg39rur4xWr1fKFy7X34DJa4kuF1vyryIyr4Dur1Dur90
	qr9av34Ikr12kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUno7K7UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gDCU2qFGwD5MgAA3E

After btrfs_uring_read_extent(), the caller always jumped to out_acct.
That skips kfree(data->iov), which is only correct for -EIOCBQUEUED
where the deferred path owns the iov. On failure, fall through to
out_free instead.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index baa645e98812..39bd9788e895 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4816,8 +4816,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 					      cached_state, disk_bytenr, disk_io_size,
 					      count, data->args.compression,
 					      data->iov, cmd);
-
-		goto out_acct;
+		if (ret == -EIOCBQUEUED)
+			goto out_acct;
 	}
 
 out_free:
-- 
2.25.1

