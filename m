Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15502 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751782AbdI0Gbp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 02:31:45 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 87FFC47CAAD4
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 14:31:41 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] btrfs-progs: check: error or return value of repair_root_items()
Date: Wed, 27 Sep 2017 14:34:38 +0800
Message-ID: <20170927063440.25961-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
References: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Return value of repair_root_items():
<0 on error
=0 does nothing
>0 if repair is enable, N roots is repaired;
   else N roots is corrupted.

In the repair mode, there should be no error if return value is bigger
than 0.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 3e2f9faa..adc4a934 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -14646,8 +14646,8 @@ int cmd_check(int argc, char **argv)
 
 	if (!init_extent_tree) {
 		ret = repair_root_items(info);
-		err |= !!ret;
 		if (ret < 0) {
+			err = !!ret;
 			error("failed to repair root items: %s",
 			      strerror(-ret));
 			goto close_out;
-- 
2.14.1



