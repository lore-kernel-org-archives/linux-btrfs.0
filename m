Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780AbaLLMgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 07:36:11 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCaBQU014223
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:36:11 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Karel Zak <kzak@redhat.com>
Subject: [PATCH 08/10] btrfs-progs: clean generated files, make version.h stuff more robust
Date: Fri, 12 Dec 2014 13:35:22 +0100
Message-Id: <1418387724-20188-9-git-send-email-kzak@redhat.com>
In-Reply-To: <1418387724-20188-1-git-send-email-kzak@redhat.com>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- add rule to generated version.h when any relevant stuff changed
- add rule to clean generated files on "make clean-all"

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 Makefile.in | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 58200ca..df752d3 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -164,6 +164,10 @@ test:
 #
 static: $(progs_static)
 
+version.h: version.sh version.h.in configure.ac
+	@echo "    [SH]     $@"
+	$(Q)bash ./config.status --silent $@
+
 $(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(LDFLAGS) $(LIBBTRFS_LIBS) \
@@ -271,14 +275,15 @@ test-build:
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation
 
-clean-all: clean-doc clean
+
+clean-all: clean clean-doc clean-gen
 
 clean: $(CLEANDIRS)
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o *.o.d \
 	      dir-test ioctl-test quick-test send-test library-test library-test-static \
 	      btrfs.static mkfs.btrfs.static \
-	      version.h $(check_defs) \
+	      $(check_defs) \
 	      $(libs) $(lib_links) \
 	      $(progs_static) $(progs_extra)
 
@@ -286,6 +291,11 @@ clean-doc:
 	@echo "Cleaning Documentation"
 	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation clean
 
+clean-gen:
+	@echo "Cleaning Generated Files"
+	$(Q)rm -f version.h config.status config.cache connfig.log \
+		configure.lineno config.status.lineno Makefile
+
 $(CLEANDIRS):
 	@echo "Cleaning $(patsubst clean-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst clean-%,%,$@) clean
-- 
1.9.3

