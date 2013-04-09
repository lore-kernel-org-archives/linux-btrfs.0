Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:43566 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762521Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUU for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/17] Btrfs-progs: add a function to free subvol_uuid_search memory
Date: Tue,  9 Apr 2013 19:08:33 +0200
Message-Id: <a813c52af05f68e20919be2ba1fc9c01d80ca86d.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was no way to free the memory that was used for the
subvol_uuid_search functions. Since this is part of the libbtrfs,
add such a cleanup function.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 send-utils.c | 23 +++++++++++++++++++++++
 send-utils.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/send-utils.c b/send-utils.c
index b1d3873..182778a 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -304,6 +304,29 @@ out:
 	return ret;
 }
 
+/*
+ * It's safe to call this function even without the subvol_uuid_search_init()
+ * call before as long as the subvol_uuid_search structure is all-zero.
+ */
+void subvol_uuid_search_finit(struct subvol_uuid_search *s)
+{
+	struct rb_root *root = &s->root_id_subvols;
+	struct rb_node *node;
+
+	while ((node = rb_first(root))) {
+		struct subvol_info *entry =
+			rb_entry(node, struct subvol_info, rb_root_id_node);
+
+		free(entry->path);
+		rb_erase(node, root);
+		free(entry);
+	}
+
+	s->root_id_subvols = RB_ROOT;
+	s->local_subvols = RB_ROOT;
+	s->received_subvols = RB_ROOT;
+	s->path_subvols = RB_ROOT;
+}
 
 char *path_cat(const char *p1, const char *p2)
 {
diff --git a/send-utils.h b/send-utils.h
index 199dd03..78abf94 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -62,6 +62,7 @@ struct subvol_uuid_search {
 };
 
 int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s);
+void subvol_uuid_search_finit(struct subvol_uuid_search *s);
 struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 				       u64 root_id, const u8 *uuid, u64 transid,
 				       const char *path,
-- 
1.8.2.1

