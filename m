Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AFD3644B3
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 03:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528517; cv=none; b=e9eL29ClInqXAhHKVEHqV+WBmWh5SjZZGx85375kiYX0CTswXQIsIGAIj+pPbrXf/ZBeb4dF63NhHGy5NLFIqowS7MwgN8CLsJfoBBJpMDSHPIl62O2Hfp/TEsYA3vWagtp+T+LCVOn8CGxTCiMtzBTeQQw9PnGs/1R5fMGzLeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528517; c=relaxed/simple;
	bh=DD0tHMlnk6awDCNcIcJvlPvMDN1GoCrXINHzT3wtwUk=;
	h=Message-Id:References:Subject:In-Reply-To:Content-Type:To:From:
	 Date:Mime-Version; b=YW/QqKy2mf78mpNCUNGNQx81FCjX3DIZXUBbXtuzelaIoi+S8a7EGv94I1HTWi2zMPulH4CwrnWEWCOK4AxOf5B5dhl0+1xvEFVaNAKDJ4mVfuLkXC/tvPMroKs4KVO2ZcREKJP8uEvWER1uubgkUhCDN/+qoflLh6rDxh1ExiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=jqaCgylr; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="jqaCgylr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789528503;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=/IvXm/q27kf6+K6+eRaF3fnKoRInRnK0ItKb+yn4SkA=;
 b=jqaCgylrXbkdy1jAIsmMxShNy2Ns1t+F7yZnC0cPMOrXOnuFsAtDsKCVm4CfHUru/HUslq
 FGW9Ruv/kl//DB1GKNx/dzfxiZjG++zAdXJkJ1VglDQnsduH2sJktpf+RngJxtWS11lbn2
 9+/PkoQdN43rMZKy8uvPDHWD1TRMduJ1W+55KIdiqyATet7xbcHnyj44CiSWny0/bwfeIQ
 ZJQEH3oBH/AzPNfhvvKwishg1hGyASqnoWhIc454W/ukA5Atw3mwIr7I9GPtTWlqaHq79N
 oxzRMIAjKLHvDBX3X8rm19BJl9V56D8REqLsBVSxiIX83RPU99q3MitZS9ZuKw==
Message-Id: <c8428d6c63138b6d398be5dd2de00dff728cedd0.1789524388.git.zhudongjiang@fygo.io>
References: <cover.1789524388.git.zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
Subject: [RFC PATCH 3/5] btrfs: qgroup: serialize rescan setup with quota changes
X-Lms-Return-Path: <lba+26aaa09b6+4417c6+vger.kernel.org+zhudongjiang@fygo.io>
In-Reply-To: <cover.1789524388.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Wed, 16 Sep 2026 11:14:51 +0800
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([183.34.164.60]) by smtp.larksuite.com with ESMTPS; Wed, 16 Sep 2026 03:15:02 +0000

Starting a qgroup rescan is a multi-step setup operation. It initializes
the rescan state, commits the current transaction, resets zero tracking,
and only then marks the rescan as running and queues the worker.

Quota disable waits for a running worker, but cannot see a rescan still
in setup. It can therefore remove the qgroup configuration while the
rescan ioctl is between these steps. If quotas are enabled again, the
old ioctl may continue setup against the new configuration. A simple
quota enable can also inherit the pending RESCAN bit and write
SIMPLE_MODE|RESCAN to its status item.

Several fixes have addressed specific effects of rescan setup racing
with quota changes:

commit 331cd9461412 ("btrfs: fix race between quota enable and quota rescan ioctl")
commit e12496677503 ("btrfs: qgroup: fix race between quota disable and quota rescan ioctl")
commit b7adbf9ada35 ("btrfs: fix race between quota rescan and disable leading to NULL pointer deref")

These fixes address individual outcomes, but do not prevent quota
changes from occurring in the middle of rescan setup.

To close the setup window itself, take subvol_sem for read around the
complete rescan ioctl setup. Quota enable and disable already take it
for write. When disable can proceed, setup has finished. If the worker
is still active, it has already been marked running and queued, so the
existing completion wait can cover it.

The lock only protects rescan setup. It is released after the worker is
queued and is not held for the duration of the scan itself.

Update the related comments to reflect the resulting serialization.

The separate case where quota disable stops an already running worker
is outside the setup window and is handled by a follow-up change.

Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/ioctl.c  |  3 +++
 fs/btrfs/qgroup.c | 26 +++++++-------------------
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 54960351fbd1..2f7902dde526 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3866,7 +3866,10 @@ static long btrfs_ioctl_quota_rescan(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	/* Serialize rescan setup with quota enable and disable. */
+	down_read(&fs_info->subvol_sem);
 	ret = btrfs_qgroup_rescan(fs_info);
+	up_read(&fs_info->subvol_sem);
 
 drop_write:
 	mnt_drop_write_file(file);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index be4e45d1aa7f..cbaab2db0f2b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -674,11 +674,6 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
 	struct rb_node *n;
 	struct btrfs_qgroup *qgroup;
 
-	/*
-	 * btrfs_quota_disable() can be called concurrently with
-	 * btrfs_qgroup_rescan() -> qgroup_rescan_zero_tracking(), so take the
-	 * lock.
-	 */
 	spin_lock(&fs_info->qgroup_lock);
 	while ((n = rb_first(&fs_info->qgroup_tree))) {
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
@@ -1275,14 +1270,9 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	                         &fs_info->qgroup_rescan_work);
 	} else {
 		/*
-		 * We have set both BTRFS_FS_QUOTA_ENABLED and
-		 * BTRFS_QGROUP_STATUS_FLAG_ON, so we can only fail with
-		 * -EINPROGRESS. That can happen because someone started the
-		 * rescan worker by calling quota rescan ioctl before we
-		 * attempted to initialize the rescan worker. Failure due to
-		 * quotas disabled in the meanwhile is not possible, because
-		 * we are holding a write lock on fs_info->subvol_sem, which
-		 * is also acquired when disabling quotas.
+		 * At this point quotas are enabled, so the only expected error
+		 * is -EINPROGRESS, either because a rescan is already pending
+		 * or new rescans are temporarily rejected.
 		 * Ignore such error, and any other error would need to undo
 		 * everything we did in the transaction we just committed.
 		 */
@@ -3932,10 +3922,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 
 	/*
 	 * Only update status, since the previous part has already updated the
-	 * qgroup info, and only if we did any actual work. This also prevents
-	 * race with a concurrent quota disable, which has already set
-	 * fs_info->quota_root to NULL and cleared BTRFS_FS_QUOTA_ENABLED at
-	 * btrfs_quota_disable().
+	 * qgroup info, and only if we did any actual work.
 	 */
 	if (did_leaf_rescans) {
 		trans = btrfs_start_transaction(fs_info->quota_root, 1);
@@ -4077,6 +4064,8 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 {
 	int ret = 0;
 
+	lockdep_assert_held_read(&fs_info->subvol_sem);
+
 	ret = qgroup_rescan_init(fs_info, 0, 1);
 	if (ret)
 		return ret;
@@ -4103,8 +4092,7 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 	mutex_lock(&fs_info->qgroup_rescan_lock);
 	/*
 	 * The rescan worker is only for full accounting qgroups, check if it's
-	 * enabled as it is pointless to queue it otherwise. A concurrent quota
-	 * disable may also have just cleared BTRFS_FS_QUOTA_ENABLED.
+	 * enabled as it is pointless to queue it otherwise.
 	 */
 	if (btrfs_qgroup_full_accounting(fs_info)) {
 		fs_info->qgroup_rescan_running = true;
-- 
2.39.5
