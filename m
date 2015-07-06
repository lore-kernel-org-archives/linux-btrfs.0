Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:37729 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbbGFNiK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 09:38:10 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, Jiri Kosina <trivial@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH trivial] Btrfs: Spelling s/consitent/consistent/
Date: Mon,  6 Jul 2015 15:38:11 +0200
Message-Id: <1436189891-10689-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d5f1f033b7a00f3c..bf3c3fbed4b691f7 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -376,7 +376,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 		qgroup = find_qgroup_rb(fs_info, found_key.offset);
 		if ((qgroup && found_key.type == BTRFS_QGROUP_INFO_KEY) ||
 		    (!qgroup && found_key.type == BTRFS_QGROUP_LIMIT_KEY)) {
-			btrfs_err(fs_info, "inconsitent qgroup config");
+			btrfs_err(fs_info, "inconsistent qgroup config");
 			flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		}
 		if (!qgroup) {
-- 
1.9.1

