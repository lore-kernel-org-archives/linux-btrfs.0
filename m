Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:59655 "EHLO
	mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbcCRBfc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 21:35:32 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 24BE9AC044B
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 10:35:22 +0900 (JST)
Subject: [PATCH 4/5] btrfs-progs: "qgroup assign" can't handle options
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56EB5B53.1010806@jp.fujitsu.com>
Date: Fri, 18 Mar 2016 10:35:15 +0900
MIME-Version: 1.0
In-Reply-To: <56EB5937.8070208@jp.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <56EB5937.8070208@jp.fujitsu.com>

"qgroup assign" is considered as working without any options
from the following commit.

commit 176aeca9a148 ("btrfs-progs: add getopt stubs where needed")

However, we can pass options to this command.

* actual result

   ==================================================
   # ./btrfs qgroup assign --rescan 0/260 1/261 /btrfs
   btrfs qgroup assign: unrecognized option '--rescan'
   usage: btrfs qgroup assign [options] <src> <dst> <path>

       Assign SRC as the child qgroup of DST

       --rescan       schedule qutoa rescan if needed
       --no-rescan

   ==================================================

* expected result

   ==================================================
   # ./btrfs qgroup assign --rescan 0/260 1/261 /btrfs
   #
   ==================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  cmds-qgroup.c | 62 ++++++++++++++++++++++++-----------------------------------
  1 file changed, 25 insertions(+), 37 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 7ae2253..ebd66ef 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -32,7 +32,8 @@ static const char * const qgroup_cmd_group_usage[] = {
  	NULL
  };

-static int _cmd_qgroup_assign(int assign, int argc, char **argv)
+static int _cmd_qgroup_assign(int assign, int argc, char **argv,
+			      const char * const *usage_str)
  {
  	int ret = 0;
  	int fd;
@@ -41,28 +42,31 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv)
  	struct btrfs_ioctl_qgroup_assign_args args;
  	DIR *dirstream = NULL;

-	while (1) {
-		enum { GETOPT_VAL_RESCAN = 256 };
-		static const struct option long_options[] = {
-			{ "rescan", no_argument, NULL, GETOPT_VAL_RESCAN },
-			{ NULL, 0, NULL, 0 }
-		};
-		int c = getopt_long(argc, argv, "", long_options, NULL);
-
-		if (c < 0)
-			break;
-		switch (c) {
-		case GETOPT_VAL_RESCAN:
-			rescan = 1;
-			break;
-		default:
-			/* Usage printed by the caller */
-			return -1;
+	if (assign) {
+		while (1) {
+			enum { GETOPT_VAL_RESCAN = 256 };
+			static const struct option long_options[] = {
+				{ "rescan", no_argument, NULL, GETOPT_VAL_RESCAN },
+				{ NULL, 0, NULL, 0 }
+			};
+			int c = getopt_long(argc, argv, "", long_options, NULL);
+
+			if (c < 0)
+				break;
+			switch (c) {
+			case GETOPT_VAL_RESCAN:
+				rescan = 1;
+				break;
+			default:
+				usage(usage_str);
+			}
  		}
+	} else {
+		clean_args_no_options(argc, argv, usage_str);
  	}

  	if (check_argc_exact(argc - optind, 3))
-		return -1;
+		usage(usage_str);

  	memset(&args, 0, sizeof(args));
  	args.assign = assign;
@@ -208,15 +212,7 @@ static const char * const cmd_qgroup_assign_usage[] = {

  static int cmd_qgroup_assign(int argc, char **argv)
  {
-	int ret;
-
-	clean_args_no_options(argc, argv, cmd_qgroup_assign_usage);
-
-	ret = _cmd_qgroup_assign(1, argc, argv);
-
-	if (ret < 0)
-		usage(cmd_qgroup_assign_usage);
-	return ret;
+	return _cmd_qgroup_assign(1, argc, argv, cmd_qgroup_assign_usage);
  }

  static const char * const cmd_qgroup_remove_usage[] = {
@@ -227,15 +223,7 @@ static const char * const cmd_qgroup_remove_usage[] = {

  static int cmd_qgroup_remove(int argc, char **argv)
  {
-	int ret;
-
-	clean_args_no_options(argc, argv, cmd_qgroup_remove_usage);
-
-	ret = _cmd_qgroup_assign(0, argc, argv);
-
-	if (ret < 0)
-		usage(cmd_qgroup_remove_usage);
-	return ret;
+	return _cmd_qgroup_assign(0, argc, argv, cmd_qgroup_remove_usage);
  }

  static const char * const cmd_qgroup_create_usage[] = {
-- 
2.7.0
