Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55959 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbcAFJCo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jan 2016 04:02:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aGjzO-0004X9-5S
	for linux-btrfs@vger.kernel.org; Wed, 06 Jan 2016 10:02:42 +0100
Received: from host-78-149-214-223.as13285.net ([78.149.214.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 10:02:42 +0100
Received: from samtygier by host-78-149-214-223.as13285.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 10:02:42 +0100
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: [PATCH v3] Btrfs: Check metadata redundancy on balance
Date: Wed, 6 Jan 2016 09:02:31 +0000
Message-ID: <568CD827.3060601@yahoo.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: dave@jikos.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sam Tygier <samtygier@yahoo.co.uk>
Date: Wed, 6 Jan 2016 08:46:12 +0000
Subject: [PATCH] Btrfs: Check metadata redundancy on balance

When converting a filesystem via balance check that metadata mode
is at least as redundant as the data mode. For example give warning
when:
-dconvert=raid1 -mconvert=single

Signed-off-by: Sam Tygier <samtygier@yahoo.co.uk>
---
v3:
  Use btrfs_warn()
  Mention profiles in message
v2:
  Use btrfs_get_num_tolerated_disk_barrier_failures()
---
 fs/btrfs/volumes.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a23399e..be91458 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3756,6 +3756,14 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		}
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
+	if (btrfs_get_num_tolerated_disk_barrier_failures(bctl->meta.target) <
+		btrfs_get_num_tolerated_disk_barrier_failures(bctl->data.target)) {
+		btrfs_warn(fs_info,
+			"Warning: metatdata profile %llu has lower redundancy "
+		        "than data profile %llu\n", bctl->meta.target,
+		        bctl->data.target);
+	}
+
 	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
 		fs_info->num_tolerated_disk_barrier_failures = min(
 			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info),
-- 
2.4.3

