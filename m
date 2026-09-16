Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E92537B40A
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 03:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528515; cv=none; b=L1Wq1Bk6hL0x7fzWKuA1XOuCJAdxVyYMxkly8aw8YCj8UYF4l1cPNFtY7GFldnaC22C7B7+D3Wdqh18whUJqBbv49c+gIPZ9I21FR3BfD5AhOwCFRxTJAUyhCkJg/nvWs4IO6cFZ7q/rG0QsoiD/BYkLe5DeWXPm9pssP0KXyWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528515; c=relaxed/simple;
	bh=BA3oAuetUS2+8V5wEBtf2z9asocSmekK2f+0BFr6TGo=;
	h=Mime-Version:In-Reply-To:To:From:Date:References:Content-Type:
	 Message-Id:Subject; b=MYoCXYj2Q5EJiRtiv2EE4jgMhHz3vvMxMP8fMQw0T91hl+7fkdI//4RdKuC/MypJP614etp3KgtWrCj3iOKRYPdbzkeO9/t7MKszpmptPenY8j2CcGWtW6CXMNW5aRBcBAUueQ9f6/PlqXu4lYMVHZJYw3AviuVPEvhU/nd/dac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=IpDDfbOU; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="IpDDfbOU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789528502;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2fi6G3wq9g2A5u/pYtI7+b7LaR2uQtgCNvi90ZJYqwQ=;
 b=IpDDfbOUxqK8KVKGuP5Vc5Zn5mxlCVsGjSRhbCuqcQLiK9W1MB7U1puL02nGCLiWuJCu1u
 EPG1Ew6LrVMiEt68FWot/1uXoep+EstEMp0cIKcFIUDqmgDNFFFTcYluJQvWXMu6qB9HHy
 WOTRL9pvet70solTZUkriWV+9c59qhTKPQci9ZqmlDgnXRQiIHaen0vT3/+5NNELsXyism
 ZhNAQwd1Re6kB+KKHaCWPLwcn44+VSjdXzUOkyKsEGEWl4WhkJmENJvrTs/xVsLBJ1H1eU
 5VBNTBv94MWlpGUTOIiQJzcz6H5dZAtUnH0nW5CaNixdWERf1eElgF9huuW1uA==
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <cover.1789524388.git.zhudongjiang@fygo.io>
To: <linux-btrfs@vger.kernel.org>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Wed, 16 Sep 2026 11:14:50 +0800
References: <cover.1789524388.git.zhudongjiang@fygo.io>
X-Lms-Return-Path: <lba+26aaa09b5+4d87be+vger.kernel.org+zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Message-Id: <ed9d34671522ad281b41cea6d132cfd6e7b3d600.1789524388.git.zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
Received: from pdzhu.teiron-inc.cn ([183.34.164.60]) by smtp.larksuite.com with ESMTPS; Wed, 16 Sep 2026 03:15:00 +0000
Subject: [RFC PATCH 2/5] btrfs: qgroup: fix rescan result reporting

The rescan worker clears BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN before
reporting the result, so the cancellation message can never be printed.

The worker also returns early when no transaction is available. This
suppresses the final result message for failures such as path allocation
or status update transaction errors.

Save the cancellation state before clearing the flag, remove the early
return, and report the rescan result after releasing the transaction.
This ensures that cancelled, paused, completed, and failed rescans are
reported consistently.

Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/qgroup.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ce02d6a256ab..be4e45d1aa7f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3886,6 +3886,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 	bool stopped = false;
+	bool cancelled = false;
 	bool did_leaf_rescans = false;
 
 	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
@@ -3950,8 +3951,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	}
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-	if (!stopped || test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
-				 &fs_info->qgroup_flags))
+	cancelled = test_and_clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
+				       &fs_info->qgroup_flags);
+	if (!stopped || cancelled)
 		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
 	if (trans) {
 		int ret2 = update_qgroup_status_item(trans);
@@ -3962,24 +3964,21 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		}
 	}
 	fs_info->qgroup_rescan_running = false;
-	clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags);
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
-	if (!trans)
-		return;
-
-	btrfs_end_transaction(trans);
+	if (trans)
+		btrfs_end_transaction(trans);
 
-	if (stopped) {
-		btrfs_info(fs_info, "qgroup scan paused");
-	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags)) {
+	if (ret < 0) {
+		btrfs_err(fs_info, "qgroup scan failed with %pe", ERR_PTR(ret));
+	} else if (cancelled) {
 		btrfs_info(fs_info, "qgroup scan cancelled");
-	} else if (ret >= 0) {
-		btrfs_info(fs_info, "qgroup scan completed%s",
-			ret > 0 ? " (inconsistency flag cleared)" : "");
+	} else if (stopped) {
+		btrfs_info(fs_info, "qgroup scan paused");
 	} else {
-		btrfs_err(fs_info, "qgroup scan failed with %pe", ERR_PTR(ret));
+		btrfs_info(fs_info, "qgroup scan completed%s",
+			   ret > 0 ? " (inconsistency flag cleared)" : "");
 	}
 }
 
-- 
2.39.5
