Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab3FLAkO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 20:40:14 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5C0e4el018327
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 20:40:06 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r5C0e3Ep029131
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 20:40:04 -0400
Message-ID: <51B7C363.2080106@redhat.com>
Date: Tue, 11 Jun 2013 19:40:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/3] Btrfs-progs: fix up .gitignore
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
In-Reply-To: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix .gitignore for new file locations.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(could update other patches rather than add 4th if it's better)

diff --git a/.gitignore b/.gitignore
index a7e1b19..abc7ca6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -4,17 +4,10 @@
 version.h
 version
 man/*.gz
-btrfs
-btrfs.static
 btrfs-debug-tree
 btrfs-map-logical
 btrfs-fragments
-btrfsck
 calc-size
-ioctl-test
-dir-test
-send-test
-quick-test
 find-root
 mkfs.btrfs
 mkfs.btrfs.static
@@ -26,10 +19,18 @@ btrfs-find-root.static
 btrfs-image
 btrfs-show-super
 btrfs-zero-log
-btrfs-corrupt-block
 btrfs-select-super
 btrfstune
 libbtrfs.a
 libbtrfs.so
 libbtrfs.so.0
 libbtrfs.so.0.1
+cmd/btrfs
+cmd/btrfs.static
+cmd/btrfsck
+tests/btrfs-corrupt-block
+tests/dir-test
+tests/ioctl-test
+tests/quick-test
+tests/random-test
+tests/send-test

