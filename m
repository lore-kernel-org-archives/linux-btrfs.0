Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39592 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752136AbaGGCAc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jul 2014 22:00:32 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: add ask_user confirmation for btrfstune clear seeding flag
Date: Mon, 7 Jul 2014 09:54:52 +0800
Message-ID: <1404698093-4149-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <20140703165145.GG1553@twin.jikos.cz>
References: <20140703165145.GG1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we do the following:
	# mkfs.btrfs -f <dev>
	# mount <dev> <mnt>
	# dd if=/dev/urandom of=<mnt>/data bs=1M count=100
	# umount <dev>
	# btrfstune -S 1 <dev> 		<--- make seeding device
	# mount <dev> <mnt>
	# btrfs dev add -f <dev2> <mnt>
	# umount <dev>
	# btrfstune -S 0 <dev>		<--- clear seeding flag
	# mount <dev2> <mnt>		<=== new device not mountable

When mounting the new device, btrfs will check whether
the seeding flag is set when try to open seeding device.
If the user clears the seeding flag of the seeding device,
the new device will not be mountable. Even set the seeding
flag back will not recovery this problem, because the generation
has been changed. So clear the seeding flag has the chance to
damage the derived new fs.

So I add user confirmation check when clearing seeding flag.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
	v1->v2: add certain scenario description
---
 btrfstune.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/btrfstune.c b/btrfstune.c
index 3f2f0cd..0895204 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -56,6 +56,7 @@ static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 			return 1;
 		}
 		super_flags &= ~BTRFS_SUPER_FLAG_SEEDING;
+		fprintf(stderr, "Warning: Seeding flag cleared.\n");
 	}
 
 	trans = btrfs_start_transaction(root, 1);
@@ -103,6 +104,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
 	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
 	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
+	fprintf(stderr, "\t-f \t\tforce to clear flags, make sure that you are aware of the dangers\n");
 }
 
 int main(int argc, char *argv[])
@@ -113,11 +115,12 @@ int main(int argc, char *argv[])
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
 	int skinny_flag = 0;
+	int force = 0;
 	int ret;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "S:rx");
+		int c = getopt(argc, argv, "S:rxf");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -131,6 +134,9 @@ int main(int argc, char *argv[])
 		case 'x':
 			skinny_flag = 1;
 			break;
+		case 'f':
+			force = 1;
+			break;
 		default:
 			print_usage();
 			return 1;
@@ -169,6 +175,15 @@ int main(int argc, char *argv[])
 	}
 
 	if (seeding_flag) {
+		if (!seeding_value && !force) {
+			fprintf(stderr, "Warning: This is dangerous, clearing the seeding flag may cause the derived device not to be mountable!\n");
+			ret = ask_user("We are going to clear the seeding flag, are you sure?");
+			if (!ret) {
+				fprintf(stderr, "Clear seeding flag canceled\n");
+				return 1;
+			}
+		}
+
 		ret = update_seeding_flag(root, seeding_value);
 		if (!ret)
 			success++;
-- 
1.8.1.4

