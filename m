Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74C8420E71;
	Thu,  6 Aug 2026 08:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006292; cv=none; b=Pb9Ldg56h+Bglf7DYyZRyMKNewBFmuujIQWYTJlVNWmYw4NMl4rOIJ9Toxb+XhdBIVpi856lFWJ/b5mD5ZyqzZIJqNOVd0PFoFKIg9+ABgcYjDA4lTrD4NGKww96Qh8SeUdLkejES6HBFi6Rw4QFZYNUJQfRN1F0Tc4SxIS6C4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006292; c=relaxed/simple;
	bh=WPOzVHClyl1C4jc3kpXHyfmbBL8u6yGsba07lG6NdO4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S2uwFRKNB+sE9Mws5NTR1Nshwa7MFpTznHq8ugGhwF9pFWEFYCPtgbXaWTILs4ygUJ4eLTDKB7MLPfLd9EtxYC6+b6fwQl0LnGB2Xz5+7QaqqtkWUmdJ7/b44WNlstdhVlPROlOK1GRxrJjB9VXrsYpy1iWpmwOKmpnjGuEAVBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TeV8qYGS; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TeV8qYGS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ef
	obL8iA74qoyJf2/P3yajtYBpsrek0NvmbTFOQe8pw=; b=TeV8qYGSQOrAGLC0oX
	QYsh7vLI+kQexcCndTP3bN+2dU1rWQ+waqg2SPXOmLaOwdDi/i7AVa/UneeO2Xeb
	4Tk6wDsV16Usz84q8i/ew22ka7KE+yY/M15fEKFkyvhQAkXtI6t/2BtFWHHjv54P
	tD8HXBowioa61MwKKEPA3i6vw=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDXGqvjSnRqmYLmMA--.78S5;
	Thu, 06 Aug 2026 16:50:52 +0800 (CST)
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
Subject: [PATCH v2 3/7] iov_iter: export __import_iovec
Date: Thu,  6 Aug 2026 16:50:37 +0800
Message-Id: <20260806085041.1410576-4-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wDXGqvjSnRqmYLmMA--.78S5
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF45Xw18KryxXF1Duw4Durg_yoWxuFX_Ca
	1Sq3Z3Wr45AF43Aa4fCF4SvrZYk3Zxur18Gr15CFZxGasxGayDuryqvas7Aa15ZFWS9Fyj
	vrsFgFyIyr1fCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0beOJUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gyFFmp0Suzd7QAA39

__import_iovec() already takes an explicit compat flag for callers that
cannot rely on in_compat_syscall() (io_uring SQPOLL / io-wq).  Export
it so loadable btrfs can use it for uring encoded IO.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 lib/iov_iter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c2484551a4e8..9c2158d5ccdd 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1410,6 +1410,7 @@ ssize_t __import_iovec(int type, const struct iovec __user *uvec,
 		*iovp = iov;
 	return total_len;
 }
+EXPORT_SYMBOL_GPL(__import_iovec);
 
 /**
  * import_iovec() - Copy an array of &struct iovec from userspace
-- 
2.25.1

