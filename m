Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:45525 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbcCNANV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 20:13:21 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id C1FC4AC01D4
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 09:13:11 +0900 (JST)
Subject: [PATCH 2/4] btrfs-progs: fix a reression that "property" with -t
 option doesn't work
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56E5FF9A.4020609@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56E601F4.9070908@jp.fujitsu.com>
Date: Mon, 14 Mar 2016 09:12:36 +0900
MIME-Version: 1.0
In-Reply-To: <56E5FF9A.4020609@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"property" is considered as working without any options
from the following commit.

commit 176aeca9a148 ("btrfs-progs: add getopt stubs where needed")

However, we can pass -t option to this command.

* actual result

  ==================================================
  # ./btrfs prop list -t f /btrfs
  btrfs property list: invalid option -- 't'
  usage: btrfs property list [-t <type>] <object>

      Lists available properties with their descriptions for the given object.

      Please see the help of 'btrfs property get' for a description of
      objects and object types.
  ==================================================

* expected result

  ==================================================
  # btrfs prop list -t f /btrfs
  label               Set/get label of device
  ==================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 cmds-property.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index 5b4da26..4c2beb7 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -379,9 +379,7 @@ static int cmd_property_get(int argc, char **argv)
 	char *name = NULL;
 	int types = 0;

-	clean_args_no_options(argc, argv, cmd_property_get_usage);
-
-	if (check_argc_min(argc, 2) || check_argc_max(argc, 5))
+	if (check_argc_min(argc, 2))
 		usage(cmd_property_get_usage);

 	parse_args(argc, argv, cmd_property_get_usage, &types, &object, &name,
@@ -415,9 +413,7 @@ static int cmd_property_set(int argc, char **argv)
 	char *value = NULL;
 	int types = 0;

-	clean_args_no_options(argc, argv, cmd_property_set_usage);
-
-	if (check_argc_min(argc, 4) || check_argc_max(argc, 6))
+	if (check_argc_min(argc, 4))
 		usage(cmd_property_set_usage);

 	parse_args(argc, argv, cmd_property_set_usage, &types,
@@ -446,9 +442,7 @@ static int cmd_property_list(int argc, char **argv)
 	char *object = NULL;
 	int types = 0;

-	clean_args_no_options(argc, argv, cmd_property_list_usage);
-
-	if (check_argc_min(argc, 2) || check_argc_max(argc, 4))
+	if (check_argc_min(argc, 2))
 		usage(cmd_property_list_usage);

 	parse_args(argc, argv, cmd_property_list_usage,
-- 
2.7.0
