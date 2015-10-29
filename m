Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11999 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751478AbbJ2Jdk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 05:33:40 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9T9X4VR015825
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 17:33:04 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/6] btrfs-progs: free fslabel for btrfs-convert
Date: Thu, 29 Oct 2015 17:31:45 +0800
Message-ID: <923885cdd32d06b2bf4446b32b91917618f3be78.1446111097.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
References: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fslabel need to be freed before exit.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-convert.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 5b9171e..1693d03 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -3027,6 +3027,9 @@ int main(int argc, char *argv[])
 		ret = do_convert(file, datacsum, packing, noxattr, nodesize,
 				copylabel, fslabel, progress, features);
 	}
+
+	free(fslabel);
+
 	if (ret)
 		return 1;
 	return 0;
-- 
1.8.5.1

