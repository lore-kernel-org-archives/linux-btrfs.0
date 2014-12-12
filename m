Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967595AbaLLMgN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 07:36:13 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCaDSh022477
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:36:13 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Karel Zak <kzak@redhat.com>
Subject: [PATCH 09/10] btrfs-progs: add --disable-backtrace
Date: Fri, 12 Dec 2014 13:35:23 +0100
Message-Id: <1418387724-20188-10-git-send-email-kzak@redhat.com>
In-Reply-To: <1418387724-20188-1-git-send-email-kzak@redhat.com>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's better to use ./configure than manually edit Makefile.

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 Makefile.in  |  4 ----
 configure.ac | 10 ++++++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index df752d3..bdd7683 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -82,10 +82,6 @@ BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
 INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
 CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
 
-ifeq ($(DISABLE_BACKTRACE),1)
-CFLAGS += -DBTRFS_DISABLE_BACKTRACE
-endif
-
 ifneq ($(DISABLE_DOCUMENTATION),1)
 BUILDDIRS += build-Documentation
 INSTALLDIRS += install-Documentation
diff --git a/configure.ac b/configure.ac
index f6adefb..290d022 100644
--- a/configure.ac
+++ b/configure.ac
@@ -56,6 +56,16 @@ AC_DEFUN([PKG_STATIC], [
   fi
 ])
 
+
+AC_ARG_ENABLE([backtrace],
+  AS_HELP_STRING([--disable-backtrace], [disable btrfs backtrace]),
+  [], [enable_backtrace=yes]
+)
+
+AS_IF([test "x$enable_backtrace" = xno], [
+  AC_DEFINE([BTRFS_DISABLE_BACKTRACE], [1], [disable backtrace stuff in kerncompat.h ])
+])
+
 dnl Define <NAME>_LIBS= and <NAME>_CFLAGS= by pkg-config
 dnl
 dnl The default PKG_CHECK_MODULES() action-if-not-found is end the
-- 
1.9.3

