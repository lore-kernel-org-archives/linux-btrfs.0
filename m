Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0926134CF
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 03:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528520; cv=none; b=ip73jxknMOtjqDWtmM/QDO8uXr0TEJP0443kCC7mK8XoRg7E6QkdhCciKIjkBFGCblpwpElKClXvA5N1GRr/W/dE5f099WXQLg9kNsJt6v91autPvBW8Nn+35dT56ooDtWb374EAkNU+bt7G6Jk4NrlrXUDTrMJcpANN2FKSYiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528520; c=relaxed/simple;
	bh=zhArsi/gQmydLri9E+GXTORxRexe2xWzjsVzMVi3S9s=;
	h=Date:Message-Id:Mime-Version:References:From:Subject:In-Reply-To:
	 Content-Type:To; b=Nv3iP/v/sFnvcEK4uUoJftR2NOEFnNP/DBG8JHUVmP7/0H57nQTqqF8Ed8IbXv+NavW80d1lHT1XGhTHw6glj4ePzHH/jOrhVo4ONah2lAZhnB7jfH5RvwYkPIlCn4SqmBl/BllHm6D8uz2DSw/GkBuorI7WdgIvV8H/r+Oiz6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ID5mnCf4; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ID5mnCf4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789528500;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=cHUh+QQ0roEczMNMeWae2KKMZarB2REMVkQVcn5YZL8=;
 b=ID5mnCf4UV7M86No6UvR2D7w2PbeDp4JMefQo/pyl6BsWmb9ESrngit/t8HrVUU0eL4XoH
 Zjn1XtuGcJdWba7HqzzSLwsJl9Eo/XSRi27ysS482KZIwzkX6YKDX0PGEpGrXLU4TqStOb
 qJI4da2iXtaD+duBT8UyTQ1XK/Y1Gcn9uLa8yALjNHK2wx+Qyb9mqq/iH+0paFomBn1mCq
 3gPTWUwD/hisIvS+ED0Lvu9kv5kvjiWl9cZxZYPGWKwD+jCtUX5+f75gY//7ZtPg8B42e0
 UYmaYnXEbsyQgaDhWsKecPB5xNzZ3ZqcN9vuQCoicMeyCuPDYHqLCrdwkO4bCg==
Date: Wed, 16 Sep 2026 11:14:49 +0800
Message-Id: <2d35ad0bec65ec74f998c7c1731b9a5aeed3f477.1789524388.git.zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1789524388.git.zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Subject: [RFC PATCH 1/5] btrfs: qgroup: clean up config after rescan resume failure
X-Lms-Return-Path: <lba+26aaa09b3+690716+vger.kernel.org+zhudongjiang@fygo.io>
In-Reply-To: <cover.1789524388.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Received: from pdzhu.teiron-inc.cn ([183.34.164.60]) by smtp.larksuite.com with ESMTPS; Wed, 16 Sep 2026 03:14:59 +0000

The following sequence can make a filesystem hang during mount:

  1. Enable full qgroups and wait for the initial rescan to finish.
  2. Start another qgroup rescan.
  3. Disable qgroups while the rescan worker is still running.
  4. Enable simple quotas.
  5. Unmount and mount the filesystem again.

After step 4, the qgroup status item can contain
ON|SIMPLE_MODE|SCANNING. On the next mount the kernel reports:

  qgroup rescan init failed, running in simple mode

and the mount task remains stuck in open_ctree().

The rescan worker leaves RESCAN set when it stops after quota disable.
A subsequent simple quota enable inherits the bit and writes it to the
new status item. On mount, qgroup_rescan_init() rejects this state in
simple quota mode and returns an error, but the existing error cleanup
branch has already been skipped. The qgroup configuration and its sysfs
kobjects are therefore left behind.

During mount failure cleanup, btrfs_sysfs_remove_fsid() waits for the
filesystem kobject to be released, but the qgroups kobject still holds a
reference to it. The mount task consequently remains stuck waiting for
the kobject unregister completion.

Check ret again after attempting to resume the rescan. On error, clear
the enabled and rescan state and call btrfs_free_qgroup_config() to
remove both the qgroup objects and their sysfs entries.

This makes the mount fail cleanly instead of hanging. Preventing quota
disable and simple quota enable from producing the stale RESCAN state
is handled separately.

Fixes: e076145115c0 ("btrfs: qgroup: only set QUOTA_ENABLED when done reading qgroups")
Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/qgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0e4de33e4f28..ce02d6a256ab 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -617,9 +617,12 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 			set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 		if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags))
 			ret = qgroup_rescan_init(fs_info, rescan_progress, 0);
-	} else {
+	}
+
+	if (ret < 0) {
+		clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
-		btrfs_sysfs_del_qgroups(fs_info);
+		btrfs_free_qgroup_config(fs_info);
 	}
 
 	return ret < 0 ? ret : 0;
-- 
2.39.5
