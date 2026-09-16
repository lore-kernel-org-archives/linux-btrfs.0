Received: from sg-3-42.ptr.tlmpb.com (sg-3-42.ptr.tlmpb.com [101.45.255.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C631C8003D
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 03:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528679; cv=none; b=F8Z2ElweQvAeizDx4yYy+3ig0DZFVpgEMVhGughuWM5PRCtJAqK5KwysoCTu8QfMvYLRILl7AX4TV20UAKDzEbl6oW9c6GW71ZMbv8DJW6KrSaDvwdUGmoX8bzGwPyZYhZX8zdsfjnK6HUm33nQYVJVfTsU+obVbpcDi+2OmcBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528679; c=relaxed/simple;
	bh=1YVm2rYtaIVoCIAfgFda3ULQaE4JEZRN7+wP3TD0Eco=;
	h=To:From:Date:Mime-Version:References:Subject:Message-Id:
	 In-Reply-To:Content-Type; b=b1zJq1F9nRjOKue74/sWBFe8LagH62FBQV8PA6x9RlVIMkDbYwvljF8GE8d7XLNtwIt2YPiPDgxiuZRsf+YYPi7gY+AP55apygR0izhOoLDUnCQ29pt0XWT+uX2cPdEDZuTxN2rHm2IhRf9I1AO0Lo8L48xNr+OQBeJQme6YqGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Wh8hWrU+; arc=none smtp.client-ip=101.45.255.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Wh8hWrU+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789528505;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=V+n/CtzjvmVqkPDoSEa2Mjk97dStWq+Z/Q3nRaEPdoo=;
 b=Wh8hWrU+fvB6miqBJ91OLAxWopthqU9i2nuRYMX3Y0oqX9x2e8RJ0DGIhkStSrcar+z2Ja
 few36gTOeQRHmzitkT8nRukDz9InxNw7NxY1uP9zZIHHfzBtUxhb0Ig5JrPfMskqMBiMuF
 7P3ILGx5OJUmuO58+AjtSpwONCwN3XuZV2AcOka2SlGgD/hJG5PnnNR+1KeuBKPb/581JQ
 4yHeJhbzv7H12A0OzgDiNukhfmtCXSOTaSpkZALUXNT8y7wSPKKgO7nFkDyFo7nJbxObdy
 zbF/IcE3i9ByNNlxqieUiBRXEoGaKC1DuTQ7lbBcCdpPcC6pnVLswhwWg12JWQ==
To: <linux-btrfs@vger.kernel.org>
X-Mailer: git-send-email 2.39.5
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26aaa09b8+86bda6+vger.kernel.org+zhudongjiang@fygo.io>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Wed, 16 Sep 2026 11:14:52 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
References: <cover.1789524388.git.zhudongjiang@fygo.io>
Subject: [RFC PATCH 4/5] btrfs: qgroup: clear RESCAN in overlooked cleanup paths
Message-Id: <d444c55c84fee5aa24d9d094a4606810884ce467.1789524388.git.zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([183.34.164.60]) by smtp.larksuite.com with ESMTPS; Wed, 16 Sep 2026 03:15:03 +0000
In-Reply-To: <cover.1789524388.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8

The current design leaves rescan-related flag cleanup to either the
rescan worker or the caller that rejects the rescan, instead of clearing
the flags directly in quota disable.

However, RESCAN is not cleared in two paths.

When the worker stops because quotas were disabled, the stopped path
preserves RESCAN even though the worker will not be resumed.

When the final full-accounting check rejects worker queuing,
qgroup_rescan_init() has already set RESCAN, but the caller returns
-ENOTCONN without clearing it.

Clear RESCAN in both paths.

Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/qgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cbaab2db0f2b..c1e58e84a86f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3940,7 +3940,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	mutex_lock(&fs_info->qgroup_rescan_lock);
 	cancelled = test_and_clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
 				       &fs_info->qgroup_flags);
-	if (!stopped || cancelled)
+	if (!stopped || cancelled || !btrfs_qgroup_enabled(fs_info))
 		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
 	if (trans) {
 		int ret2 = update_qgroup_status_item(trans);
@@ -4099,6 +4099,7 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 		btrfs_queue_work(fs_info->qgroup_rescan_workers,
 				 &fs_info->qgroup_rescan_work);
 	} else {
+		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
 		ret = -ENOTCONN;
 	}
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
-- 
2.39.5
