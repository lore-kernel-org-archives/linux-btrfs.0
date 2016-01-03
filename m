Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35182 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcACTAL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 14:00:11 -0500
Received: by mail-pf0-f178.google.com with SMTP id 78so191918925pfw.2
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 11:00:11 -0800 (PST)
Received: from arch-gct.localdomain ([175.114.213.172])
        by smtp.gmail.com with ESMTPSA id fc6sm120726837pac.44.2016.01.03.11.00.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Jan 2016 11:00:09 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs-progs: get sparse checking working
Date: Mon,  4 Jan 2016 03:59:53 +0900
Message-Id: <1451847598-30666-2-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
References: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I run sparse checking it gives following error:

 $ make C=1 V=1
 gcc -MM -MG -MF cmds-fi-usage.o.d -MT cmds-fi-usage.o -MT \
 cmds-fi-usage.static.o -MT cmds-fi-usage.o.d -g -O1 -Wall \
 -D_FORTIFY_SOURCE=2 -include config.h -DBTRFS_FLAT_INCLUDES \
 -D_XOPEN_SOURCE=700 -fno-strict-aliasing -fPIC   cmds-fi-usage.c
    [SP]     ctree.c
 sparse -g -O1 -Wall -D_FORTIFY_SOURCE=2 -include config.h \
 -DBTRFS_FLAT_INCLUDES -D_XOPEN_SOURCE=700 -fno-strict-aliasing -fPIC \
 -include  -D__CHECKER__ -D__CHECK_ENDIAN__ -Wbitwise -Wuninitialized \
 -Wshadow -Wundef -U_FORTIFY_SOURCE ctree.c
 builtin:1:15: error: unable to open '-D__CHECKER__'
 Makefile:177: recipe for target 'ctree.o' failed
 make: *** [ctree.o] Error 1

It means '$(check_defs)' is passed to sparse as NULL and looks
'$(check_defs)'should be assigned before assigning '$(CHECKER_FLAGS)'.
BTW, I'm not familiar with make tool so there could be some my
misunderstanding and better solution.

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 Makefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.in b/Makefile.in
index 85b45e5bee3b..3b98709f31a5 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -60,6 +60,7 @@ STATIC_LIBS = @UUID_LIBS_STATIC@ @BLKID_LIBS_STATIC@ \
 # generate so many sparse errors that sparse stops parsing,
 # which masks real errors that we want to see.
 CHECKER := sparse
+check_defs := .cc-defines.h
 CHECKER_FLAGS := -include $(check_defs) -D__CHECKER__ \
 	-D__CHECK_ENDIAN__ -Wbitwise -Wuninitialized -Wshadow -Wundef \
 	-U_FORTIFY_SOURCE
@@ -154,7 +155,6 @@ lib_links = libbtrfs.so.0 libbtrfs.so
 headers = $(libbtrfs_headers)
 
 # make C=1 to enable sparse
-check_defs := .cc-defines.h 
 ifdef C
 	# We're trying to use sparse against glibc headers which go wild
 	# trying to use internal compiler macros to test features.  We
-- 
2.6.4

