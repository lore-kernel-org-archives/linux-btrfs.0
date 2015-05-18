Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32836 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbbERJQo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 05:16:44 -0400
Received: by padbw4 with SMTP id bw4so144023113pad.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 02:16:44 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 2/6] Btrfs: remove all subvol options before mounting top-level
Date: Mon, 18 May 2015 02:16:27 -0700
Message-Id: <890a770a617e3b7bb2c857fc0e87ac9b4cecfd0c.1431939732.git.osandov@osandov.com>
In-Reply-To: <cover.1431939732.git.osandov@osandov.com>
References: <cover.1431939732.git.osandov@osandov.com>
In-Reply-To: <cover.1431939732.git.osandov@osandov.com>
References: <cover.1431939732.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, setup_root_args() substitutes 's/subvol=[^,]*/subvolid=0/'.
But, this means that if the user passes both a subvol and subvolid for
some reason, we won't actually mount the top-level when we recursively
mount. For example, consider:

mkfs.btrfs -f /dev/sdb
mount /dev/sdb /mnt
btrfs subvol create /mnt/subvol1 # subvolid=257
btrfs subvol create /mnt/subvol2 # subvolid=258
umount /mnt
mount -osubvol=/subvol1,subvolid=258 /dev/sdb /mnt

In the final mount, subvol=/subvol1,subvolid=258 becomes
subvolid=0,subvolid=258, and the last option takes precedence, so we
mount subvol2 and try to look up subvol1 inside of it, which fails.

So, instead, do a thorough scan through the argument list and remove any
subvol= and subvolid= options, then append subvolid=0 to the end. This
implicitly makes subvol= take precedence over subvolid=, but we're about
to add a stricter check for that. This also makes setup_root_args() more
generic, which we'll need soon.

Reviewed-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 56 ++++++++++++++++++++------------------------------------
 1 file changed, 20 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0576750..b5d04e4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1138,52 +1138,36 @@ static inline int is_subvolume_inode(struct inode *inode)
 }
 
 /*
- * This will strip out the subvol=%s argument for an argument string and add
- * subvolid=0 to make sure we get the actual tree root for path walking to the
- * subvol we want.
+ * This will add subvolid=0 to the argument string while removing any subvol=
+ * and subvolid= arguments to make sure we get the top-level root for path
+ * walking to the subvol we want.
  */
 static char *setup_root_args(char *args)
 {
-	unsigned len = strlen(args) + 2 + 1;
-	char *src, *dst, *buf;
+	char *buf, *dst, *sep;
 
-	/*
-	 * We need the same args as before, but with this substitution:
-	 * s!subvol=[^,]+!subvolid=0!
-	 *
-	 * Since the replacement string is up to 2 bytes longer than the
-	 * original, allocate strlen(args) + 2 + 1 bytes.
-	 */
-
-	src = strstr(args, "subvol=");
-	/* This shouldn't happen, but just in case.. */
-	if (!src)
-		return NULL;
+	if (!args)
+		return kstrdup("subvolid=0", GFP_NOFS);
 
-	buf = dst = kmalloc(len, GFP_NOFS);
+	/* The worst case is that we add ",subvolid=0" to the end. */
+	buf = dst = kmalloc(strlen(args) + strlen(",subvolid=0") + 1, GFP_NOFS);
 	if (!buf)
 		return NULL;
 
-	/*
-	 * If the subvol= arg is not at the start of the string,
-	 * copy whatever precedes it into buf.
-	 */
-	if (src != args) {
-		*src++ = '\0';
-		strcpy(buf, args);
-		dst += strlen(args);
+	while (1) {
+		sep = strchrnul(args, ',');
+		if (!strstarts(args, "subvol=") &&
+		    !strstarts(args, "subvolid=")) {
+			memcpy(dst, args, sep - args);
+			dst += sep - args;
+			*dst++ = ',';
+		}
+		if (*sep)
+			args = sep + 1;
+		else
+			break;
 	}
-
 	strcpy(dst, "subvolid=0");
-	dst += strlen("subvolid=0");
-
-	/*
-	 * If there is a "," after the original subvol=... string,
-	 * copy that suffix into our buffer.  Otherwise, we're done.
-	 */
-	src = strchr(src, ',');
-	if (src)
-		strcpy(dst, src);
 
 	return buf;
 }
-- 
2.4.1

