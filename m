Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:47267 "EHLO
	mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbcDTGdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Apr 2016 02:33:39 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 5E4DCAC00ED
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Apr 2016 15:33:32 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: prop: remove an unnecessary condition on
 parse_args
Message-ID: <57172290.1030005@jp.fujitsu.com>
Date: Wed, 20 Apr 2016 15:32:48 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From commit c742debab11f ('btrfs-progs: fix a regression that
"property" with -t option doesn't work'), the number of arguments
is checked strictly. So the following condition never be
satisfied.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 cmds-property.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index eed5f4a..48a8945 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -352,11 +352,6 @@ static void parse_args(int argc, char **argv,
 	if (value && optind < argc)
 		*value = argv[optind++];

-	if (optind != argc) {
-		error("unexpected agruments found");
-		usage(usage_str);
-	}
-
 	if (!*types && object && *object) {
 		ret = autodetect_object_types(*object, types);
 		if (ret < 0) {
-- 
2.5.5
