Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B8A35838E
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 03:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528512; cv=none; b=QtkGi7nZC7wj7U2obLlGw+aWMc0UxXgXMJrRbqkGHJbY5tv/YAaAgnMP3L2Hwa2RUXbOM/lLJ665Eni7qSKRZY4MN6EIqp08COn6iYRnDZf+oV+SIfvFMSwJGeethDqmYup70enFvMCk6qO9Fg4KhTGHDf99kLuluasLN2dq218=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528512; c=relaxed/simple;
	bh=t+cHfYAdDWnpdZhttSwN8FND5OEeC3zMZukA/KuNZZU=;
	h=Subject:Content-Type:To:Date:Message-Id:Mime-Version:From; b=Or8tBtPaJV6mjnFuCPxzY/ujA1natvZ/JNbZ/4AGs8L0h6Q/TI8UahXKXC3av5W95cW09Ov5bbhFB6auMwtwSLiucpuqGzZLCJDH81Ds8l4yZIzk38GtwB15zYMPqh0z3GKVqW3g2t9U270r803NVztElwo5Lb3dOXafwX3UwpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=SgrBbM6F; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="SgrBbM6F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789528499;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=mW9TWh48YdcScz9c0ElAh8Kb5jAQabUrI6cIc3ud1oM=;
 b=SgrBbM6FbTPjnk5RRHhQRGCiJ4J7bmFWEyO0L1ZTkUfxeSOPvdrcL1nXsaQbV+AavprxKa
 L1Dh3pzJ3OKPmi9QUzRqD7+EOVZtDcjdXk/L82aIwE2MVBOz1dDIHOc/QP83XR7VsvTy0/
 VRXzDv83JNX6iAr/AYxrp4DznyaFN8GFTeb5eU8w5rMZZuTk2VnUpMXgM0PkFVYY+zQSMa
 1fvDRJfLyiHHgmS1H2WnnbupgPImY3+w6YaqZXWuupkrMwoPiEPTlvQ1dtGrQLnwmh4OxM
 s2+M+JlVLoMdOuASR0uEHTJD4QzXkZfrVQs8NjX7EzdcqPmZSSOElW1ZEmUxaw==
Subject: [RFC PATCH 0/5] btrfs: tighten qgroup rescan lifecycle handling
Received: from pdzhu.teiron-inc.cn ([183.34.164.60]) by smtp.larksuite.com with ESMTPS; Wed, 16 Sep 2026 03:14:57 +0000
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.39.5
To: <linux-btrfs@vger.kernel.org>
Date: Wed, 16 Sep 2026 11:14:48 +0800
Message-Id: <cover.1789524388.git.zhudongjiang@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
X-Lms-Return-Path: <lba+26aaa09b2+ff0a0f+vger.kernel.org+zhudongjiang@fygo.io>

While fixing the confusing error returned for a qgroup rescan request
in simple quota mode, we found further problems in the qgroup rescan
lifecycle.

The following sequence can make a filesystem hang during mount:

  1. Enable full qgroups and wait for the initial rescan to finish.
  2. Start another qgroup rescan.
  3. Disable qgroups while the rescan worker is running.
  4. Enable simple quotas with "quota enable -s".
  5. Unmount and mount the filesystem again.

The rescan worker stops after quotas are disabled, but preserves RESCAN
as if the scan were only paused. Quota disable waits for the worker to
stop, but the stale bit remains. A subsequent simple quota enable
inherits it and writes ON|SIMPLE_MODE|SCANNING to the new status item.

On the next mount, qgroup_rescan_init() rejects this state. However,
its return value is assigned after the existing error cleanup branch
has already been skipped. The qgroup configuration and its sysfs
kobjects are left behind, so mount failure cleanup waits for a kobject
reference that cannot be released.

Fixing the mount error cleanup makes this state fail cleanly instead
of hanging. Preventing the stale state requires fixing rescan flag
cleanup, but clearing RESCAN alone is not sufficient. Two approaches
were considered:

  A. Clear RESCAN in the rescan worker and setup error paths. This fixes
     the running-worker case above, but leaves a race before worker
     queuing. Quota disable can proceed while rescan setup is still in
     progress, and a subsequent simple quota enable can commit a status
     item containing ON|SIMPLE_MODE|SCANNING. If the old rescan ioctl
     later returns -ENOTCONN and clears RESCAN, it only changes the
     in-memory flag; the committed status item is not updated.

  B. Clear RESCAN directly in quota disable. This prevents the new
     simple quota configuration from inheriting the bit, but does not
     stop the old rescan setup. After quota disable and simple quota
     enable, the old ioctl can still run qgroup_rescan_zero_tracking()
     against the newly created qgroup configuration. This was observed
     in the zero-tracking experiment.

Both approaches leave the same synchronization gap. Rescan
initialization, transaction commit, zero tracking, and worker queuing
are separate steps. Quota disable waits for a running worker, but does
not wait for setup that has not yet marked the worker as running.
Neither flag-clearing approach prevents an old setup from crossing
the quota disable/enable boundary.

Several fixes have addressed individual consequences of this window:

commit 331cd9461412 ("btrfs: fix race between quota enable and quota rescan ioctl")
commit e12496677503 ("btrfs: qgroup: fix race between quota disable and quota rescan ioctl")
commit b7adbf9ada35 ("btrfs: fix race between quota rescan and disable leading to NULL pointer deref")

These fixes protect individual objects and failure paths, but do not
serialize the complete rescan setup with quota mode changes.

This series combines the necessary flag cleanup with serialization of
the complete userspace rescan setup. Take subvol_sem for read across
initialization, transaction commit, zero tracking, and worker queuing;
quota enable and disable already take it for write. This prevents
quota configuration changes during setup. The lock is released after
setup and is not held for the duration of the asynchronous scan.

The series also fixes related result-reporting and remount issues:

Patch 1: Clean up qgroup state and sysfs entries when mount-time rescan initialization fails.
Patch 2: Fix cancellation reporting and emit the final result even when no status-update transaction is available.
Patch 3: Serialize rescan setup with quota enable and disable.
Patch 4: Clear stale RESCAN state in worker and setup failure paths.
Patch 5: Fix rescan stop and resume handling during remount.

Dongjiang Zhu (5):
  btrfs: qgroup: clean up config after rescan resume failure
  btrfs: qgroup: fix rescan result reporting
  btrfs: qgroup: serialize rescan setup with quota changes
  btrfs: qgroup: clear RESCAN in overlooked cleanup paths
  btrfs: qgroup: fix rescan handling during remount

 fs/btrfs/disk-io.c |  3 +--
 fs/btrfs/ioctl.c   |  3 +++
 fs/btrfs/qgroup.c  | 67 ++++++++++++++++++++--------------------------
 fs/btrfs/super.c   |  1 +
 4 files changed, 34 insertions(+), 40 deletions(-)

-- 
2.39.5
