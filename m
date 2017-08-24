Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:23657 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdHXEPE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 00:15:04 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id EE3A6AC0127
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 13:03:41 +0900 (JST)
Received: from G01JPEXCHKW17.g01.fujitsu.local (G01JPEXCHKW17.g01.fujitsu.local [10.0.194.56])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 58F056926E3
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 13:03:41 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: fix option handling for some commands
Message-ID: <c24c91e1-1e0e-c398-bf84-59fecb76637e@jp.fujitsu.com>
Date: Thu, 24 Aug 2017 13:03:37 +0900
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

-               c = getopt_long(argc, argv, "as:br:p", long_options, NULL);
+               c = getopt_long(argc, argv, "as:br:pQE:", long_options, 
NULL);
                 if (c < 0)
                         break;
                 switch(c) {
-- 
2.9.4

