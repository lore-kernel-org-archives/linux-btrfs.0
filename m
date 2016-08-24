Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64022 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753322AbcHXP6K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 11:58:10 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.17/8.16.0.17) with SMTP id u7OFsZe0006000
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 08:58:09 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0089730.ppops.net with ESMTP id 250upxfwb3-3
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 08:58:09 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH][v2] Btrfs: kill invalid ASSERT() in process_all_refs()
Date: Wed, 24 Aug 2016 11:57:52 -0400
Message-ID: <1472054272-23792-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Suppose you have the following tree in snap1 on a file system mounted with -o
inode_cache so that inode numbers are recycled

└── [    258]  a
    └── [    257]  b

and then you remove b, rename a to c, and then re-create b in c so you have the
following tree

└── [    258]  c
    └── [    257]  b

and then you try to do an incremental send you will hit

ASSERT(pending_move == 0);

in process_all_refs().  This is because we assume that any recycling of inodes
will not have a pending change in our path, which isn't the case.  This is the
case for the DELETE side, since we want to remove the old file using the old
path, but on the create side we could have a pending move and need to do the
normal pending rename dance.  So remove this ASSERT() and put a comment about
why we ignore pending_move.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
v1->v2:
-turns out send does the right thing without the ASSERT() in place, I must have
 loaded the wrong module when testing, so just kill the ASSERT().
-adjusted the changelog to reflect the actual fix.

 fs/btrfs/send.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b71dd29..375c45b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4126,10 +4126,12 @@ static int process_all_refs(struct send_ctx *sctx,
 	}
 	btrfs_release_path(path);
 
+	/*
+	 * We don't actually care about pending_move as we are simply
+	 * re-creating this inode and will be rename'ing it into place once we
+	 * rename the parent directory.
+	 */
 	ret = process_recorded_refs(sctx, &pending_move);
-	/* Only applicable to an incremental send. */
-	ASSERT(pending_move == 0);
-
 out:
 	btrfs_free_path(path);
 	return ret;
-- 
1.8.3.1

