Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60802 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3COODR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 10:03:17 -0400
Received: by mail-ee0-f45.google.com with SMTP id b57so1581363eek.18
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Mar 2013 07:03:16 -0700 (PDT)
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH] btrfs-progs: mkfs: add missing raid5/6 description
Date: Fri, 15 Mar 2013 15:02:57 +0100
Message-Id: <1363356177-3532-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 man/mkfs.btrfs.8.in |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 41163e0..db8c57c 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -37,7 +37,7 @@ mkfs.btrfs uses all the available storage for the filesystem.
 .TP
 \fB\-d\fR, \fB\-\-data \fItype\fR
 Specify how the data must be spanned across the devices specified. Valid
-values are raid0, raid1, raid10 or single.
+values are raid0, raid1, raid5, raid6, raid10 or single.
 .TP
 \fB\-f\fR
 Force overwrite when an existing filesystem is detected on the device.
@@ -53,10 +53,11 @@ Specify a label for the filesystem.
 .TP
 \fB\-m\fR, \fB\-\-metadata \fIprofile\fR
 Specify how metadata must be spanned across the devices specified. Valid
-values are raid0, raid1, raid10, single or dup.  Single device will have dup
-set by default except in the case of SSDs which will default to single.  This is
-because SSDs can remap blocks internally so duplicate blocks could end up in the
-same erase block which negates the benefits of doing metadata duplication.
+values are raid0, raid1, raid5, raid6, raid10, single or dup.  Single device
+will have dup set by default except in the case of SSDs which will default to
+single. This is because SSDs can remap blocks internally so duplicate blocks
+could end up in the same erase block which negates the benefits of doing
+metadata duplication.
 .TP
 \fB\-M\fR, \fB\-\-mixed\fR
 Mix data and metadata chunks together for more efficient space 
-- 
1.7.10.4

