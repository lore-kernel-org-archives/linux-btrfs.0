Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab3FCMbn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Jun 2013 08:31:43 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EFACAA5388
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Jun 2013 14:31:41 +0200 (CEST)
Date: Mon, 3 Jun 2013 14:31:41 +0200
From: Arvin Schnell <aschnell@suse.de>
To: linux-btrfs@vger.kernel.org
Subject: library version defines?
Message-ID: <20130603123141.GA2315@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Hi,

commit 46de1a6ec3dbb0db203baa6c46cb64ba9b000ea2 changed the
parameters of btrfs_read_and_process_send_stream().  This breaks
snapper compilation so I wonder whether we can include version
defines usable for the C preprocessor.  Surely it won't help in
this case anymore but might in the future.

Please find my proposal attached.

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany

--X1bOJ3K7DJ5YkBrT
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="bv.2.diff"

diff --git a/Makefile b/Makefile
index da7438e..8ee372f 100644
--- a/Makefile
+++ b/Makefile
@@ -14,7 +14,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
-	       extent_io.h ioctl.h ctree.h
+	       extent_io.h ioctl.h ctree.h version.h
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/version.sh b/version.sh
index b81040e..1d9fe9f 100644
--- a/version.sh
+++ b/version.sh
@@ -8,6 +8,10 @@
 
 v="v0.20-rc1"
 
+lib_major=0
+lib_minor=1
+lib_patchlevel=0
+
 which git &> /dev/null
 if [ $? == 0 -a -d .git ]; then
     if head=`git rev-parse --verify HEAD 2>/dev/null`; then
@@ -46,7 +50,17 @@ fi
 
 echo "#ifndef __BUILD_VERSION" > .build-version.h
 echo "#define __BUILD_VERSION" >> .build-version.h
+echo >> .build-version.h
 echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-version.h
+echo >> .build-version.h
+echo "#define BTRFS_LIB_MAJOR $lib_major" >> .build-version.h
+echo "#define BTRFS_LIB_MINOR $lib_minor" >> .build-version.h
+echo "#define BTRFS_LIB_PATCHLEVEL $lib_patchlevel" >> .build-version.h
+echo >> .build-version.h
+echo "#define BTRFS_LIB_VERSION ( BTRFS_LIB_MAJOR * 10000 + \\" >> .build-version.h
+echo "                            BTRFS_LIB_MINOR * 100 + \\" >> .build-version.h
+echo "                            BTRFS_LIB_PATCHLEVEL )" >> .build-version.h
+echo >> .build-version.h
 echo "#endif" >> .build-version.h
 
 diff -q version.h .build-version.h >& /dev/null

--X1bOJ3K7DJ5YkBrT--
