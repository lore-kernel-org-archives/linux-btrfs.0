Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54169 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbaLDSjt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 13:39:49 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so23610997wgh.16
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 10:39:48 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/5] Add reference to BTRFS_SKIP_LVM_SNAPSHOT environment variable.
Date: Thu,  4 Dec 2014 19:39:41 +0100
Message-Id: <1417718382-6753-5-git-send-email-kreijack@inwind.it>
In-Reply-To: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add reference to BTRFS_SKIP_LVM_SNAPSHOT environment viarble in
the btrfs(8) documentation.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/btrfs.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/btrfs.txt b/Documentation/btrfs.txt
index 3bdc6b4..889b97c 100644
--- a/Documentation/btrfs.txt
+++ b/Documentation/btrfs.txt
@@ -96,6 +96,14 @@ AVAILABILITY
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
+ENVIRONMENT VARIABLES
+---------------------
+BTRFS_SKIP_LVM_SNAPSHOT::
+	Controls if the *lvm snapshots* have to be
+	ignored. Default "yes"; if you need to consider them, set it to "no".
+	Pay attention that *btrfs* may be confused if two devices have
+	the same dev uuid. This is the reason to skip a lvm snapshot.
+
 SEE ALSO
 --------
 `mkfs.btrfs`(8), `ionice`(1),
-- 
2.1.3

