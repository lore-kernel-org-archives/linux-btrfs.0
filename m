Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaEMUFw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 16:05:52 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4DK5qXC022968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 16:05:52 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s4DK5p71026351
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 16:05:52 -0400
Message-ID: <53727B21.8070901@redhat.com>
Date: Tue, 13 May 2014 15:05:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: clarify mkfs.btrfs --alloc-start option
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fedora had a bug where a poor user thought that --alloc-start
meant that the filesystem would be created at that offset into
the device, rather than just starting allocations at that offset.
A subtle difference, but worth clarifying, because the manpage
is misleading on this point.

The original commit log for this option says:

    Add mkfs.btrfs -A offset to control allocation start on devices
    
    This is a utility option for the resizer, it makes sure to allocate
    at offset bytes in the disk or higher.  It ensures the resizer will have
    something to move when testing it.

so allude to that intended use in the manpage.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index dabeb62..bef509d 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -30,7 +30,7 @@ spanning across the specified \fI devices\fP.
 .SH OPTIONS
 .TP
 \fB\-A\fR, \fB\-\-alloc\-start \fIoffset\fR
-Specify the offset from the start of the device to start the btrfs filesystem. The default value is zero, or the start of the device.
+Specify the offset from the start of the device at which to start allocations in this btrfs filesystem. The default value is zero, or the start of the device.  This option is intended only for debugging filesystem resize operations.
 .TP
 \fB\-b\fR, \fB\-\-byte\-count \fIsize\fR
 Specify the size of the resultant filesystem. If this option is not used,

