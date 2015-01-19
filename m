Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbbASSLu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 13:11:50 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: tests, use non-interactive sudo helper
Date: Mon, 19 Jan 2015 19:11:47 +0100
Message-Id: <1421691107-4106-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sudo may not be configured to run without user prompt, in that case the
tests would be stuck.

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 tests/common | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/common b/tests/common
index 84a4b9d335e2..d7d2e9bef050 100644
--- a/tests/common
+++ b/tests/common
@@ -58,7 +58,7 @@ export have_root_helper
 setup_root_helper()
 {
 	if [ $UID != 0 ]; then
-		sudo=sudo
+		sudo="sudo --non-interactive"
 	fi
 	have_root_helper=1
 }
-- 
2.1.3

