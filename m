Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48597 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751885AbdKJJsB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 04:48:01 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 6F36348089F3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Nov 2017 17:47:55 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: lowmem check: Reword an unclear error message about file extent gap
Date: Fri, 10 Nov 2017 17:47:10 +0800
Message-ID: <20171110094710.21193-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This error occurs when no_holes is not set, but there is a gap
before the file extent.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---

Really ashamed, I made the mistake about the meaning of this word.

 cmds-check.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a93ac2c8..5eab0143 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5868,8 +5868,9 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		if (!repair || ret) {
 			err |= FILE_EXTENT_ERROR;
 			error(
-		"root %llu EXTENT_DATA[%llu %llu] interrupt, should start at %llu",
-			root->objectid, fkey->objectid, fkey->offset, *end);
+"root %llu EXTENT_DATA[%llu %llu] gap exists, expected: EXTENT_DATA[%llu %llu]",
+			root->objectid, fkey->objectid, fkey->offset,
+			fkey->objectid, *end);
 		}
 	}
 
-- 
2.15.0



