Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:43321 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752541AbeAQIil (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 03:38:41 -0500
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 33B1FAC0090
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jan 2018 17:38:37 +0900 (JST)
Subject: [PATCH 2/2] btrfs: remove unused arg from parse_subvol_options()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Anand Jain <anand.jain@oracle.com>
References: <7fba2dc9-44a9-4317-b9fd-263b2a687e9a@jp.fujitsu.com>
Message-ID: <557567d8-1557-389b-81b6-bb269c147320@jp.fujitsu.com>
Date: Wed, 17 Jan 2018 17:38:31 +0900
MIME-Version: 1.0
In-Reply-To: <7fba2dc9-44a9-4317-b9fd-263b2a687e9a@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unused arg 'holder' from parse_subvol_options(), which has been
forgotten to be cleaned in the commit b99beb110e2d ("btrfs: split
parse_early_options() in two").

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6ff13948b655..36fcdaf904b3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -926,7 +926,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
  * The value is later passed to mount_subvol()
  */
 static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
-		void *holder, char **subvol_name, u64 *subvol_objectid)
+		char **subvol_name, u64 *subvol_objectid)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *opts, *orig, *p;
@@ -1644,7 +1644,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	if (!(flags & SB_RDONLY))
 		mode |= FMODE_WRITE;
 
-	error = btrfs_parse_subvol_options(data, mode, fs_type,
+	error = btrfs_parse_subvol_options(data, mode,
 					  &subvol_name, &subvol_objectid);
 	if (error) {
 		kfree(subvol_name);
-- 
2.14.3

