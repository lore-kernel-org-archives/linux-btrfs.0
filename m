Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FCE420468;
	Mon, 14 Sep 2026 09:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377771; cv=none; b=gnTRFFCf16gY/9BbOgQ97Y9ibMJu8Z9IZmQ/C1AraKUKHZ63tdmXI4YiNS/BQdYLBzi8sYsdtSDHKn406p1hPQilsS5wf52JwX9gfkCYMazIYwC0SO0KvAuaYf9ipfARGbReySV+YtxfuZaA/tNYoWkmQrTODj3hh7HObpDS7MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377771; c=relaxed/simple;
	bh=CTU6kNA4lhjUrkL83cra6S1TXKxMzbXLOeLDGAxzMm4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=erOB8PGXiGgB+cP4nuCbMXebc8wZug5zCc5agQ7VnNa4AM5sYxXujhLNZqDt7LYEtgSChwO9yyMRB568wfN5uqKNjjfYy3P4Gw7FXegiYuGzXbh0LjImbfzQEagL4cELcycsVnvG6u/0HCJq4mh6zVBAuoKJlRIm1nLm+4Cj2TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ADtFBfYY; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ADtFBfYY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=1J
	qaVddzxdKihEpgRpDLiYm4g+b7Lj4l7BuCdzKNB3U=; b=ADtFBfYYd9Pnx/LoCJ
	MOZXhjN10mdPHXKX+xbt4b0duY4np/4cZwVkACKzVrsuydY4MAlwO8iK4fyh9VuH
	i47g2Ql0+Zggtl4H7WKKL/qSOzqnDWwGkDMKIzanShcle75GwKfmJyArsQXInfac
	BB0vLGhl9q8V7haSeqMOWPMUE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wCn+t7QvKdq4+5bAg--.13501S2;
	Mon, 14 Sep 2026 17:22:25 +0800 (CST)
From: Jiahao Li <lijiahao202609@163.com>
To: dsterba@suse.com,
	mason@kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiahao Li <lijiahao1@kylinos.cn>
Subject: [PATCH v1] btrfs: discard: fix warning for discard_state
Date: Mon, 14 Sep 2026 17:22:22 +0800
Message-Id: <20260914092222.1465563-1-lijiahao202609@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn+t7QvKdq4+5bAg--.13501S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtryftFyruryxXw13GF47XFb_yoWkCwc_G3
	WfGa4v9rnxtwsxJr1Fga15JFZYgw4jgrW7uw47Cw1UKa48J343Jas7KF4ayr1kWr1Uury3
	trWSq3yjga17CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeAMa5UUUUU==
X-CM-SenderInfo: 5olmxthkdrjiiswqmqqrwthudrp/xtbC6RHnxGqnvNF57AAA3u

From: Jiahao Li <lijiahao1@kylinos.cn>

Building with -Werror=mabe-uninitialized fails:
fs/btrfs/discard.c:553:9: error: 'discard_state' may be used
uninitialized [-Werror=maybe-uninitialized]

The compiler cannot prove that discard_state is assigned on every path
before it is read. Initialize it to BTRFS_DISCARD_EXTENTS, which is the
state the variable holds when the loop is first entered, this does not
change runtime behavior, so the warning is gone and the value is always
well defined.

Signed-off-by: Jiahao Li <lijiahao1@kylinos.cn>
---
 fs/btrfs/discard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index 1c304bf473e5..413a804ff46b 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -519,7 +519,7 @@ static void btrfs_discard_workfn(struct work_struct *work)
 {
 	struct btrfs_discard_ctl *discard_ctl;
 	struct btrfs_block_group *block_group;
-	enum btrfs_discard_state discard_state;
+	enum btrfs_discard_state discard_state = BTRFS_DISCARD_EXTENTS;
 	int discard_index = 0;
 	u64 trimmed = 0;
 	u64 minlen = 0;
-- 
2.25.1

