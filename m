Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:31616 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdHXFZn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 01:25:43 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id ABBD2AC0185
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 14:25:36 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id DEE466926E5
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 14:25:35 +0900 (JST)
Subject: [PATCH 3/3] btrfs-progs: fix option handling for some commands
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <2ea1dea7-13b5-b984-03ce-2d88d4f9d220@jp.fujitsu.com>
Message-ID: <e0101e20-6536-9b84-2808-242408af3e0f@jp.fujitsu.com>
Date: Thu, 24 Aug 2017 14:25:29 +0900
MIME-Version: 1.0
In-Reply-To: <2ea1dea7-13b5-b984-03ce-2d88d4f9d220@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes "btrfs inspect-internal dump-super --bytenr"

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
  cmds-inspect-dump-super.c | 7 +++++++
  1 file changed, 7 insertions(+)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 98e0270..c7afd80 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -519,11 +519,13 @@ int cmd_inspect_dump_super(int argc, char **argv)

  	while (1) {
  		int c;
+		enum { GETOPT_VAL_BYTENR = 257 };
  		static const struct option long_options[] = {
  			{"all", no_argument, NULL, 'a'},
  			{"full", no_argument, NULL, 'f'},
  			{"force", no_argument, NULL, 'F'},
  			{"super", required_argument, NULL, 's' },
+			{"bytenr", required_argument, NULL, GETOPT_VAL_BYTENR },
  			{NULL, 0, NULL, 0}
  		};

@@ -565,6 +567,11 @@ int cmd_inspect_dump_super(int argc, char **argv)
  			}
  			all = 0;
  			break;
+		case GETOPT_VAL_BYTENR:
+			arg = arg_strtou64(optarg);
+			sb_bytenr = arg;
+			all = 0;
+			break;
  		default:
  			usage(cmd_inspect_dump_super_usage);
  		}
-- 
2.9.4

