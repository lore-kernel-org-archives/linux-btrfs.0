Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaFZUiY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 16:38:24 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5QKcNah025835
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 16:38:24 -0400
Received: from Liberator-2.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s5QKcMGY013028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 16:38:23 -0400
Message-ID: <53AC84C9.2080106@redhat.com>
Date: Thu, 26 Jun 2014 15:38:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: add supported attr flags to btrfs(5)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The chattr(1) manpage suffers from the same problems mount(1)
had: many options listed, not kept up to date for various
filesystems.

I've submitted a manpage update for chattr(1) which says to
refer to filesystem-specific manpages for supported attributes;
this patch updates btrfs(5) to list the attributes supported
by btrfs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Documentation/btrfs-mount.txt b/Documentation/btrfs-mount.txt
index 4433a78..c38e80a 100644
--- a/Documentation/btrfs-mount.txt
+++ b/Documentation/btrfs-mount.txt
@@ -3,7 +3,7 @@ btrfs-mount(5)
 
 NAME
 ----
-btrfs-mount - mount options for the btrfs filesystem
+btrfs-mount - mount options and supported file attributes for the btrfs filesystem
 
 DESCRIPTION
 -----------
@@ -179,8 +179,20 @@ MOUNT OPTIONS
 *user_subvol_rm_allowed*::
 	Allow subvolumes to be deleted by a non-root user. Use with caution.
 
+FILE ATTRIBUTES
+---------------
+The btrfs filesystem supports setting the following file
+attributes the `chattr`(1) utility
+append only (a), no atime updates (A), compressed (c), no copy on write (C),
+no dump (d), synchronous directory updates (d), immutable (i),
+synchronous updates (S), and no compression (X).
+
+For descriptions of these attribute flags, please refer to the
+`chattr`(1) man page.
+
 SEE ALSO
 --------
+`chattr`(1),
 `mkfs.btrfs`(8),
 `mount`(8),
 `btrfs`(8)

