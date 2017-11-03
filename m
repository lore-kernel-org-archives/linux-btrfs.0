Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55818 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755798AbdKCI24 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 04:28:56 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 6DE0C48089D5
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Nov 2017 16:28:49 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 2/4] btrfs-progs: lowmem check: Output more detailed information about file extent interrupt
Date: Fri, 3 Nov 2017 16:28:04 +0800
Message-ID: <20171103082806.22448-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
References: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make lowmem mode output more detailed information about file extent
interrupt.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a6198bad..5750bb72 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5867,8 +5867,9 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 						*end, fkey->offset - *end);
 		if (!repair || ret) {
 			err |= FILE_EXTENT_ERROR;
-			error("root %llu EXTENT_DATA[%llu %llu] interrupt",
-			      root->objectid, fkey->objectid, fkey->offset);
+			error(
+		"root %llu EXTENT_DATA[%llu %llu] interrupt, should start at %llu",
+			root->objectid, fkey->objectid, fkey->offset, *end);
 		}
 	}
 
-- 
2.15.0



