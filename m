Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58328 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754641AbaDKKfH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 06:35:07 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>
Subject: [PATCH] Btrfs: fix compile warnings on on avr32 platform
Date: Fri, 11 Apr 2014 18:32:25 +0800
Message-ID: <1397212345-25843-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs/btrfs/scrub.c: In function 'get_raid56_logic_offset':
fs/btrfs/scrub.c:2269: warning: comparison of distinct pointer types lacks a cast
fs/btrfs/scrub.c:2269: warning: right shift count >= width of type
fs/btrfs/scrub.c:2269: warning: passing argument 1 of '__div64_32' from incompatible pointer type

Since @rot is an int type, we should not use do_div(), fix it.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index aee909f..68a5a26 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2266,7 +2266,7 @@ static int get_raid56_logic_offset(u64 physical, int num,
 		rot = do_div(stripe_nr, map->num_stripes);
 		/* calculate which stripe this data locates */
 		rot += i;
-		stripe_index = do_div(rot, map->num_stripes);
+		stripe_index = rot % map->num_stripes;
 		if (stripe_index == num)
 			return 0;
 		if (stripe_index < num)
-- 
1.9.0

