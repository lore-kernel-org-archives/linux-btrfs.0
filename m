Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:16192 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752907AbaBXPIP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 10:08:15 -0500
Date: Mon, 24 Feb 2014 17:08:11 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: mkfs.btrfs man page: update default metadata
 blocksize
Message-ID: <20140224150810.GA6333@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit c652e4ef changes default metadata blocksize, update
corresponding options in man page.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 man/mkfs.btrfs.8.in | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index b54e935..dabeb62 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -47,10 +47,10 @@ there is a filesystem or partition table on the device already.
 .TP
 \fB\-n\fR, \fB\-\-nodesize \fIsize\fR
 \fB\-l\fR, \fB\-\-leafsize \fIsize\fR
-Specify the nodesize, the tree block size in which btrfs stores data. The
-default value is the page size. Must be a multiple of the sectorsize, but
-not larger than 65536. Leafsize always equals nodesize and the options are
-aliases.
+Specify the nodesize, the tree block size in which btrfs stores
+data. The default value is 16KB (16384) or the page size, whichever is
+bigger. Must be a multiple of the sectorsize, but not larger than
+65536. Leafsize always equals nodesize and the options are aliases.
 .TP
 \fB\-L\fR, \fB\-\-label \fIname\fR
 Specify a label for the filesystem.
-- 
1.8.3.1

