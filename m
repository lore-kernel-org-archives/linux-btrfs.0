Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A0E24BBF4
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 06:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775112264; cv=none; b=sml6+UOBtb4V15ADOWrKQDcWU1I+/+mI1CbGh6hcKSSke4c/ANsH/uYE0H3qSNLcfHV9pkJPqQw1Y7rG7pmbFa3rMRE02wRa5BLfYPCCy37qXJgmatMiIoFqjwhQGKqNzNU2r1P7r5p8SbFF6FZ9TSQanwUS0KI+mjMJ4Q3jMBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775112264; c=relaxed/simple;
	bh=mUlcPKO0SDvJ7NoF1FCmbpc3N6Ocx/ZTCUDPHVXx6TI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LtgtbjTu2mzIlfcb/UpMNEHNv+WlxFuaBoXk3M2e6ZOBdjdieQsD42UcFOcube88VeGHN+DHigcgCWPKq80jpBrEbsOcKDj/2YbX+Z1RIhqgpVnw9uAmiO+SqHoSyqlBj0T/dqWZScgGSUH4mIjOQmxUkTmkde+p/aljHSrNkWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=GW3G7Aet; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="GW3G7Aet"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4fmXQD3m9gzHj7gpH;
	Thu,  2 Apr 2026 14:44:20 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1775112260; bh=mUlcPKO0SDvJ7NoF1FCmbpc3N6Ocx/ZTCUDPHVXx6TI=;
	h=From:To:Cc:Subject:Date;
	b=GW3G7Aeth2WQNZT1NmrLY4JP8axvg+w64n3KBGhFnW93a4Sr1bmPs+ljkso/8JNLN
	 xnt1pa3aVxRA+fBwEFz8YDSC9vS7dOgkTxfm6MKAVUCnDa7hJM5G+zGJrd6cC7lS3X
	 OBujMnPMZPbWYrH62l0m/l1faBXKhuqn34cwZNxU=
From: Dave Chen <davechen@synology.com>
To: linux-btrfs@vger.kernel.org,
	dsterba@suse.com
Cc: cccheng@synology.com,
	robbieko@synology.com,
	Dave Chen <davechen@synology.com>
Subject: [PATCH] btrfs: fix unnecessary UUID tree rescan on mount
Date: Thu,  2 Apr 2026 14:43:48 +0800
Message-ID: <20260402064348.2807138-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
Content-Type: text/plain

The UUID tree rescan check in open_ctree() compares
fs_info->generation with the superblock's uuid_tree_generation.
This comparison can produce false positives because
fs_info->generation is bumped at transaction start time in
join_transaction(), while uuid_tree_generation is only updated at
commit time via update_super_roots().

Between the early BTRFS_FS_UPDATE_UUID_TREE_GEN flag check and the
late rescan decision, mount operations such as orphan cleanup start
transactions without committing them. This advances
fs_info->generation past uuid_tree_generation, triggering an
unnecessary full UUID tree rescan on every mount that recovers
file orphans from an unclean shutdown.

Fix this by using the BTRFS_FS_UPDATE_UUID_TREE_GEN flag directly,
which was already set earlier when the generations were known to
match, and is not invalidated by subsequent transaction starts.

Fixes: 70f80175472 ("Btrfs: check UUID tree during mount if required")
Signed-off-by: Dave Chen <davechen@synology.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1b0eb246b7147..70357b12508d0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3674,7 +3674,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	if (fs_info->uuid_root &&
 	    (btrfs_test_opt(fs_info, RESCAN_UUID_TREE) ||
-	     fs_info->generation != btrfs_super_uuid_tree_generation(disk_super))) {
+	     !test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))) {
 		btrfs_info(fs_info, "checking UUID tree");
 		ret = btrfs_check_uuid_tree(fs_info);
 		if (ret) {
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
