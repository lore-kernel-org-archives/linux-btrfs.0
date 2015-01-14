Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbbANRZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 12:25:08 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs-progs: tests, add support for running commands under root
Date: Wed, 14 Jan 2015 18:25:02 +0100
Message-Id: <1421256302-8503-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Most of the checks run fine without root, but some of them may need to
do a mount test or access the data. Add the support to selectively run
commands under root, hardcoded to sudo for now.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

 tests/common | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tests/common b/tests/common
index 80a538165949..84a4b9d335e2 100644
--- a/tests/common
+++ b/tests/common
@@ -47,3 +47,18 @@ check_all_images()
 		rm $i.restored
 	done
 }
+
+# some tests need to mount the recovered image and do verifications call
+# 'setup_root_helper' and then check for have_root_helper == 1 if the test
+# needs to fail otherwise; using sudo by default for now
+sudo=
+have_root_helper=0
+export sudo
+export have_root_helper
+setup_root_helper()
+{
+	if [ $UID != 0 ]; then
+		sudo=sudo
+	fi
+	have_root_helper=1
+}
-- 
2.1.3

