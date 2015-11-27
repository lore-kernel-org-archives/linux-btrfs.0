Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33795 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbK0ILt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 03:11:49 -0500
Received: by lffu14 with SMTP id u14so120843541lff.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 00:11:48 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: use kbasename in btrfsic_mount
Date: Fri, 27 Nov 2015 09:11:31 +0100
Message-Id: <1448611892-26144-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is more readable.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

I think the following strlcpy may be somewhat fragile since obviously
ds->name and p overlap. It certainly relies on strlcpy doing a forward
copy, and since different architectures can have their own strlcpy,
that's hard to verify (and also won't necessarily continue to hold).

Maybe

  if (p != ds->name)
    memmove(ds->name, p, strlen(p)+1);

instead.


 fs/btrfs/check-integrity.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 0340c57bf377..55a5cff390b9 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -95,6 +95,7 @@
 #include <linux/genhd.h>
 #include <linux/blkdev.h>
 #include <linux/vmalloc.h>
+#include <linux/string.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "hash.h"
@@ -3136,11 +3137,7 @@ int btrfsic_mount(struct btrfs_root *root,
 		ds->state = state;
 		bdevname(ds->bdev, ds->name);
 		ds->name[BDEVNAME_SIZE - 1] = '\0';
-		for (p = ds->name; *p != '\0'; p++);
-		while (p > ds->name && *p != '/')
-			p--;
-		if (*p == '/')
-			p++;
+		p = kbasename(ds->name);
 		strlcpy(ds->name, p, sizeof(ds->name));
 		btrfsic_dev_state_hashtable_add(ds,
 						&btrfsic_dev_state_hashtable);
-- 
2.6.1

