Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:56431 "EHLO
        smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752047AbcJJMFZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 08:05:25 -0400
Received: from [212.54.42.118] (helo=lsmtp4.tb.mail.iss.as9143.net)
        by smtpq5.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1btZKc-0004Cv-QX
        for linux-btrfs@vger.kernel.org; Mon, 10 Oct 2016 14:05:22 +0200
Received: from 31-151-236-204.dynamic.upc.nl ([31.151.236.204] helo=webminal.org)
        by lsmtp4.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1btZKS-00086q-N1
        for linux-btrfs@vger.kernel.org; Mon, 10 Oct 2016 14:05:22 +0200
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id u9AC56tO001526
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2016 14:05:16 +0200
Received: (from laks@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id u9AC4tcq001199
        for linux-btrfs@vger.kernel.org; Mon, 10 Oct 2016 14:04:55 +0200
Date: Mon, 10 Oct 2016 14:04:55 +0200
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH]btrfs-progs: btrfs-debugfs: cleanup unused variables reported
 by pylint
Message-ID: <20161010120455.GA32406@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 btrfs-debugfs | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/btrfs-debugfs b/btrfs-debugfs
index 0a654a6..dfb8853 100755
--- a/btrfs-debugfs
+++ b/btrfs-debugfs
@@ -4,7 +4,7 @@
 # LGPLv2 license
 # Copyright Facebook 2014
 
-import sys,os,struct,fcntl,ctypes,stat,argparse
+import sys, os, fcntl, ctypes, stat, argparse
 
 # helpers for max ints
 maxu64 = (1L << 64) - 1
@@ -233,7 +233,6 @@ def print_file_extents(filename):
     s.args.min_objectid = st.st_ino
     s.args.max_objectid = st.st_ino
 
-    size = st.st_size
 
     while True:
         try:
@@ -314,7 +313,7 @@ def print_block_groups(mountpoint):
 
     try:
         fd = os.open(mountpoint, os.O_RDONLY)
-        st = os.fstat(fd)
+        os.fstat(fd)
     except Exception, e:
         sys.stderr.write("Failed to open %s (%s)\n" % (mountpoint, e))
         return -1
@@ -336,7 +335,7 @@ def print_block_groups(mountpoint):
         h = ctypes.addressof(header)
         p_left = args_buffer_size
 
-        for x in xrange(0, s.args.nr_items):
+        for _ in xrange(0, s.args.nr_items):
             # for each itme, copy the header from the buffer into
             # our header struct
             ctypes.memmove(h, p, header_size)
-- 
1.9.3

