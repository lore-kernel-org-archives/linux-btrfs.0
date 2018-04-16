Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38915 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbeDPQui (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 12:50:38 -0400
Date: Mon, 16 Apr 2018 18:48:05 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Ren=E9?= Rebe <rene@exactcode.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel unaligned access at ... btrfs_real_readdir+0x51c/0x718
 [btrfs]
Message-ID: <20180416164805.GQ21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CF3AC07F-83D7-41FE-ABE5-C442DAB29292@exactcode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CF3AC07F-83D7-41FE-ABE5-C442DAB29292@exactcode.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2018 at 04:52:16PM +0200, René Rebe wrote:
> I just installed the latest #t2sde test build on a sparc64 system with
> btrfs rootfs - you know, just for the fun of testing, and in contrast
> to my x86 and ppc systems I get tons of unaligned access warnings, in
> the form of:
> 
> [    0.000000] Btrfs loaded, crc32c=crc32c-generic
> [    0.000000] BTRFS: device fsid c84acf49-452a-4ed3-ae86-576975967db5 devid 1 transid 42 /dev/sda3
> [    0.000000] BTRFS info (device sda3): disk space caching is enabled
> [    0.000000] BTRFS info (device sda3): has skinny extents
> [    0.000000] Kernel unaligned access at TPC[102f3080] btrfs_real_readdir+0x51c/0x718 [btrfs]
> [    0.000000] Kernel unaligned access at TPC[102f30dc] btrfs_real_readdir+0x578/0x718 [btrfs]
> [    0.000000] Kernel unaligned access at TPC[102f313c] btrfs_real_readdir+0x5d8/0x718 [btrfs]
> [    0.000000] Kernel unaligned access at TPC[102f31a0] btrfs_real_readdir+0x63c/0x718 [btrfs]
> [    0.000000] Kernel unaligned access at TPC[102f3080] btrfs_real_readdir+0x51c/0x718 [btrfs]
> [    0.000000] log_unaligned: 38289 callbacks suppressed
> [    0.000000] Kernel unaligned access at TPC[102f3080] btrfs_real_readdir+0x51c/0x718 [btrfs]
> [    0.000000] Kernel unaligned access at TPC[102f30dc] btrfs_real_readdir+0x578/0x718 [btrfs]
> [    0.000000] Kernel unaligned access at TPC[102f313c] btrfs_real_readdir+0x5d8/0x718 [btrfs]
> [    0.000000] Kernel unaligned access at TPC[102f31a0] btrfs_real_readdir+0x63c/0x718 [btrfs]
> [    0.000000] Kernel unaligned access at TPC[102f3080] btrfs_real_readdir+0x51c/0x718 [btrfs]
> [    0.000000] log_unaligned: 112774 callbacks suppressed
> 
> in case some someone likes to address those, or has a quick patch to
> test, … just let me know ;-)

The warnings are valid, there's unaligned access introduced by patch

23b5ec74943f44378b68c0edd8e210a86318ea5e
btrfs: fix readdir deadlock with pagefault

The directory entries (struct dir_entry) are copied to a temporary
buffer as they fit, ie. no alignment, and the members accessed in
several places.

The following patch adds the proper unaligned access, only compile-tested.
Please test and let me know, thanks!

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e064c49c9a9a..f958eb686462 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -31,6 +31,7 @@
 #include <linux/uio.h>
 #include <linux/magic.h>
 #include <linux/iversion.h>
+#include <asm/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -5905,11 +5906,13 @@ static int btrfs_filldir(void *addr, int entries, struct dir_context *ctx)
                struct dir_entry *entry = addr;
                char *name = (char *)(entry + 1);
 
-               ctx->pos = entry->offset;
-               if (!dir_emit(ctx, name, entry->name_len, entry->ino,
-                             entry->type))
+               ctx->pos = get_unaligned(&entry->offset);
+               if (!dir_emit(ctx, name, get_unaligned(&entry->name_len),
+                                       get_unaligned(&entry->ino),
+                                       get_unaligned(&entry->type)))
                        return 1;
-               addr += sizeof(struct dir_entry) + entry->name_len;
+               addr += sizeof(struct dir_entry) +
+                       get_unaligned(&entry->name_len);
                ctx->pos++;
        }
        return 0;
@@ -5999,14 +6002,15 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
                }
 
                entry = addr;
-               entry->name_len = name_len;
+               put_unaligned(name_len, &entry->name_len);
                name_ptr = (char *)(entry + 1);
                read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
                                   name_len);
-               entry->type = btrfs_filetype_table[btrfs_dir_type(leaf, di)];
+               put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
+                               &entry->type);
                btrfs_dir_item_key_to_cpu(leaf, di, &location);
-               entry->ino = location.objectid;
-               entry->offset = found_key.offset;
+               put_unaligned(location.objectid, &entry->ino);
+               put_unaligned(found_key.offset, &entry->offset);
                entries++;
                addr += sizeof(struct dir_entry) + name_len;
                total_len += sizeof(struct dir_entry) + name_len;
---
