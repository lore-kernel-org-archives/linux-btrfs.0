Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5732 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752606AbdF0IfI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 04:35:08 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: lowmem: check: Output more detailed information about file extent interrupt
Date: Tue, 27 Jun 2017 16:34:55 +0800
Message-ID: <20170627083455.14576-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make lowmem mode output more detailed information about file extent
interrupt.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---

Sorry for any inconvenience caused. Please ignore this message(https://www.spinics.net/lists/linux-btrfs/msg66803.html).

 cmds-check.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index dedb12d1..f42968cd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4848,8 +4848,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		      root->objectid, fkey->objectid, fkey->offset);
 	} else if (!no_holes && *end != fkey->offset) {
 		err |= FILE_EXTENT_ERROR;
-		error("root %llu EXTENT_DATA[%llu %llu] interrupt",
-		      root->objectid, fkey->objectid, fkey->offset);
+		error("root %llu EXTENT_DATA[%llu %llu] interrupt, should start at %llu",
+		      root->objectid, fkey->objectid, fkey->offset, *end);
 	}
 
 	*end += extent_num_bytes;
-- 
2.13.2



