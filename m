Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640F64086A
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 05:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783747196; cv=none; b=AK1Mz1ZFfVB5fR83+E4/It+kdXDOfOHP4S0aLFtQy3PtBVx0jGVGa3xn9zW8+9iBYfD6cAUrF5r8uO5t2FfIietEpO+IoZjj62l/Vjc9x0qc7xmXoASvs18ruV1fP1/VKUjZX1M41tuM5wS4raOeM+c9V2uzze1ytXRPBcABQqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783747196; c=relaxed/simple;
	bh=I9+JVPeJzgc0e8Y2GYjWpZBoh+3RPvBcNn8TaWDeuXU=;
	h=Content-Type:Subject:Date:Message-Id:References:From:In-Reply-To:
	 To:Cc:Mime-Version; b=bw430zGFawjCmfz2NmeyIOmF0papTkC7hFoIVoEQBhkoXBIUcqIzLt9V+WNnJN6VLLnUOXELJXeu8mcAByxFvWzH1AgUGfnPtnLBqGMsyUpe7ZA2obbPiX6aRyfgoI6BfsIb2uGB9aPobZBpQPDU/xR7ujbNwPOHRa3dICFPdvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=B1aUZOCG; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="B1aUZOCG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783747183;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=dJzFSIkAOgL+Z8toZ/iWeG4EGxZ5FxxSzkF3XyzWBa4=;
 b=B1aUZOCG96UOIMA3BOYz6rxtGzAUs7TY5LpVKWK0vaekdXEaTXHpAQehtBWbzqvtbTwzy5
 J+RqvL+rRgHNlDJ6eDjnqTzLGJZQRETF9JF3uwjQFCnAcvBSHH7W3Zghkclb/WJFnA/6XF
 vV5qbLHnL82+1UcVDjdio45WMqoNpJ9LlJ001/Cp+ByuoQRsnnaIdHUgADxCTzB2Uy4uIS
 CDPuIMyhJpY/Jn3wgsjgeHyWq34OFDXVkMulmvp89cvEhMvqiEL5Zs+0EVJCeYDdf/kttf
 yMHOkmhV5itisIz+uY2LtyAhfDp3YskjjfwmZljiBbGB+3934hVrOYWwNXYk/Q==
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 3/3] btrfs: report missing raid stripe tree root during lookup
Date: Sat, 11 Jul 2026 13:19:09 +0800
Message-Id: <20260711051909.1313584-4-zhudongjiang@fnnas.com>
References: <20260711051909.1313584-1-zhudongjiang@fnnas.com>
X-Lms-Return-Path: <lba+26a51d26e+cbc493+vger.kernel.org+zhudongjiang@fnnas.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
In-Reply-To: <20260711051909.1313584-1-zhudongjiang@fnnas.com>
Received: from pdzhu.teiron-inc.cn ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 13:19:40 +0800
To: <linux-btrfs@vger.kernel.org>
Cc: <dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.39.5

When rescue=ibadroots ignores a failure to load the raid stripe tree root,
fs_info->stripe_root remains NULL. After the rescue mount proceeds, reading
file data that requires the raid stripe tree reaches
btrfs_get_raid_extent_offset().

Currently btrfs_search_slot() handles the NULL root and returns -EINVAL.
This avoids a NULL pointer dereference, but provides no diagnostic and
incorrectly describes missing filesystem metadata as an invalid argument.

Check stripe_root before allocating a path, emit a rate-limited error with
the logical address, and return -EUCLEAN.

Lookups with a valid stripe root are unchanged.

Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
---
 fs/btrfs/raid-stripe-tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 454a95bf542a..716ba7cbce17 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -414,6 +414,13 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 	int slot;
 	int ret;
 
+	if (unlikely(!stripe_root)) {
+		btrfs_err_rl(fs_info,
+			     "missing raid stripe tree root for logical %llu",
+			     logical);
+		return -EUCLEAN;
+	}
+
 	stripe_key.objectid = logical;
 	stripe_key.type = BTRFS_RAID_STRIPE_KEY;
 	stripe_key.offset = 0;
-- 
2.39.5
