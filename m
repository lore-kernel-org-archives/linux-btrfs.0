Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37807 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751166AbbASH3C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 02:29:02 -0500
From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH v2 1/2] btrfs-progs:btrfstune:force to set seeding flags
Date: Mon, 19 Jan 2015 15:27:30 +0800
Message-ID: <1421652451-994-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now we can use -f with -S option when setting seeding flags or clearing
seeding flags

Reported-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 Documentation/btrfstune.txt |  2 +-
 btrfstune.c                 | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/btrfstune.txt b/Documentation/btrfstune.txt
index d49a974..2448e27 100644
--- a/Documentation/btrfstune.txt
+++ b/Documentation/btrfstune.txt
@@ -25,7 +25,7 @@ Enable extended inode refs.
 -x::
 Enable skinny metadata extent refs.
 -f::
-Allow dangerous changes, e.g. clear the seeding flag
+Force to set or clear seeding flag. Allow dangerous changes, e.g. clear the seeding flag
 
 When mounting the new device, btrfs will check whether the seeding flag is set
 when try to open seeding device.  If the user clears the seeding flag of the
diff --git a/btrfstune.c b/btrfstune.c
index 050418a..15f68c8 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -33,6 +33,7 @@
 #include "version.h"
 
 static char *device;
+static int force = 0;
 
 static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 {
@@ -44,8 +45,10 @@ static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 	super_flags = btrfs_super_flags(disk_super);
 	if (set_flag) {
 		if (super_flags & BTRFS_SUPER_FLAG_SEEDING) {
-			fprintf(stderr, "seeding flag is already set on %s\n",
-				device);
+			if (force)
+				return 0;
+			else
+				fprintf(stderr, "seeding flag is already set on %s\n", device);
 			return 1;
 		}
 		super_flags |= BTRFS_SUPER_FLAG_SEEDING;
@@ -104,7 +107,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
 	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
 	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
-	fprintf(stderr, "\t-f \t\tforce to clear flags, make sure that you are aware of the dangers\n");
+	fprintf(stderr, "\t-f \t\tforce to set or clear flags, make sure that you are aware of the dangers\n");
 }
 
 int main(int argc, char *argv[])
@@ -115,7 +118,6 @@ int main(int argc, char *argv[])
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
 	int skinny_flag = 0;
-	int force = 0;
 	int ret;
 
 	optind = 1;
-- 
1.9.1

