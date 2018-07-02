Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47587 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753867AbeGBJWG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 05:22:06 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 476B14B43D4C
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 17:22:02 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 3/3] btrfs-progs: tests: append '--force-repair-lowmem' if lowmem repair is enabled
Date: Mon, 2 Jul 2018 17:28:20 +0800
Message-ID: <20180702092820.16285-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
References: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit 62785de7c107 ("btrfs-progs: lowmem: force to start
without delay with option '--force-repair-lowmem'") delays repair in
lowmem mode.
For tests which repair in lowmem mode, append '--force-repair-lowmem'
to force them to start without delay.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 tests/common.local | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/common.local b/tests/common.local
index f5e96f5b73ac..4facc5482ef7 100644
--- a/tests/common.local
+++ b/tests/common.local
@@ -29,6 +29,7 @@ _skip_spec()
 	   echo "$@" | grep -q -- '--repair'; then
 		dir="$(dirname ${@: -1})"
 		if [ -f ${dir}/${beacon} ]; then
+			TEST_ARGS_CHECK+=" --force-repair-lowmem"
 			return 1;
 		fi
 		return 0;
-- 
2.17.1



