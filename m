Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:63510 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750769AbdK3HwV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 02:52:21 -0500
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id D9EA3AC0100
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:52:11 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 02A956926FD
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:52:11 +0900 (JST)
Subject: [PATCH 1/3] btrfs-progs: fi usage: change warning message more
 appropriately
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
Message-ID: <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>
Date: Thu, 30 Nov 2017 16:52:07 +0900
MIME-Version: 1.0
In-Reply-To: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"fi usage" shows the warning "RAID5/6 numbers will be incorrect" when
runnning without root privilege even if raid5/6 is not used.  What
happens is it cannot get the per device profile usage info, so change
the message more appropriately.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-fi-usage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 6c846c15..299c2dae 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -590,7 +590,8 @@ int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
 	ret = load_chunk_info(fd, chunkinfo, chunkcount);
 	if (ret == -EPERM) {
 		warning(
-"cannot read detailed chunk info, RAID5/6 numbers will be incorrect, run as root");
+		"cannot read detailed chunk info. " \
+		"per device profile usage will not be shown, run as root");
 	} else if (ret) {
 		return ret;
 	}
-- 
2.13.6

