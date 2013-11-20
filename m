Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab3KTVvb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 16:51:31 -0500
Message-ID: <528D2E9F.6070101@suse.com>
Date: Wed, 20 Nov 2013 16:50:23 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Cc: Kees Cook <keescook@chromium.org>, Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] btrfs: fix static checker warnings
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes the following warnings:
fs/btrfs/extent-tree.c:6201:12: sparse: symbol 'get_raid_name' was not declared. Should it be static?
fs/btrfs/extent-tree.c:8430:9: error: format not a string literal and no format arguments [-Werror=format-security] get_raid_name(index));

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/extent-tree.c	2013-11-20 12:21:23.969683074 -0500
+++ b/fs/btrfs/extent-tree.c	2013-11-20 14:43:34.494306159 -0500
@@ -6119,7 +6119,7 @@ static const char *btrfs_raid_type_names
 	[BTRFS_RAID_RAID6]	= "raid6",
 };
 
-const char *get_raid_name(enum btrfs_raid_types type)
+static const char *get_raid_name(enum btrfs_raid_types type)
 {
 	if (type >= BTRFS_NR_RAID_TYPES)
 		return NULL;
@@ -8328,7 +8328,7 @@ static void __link_block_group(struct bt
 
 		kobject_get(&space_info->kobj); /* put in release */
 		ret = kobject_init_and_add(kobj, &btrfs_raid_ktype,
-					   &space_info->kobj,
+					   &space_info->kobj, "%s",
 					   get_raid_name(index));
 		if (ret) {
 			pr_warn("btrfs: failed to add kobject for block cache. ignoring.\n");


-- 
Jeff Mahoney
SUSE Labs
