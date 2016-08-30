Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57662 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751606AbcH3HW0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 03:22:26 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 1E88A4334C75
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 15:22:20 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs-progs: fsck: Check drop level before walking through fs tree
Date: Tue, 30 Aug 2016 15:22:13 +0800
Message-ID: <20160830072217.8599-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
References: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Exposed by fuzzed image from Lukas, which contains invalid drop level
(16), causing segfault when accessing path->nodes[drop_level].

This patch will check drop level against fs tree level and
BTRFS_MAX_LEVEL to avoid such problem.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 1e1f7c9..2aa0a7b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3742,6 +3742,11 @@ static int check_fs_root(struct btrfs_root *root,
 		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
 		level = root_item->drop_level;
 		path.lowest_level = level;
+		if (level > btrfs_header_level(root->node) ||
+		    level >= BTRFS_MAX_LEVEL) {
+			error("ignoring invalid drop level: %u", level);
+			goto skip_walking;
+		}
 		wret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 		if (wret < 0)
 			goto skip_walking;
-- 
2.9.3



