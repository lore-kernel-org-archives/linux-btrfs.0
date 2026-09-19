Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6951B1C3F0C
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 04:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789790593; cv=none; b=SykgTlga5UdDMyVpBuY7BVDEjHviSTKIKRAVBvavQutxlujpd+Cl9qnCjeZ18IV0A7mDULTrbYjXE05INS2wju6Tre3ND2lM6ALRD+4MvH/lpyIJoH46bRNAWbi5lc2oUXcz1KOpOSTy0ixyZtlFq2QOfeCFBtKOqjgaRXeS11s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789790593; c=relaxed/simple;
	bh=QIHXPDu8Z5H8qu9efYBIerA6vlky6kHQPUxfa3FJgNQ=;
	h=Subject:Date:Content-Type:From:Mime-Version:To:Cc:Message-Id; b=YuEKoODQ+fJkpY9kDvKVEgq21N42+MShVWjujdyipzPqaT9EaYlf3vRR5RLkZjHnHa4hgccCE/se8xdB0ZEZA1pcOwu3XXFr3L6OCmt9TBGIiemF9bT4Gg9CcpgksZapuNj6oGseNVtRjssjRxJuVHsIUMU3EPMsZRx+alYu8fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=hSOIeXPT; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="hSOIeXPT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789790584;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uNv5BFf+noMJDArFDFTsmdyJdvWL07hiAdy6AZCgyv0=;
 b=hSOIeXPTVSJqQxj5eGnVayyLoiVYypuP+ww1dXp1OYM3ci9UMn16JNVPsmdH+sxgTstqtn
 LAO1ZQtpsc3ozwnU/UzYNqmdtYTlWZs0CGeAhziU984hMJyNuOJ/SWmihAPirdUu7Y24Oe
 l2IBoMuBy7KIfQRkYUx42aGOZLd5g0JKB6fV1nCA0s+3/Av9WGLwOFQUfe2lFr2LQsOcd9
 VqvrDfzeeIFDRtyf2v6w/JGgC8XrsursvFyUFxS4DtNxxJU6PdXN0i50D4s+2QMuuqwvAZ
 7ZNig+QkZmKhWVChwJMsgaaCMjmiec5s63HBxL+qkUjQcPy9ukVNVTuD2S6Lbw==
Subject: [PATCH v2] btrfs: qgroup: use specific errors for simple quota rescan
Date: Sat, 19 Sep 2026 12:02:49 +0800
X-Mailer: git-send-email 2.39.5
Content-Type: text/plain; charset=UTF-8
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Cc: <boris@bur.io>
Message-Id: <20260919040249.912597-1-zhudongjiang@fygo.io>
X-Lms-Return-Path: <lba+26aae0977+6a7558+vger.kernel.org+zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([183.34.169.97]) by smtp.larksuite.com with ESMTPS; Sat, 19 Sep 2026 04:03:03 +0000
Content-Transfer-Encoding: 7bit
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>

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

Assisted-by: LLM
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
Changes in v2:
- Drop the Fixes tag, as suggested by Boris.
- Add Boris's Reviewed-by.

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
