Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D869E39CCF6
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 02:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785895923; cv=none; b=YElm1qo0OgJjBwWUvYDMJ5ptVYFDYG2hOinImIVZuLL+2+G68isV1Fv91txftWefidI/hH01kuGw3zMcSTTINjJcEwg7ZsERaq/geyhjDLBakK9iI0V+ldrO1iNsh4g0M0JQmxv7oSmFUkrkrp3oLSxO9Qnpxj2BpbBzzsbpwlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785895923; c=relaxed/simple;
	bh=SN1nog+qoEPwwPpi4UnN7fnah3BrUQk2LwG7IgrJtfM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=InVzqg8C2Ve6xvmqotg2FrxDUpYcpwnVnmndNqtObB39LA15Oc1KuW/JrmAqlJXuDtJuY/qjXVJEJtAk03LlRFAyO7wJ9PYRPe7D7puyMwH5JKaUGXxh6gJvpjx7LQwYgugm9HgKAymiwkN61Tcsutv1+J8Zrv9dqbZvQE7KwAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ffHNGfQy; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ffHNGfQy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=UQ
	6Ua36CEJjkKBeN3p78kaokwBXBEQsg1YGlCCHIQgA=; b=ffHNGfQyf6Tdhv2kGB
	WMOoPG846DUi4zd1MP8htWWpKeN4VDZK4pe7NCwh3nNm1EpCpPhrBLoHntDzFOSm
	3WO9o8PrD74MMV7PXdqvKp+AxC/vHVCeouApiANHNsvblbex5S7oC0ksHyE96+ap
	shVv2+AxoTR1IrEP0s/Kwty7o=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDX3_LZm3JqukrpNA--.22607S5;
	Wed, 05 Aug 2026 10:11:43 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Mark Harmstone <maharmstone@fb.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 3/3] btrfs: free iov when btrfs_uring_read_extent fails
Date: Wed,  5 Aug 2026 10:11:35 +0800
Message-Id: <20260805021135.1896609-4-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wDX3_LZm3JqukrpNA--.22607S5
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry5Cw13JFW3tFyxAr4xZwb_yoWfCrc_XF
	Z3Za40qw47JF1Uuw1j9r10vrWag39F9r4xWr1fKF9rZ34DJa4kuF1vyw1Iyr4Dur1Dur90
	qrnav34Ikr12kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnRBT5UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwh9V5Wpym9-8BwAA3K

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
index c953e4409d5b..af5e168068d3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4820,8 +4820,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
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

