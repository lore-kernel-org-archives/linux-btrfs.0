Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:47577 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdHXFSk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 01:18:40 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9EA59AC01E2
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 14:18:30 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id E5FA5BD680F
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 14:18:29 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: fix option handling for some commands
Message-ID: <2ea1dea7-13b5-b984-03ce-2d88d4f9d220@jp.fujitsu.com>
Date: Thu, 24 Aug 2017 14:18:25 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I found some btrfs commands options are not working because of 
inappropriate getopt_long() setting.

This fixes "btrfs check -Q/-E"

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
  cmds-check.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index c5faa2b..465fd17 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12745,7 +12745,7 @@ int cmd_check(int argc, char **argv)
  			{ NULL, 0, NULL, 0}
  		};

-		c = getopt_long(argc, argv, "as:br:p", long_options, NULL);
+		c = getopt_long(argc, argv, "as:br:pQE:", long_options, NULL);
  		if (c < 0)
  			break;
  		switch(c) {
-- 
2.9.4

