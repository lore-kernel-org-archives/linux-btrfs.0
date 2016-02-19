Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:50671 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947233AbcBSCOk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 21:14:40 -0500
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
	by mail1.windriver.com (8.15.2/8.15.1) with ESMTPS id u1J2EbXg026072
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 18:14:37 -0800 (PST)
From: Hongxu Jia <hongxu.jia@windriver.com>
To: <linux-btrfs@vger.kernel.org>
CC: <hongxu.jia@windriver.com>
Subject: [PATCH] btrfs-progs: fix symlink creation multiple times
Date: Thu, 18 Feb 2016 21:14:34 -0500
Message-ID: <1455848074-47741-1-git-send-email-hongxu.jia@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The rule to create symlink in Makefile caused parallel issue:
$ make -j 40 DESTDIR=/image install BUILD_VERBOSE=1
...
  1     [LN]     libbtrfs.so.0
  2     [LN]     libbtrfs.so
  3 ln -s -f libbtrfs.so.0.1 libbtrfs.so.0
  4 ln -s -f libbtrfs.so.0.1 libbtrfs.so.0
  5 ln -s -f libbtrfs.so.0.1 libbtrfs.so
  6 ln -s -f libbtrfs.so.0.1 libbtrfs.so
...

It failed occasionally:
...
|symlinkat: couldn't stat 'git/libbtrfs.so' even though symlink
creation succeeded (No such file or directory).
|ln: failed to create symbolic link 'libbtrfs.so': No such file or directory
...

Signed-off-by: Hongxu Jia <hongxu.jia@windriver.com>
---
 Makefile.in | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 1f4002e..16eeaf9 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -236,8 +236,7 @@ $(libs_static): $(libbtrfs_objects)
 
 $(lib_links):
 	@echo "    [LN]     $@"
-	$(Q)$(LN_S) -f libbtrfs.so.0.1 libbtrfs.so.0
-	$(Q)$(LN_S) -f libbtrfs.so.0.1 libbtrfs.so
+	$(Q)$(LN_S) -f libbtrfs.so.0.1 $@
 
 # keep intermediate files from the below implicit rules around
 .PRECIOUS: $(addsuffix .o,$(progs))
-- 
1.9.1

