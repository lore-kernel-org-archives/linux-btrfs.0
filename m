Received: from out30-85.freemail.mail.aliyun.com (out30-85.freemail.mail.aliyun.com [115.124.30.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CC2332604;
	Fri, 17 Apr 2026 02:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776394320; cv=none; b=QGpuo1MH+xFUdNJE/v1k4jL1iy71EuZU06Efu6iu42IYBwcG36i7P7HNRYthuFTNka4CW07fCeSHsYRXXbeEBHB5oE9/KycFqfG96Rs6KDMzwAK01pSLhueDmC8EchBDAjqBgUQJaU7JTET9f4G5XFxpHbGt/C+p03YR4rvzm4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776394320; c=relaxed/simple;
	bh=Fkzwm/5CLTNhZkiwc9qcU5nP5+27w1PU7QrZLfWzUh0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZgxdoCEheboQ0MBL9DbYMyFAFdUldoLtrtdhc9LMbCV3TZhPLBLUoQ7tXEYJocTGqTOm/TXZBAL/UEUwU66Lj7Ko0TQzi3BPXZhikNbw5KNZrklBmrf4h53aYPaCz1qmGzRITTHFL0fTT/imdP0OnErRxDSZ6LQnyiWW9PTtTho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=l+gStobh; arc=none smtp.client-ip=115.124.30.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="l+gStobh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1776394311; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=H9uQJyjHfjoT7CKJxEHYFwc+WbOT+sVBBtzzESoHp+U=;
	b=l+gStobhncuxoM1nCG945TE4jZNnixBOjqriK44FsAIjpPAaHOWC5prGLym8RUM+/EmdINwzlQ6UsPCKvvlcECltxKtrXcY4jpfFwOteLK0aGvop9zQE5GPMtdoR9LF3zWVXyrIfjjYVdvIJT/aWggNtKEVY9NWV7QowLv18lDw=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.3820338|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0214311-0.000652078-0.977917;FP=5462798403030388459|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ruohanlan@aliyun.com;NM=1;PH=DS;RN=10;RT=10;SR=0;TI=SMTPD_---0X19nFwn_1776394308;
Received: from China-team(mailfrom:ruohanlan@aliyun.com fp:SMTPD_---0X19nFwn_1776394308 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Apr 2026 10:51:50 +0800
From: Ruohan Lan <ruohanlan@aliyun.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	naohiro.aota@wdc.com,
	wqu@suse.com,
	dsterba@suse.com,
	ruohanlan@aliyun.com,
	hch@lst.de,
	johannes.thumshirn@wdc.com
Subject: [PATCH 6.6.y 0/2] backport to fix error propagation of split bios
Date: Fri, 17 Apr 2026 10:51:14 +0800
Message-ID: <20260417025116.743-1-ruohanlan@aliyun.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Backport commit d48e1dea3931 ("btrfs: fix error propagation of split bios") 
to 6.6.y to fix error propagation of split bios.
It depends on commit 
9ca0e58cb752 ("btrfs: merge btrfs_orig_bbio_end_io() into btrfs_bio_end_io()").

In order to make a clean backport on stable kernel, backport 2 commits.

Naohiro Aota (1):
  btrfs: fix error propagation of split bios

Qu Wenruo (1):
  btrfs: merge btrfs_orig_bbio_end_io() into btrfs_bio_end_io()

 fs/btrfs/bio.c | 62 ++++++++++++++++++--------------------------------
 fs/btrfs/bio.h |  3 +++
 2 files changed, 25 insertions(+), 40 deletions(-)

-- 
2.43.0

