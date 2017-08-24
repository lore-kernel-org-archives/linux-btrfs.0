Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:30329 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751183AbdHXFYQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 01:24:16 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9F8A3AC012F
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 14:24:08 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id C2726BD680F
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 14:24:07 +0900 (JST)
Subject: [PATCH 2/3] btrfs-progs: fix option handling for some commands
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <2ea1dea7-13b5-b984-03ce-2d88d4f9d220@jp.fujitsu.com>
Message-ID: <3f55a6f6-4302-bc7d-92a8-f514bbe69ff9@jp.fujitsu.com>
Date: Thu, 24 Aug 2017 14:24:03 +0900
MIME-Version: 1.0
In-Reply-To: <2ea1dea7-13b5-b984-03ce-2d88d4f9d220@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes "btrfs receive -E"

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
  cmds-receive.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 72e9c8f..e584cef 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1277,7 +1277,7 @@ int cmd_receive(int argc, char **argv)
  			{ NULL, 0, NULL, 0 }
  		};

-		c = getopt_long(argc, argv, "Cevf:m:", long_opts, NULL);
+		c = getopt_long(argc, argv, "Cevf:m:E:", long_opts, NULL);
  		if (c < 0)
  			break;

-- 
2.9.4

