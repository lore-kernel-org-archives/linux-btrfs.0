Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35029 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbbC0V7O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Mar 2015 17:59:14 -0400
Received: by pdbop1 with SMTP id op1so108606137pdb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2015 14:59:14 -0700 (PDT)
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org
Cc: Harald Hoyer <harald@redhat.com>
Subject: [PATCH] btrfs-progs: silence fake fsck
Date: Fri, 27 Mar 2015 14:58:43 -0700
Message-Id: <1427493523-13424-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Harald suggested that we remove the message from the fake fsck.btrfs
that some distros run at boot:

  https://bugzilla.redhat.com/show_bug.cgi?id=1206502

"This output does not add anything, but is a disturbing element of
booting up a system. It's the only message I get, when starting my
system, before gdm is started."

I'm inclined to agree.

This makes the tiniest change to remove the message that's output for an
auto invocation.  My guess is that it was just copied from the xfs
fsck.xfs and that no one actually cares about it.

Signed-off-by: Zach Brown <zab@zabbo.net>
---
 fsck.btrfs | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fsck.btrfs b/fsck.btrfs
index e90043a..f056a7f 100755
--- a/fsck.btrfs
+++ b/fsck.btrfs
@@ -31,9 +31,7 @@ if [ ! -e $DEV ]; then
 	echo "$0: $DEV does not exist"
 	exit 8
 fi
-if $AUTO; then
-	echo "$0: BTRFS file system."
-else
+if [ "$AUTO" == "false" ]; then
 	echo "If you wish to check the consistency of a BTRFS filesystem or"
 	echo "repair a damaged filesystem, see btrfs(8) subcommand 'check'."
 fi
-- 
2.1.0

