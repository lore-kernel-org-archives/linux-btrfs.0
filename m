Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C5F4F0534
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792168605; cv=none; b=gc2AGrPZpMhefw1xrbF0teTnkdUuss9Rk1qtSZJXmMzv7u7xGrOZ0ndztvJ6FZKRbkPzc/4Guqf6z77+RJNLOapi/r5AelmjJd6d+f2QBNu/Xhay+i27AY9v8xuD0bohnUomReWDkL6B0IFY7wZBBzd/Rq/VSijgI7uHQmT2FT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792168605; c=relaxed/simple;
	bh=3dWegxl7XXjYS7snmdIZHvSxuvjBZAh7HR8vfD2wxXc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tl91cb3F1cwuHj72PyhkiiYtyZaYYgwtyu1tBb82B3f7x+bVG48jhLiXxZd27Y/Lbw0kh87GyvSLirCKOqXyGHiN077F90fBQlElmoPxkj+NicwyYikopRhHywWAjbj8EJ/AsS75TgA2vxJaQVIwhBmD1eA85bfiFVB+Rygpru4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cj720y1K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cj720y1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9E21F000C5
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792168603;
	bh=BOiQUSs1u/iadEzxWTDE0V3kNKhT6oQTpkFpj8ejcfQ=;
	h=From:To:Subject:Date;
	b=cj720y1KZSSjACFyyq0mUQ+hznBSRlEYUkbN5wJ93itW/nfS7ACwSCsrLUAffPSZY
	 pLCYh9xSx6dbQ9hpS4HFHH2B7gzRTBKCB+frwpddrrXSLGWINuCH2xtbOkeSxdCQTM
	 JMObAn3A+hY46YgheVxy3q6WrDm4QWt11gr8O1eNth55O05e7sPAyvadCbj/Jo6aEa
	 IpFTmPa90A8fy0bvxsjDY0tHwlepicXOXZZiCew4tbS/WBWSdCQdtxW7GK/CRGBiMQ
	 adSBeCaSceQpuCfUzb+lMAvC8SNaAEeBG2cPcX8Xln/i/LFaxaQivXf2+9LvCsIKYU
	 ZdfnZe6BTS5OQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: scrub: fix race between scrub and scrub progress ioctl
Date: Fri, 16 Oct 2026 17:36:40 +0100
Message-ID: <a2e99c3b10f86144bdae7ea4953dee3b3e69c2aa.1792168588.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The scrub progress ioctl is copying the scrub progress stats without
acquiring the spinlock that protects it and a concurrent scrub can be
updating the stats at the same time which can lead to load tearing
issues. So take the spinlock when copying the progress stats.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0eb30625439b..a70a1eeb9ecb 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3295,8 +3295,11 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	if (dev)
 		sctx = dev->scrub_ctx;
-	if (sctx)
+	if (sctx) {
+		spin_lock(&sctx->stat_lock);
 		memcpy(progress, &sctx->stat, sizeof(*progress));
+		spin_unlock(&sctx->stat_lock);
+	}
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	return dev ? (sctx ? 0 : -ENOTCONN) : -ENODEV;
-- 
2.53.0

