Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:34612 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933322AbaLJVFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:43 -0500
Received: from mail-in-01-z2.arcor-online.net (mail-in-01-z2.arcor-online.net [151.189.8.13])
	by mx.arcor.de (Postfix) with ESMTP id 4061326315
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:42 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 12/18] btrfs restore: check progress of file restoration
Date: Wed, 10 Dec 2014 21:51:42 +0100
Message-Id: <1418244708-7087-13-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

extents should be ordered by file offset. Expect no overlaps,
and report holes.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 cmds-restore.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 004c82e..80081b8 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -739,6 +739,14 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 			ret = -1;
 			goto set_size;
 		}
+		if (found_key.offset < next_pos) {
+			fprintf(stderr, "extent overlap, %llu < %llu\n",
+				found_key.offset, next_pos);
+			ret = -1;
+			goto set_size;
+		} else if (found_key.offset > next_pos)
+			fprintf(stderr, "hole at %llu (%llu bytes)\n",
+				next_pos, found_key.offset - next_pos);
 
 		bytes_written = 0ULL;
 		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC)
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
