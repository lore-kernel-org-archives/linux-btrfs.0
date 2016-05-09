Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:23550 "EHLO
	mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbcEIHwo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 03:52:44 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id CFE13AC00EC
	for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2016 16:52:39 +0900 (JST)
Subject: [PATCH 3/3] btrfs-progs: prop: remove conditions which never be
 satisfied
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <57303A21.9070308@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <573041AB.8090603@jp.fujitsu.com>
Date: Mon, 9 May 2016 16:52:11 +0900
MIME-Version: 1.0
In-Reply-To: <57303A21.9070308@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

parse_args() always set at least one parameter, 'object', for
{get,list} subcommands. In addition, it always set all three
parameters, 'object', 'name', and 'value' for set subcommand.
So the following conditions can be removed.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 cmds-property.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index 46be8f3..e59882b 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -385,10 +385,6 @@ static int cmd_property_get(int argc, char **argv)

 	parse_args(argc, argv, cmd_property_get_usage, &types, &object, &name,
 		   NULL, 1);
-	if (!object) {
-		error("invalid arguments");
-		usage(cmd_property_get_usage);
-	}

 	if (name)
 		ret = setget_prop(types, object, name, NULL);
@@ -416,10 +412,6 @@ static int cmd_property_set(int argc, char **argv)

 	parse_args(argc, argv, cmd_property_set_usage, &types,
 		   &object, &name, &value, 3);
-	if (!object || !name || !value) {
-		error("invalid arguments");
-		usage(cmd_property_set_usage);
-	}

 	ret = setget_prop(types, object, name, value);

@@ -442,10 +434,6 @@ static int cmd_property_list(int argc, char **argv)

 	parse_args(argc, argv, cmd_property_list_usage,
 		   &types, &object, NULL, NULL, 1);
-	if (!object) {
-		error("invalid arguments");
-		usage(cmd_property_list_usage);
-	}

 	ret = dump_props(types, object, 1);

-- 
2.5.5
