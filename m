Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:39154 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbdK3I31 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 03:29:27 -0500
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id B81F9AC00C0
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 17:29:21 +0900 (JST)
Received: from G01JPEXCHYT16.g01.fujitsu.local (G01JPEXCHYT16.g01.fujitsu.local [10.128.194.55])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id CBF14584370
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 17:29:20 +0900 (JST)
Subject: [PATCH v2 1/3] btrfs-progs: fi usage: change warning message more
 appropriately
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>
Message-ID: <1a534c1e-4223-f5fd-89a3-dd97ed79a0da@jp.fujitsu.com>
Date: Thu, 30 Nov 2017 17:29:13 +0900
MIME-Version: 1.0
In-Reply-To: <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"fi usage" shows the warning "RAID5/6 numbers will be incorrect" when
runnning without root privilege even if raid5/6 is not used.  What
happens is it cannot get the per device profile usage info, so change
the message more appropriately.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
v1 -> v2: fix not to split message line

 cmds-fi-usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 6c846c15..2f3d57e3 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -590,7 +590,7 @@ int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
 	ret = load_chunk_info(fd, chunkinfo, chunkcount);
 	if (ret == -EPERM) {
 		warning(
-"cannot read detailed chunk info, RAID5/6 numbers will be incorrect, run as root");
+"cannot read detailed chunk info. per device usage will not be shown, run as root");
 	} else if (ret) {
 		return ret;
 	}
-- 
2.13.6

