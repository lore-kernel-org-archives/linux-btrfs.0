Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50657 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbeDPTSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 15:18:06 -0400
Date: Mon, 16 Apr 2018 21:15:33 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Ren=E9?= Rebe <rene@exactcode.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: Kernel unaligned access at ... btrfs_real_readdir+0x51c/0x718
 [btrfs]
Message-ID: <20180416191533.GZ21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CF3AC07F-83D7-41FE-ABE5-C442DAB29292@exactcode.com>
 <20180416164805.GQ21272@twin.jikos.cz>
 <83e9ab82-1ee8-11ac-6987-127722aaba69@exactcode.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
In-Reply-To: <83e9ab82-1ee8-11ac-6987-127722aaba69@exactcode.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Apr 16, 2018 at 09:55:45PM +0200, René Rebe wrote:
> Hi,
> 
> On 04/16/2018 06:48 PM, David Sterba wrote:
> > The warnings are valid, there's unaligned access introduced by patch
> > 
> > 23b5ec74943f44378b68c0edd8e210a86318ea5e
> > btrfs: fix readdir deadlock with pagefault
> > 
> > The directory entries (struct dir_entry) are copied to a temporary
> > buffer as they fit, ie. no alignment, and the members accessed in
> > several places.
> > 
> > The following patch adds the proper unaligned access, only compile-tested.
> > Please test and let me know, thanks!
> Would have loved to immediately give it a try, however, sorry,
> I forgot to mention I'm on the latest stable release -4.16.2-
> on a first glance this does not look like it does just apply.
> 
> I would re-base myself if I would not also have a glibc initialization 
> bug to hunt and debug, too :-/
> 
> If you happen to also rebase it for current -stable, ... ;-)

Sure, attached a 4.16.2 version.

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-test-readdir-unaligned-access.patch"

>From 4df58593a5a42c632f1c18ced3d6fae2196e29a9 Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Mon, 16 Apr 2018 21:10:14 +0200
Subject: [PATCH] test readdir unaligned access

---
 fs/btrfs/inode.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c7b75dd58fad..c2df7b158820 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -44,6 +44,7 @@
 #include <linux/uio.h>
 #include <linux/magic.h>
 #include <linux/iversion.h>
+#include <asm/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -5951,11 +5952,13 @@ static int btrfs_filldir(void *addr, int entries, struct dir_context *ctx)
 		struct dir_entry *entry = addr;
 		char *name = (char *)(entry + 1);
 
-		ctx->pos = entry->offset;
-		if (!dir_emit(ctx, name, entry->name_len, entry->ino,
-			      entry->type))
+		ctx->pos = get_unaligned(&entry->offset);
+		if (!dir_emit(ctx, name, get_unaligned(&entry->name_len),
+					get_unaligned(&entry->ino),
+					get_unaligned(&entry->type)))
 			return 1;
-		addr += sizeof(struct dir_entry) + entry->name_len;
+		addr += sizeof(struct dir_entry) +
+			get_unaligned(&entry->name_len);
 		ctx->pos++;
 	}
 	return 0;
@@ -6045,14 +6048,15 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		entry = addr;
-		entry->name_len = name_len;
+		put_unaligned(name_len, &entry->name_len);
 		name_ptr = (char *)(entry + 1);
 		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
 				   name_len);
-		entry->type = btrfs_filetype_table[btrfs_dir_type(leaf, di)];
+		put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
+				&entry->type);
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
-		entry->ino = location.objectid;
-		entry->offset = found_key.offset;
+		put_unaligned(location.objectid, &entry->ino);
+		put_unaligned(found_key.offset,&entry->offset);
 		entries++;
 		addr += sizeof(struct dir_entry) + name_len;
 		total_len += sizeof(struct dir_entry) + name_len;
-- 
2.16.2


--UugvWAfsgieZRqgk--
