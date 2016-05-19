Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40778 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcESFN0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 01:13:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/3] btrfs-progs: add clean-all to the usage
Date: Thu, 19 May 2016 13:13:13 +0800
Message-Id: <1463634794-591-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
References: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 Makefile.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile.in b/Makefile.in
index 238dd59badaf..50b2ee5d8eba 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -6,6 +6,7 @@
 #   test        run the full testsuite
 #   install     install to default location (/usr/local)
 #   clean       clean built binaries (not the documentation)
+#   clean-all   clean as above, clean docs and generated files
 #
 # Tuning by variables (environment or make arguments):
 #   V=1            verbose, print command lines (default: quiet)
-- 
2.7.0

