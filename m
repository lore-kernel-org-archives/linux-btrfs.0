Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD523890E4
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 03:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528284; cv=none; b=Qv1EXaPtXxU8T10b9eWmSiuZmV3xwn3w8auwsC8mmwRoDvmDuoeR6yq7q0YNUtFnEcpWvb3V6w0qi7XKTshJLEfkX8n5sJi4mlpkZQSImpLXXSmG+Z2gn5qSSBbBsALI4zf/wqUDckKVA5eovByyWh/HvSFcZ7kbZnL+z2ySXNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528284; c=relaxed/simple;
	bh=wFLQf4ptZY9EAD98qRrSQWf1rKDYHYur46Sc0nFwHKQ=;
	h=Subject:Message-Id:To:Mime-Version:Content-Type:From:Date; b=AzJcEhNpyGrErZ8b2GutlNYJ0oKdoVsrszYTs4G7T3uJFI/gnP3eO6RLpsGubaHinG1bEfEiAcnWCI6TSw+ZSvsH8K7WQfK+El6EVvb/Ai1F2k47zr/D2yzo5RNSphajCgXJf6eI98bxsp0HtoIoTzhMDuUanWiCNiEwYcFT5qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RmB5BX5K; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RmB5BX5K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789528277;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=6LfxtYxuG7QgcJfViSc3JyJrnXwiSRBZrfAtKFqJqvs=;
 b=RmB5BX5Kk7TGoBDIUABRWg1zjKBAaRpgTtngFqPvLQ9Hh7h+95aaxnF+KtULiLmtX+4vzX
 1ffHKyZ4/Jb9AfQd5BcbAN3SV885kObk3P3bqLeTXuWwKRzRDrAjLFBuZIFMXISHG0yEuM
 eUPu3nRtThdzodMwpcMyuh3o6SlI2IpQ+V+C1ib97pmC8FDQcAgl0GVB5ORt19NMm6GJED
 f5rvnRLjhgDSGvITG1BlOtVRa0p0CXz4XZ7/8eoUxwexJU3sJx6cZUu2m5GhZ8neOCxKdm
 cUgF5KwV5DilRd6LWGIcfvHrUfL+ufIXo/QQaNEBMtWCIiqBIXCsqoinudoEVQ==
Subject: [PATCH] btrfs: qgroup: use specific errors for simple quota rescan
Message-Id: <20260916031104.2390777-1-zhudongjiang@fygo.io>
To: <linux-btrfs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aaa08d5+04fd0c+vger.kernel.org+zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Wed, 16 Sep 2026 11:11:04 +0800
Received: from pdzhu.teiron-inc.cn ([183.34.164.60]) by smtp.larksuite.com with ESMTPS; Wed, 16 Sep 2026 03:11:16 +0000
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5

With simple quotas enabled, running:

  btrfs quota rescan /mnt

fails with:

  ERROR: quota rescan failed: Invalid argument

Starting a qgroup rescan is not supported in simple quota mode.
Return -EOPNOTSUPP for new rescan requests so userspace can report
"Operation not supported" instead.

qgroup_rescan_init() is also called during mount to resume a rescan
recorded in the qgroup status item. A RESCAN flag in simple quota mode
represents an inconsistent persisted state, so return -EUCLEAN for this
case and retain the warning for diagnostics.

Fixes: 182940f4f4db ("btrfs: qgroup: add new quota mode for simple quotas")
Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/qgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 05e35eb126dc..0e4de33e4f28 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3991,8 +3991,11 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 	int ret = 0;
 
 	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE) {
+		if (init_flags)
+			return -EOPNOTSUPP;
+
 		btrfs_warn(fs_info, "qgroup rescan init failed, running in simple mode");
-		return -EINVAL;
+		return -EUCLEAN;
 	}
 
 	if (!init_flags) {
-- 
2.39.5
