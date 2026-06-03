Received: from sg-3-27.ptr.tlmpb.com (sg-3-27.ptr.tlmpb.com [101.45.255.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0601F2E736D
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 11:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780485621; cv=none; b=iF1RFt6356dc0yjEKKMIO1zaOTtG8xEgobpgfNWK8TgxEgUrCvIQ+LHvh0S5gD05Ebw6I2ojjg55aFwfU5Y9hrpF5XeCN18pz4mqEZutdq4+s7obXFPVpRSMNgdra6FYQeih6pQJ09BTkURwHEtj/5KZ7PXHid5R8EWy4nZz83g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780485621; c=relaxed/simple;
	bh=vvCS9BNx6rkhVcNzH1apDRAtXp7aKr2qx6tUvY9R3+A=;
	h=To:Content-Type:From:Message-Id:Date:Cc:Subject:Mime-Version; b=g8JkAGwkYJ+foC/Q4SZdQG2WUwLTd946SLw7o86YURCFUXFf9ODJQMuScrMR6K61EOEoCnYcvH5QmrFyDRFVoW0Knsg6mzLTGpG+ycl3CkyQWE1VQi++haWXX18GKH+BrpX//7K6e1Ra5ma+wZEtyQOAH9bwVocpgOD8Wy9+ItA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=oQauaeSP; arc=none smtp.client-ip=101.45.255.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="oQauaeSP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780485567;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ziJrDNVU/XO7/XN5X8k3HAhTrOEiFaDDdlHm0tG60s0=;
 b=oQauaeSPeRMsLSh7qFNZYU+rqJfLtMXjM7LKO30WqQ0hHRWYuJfG28QpBsieH3olhu/l9h
 lxn4drvPVxCIyAzpWILUjRs04dUW9WbQW5ML/VisfbJq2FKcZt7InjSlqcTmxE/TQ7Rk0C
 KROvK3g+j0W+OgOCTpiNlZd/JQMF8mrBXSWX2/s4X2ugemqEr+mXU/OyOonxNLXROVbGx8
 X5Y5E5+9bZLbteBhUQUrdwp5LnLoao4fA1FYUFOPN1+KD8QvM65Qo9Jyxfb40KE8L61NIy
 v2jbsRO5W8IPINPF2Du6pyrISCbN7qiTeEATv5d810XjWWP3LmVO2denkCNQMw==
To: <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Message-Id: <20260603111857.230985-1-zhudongjiang@fnnas.com>
X-Mailer: git-send-email 2.39.5
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a200dbd+d42481+vger.kernel.org+zhudongjiang@fnnas.com>
Date: Wed,  3 Jun 2026 19:18:57 +0800
Received: from localhost.localdomain ([183.34.161.59]) by smtp.feishu.cn with ESMTPS; Wed, 03 Jun 2026 19:19:24 +0800
Cc: <dsterba@suse.com>, <fdmanana@suse.com>
Subject: [RFC PATCH] btrfs: do not enforce qgroup limits when changing qgroup limits
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>

Since qgroup ioctls started reserving transaction space, qgroup limit
changes can fail before reaching btrfs_limit_qgroup().

For example, if a subvolume qgroup has reached its max referenced limit,
issuing BTRFS_IOC_QGROUP_LIMIT on a path inside that subvolume makes
btrfs_start_transaction(root, 1) reserve qgroup metadata against that
same qgroup. The reservation can fail with -EDQUOT, so the administrator
cannot increase or disable the limit that caused the failure.

This is also path dependent. The same operation may succeed when the
ioctl is issued on another path from the same filesystem whose root
qgroup is not limited, while it fails on the target subvolume path.

Keep reserving transaction space for the QGROUP_LIMIT item, but do not
enforce qgroup limits for that transaction reservation. This preserves
the metadata and delayed ref reservation semantics added for qgroup
ioctls, while avoiding a qgroup limit self-deadlock for limit changes.

Currently this can be worked around by enabling quota_override or by
issuing the ioctl on another path from the same filesystem whose root
qgroup is not limited. However, changing a qgroup limit should not depend
on either of those.

This only changes BTRFS_IOC_QGROUP_LIMIT. A follow-up question is whether
the same helper should also be used for other qgroup management ioctls,
such as qgroup destroy or relation removal, when they are part of
recovering from an over-limit state.

Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
---
 fs/btrfs/ioctl.c       | 10 ++++++++--
 fs/btrfs/transaction.c |  8 ++++++++
 fs/btrfs/transaction.h |  3 +++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d47d16394fc..1e410db06c19 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3758,8 +3758,14 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
-	/* 1 BTRFS_QGROUP_LIMIT_KEY item. */
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * 1 BTRFS_QGROUP_LIMIT_KEY item.
+	 *
+	 * Do not enforce the current qgroup limit while changing that limit,
+	 * otherwise a qgroup that already reached its limit cannot have the
+	 * limit increased or disabled.
+	 */
+	trans = btrfs_start_transaction_no_qgroup_enforce(root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto drop_write;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0360439e4864..92059af3064b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -834,6 +834,14 @@ struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 				 BTRFS_RESERVE_FLUSH_ALL, true);
 }
 
+struct btrfs_trans_handle *btrfs_start_transaction_no_qgroup_enforce(
+					struct btrfs_root *root,
+					unsigned int num_items)
+{
+	return start_transaction(root, num_items, TRANS_START,
+				 BTRFS_RESERVE_FLUSH_ALL, false);
+}
+
 struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items)
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5e4b1106fd90..7a952a7cfd21 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -289,6 +289,9 @@ do {								\
 int btrfs_end_transaction(struct btrfs_trans_handle *trans);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   unsigned int num_items);
+struct btrfs_trans_handle *btrfs_start_transaction_no_qgroup_enforce(
+					struct btrfs_root *root,
+					unsigned int num_items);
 struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items);
-- 
2.39.5
