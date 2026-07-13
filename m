Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6073CF1F4
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 08:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932647; cv=none; b=hjbCmpNbnFCLrSJod0IAxY3POGpFgUlLzeITZ9wecOpdGhKKfgxX+GI8jDR854fLUZh72phOly6kXH+DKpUHXJ6zUYGDJvAG4PvduZ6hb91g4W4XwNKGSBEdd9RW6rVQwZdniCEf2SawpXKMyClo/Z9CbhllV5Gym8SPE0RL9wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932647; c=relaxed/simple;
	bh=I9+JVPeJzgc0e8Y2GYjWpZBoh+3RPvBcNn8TaWDeuXU=;
	h=Content-Type:Message-Id:Subject:Mime-Version:References:From:Cc:
	 Date:In-Reply-To:To; b=XRMcuTh7wv6AEQ7ckfVeDYScdO49xke+N36JFKP1t9Vw4LE+hHvt6Dazkhz5CqoW6mAT+smxaVRRybWyZGh99o5BxyRGNj5jH4hz38ubLSW21xXOsAufpyi6JfH32SDAqMcB9h1rUgRMKV1zXVgxXhp2OLmHyePxkl+MwkdAnUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=yD1OXgdp; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="yD1OXgdp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783932640;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=dJzFSIkAOgL+Z8toZ/iWeG4EGxZ5FxxSzkF3XyzWBa4=;
 b=yD1OXgdpMyWFj9IsAhBkvTmJwIL7G5iYx+grZPNWbBI7LQ8MvucEDPCCLFSo79SnnEM36n
 Zwvazdt/ympG5x4DTAWYZzWOzOrUjEh09pQkQmQDkKqFXItTYzjJc0viSM0sUgrn6WNqfx
 GHC4U51p/mblNAvD4ao7ZWtRhqeiRFQF12dsmNksDB7wnb//RiN0OLc/2PTYVJt4y0c6RW
 94+6/Rky4r+TVlxJB9BgjcwnCvNbw1dpPdJHHPlx148RrF8JSo4E1WXdnWxQ9i5umtl3AW
 n3QelYthOJICYW8Rs34edFnzXI/S+K7K4ikbFcPNMCL4iw6WQW9IstDUrGx13w==
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.39.5
Message-Id: <20260713085010.1123273-4-zhudongjiang@fnnas.com>
Subject: [PATCH v2 3/3] btrfs: report missing raid stripe tree root during lookup
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a54a6de+ef205e+vger.kernel.org+zhudongjiang@fnnas.com>
References: <20260713085010.1123273-1-zhudongjiang@fnnas.com>
Content-Transfer-Encoding: 7bit
Received: from pdzhu.teiron-inc.cn ([183.34.174.151]) by smtp.feishu.cn with ESMTPS; Mon, 13 Jul 2026 16:50:36 +0800
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Cc: <dsterba@suse.com>, <wqu@suse.com>
Date: Mon, 13 Jul 2026 16:50:10 +0800
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
In-Reply-To: <20260713085010.1123273-1-zhudongjiang@fnnas.com>
To: <linux-btrfs@vger.kernel.org>

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
