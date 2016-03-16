Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:48562 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbcCPCPu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 22:15:50 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id C10D6AC0136
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 11:15:46 +0900 (JST)
Subject: [PATCH 2/2 v2] btrfs-progs: Fix a regression that "property" with -t
 option doesn't work
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56E8BE67.6030802@jp.fujitsu.com>
 <56E8C0BB.1050307@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56E8C1CE.7060806@jp.fujitsu.com>
Date: Wed, 16 Mar 2016 11:15:42 +0900
MIME-Version: 1.0
In-Reply-To: <56E8C0BB.1050307@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I forgot to add "btrfs-progs: " in the subject line.
---
"property" is considered as working without any options
from the following commit.

commit 176aeca9a148 ("btrfs-progs: add getopt stubs where needed")

However, we can pass -t option to this command.

* actual result

  ==================================================
  $ ./btrfs prop list -t f /btrfs
  btrfs property list: invalid option -- 't'
  usage: btrfs property list [-t <type>] <object>

      Lists available properties with their descriptions for the given object.

      Please see the help of 'btrfs property get' for a description of
      objects and object types.

  ==================================================

* expected result

  ==================================================
  $ ./btrfs prop list -t f /btrfs
  label               Set/get label of device.
  ==================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com
---
v2: Reflect David's comment.
  - Check the number of non-option arguments
---
 cmds-property.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index 5b4da26..eed5f4a 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -294,10 +294,11 @@ out:
 static void parse_args(int argc, char **argv,
 		       const char * const *usage_str,
 		       int *types, char **object,
-		       char **name, char **value)
+		       char **name, char **value, int min_nonopt_args)
 {
 	int ret;
 	char *type_str = NULL;
+	int max_nonopt_args = 0;

 	optind = 1;
 	while (1) {
@@ -314,6 +315,17 @@ static void parse_args(int argc, char **argv,
 		}
 	}

+	if (object)
+		max_nonopt_args++;
+	if (name)
+		max_nonopt_args++;
+	if (value)
+		max_nonopt_args++;
+
+	if (check_argc_min(argc - optind, min_nonopt_args) ||
+	    check_argc_max(argc - optind, max_nonopt_args))
+		usage(usage_str);
+
 	*types = 0;
 	if (type_str) {
 		if (!strcmp(type_str, "s") || !strcmp(type_str, "subvol")) {
@@ -379,13 +391,8 @@ static int cmd_property_get(int argc, char **argv)
 	char *name = NULL;
 	int types = 0;

-	clean_args_no_options(argc, argv, cmd_property_get_usage);
-
-	if (check_argc_min(argc, 2) || check_argc_max(argc, 5))
-		usage(cmd_property_get_usage);
-
 	parse_args(argc, argv, cmd_property_get_usage, &types, &object, &name,
-			NULL);
+		   NULL, 1);
 	if (!object) {
 		error("invalid arguments");
 		usage(cmd_property_get_usage);
@@ -415,13 +422,8 @@ static int cmd_property_set(int argc, char **argv)
 	char *value = NULL;
 	int types = 0;

-	clean_args_no_options(argc, argv, cmd_property_set_usage);
-
-	if (check_argc_min(argc, 4) || check_argc_max(argc, 6))
-		usage(cmd_property_set_usage);
-
 	parse_args(argc, argv, cmd_property_set_usage, &types,
-			&object, &name, &value);
+		   &object, &name, &value, 3);
 	if (!object || !name || !value) {
 		error("invalid arguments");
 		usage(cmd_property_set_usage);
@@ -446,13 +448,8 @@ static int cmd_property_list(int argc, char **argv)
 	char *object = NULL;
 	int types = 0;

-	clean_args_no_options(argc, argv, cmd_property_list_usage);
-
-	if (check_argc_min(argc, 2) || check_argc_max(argc, 4))
-		usage(cmd_property_list_usage);
-
 	parse_args(argc, argv, cmd_property_list_usage,
-			&types, &object, NULL, NULL);
+		   &types, &object, NULL, NULL, 1);
 	if (!object) {
 		error("invalid arguments");
 		usage(cmd_property_list_usage);
-- 
2.5.0
