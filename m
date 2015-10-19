Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34104 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbbJSLtI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:49:08 -0400
Received: by padhk11 with SMTP id hk11so28288278pad.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:49:08 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 09/10] btrfs-progs: fix memory leak in cmd_qgroup_show()
Date: Mon, 19 Oct 2015 19:37:59 +0800
Message-Id: <1445254680-11102-10-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

filter_set and comparer_set should be freed on return.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-qgroup.c | 2 ++
 qgroup.c      | 1 +
 2 files changed, 3 insertions(+)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 48c1733..82bd2e2 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -354,6 +354,8 @@ static int cmd_qgroup_show(int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		btrfs_qgroup_free_filter_set(filter_set);
+		btrfs_qgroup_free_comparer_set(comparer_set);
 		return 1;
 	}
 
diff --git a/qgroup.c b/qgroup.c
index ec9a3ac..0272aa8 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1211,6 +1211,7 @@ int btrfs_show_qgroups(int fd,
 
 	__free_all_qgroups(&qgroup_lookup);
 	btrfs_qgroup_free_filter_set(filter_set);
+	btrfs_qgroup_free_comparer_set(comp_set);
 	return ret;
 }
 
-- 
2.4.3

