Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4785 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751409AbdKVCNl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 21:13:41 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <nborisov@suse.com>
Subject: [PATCH v2 1/3] btrfs-progs: check: report more specific info about invalid location
Date: Wed, 22 Nov 2017 10:17:16 +0800
Message-ID: <20171122021716.5957-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously, it was so useless to print message like
"invalid location %d".

Let it print objectid and offset of dir_item too.
Debug is easier now.

Suggested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
changelog:
v2:
	Print unknown location type.
---
 cmds-check.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a93ac2c88a38..416a7601bce1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1635,8 +1635,9 @@ static int process_dir_item(struct extent_buffer *eb,
 					  namebuf, len, filetype,
 					  key->type, error);
 		} else {
-			fprintf(stderr, "invalid location in dir item %u\n",
-				location.type);
+			fprintf(stderr,
+				"Unknown location type %d in DIR_ITEM[%llu %llu]\n",
+				location.type, key->objectid, key->offset);
 			add_inode_backref(inode_cache, BTRFS_MULTIPLE_OBJECTIDS,
 					  key->objectid, key->offset, namebuf,
 					  len, filetype, key->type, error);
-- 
2.15.0



