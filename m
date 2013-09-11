Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54345 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3IKJEN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 05:04:13 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 11 Sep 2013 14:22:15 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id BC9BB3940057
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 14:33:54 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r8B9449G45023318
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 14:34:04 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r8B946E2029565
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 14:34:06 +0530
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org, chandra.seetharaman@us.ibm.com
Subject: [PATCH] btrfs-progs: btrfs.8.in: Add info about reverting back to root subvolume.
Date: Wed, 11 Sep 2013 14:34:05 +0530
Message-ID: <2061327.l3bBKU3J9X@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs subvolume list <path>' does not list the root subvolume's ID.
Hence there is no way for the user to set the root subvolume as the
default subvolume unless he knows about the magic number 5 (i.e.
BTRFS_FS_TREE_OBJECTID).

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 man/btrfs.8.in | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 61ffe8d..36846b6 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -244,7 +244,8 @@ is similar to \fBsubvolume list\fR command.
 \fBsubvolume set-default\fR\fI <id> <path>\fR
 Set the subvolume of the filesystem \fI<path>\fR which is mounted as
 \fIdefault\fR. The subvolume is identified by \fI<id>\fR, which
-is returned by the \fBsubvolume list\fR command.
+is returned by the \fBsubvolume list\fR command. The default subvolume
+can be set to the root subvolume by passing an \fI<id>\fR value of 5.
 .TP
 
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
-- 
1.8.3.1


