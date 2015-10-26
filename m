Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48063 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753848AbbJZKaG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 06:30:06 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9QATWu1004085
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 18:29:32 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 4/5] btrfs-progs: Add missing close_ctree to btrfs-select-super.c
Date: Mon, 26 Oct 2015 18:28:21 +0800
Message-ID: <22e13c15523f1920e249761ae8a737dd66192f0f.1445855131.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
References: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add missing close_ctree() to btrfs-select-super.c to avoid memory leak.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-select-super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index bd44978..df74153 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -102,6 +102,7 @@ int main(int ac, char **av)
 	 */
 	printf("using SB copy %llu, bytenr %llu\n", (unsigned long long)num,
 	       (unsigned long long)bytenr);
+	close_ctree(root);
 	btrfs_close_all_devices();
 	return ret;
 }
-- 
1.8.5.1

