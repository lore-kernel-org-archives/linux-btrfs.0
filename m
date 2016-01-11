Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23678 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759184AbcAKUKg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 15:10:36 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Subject: [PATCH] Btrfs-progs: use btrfs-debugfs to fetch block group information
Date: Mon, 11 Jan 2016 12:10:22 -0800
Message-Id: <1452543022-9224-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: liub.liubo@gmail.com <boliu23@localhost.localdomain>

This aims to decide whether a balance can reduce the number of
data block groups and if it is, this shows the '-dvrange' block
group's objectid.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-debugfs |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 111 insertions(+), 6 deletions(-)

diff --git a/btrfs-debugfs b/btrfs-debugfs
index cf1d285..08e3ec6 100755
--- a/btrfs-debugfs
+++ b/btrfs-debugfs
@@ -4,7 +4,7 @@
 # LGPLv2 license
 # Copyright Facebook 2014
 
-import sys,os,struct,fcntl,ctypes,stat
+import sys,os,struct,fcntl,ctypes,stat,argparse
 
 # helpers for max ints
 maxu64 = (1L << 64) - 1
@@ -65,6 +65,11 @@ BTRFS_DEV_STATS_KEY = 249
 BTRFS_DEV_REPLACE_KEY = 250
 BTRFS_STRING_ITEM_KEY = 253
 
+# store information about which extents are in use, and reference counts
+BTRFS_EXTENT_TREE_OBJECTID = 2
+
+BTRFS_BLOCK_GROUP_DATA = (1 << 0)
+
 # in the kernel sources, this is flattened
 # btrfs_ioctl_search_args_v2.  It includes both the btrfs_ioctl_search_key
 # and the buffer.  We're using a 64K buffer size.
@@ -121,6 +126,13 @@ class btrfs_file_extent_item(ctypes.LittleEndianStructure):
                  ("num_bytes", ctypes.c_ulonglong),
                ]
 
+class btrfs_block_group_item(ctypes.LittleEndianStructure):
+    _pack_ = 1
+    _fields_ = [ ("used", ctypes.c_ulonglong),
+                 ("chunk_objectid", ctypes.c_ulonglong),
+                 ("flags", ctypes.c_ulonglong),
+              ]
+
 class btrfs_ioctl_search():
     def __init__(self):
         self.args = btrfs_ioctl_search_args()
@@ -288,9 +300,102 @@ def print_file_extents(filename):
           float(st.st_size) / float(total_on_disk))
     return 0
 
-if len(sys.argv) == 1:
-    sys.stderr.write("Usage: btrfs-debug filename ...\n")
-    sys.exit(1)
+def print_block_groups(mountpoint):
+    s = btrfs_ioctl_search()
+
+    s.args.min_type = BTRFS_BLOCK_GROUP_ITEM_KEY
+    s.args.max_type = BTRFS_BLOCK_GROUP_ITEM_KEY
+    s.args.tree_id = BTRFS_EXTENT_TREE_OBJECTID
+
+    min_used = maxu64
+    free_of_min_used = 0
+    bg_of_min_used = 0
+    total_free = 0
+
+    try:
+        fd = os.open(mountpoint, os.O_RDONLY)
+        st = os.fstat(fd)
+    except Exception, e:
+        sys.stderr.write("Failed to open %s (%s)\n" % (mountpoint, e))
+        return -1
+
+    while True:
+        try:
+            s.search(fd)
+        except Exception, e:
+            sys.stderr.write("Search ioctl failed for %s (%s)\n" % (mountpoint, e))
+            return -1
+
+        if s.args.nr_items == 0:
+            break
+
+        # p is the results buffer from kernel
+        p = ctypes.addressof(s.args.buf)
+        header = btrfs_ioctl_search_header()
+        header_size = ctypes.sizeof(header)
+        h = ctypes.addressof(header)
+        p_left = args_buffer_size
+
+        for x in xrange(0, s.args.nr_items):
+            # for each itme, copy the header from the buffer into
+            # our header struct
+            ctypes.memmove(h, p, header_size)
+            p += header_size
+            p_left -= header_size
+
+            # this would be a kernel bug it shouldn't be sending malformed
+            # items
+            if p_left <= 0:
+                break
+
+            if header.type == BTRFS_BLOCK_GROUP_ITEM_KEY:
+                bg = btrfs_block_group_item()
+
+                # this would be a kernel bug
+                if p_left < ctypes.sizeof(bg):
+                    break
+
+                ctypes.memmove(ctypes.addressof(bg), p, ctypes.sizeof(bg))
+                if bg.flags & BTRFS_BLOCK_GROUP_DATA:
+                    print "block group offset %Lu len %Lu used %Lu chunk_objectid %Lu flags %Lu usage %.2f" %\
+                     (header.objectid, header.offset, bg.used, bg.chunk_objectid, bg.flags, float(bg.used) / float(header.offset))
+
+                    total_free += (header.offset - bg.used)
+                    if min_used >= bg.used:
+                        min_used = bg.used
+                        free_of_min_used = (header.offset - bg.used)
+                        bg_of_min_used = header.objectid
+
+            p += header.len
+            p_left -= header.len
+            if p_left <= 0:
+                break
+
+            s.args.min_objectid = header.objectid
+
+        if s.args.min_objectid < maxu64:
+            s.args.min_objectid += 1
+        if s.args.min_objectid > s.args.max_objectid:
+            break
+
+    print "total_free %Lu min_used %Lu free_of_min_used %Lu block_group_of_min_used %Lu" %\
+     (total_free, min_used, free_of_min_used, bg_of_min_used)
+    if (total_free - free_of_min_used) >= min_used:
+        print "balance block group (%Lu) can reduce the number of data block group" % bg_of_min_used
+
+    return 0
+
+# main
+parser = argparse.ArgumentParser()
+parser.add_argument('path', nargs='+')
+parser.add_argument('-b', '--block-group', action='store_const', const=1, help='get block group information, use mountpoint as "path"')
+parser.add_argument('-f', '--file', action='store_const', const=1, help='get file mapping, use filepath')
+
+args = parser.parse_args()
 
-for f in sys.argv[1:]:
-    print_file_extents(f)
+if args.block_group:
+    for i in args.path[0:]:
+        print_block_groups(i)
+elif args.file:
+    for f in args.path[0:]:
+        print_file_extents(f)
-- 
1.7.1

