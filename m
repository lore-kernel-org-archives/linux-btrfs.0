Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:39979 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932967AbeFTRDw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:03:52 -0400
From: Bart Van Assche <bart.vanassche@wdc.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 2/3] btrfs: Annotate fall-through
Date: Wed, 20 Jun 2018 10:03:32 -0700
Message-Id: <20180620170333.29182-3-bart.vanassche@wdc.com>
In-Reply-To: <20180620170333.29182-1-bart.vanassche@wdc.com>
References: <20180620170333.29182-1-bart.vanassche@wdc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch avoids that the compiler complains that a fall-through
annotation is missing when building with W=1.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 fs/btrfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 81107ad49f3a..3e298f26a383 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -760,6 +760,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_recovery:
 			btrfs_warn(info,
 				   "'recovery' is deprecated, use 'usebackuproot' instead");
+			/* fall through */
 		case Opt_usebackuproot:
 			btrfs_info(info,
 				   "trying to use backup root at mount time");
-- 
2.17.1

