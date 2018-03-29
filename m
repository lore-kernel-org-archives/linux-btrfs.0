Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:19738 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbeC2IWy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 04:22:54 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id D9933AC01F4
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 17:22:47 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 11CDF58426C
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 17:22:47 +0900 (JST)
Subject: [PATCH v2 1/3] btrfs-progs: fi usage: change warning message more
 appropriately
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
Message-ID: <c8a655bc-ae35-2d4d-2b0f-2fd4535a9070@jp.fujitsu.com>
Date: Thu, 29 Mar 2018 17:22:43 +0900
MIME-Version: 1.0
In-Reply-To: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"fi usage" shows the warning "RAID5/6 numbers will be incorrect" when
running without root privilege even if raid5/6 is not used.  What
happens is it cannot get the per device profile usage info, so change
the message more appropriately.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-fi-usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index de7ad668..f2307fe0 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -629,7 +629,7 @@ int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
 	ret = load_chunk_info(fd, chunkinfo, chunkcount);
 	if (ret == -EPERM) {
 		warning(
-"cannot read detailed chunk info, RAID5/6 numbers will be incorrect, run as root");
+"cannot read detailed chunk info. per device usage will not be shown, run as root");
 	} else if (ret) {
 		return ret;
 	}
-- 
2.14.3


