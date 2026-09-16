Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162E93655D6
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 03:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528518; cv=none; b=UhuqGRSHJ6OtEIJF8t2W72jnePg3uCRd97hW+quh+c5ykvkij0rT9DdaPQSUUicJNZpwWcqucTLFUeerC+v1JGDDno4Lunr7vxAZZ17h33QPhoJYiwYS2ZFcaoY1Y4Xz6WmmSeZogVy2XArw+0N8TE11r/SWEDrKRIxizTqW1nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528518; c=relaxed/simple;
	bh=utZt0I5l7Uc0gExXly27wh6dJVM95FkqMism0g9pXBE=;
	h=Subject:From:Message-Id:Mime-Version:References:Content-Type:Date:
	 To:In-Reply-To; b=ixp2VaqCqxeqrKDIAfkKcXeuJ/vRqS20OuQ1KD+QtT0DFmfrdGmJfbBHX6PURfCd9LQ0+S30o2sDJhPdvHcyzSw6Dx3bt+uahDDItF4ajL7b918EB4iL5t7azn5i97OVkW4kMoNdGJlDfGwElUbeztbjsN/DaARH083Q5xSyqhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=LsCcMRr3; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="LsCcMRr3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789528506;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=tuIEqTWjKpfGaxzw88S0BqTEmqDHduf1aKAcdmbSLeQ=;
 b=LsCcMRr3zvrUsZBci+s0Ofve5YzwX8UYyes7neqI8a0LY1HhlvaefXyt3YhQTz0P+5f9Nh
 MUY4R/FOXzdDz564jkPBtWwxT0ab9yXmA02c20DtCNXXtNAQWqHa5izQFN3eomybXUU7NN
 Rye/BfUUpaxiI+PiN2dHLCqpXm21fbBV4ikpck6JfR9PcvGSFX2j52M9iZPA5G82RevoUS
 jrtguk2B9wtDaUrOpr8rfxx/yaD1lfZOopo5bREbNojfM9VAxOQ1hu2BbWbAM9COoq54N8
 wqSBC2JL2AYQUmbT/6Ikw9vxclEWG5gb68NSEmCJDl33IAIKj7OQvqGX5yHOOA==
Subject: [RFC PATCH 5/5] btrfs: qgroup: fix rescan handling during remount
X-Mailer: git-send-email 2.39.5
X-Lms-Return-Path: <lba+26aaa09b9+0ecfe1+vger.kernel.org+zhudongjiang@fygo.io>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Message-Id: <6e1accfc2487250fdf5d5b1dc397434b5f854242.1789524388.git.zhudongjiang@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from pdzhu.teiron-inc.cn ([183.34.164.60]) by smtp.larksuite.com with ESMTPS; Wed, 16 Sep 2026 03:15:05 +0000
References: <cover.1789524388.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 16 Sep 2026 11:14:53 +0800
To: <linux-btrfs@vger.kernel.org>
Content-Transfer-Encoding: 7bit
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
In-Reply-To: <cover.1789524388.git.zhudongjiang@fygo.io>

There are two problems with qgroup rescan handling during remount.

First, the rescan worker stops whenever BTRFS_FS_STATE_REMOUNTING is
set. This is a transient state used for all remount operations,
including read-write to read-write remounts. A read-write to read-write
remount can therefore stop a rescan even though the filesystem remains
writable, and there is no corresponding resume path. Check the actual
read-only state instead, so the worker only stops when the filesystem is
becoming read-only.

Second, during a read-only to read-write remount,
btrfs_qgroup_rescan_resume() is called from the pre-RW setup. At that
point the filesystem is still read-only and the remount is still in
progress, so the resumed worker can immediately stop again.

Move rescan resume out of btrfs_start_pre_rw_mount() and into its
callers. On a read-only to read-write remount, resume after
btrfs_clear_sb_rdonly(). On an initial read-write mount, resume after
the pre-RW setup succeeds. In both paths, place the call next to
discard resume.

Update the rescan resume comment for its additional remount caller.

Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/disk-io.c | 3 +--
 fs/btrfs/qgroup.c  | 6 +++---
 fs/btrfs/super.c   | 1 +
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a1d83ad9a4c0..46b081586883 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3183,8 +3183,6 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 		return ret;
 	}
 
-	btrfs_qgroup_rescan_resume(fs_info);
-
 	if (!fs_info->uuid_root) {
 		btrfs_info(fs_info, "creating UUID tree");
 		ret = btrfs_create_uuid_tree(fs_info);
@@ -3779,6 +3777,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		return ret;
 	}
 	btrfs_discard_resume(fs_info);
+	btrfs_qgroup_rescan_resume(fs_info);
 
 	if (fs_info->uuid_root &&
 	    (btrfs_test_opt(fs_info, RESCAN_UUID_TREE) ||
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c1e58e84a86f..2df581a498be 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3859,7 +3859,7 @@ static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
 {
 	if (btrfs_fs_closing(fs_info))
 		return true;
-	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
+	if (test_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state))
 		return true;
 	if (!btrfs_qgroup_enabled(fs_info))
 		return true;
@@ -4130,8 +4130,8 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
 }
 
 /*
- * this is only called from open_ctree where we're still single threaded, thus
- * locking is omitted here.
+ * Called during initial read-write mount or read-only to read-write remount,
+ * while userspace writes are still blocked.
  */
 void
 btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 464129b1b0d4..cfbe26747a5b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1331,6 +1331,7 @@ static int btrfs_remount_rw(struct btrfs_fs_info *fs_info)
 	 * sync/async discard lists in the right state.
 	 */
 	btrfs_discard_resume(fs_info);
+	btrfs_qgroup_rescan_resume(fs_info);
 
 	return 0;
 }
-- 
2.39.5
