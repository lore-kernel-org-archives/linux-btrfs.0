Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794364377;
	b=tmxx50QMpkAOQ7UTK4DF+FmTiQi5fsuPP+pLdlBJIu1LPDPmXvH08lGoqCfe8LyUM+uu
	 Y9nTru/9aBEPRDYDcgj97Iib152OVh6Cj8nktRGZuafy9PXzFbKA3rlDAmNp3IqwiL8By
	 plfwDLBSe+6/aLM1wCg/ygtg94SP/h6b+NzYdxNW81KTpaUqsJneYYLz9IfjmliuoRBGt
	 clNYNZ45pDFjs9oRMV/JW2sY6c+sFFQ7Yw76Sm1+60nP4g+sEmPnX79DZtuW8Sc+U8lIm
	 RMr1vVWYRmCbwXPFu0HzPyc5cMopG1n/6n4tXB2UWCC09SYR6zO/K+qDKPBV6WHUvtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794364377;
	h=DMARC-Filter:DKIM-Signature:Date:Subject:X-Mailer:X-Lms-Return-Path:
	 Mime-Version:Cc:From:Received:X-Original-From:To:
	 Content-Transfer-Encoding:Content-Type:Message-Id;
	bh=Xe2QOwssT9qZfTbJ00s2s3iiplYJJf6BvI0nfo+NGWM=;
	b=vd4i6XZHMkczJYOZylWA8qFcU2dBz/au1ES+TxVHlJB++0nmbB8bQV0/kZfUK/z8P/Dh
	 Pe7gENOwOoXeXACVXtDf0wGKFsooJ3yqcj5ABAe1PFDw0qKrn1RNl7n8T957Mv6pnRFfY
	 qaG9Ns6GGS6TsdB2JDEocu9mql35oNNFyq6VARxHuOfMCQXER7Nbexi5OP+7waUB9n07e
	 oMDmdLCVjlX9Gj7oPiNM/cpH8uEYSg4AVsVMvuRGVlDkI+1qLRfTVFZwyMCh1HiVHnAGz
	 o5f2OdyFkrwvX5c0WgytyFs/hYJ3nxY2mFEqrfyk0l474JFoDGTQ65BJ03L3LkrD7YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=fnnas.com;
	spf=pass smtp.mailfrom=fnnas.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=ze7lupFZ;
	arc=none smtp.remote-ip=209.127.231.58
Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE13606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 02:32:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CE13606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=ze7lupFZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1794364371;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Xe2QOwssT9qZfTbJ00s2s3iiplYJJf6BvI0nfo+NGWM=;
 b=ze7lupFZizW1UClsIAK+07TU0jT1fSNQhkNDwF/UQWr8TVMwBnzUIu+MBLiNFivuobTmZV
 zn7f8QXPkQcrSvl+u750xhOCpuVPQkbq0qufnJXbBUXYzTAR3yyfzbGGgGbDmnxqHWG8LQ
 y7lxn5PbzXnBwWV844axGtN/TCTp4VkWZADxUlYCQb+nqjcRIi25evh75mttgpdXcrJuY9
 HFK1DsXqm7anhuzNTCN/DNJ7ytOAu4B1+gGBX9HBz2X+8sG/yEb9vBORbY+0heeFq7Jdcg
 h1O1A4AyCmWAJNT9fCIvxEepZ68krJtF2BfAGbkZkEKgUlMVoR+la2kxwtHwBw==
Date: Wed, 11 Nov 2026 10:32:33 +0800
Subject: [PATCH] btrfs: qgroup: skip inconsistent accounting after mount
X-Mailer: git-send-email 2.53.0
X-Lms-Return-Path: <lba+26af3d3d1+ab24dd+vger.kernel.org+sunyangkai@fnnas.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Cc: <sunk67188@gmail.com>
From: "sunyangkai" <sunyangkai@fnnas.com>
Received: from debian.localdomain ([183.34.160.221]) by smtp.feishu.cn with ESMTPS; Wed, 11 Nov 2026 10:32:48 +0800
X-Original-From: sunyangkai <sunyangkai@fnnas.com>
To: <linux-btrfs@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Message-Id: <20261111023233.1138009-1-sunyangkai@fnnas.com>

When full qgroups become inconsistent, qgroup_mark_inconsistent() sets
NO_ACCOUNTING to avoid expensive backref walks which cannot repair the
counters. This is a runtime flag, so unmounting and mounting the filesystem
loses it. Incremental accounting then resumes even when the persistent
INCONSISTENT flag is set and no rescan is pending.

On a filesystem with many snapshots, the resulting backref walks can
stall transaction commits and operations waiting to join a transaction.

Use qgroup_mark_inconsistent() when loading an inconsistent full-qgroup
configuration without a pending rescan. This restores NO_ACCOUNTING and
CANCEL_RESCAN. Preserve the existing rescan initialization path, which
clears both flags for resumed and newly requested rescans. Simple quotas
are unaffected.

Fixes: e15e9f43c7ca ("btrfs: introduce BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING to skip qgroup accounting")
Signed-off-by: sunyangkai <sunyangkai@fnnas.com>
---
Prepared with assistance from OpenAI Codex.

Tested on the same for-next base and x86_64 config before/after the fix:
- Full kernel builds and W=1 fs/btrfs/qgroup.o, without compiler warnings.
- QEMU, 620 snapshots, 10 ms read delay: maximum create latency drops from
  36.47 s to 2.31 s; btrfs_find_all_roots_safe calls drop from 1476 to 0.
- Manual rescan and mount-time resume complete with inconsistency cleared.
- Fresh-image consistent full, disabled and simple quota smoke tests,
  including offline read-only filesystem checks after each stage.

 fs/btrfs/qgroup.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index baef546fa213e3f9745cedd729939865bc1976ea..522493ffab8d4d26e447dc22e11e04130f603d8d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -615,8 +615,18 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 	if (ret >= 0) {
 		if (test_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags))
 			set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
-		if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags))
+		if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags)) {
 			ret = qgroup_rescan_init(fs_info, rescan_progress, 0);
+		} else if (btrfs_qgroup_full_accounting(fs_info) &&
+			   test_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT,
+				    &fs_info->qgroup_flags)) {
+			/*
+			 * Incremental accounting cannot repair inconsistent counters.
+			 * Keep it disabled until a new rescan is started.
+			 */
+			qgroup_mark_inconsistent(fs_info,
+						 "inconsistent qgroup status found at mount");
+		}
 	} else {
 		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
 		btrfs_sysfs_del_qgroups(fs_info);

base-commit: 50fd5933d3fa2a70acbaf87a21c355f6415974fa
