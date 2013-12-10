Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab3LJRRN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 12:17:13 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1CA52A7EE5
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 18:17:12 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: convert remaining uuid buffer declarations to BTRFS_UUID_UNPARSED_SIZE
Date: Tue, 10 Dec 2013 18:17:10 +0100
Message-Id: <1386695830-8682-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-receive.c | 6 +++---
 print-tree.c   | 2 +-
 send-test.c    | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 95dc3ec4cafa..ed4410761b3e 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -78,7 +78,7 @@ static int finish_subvol(struct btrfs_receive *r)
 	int ret;
 	int subvol_fd = -1;
 	struct btrfs_ioctl_received_subvol_args rs_args;
-	char uuid_str[128];
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
 	u64 flags;
 
 	if (r->cur_subvol == NULL)
@@ -149,7 +149,7 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 	int ret;
 	struct btrfs_receive *r = user;
 	struct btrfs_ioctl_vol_args args_v1;
-	char uuid_str[128];
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
 
 	ret = finish_subvol(r);
 	if (ret < 0)
@@ -196,7 +196,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 {
 	int ret;
 	struct btrfs_receive *r = user;
-	char uuid_str[128];
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
 	struct btrfs_ioctl_vol_args_v2 args_v2;
 	struct subvol_info *parent_subvol = NULL;
 
diff --git a/print-tree.c b/print-tree.c
index 716f4d371449..9b90f9b5dd40 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -378,7 +378,7 @@ static void print_root(struct extent_buffer *leaf, int slot)
 	struct btrfs_root_item *ri;
 	struct btrfs_root_item root_item;
 	int len;
-	char uuid_str[128];
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
 
 	ri = btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
 	len = btrfs_item_size_nr(leaf, slot);
diff --git a/send-test.c b/send-test.c
index a37b7fd61487..5f7c31117a58 100644
--- a/send-test.c
+++ b/send-test.c
@@ -72,7 +72,7 @@ static int print_subvol(const char *path, const u8 *uuid, u64 ctransid,
 			void *user)
 {
 	struct recv_args *r = user;
-	char uuid_str[128];
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
 
 	r->full_subvol_path = path_cat(r->root_path, path);
 	uuid_unparse(uuid, uuid_str);
@@ -88,8 +88,8 @@ static int print_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 			  void *user)
 {
 	struct recv_args *r = user;
-	char uuid_str[128];
-	char parent_uuid_str[128];
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
+	char parent_uuid_str[BTRFS_UUID_UNPARSED_SIZE];
 
 	r->full_subvol_path = path_cat(r->root_path, path);
 	uuid_unparse(uuid, uuid_str);
-- 
1.8.5

