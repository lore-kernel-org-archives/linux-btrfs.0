Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:22916 "EHLO
	mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbcEIHuR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 03:50:17 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 22A17AC00D5
	for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2016 16:50:09 +0900 (JST)
Subject: [PATCH 2/3] btrfs-progs: prop: simplify parse_args()
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <57303A21.9070308@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <573040FF.5060601@jp.fujitsu.com>
Date: Mon, 9 May 2016 16:49:19 +0900
MIME-Version: 1.0
In-Reply-To: <57303A21.9070308@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since <object> parameter is mandatory for all subcommands,
'object' is always set by parse_args()'s callers.
In addition, on setting '*name' and '*value', if 'optind < argc'
is satisfied here, they are always set by parse_args()'s callers.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 cmds-property.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index 48a8945..46be8f3 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -298,7 +298,7 @@ static void parse_args(int argc, char **argv,
 {
 	int ret;
 	char *type_str = NULL;
-	int max_nonopt_args = 0;
+	int max_nonopt_args = 1;

 	optind = 1;
 	while (1) {
@@ -315,8 +315,6 @@ static void parse_args(int argc, char **argv,
 		}
 	}

-	if (object)
-		max_nonopt_args++;
 	if (name)
 		max_nonopt_args++;
 	if (value)
@@ -345,14 +343,13 @@ static void parse_args(int argc, char **argv,
 		}
 	}

-	if (object && optind < argc)
-		*object = argv[optind++];
-	if (name && optind < argc)
+	*object = argv[optind++];
+	if (optind < argc)
 		*name = argv[optind++];
-	if (value && optind < argc)
+	if (optind < argc)
 		*value = argv[optind++];

-	if (!*types && object && *object) {
+	if (!*types) {
 		ret = autodetect_object_types(*object, types);
 		if (ret < 0) {
 			error("failed to detect object type: %s",
-- 
2.5.5
