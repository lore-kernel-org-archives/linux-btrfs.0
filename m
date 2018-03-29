Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36679 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbeC2HyH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 03:54:07 -0400
Received: by mail-pg0-f65.google.com with SMTP id 201so2569972pgg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 00:54:07 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 4/5] libbtrfsutil: always build libbtrfsutil.so.$MAJOR
Date: Thu, 29 Mar 2018 00:53:56 -0700
Message-Id: <7c3074bb611c599bd4751d0361a1888b739e23cc.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Otherwise, make test-libbtrfsutil from a fresh checkout fails.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 699f864d..fbd6677a 100644
--- a/Makefile
+++ b/Makefile
@@ -417,7 +417,7 @@ libbtrfsutil.so.$(libbtrfsutil_major) libbtrfsutil.so: libbtrfsutil.so.$(libbtrf
 	$(Q)$(LN_S) -f $< $@
 
 ifeq ($(PYTHON_BINDINGS),1)
-libbtrfsutil_python: libbtrfsutil.so libbtrfsutil/btrfsutil.h
+libbtrfsutil_python: libbtrfsutil.so.$(libbtrfsutil_major) libbtrfsutil.so libbtrfsutil/btrfsutil.h
 	@echo "    [PY]     libbtrfsutil"
 	$(Q)cd libbtrfsutil/python; \
 		CFLAGS= LDFLAGS= $(PYTHON) setup.py $(SETUP_PY_Q) build_ext -i build
-- 
2.16.3

