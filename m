Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:22627 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754690AbcLOEbN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 23:31:13 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D1E63AC00B2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 13:31:08 +0900 (JST)
Message-Id: <201612150430.AA00025@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 15 Dec 2016 13:30:55 +0900
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 2/2] btrfs-progs: qgroup: change the value of sort option
In-Reply-To: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value of sort option ('S') is not used for option letter.
Therefore, I'll change the single letter to non-character.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
This patch is separated from patch of --sync option.
---
 cmds-qgroup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 2a10c97..34e3bcc 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -313,10 +313,11 @@ static int cmd_qgroup_show(int argc, char **argv)
 	while (1) {
 		int c;
 		enum {
-			GETOPT_VAL_SYNC = 256
+			GETOPT_VAL_SORT = 256,
+			GETOPT_VAL_SYNC
 		};
 		static const struct option long_options[] = {
-			{"sort", required_argument, NULL, 'S'},
+			{"sort", required_argument, NULL, GETOPT_VAL_SORT},
 			{"sync", no_argument, NULL, GETOPT_VAL_SYNC},
 			{ NULL, 0, NULL, 0 }
 		};
@@ -347,7 +348,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 		case 'f':
 			filter_flag |= 0x2;
 			break;
-		case 'S':
+		case GETOPT_VAL_SORT:
 			ret = btrfs_qgroup_parse_sort_string(optarg,
 							     &comparer_set);
 			if (ret)
-- 
2.9.3
