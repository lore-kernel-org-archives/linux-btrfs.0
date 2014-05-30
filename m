Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933479AbaE3Q3T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 12:29:19 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4UGTJ4n023705
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 12:29:19 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s4UGTIv4030899
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 12:29:19 -0400
Message-ID: <5388B1DF.9030307@redhat.com>
Date: Fri, 30 May 2014 11:29:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: fix btrfs-fragments build
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I made all the btrfs-foo.c targets generic, I somehow
managed to break the libs definition for btrfs-fragments by
dropping the "s" off the end.

Fix that, although apparently nobody is building this tool.  :)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

As an aside, since it's not built by default, it seems at-risk
for this kind of bitrot...

diff --git a/Makefile b/Makefile
index 76565e8..037a1c4 100644
--- a/Makefile
+++ b/Makefile
@@ -54,7 +54,7 @@ progs = mkfs.btrfs btrfs-debug-tree btrfsck \
 # specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
 btrfs_convert_libs = -lext2fs -lcom_err
 btrfs_image_libs = -lpthread
-btrfs_fragment_libs = -lgd -lpng -ljpeg -lfreetype
+btrfs_fragments_libs = -lgd -lpng -ljpeg -lfreetype
 
 SUBDIRS =
 BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS)) build-Documentation

