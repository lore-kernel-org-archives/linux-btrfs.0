Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:48204 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765530Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUX for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/17] Btrfs-progs: Set the root-id for received subvols in btrfs receive
Date: Tue,  9 Apr 2013 19:08:36 +0200
Message-Id: <68d8e4735895de4f99a49484a14d34b69962ae17.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When an entry was added to the subvol search tree, the root_id was
always 0 (not set at all) and therefore only the first one was
added, all the others had been ignored. This commit adds a function
to retrieve the root_id for a given fd, and this function is used
to set the root_id before the entry is added.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c |  3 +++
 send-utils.c   | 20 ++++++++++++++++++++
 send-utils.h   |  1 +
 3 files changed, 24 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index dc72e9e..eedff13 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -125,6 +125,9 @@ static int finish_subvol(struct btrfs_receive *r)
 		goto out;
 	}
 
+	ret = btrfs_get_root_id(subvol_fd, &r->cur_subvol->root_id);
+	if (ret < 0)
+		goto out;
 	subvol_uuid_search_add(&r->sus, r->cur_subvol);
 	r->cur_subvol = NULL;
 	ret = 0;
diff --git a/send-utils.c b/send-utils.c
index 182778a..b2d544c 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -23,6 +23,26 @@
 #include "ioctl.h"
 #include "btrfs-list.h"
 
+int btrfs_get_root_id(int fd, u64 *root_id)
+{
+	struct btrfs_ioctl_ino_lookup_args ino_args;
+	int ret;
+
+	memset(&ino_args, 0, sizeof(ino_args));
+	ino_args.objectid = BTRFS_FIRST_FREE_OBJECTID;
+
+	/* this ioctl fills in ino_args->treeid */
+	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &ino_args);
+	if (ret) {
+		fprintf(stderr, "ERROR: Failed to lookup root_id - %s\n",
+			strerror(errno));
+		return ret;
+	}
+
+	*root_id = ino_args.treeid;
+	return 0;
+}
+
 static struct rb_node *tree_insert(struct rb_root *root,
 				   struct subvol_info *si,
 				   enum subvol_search_type type)
diff --git a/send-utils.h b/send-utils.h
index 78abf94..3c8b7b7 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -61,6 +61,7 @@ struct subvol_uuid_search {
 	struct rb_root path_subvols;
 };
 
+int btrfs_get_root_id(int fd, u64 *root_id);
 int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s);
 void subvol_uuid_search_finit(struct subvol_uuid_search *s);
 struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
-- 
1.8.2.1

