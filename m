Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:60160 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751404AbdI3Py3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 11:54:29 -0400
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: [PATCH] btrfs-progs: right-align number columns in btrfs-debugfs
 output
Message-ID: <59f60b49-3e74-547d-5124-8ce0097059ff@applied-asynchrony.com>
Date: Sat, 30 Sep 2017 17:54:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


The values for block group offset, length etc. in btrfs-debugfs' output
are left-aligned, which creates unaligned output and makes the usage
percentage hard to read/process further. This patch adds right-aligning
format specifiers for the number values.
Ideally the format values wouldn't be hardcoded but instead derived from
the filesystem size, but this seems to work for now.

Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
---
 btrfs-debugfs | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/btrfs-debugfs b/btrfs-debugfs
index dfb88539..a7ecd16d 100755
--- a/btrfs-debugfs
+++ b/btrfs-debugfs
@@ -356,8 +356,13 @@ def print_block_groups(mountpoint):
 
                 ctypes.memmove(ctypes.addressof(bg), p, ctypes.sizeof(bg))
                 if bg.flags & BTRFS_BLOCK_GROUP_DATA:
-                    print "block group offset %Lu len %Lu used %Lu chunk_objectid %Lu flags %Lu usage %.2f" %\
-                     (header.objectid, header.offset, bg.used, bg.chunk_objectid, bg.flags, float(bg.used) / float(header.offset))
+                    print "block group offset %s len %s used %s chunk_objectid %Lu flags %Lu usage %.2f" %\
+                     ('{:>14}'.format(header.objectid),
+                      '{:>10}'.format(header.offset),
+                      '{:>10}'.format(bg.used),
+                      bg.chunk_objectid,
+                      bg.flags,
+                      float(bg.used) / float(header.offset))
 
                     total_free += (header.offset - bg.used)
                     if min_used >= bg.used:
-- 
2.14.2

