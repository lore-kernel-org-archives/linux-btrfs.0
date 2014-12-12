Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967699AbaLLMgI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 07:36:08 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCa8j8022468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:36:08 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Karel Zak <kzak@redhat.com>
Subject: [PATCH 06/10] btrfs-progs: use paths and $*_LIBS from ./configure
Date: Fri, 12 Dec 2014 13:35:20 +0100
Message-Id: <1418387724-20188-7-git-send-email-kzak@redhat.com>
In-Reply-To: <1418387724-20188-1-git-send-email-kzak@redhat.com>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 Makefile.in | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 17eea58..df590ab 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -26,11 +26,11 @@ libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 TESTS = fsck-tests.sh convert-tests.sh
 
 INSTALL = @INSTALL@
-prefix ?= /usr/local
-bindir = $(prefix)/bin
-lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
-libdir ?= $(prefix)/lib
-incdir = $(prefix)/include/btrfs
+prefix ?= @prefix@
+bindir = @bindir@
+lib_LIBS = @UUID_LIBS@ @BLKID_LIBS@ @ZLIB_LIBS@ @LZO2_LIBS@ -m -L.
+libdir ?= @libdir@
+incdir = @includedir@/btrfs
 LIBS = $(lib_LIBS) $(libs_static)
 
 ifeq ("$(origin V)", "command line")
-- 
1.9.3

