Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40622 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaIUBBf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 21:01:35 -0400
Received: by mail-wi0-f170.google.com with SMTP id fb4so1185845wid.5
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 18:01:34 -0700 (PDT)
From: Dimitri John Ledkov <xnox@debian.org>
To: linux-btrfs@vger.kernel.org
Cc: Dimitri John Ledkov <xnox@debian.org>
Subject: [PATCH 4/4] Default to acting like fsck.
Date: Sun, 21 Sep 2014 02:01:22 +0100
Message-Id: <1411261282-26831-4-git-send-email-xnox@debian.org>
In-Reply-To: <1411261282-26831-1-git-send-email-xnox@debian.org>
References: <1411261282-26831-1-git-send-email-xnox@debian.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Inspect arguments, if we are not called as btrfs, then assume we are
called to act like fsck.

Bug-Debian: http://bugs.debian.org/712078
Signed-off-by: Dimitri John Ledkov <xnox@debian.org>
---
 btrfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs.c b/btrfs.c
index e83349c..e8a87ac 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -222,7 +222,7 @@ int main(int argc, char **argv)
 	else
 		bname = argv[0];
 
-	if (!strcmp(bname, "btrfsck")) {
+	if (strcmp(bname, "btrfs") != 0) {
 		argv[0] = "check";
 	} else {
 		argc--;
-- 
2.1.0.rc1

