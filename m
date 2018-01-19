Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41535 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbeASHZr (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 02:25:47 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: nborisov@suse.com, Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 1/3] btrfs-progs: lowmem fsck: Remove corupted link before re-add correct link
Date: Fri, 19 Jan 2018 15:25:34 +0800
Message-Id: <20180119072536.22286-2-wqu@suse.com>
In-Reply-To: <20180119072536.22286-1-wqu@suse.com>
References: <20180119072536.22286-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For repair_ternary_lowmem() used in lowmem mode, if it found 1 of
DIR_INDEX/DIR_ITEM/INODE_REF missing, it will try to insert correct
link.

However for case like invalid type in DIR_INDEX, we should delete the
corrupted DIR_INDEX first before inserting the correct link.

This patch will remove the corrupted link before re-insert.
This should solve the duplicated DIR_INDEX problem in old lowmem mode
repair.

Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 7fc30da83ea1..f302724dd840 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4997,6 +4997,10 @@ int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
 		goto out;
 	}
 	if (stage == 1) {
+		ret = btrfs_unlink(trans, root, ino, dir_ino, index, name,
+				   name_len, 0);
+		if (ret)
+			goto out;
 		ret = btrfs_add_link(trans, root, ino, dir_ino, name, name_len,
 			       filetype, &index, 1, 1);
 		goto out;
-- 
2.15.1

