Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64316 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753503AbbEOGab (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 02:30:31 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 4/4] btrfs-progs: Update the Document for offline fsid change.
Date: Fri, 15 May 2015 14:28:26 +0800
Message-ID: <1431671306-22262-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431671306-22262-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431671306-22262-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfstune.asciidoc | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfstune.asciidoc b/Documentation/btrfstune.asciidoc
index 9620221..6927758 100644
--- a/Documentation/btrfstune.asciidoc
+++ b/Documentation/btrfstune.asciidoc
@@ -25,8 +25,22 @@ Enable extended inode refs.
 -x::
 Enable skinny metadata extent refs.
 -f::
-Allow dangerous changes, e.g. clear the seeding flag. Make sure that you are
-aware of the dangers.
+Allow dangerous changes, e.g. clear the seeding flag or change fsid. Make sure
+that you are aware of the dangers.
+-u::
+Change fsid to a random generated UUID.
+If there is a previous unfinished fsid change, it will continue the unfinished
+fsid change.
+-U <UUID>::
+Change fsid to <UUID>.
+The <UUID> should be a 36 bytes string in `printf`(3) format
+"%08x-%04x-%04x-%04x-%012x".
+If there is a previous unfinished fsid change, it will only continue if the
+<UUID> matches the unfinished one.
+
+WARNING: Canceling a running UUID progress will cause the filesystem unmountable.
+To fix it, please rerun 'btrfstune -u' to restore the UUID and wait it complete.
+
 
 When mounting the new device, btrfs will check whether the seeding flag is set
 when try to open seeding device.  If the user clears the seeding flag of the
-- 
2.4.0

