Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E26B41F37D;
	Thu,  6 Aug 2026 08:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006292; cv=none; b=ST2XMcVeSI0HS+Ab1QbVTuCxwVnSiz3IoW7ITyojx7kulddvqxDREsyp9GInbpC8V3iAJ+xvkb6W1IC2oC5s16KDifY5yM2z/TpXSGJ6sde+rG0JKzk6GNAGmABIWx86rZYLewQxyssjusfFaxVvBhSVk6Z+J3Js1o/r7kHjWOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006292; c=relaxed/simple;
	bh=aHEdygA6UDl9EN6GgVbWj6yXeBMvUZ+SEfQh8J759vw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZYbyjbydh1XUweObAI9ca7SKATZLyADNZ4Xbf5yL90upDer1/hI5FlCbB6Ys7hm5AqX90RGU2PYeyqfq/RropNqrcaYUW2uyoATBcU20lyyMi2w6DIGccGEX0pDzlYYCE6GPqrHZ78gXUTLtwA8jUsNHJ79J8oSehgxbRrEzdOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FX0manjt; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FX0manjt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=cL
	qjdKVutnpDvxedL5etDmJF+DMGO7ULYf4G5b9DLyI=; b=FX0manjtV2rHTGgOoF
	jlEtTqbS30MhVx7DAIGp5AFuvbd6hmHx0KTFNgvvG6pJ288pl56/PPXU0yoYEdYA
	3IiXKvKho86BpV/nFA4zkApiQ7anbS/uqYV3vMfJ1+pQ8hsu9hqED9j1Luk6aADr
	5MLjw7r9hT/NXmsu1EDLXo7ok=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDXGqvjSnRqmYLmMA--.78S4;
	Thu, 06 Aug 2026 16:50:50 +0800 (CST)
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
Subject: [PATCH v2 2/7] btrfs: free iov when btrfs_uring_read_extent fails
Date: Thu,  6 Aug 2026 16:50:36 +0800
Message-Id: <20260806085041.1410576-3-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wDXGqvjSnRqmYLmMA--.78S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry5Cw13JFW3tFyxAr4xZwb_yoWfCrc_XF
	n7Z34vqw47JF17uw1jkrnYqrWYg39rur4xWr1fKFy7X34DJa4kuF1vyryIyr4Dur1Dur90
	qr9av34Ikr12kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0UEf5UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gqEFWp0SurdygAA3Y

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

