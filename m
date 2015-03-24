Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbbCXViZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 17:38:25 -0400
Message-ID: <5511D94C.9090109@redhat.com>
Date: Tue, 24 Mar 2015 16:38:20 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: fstests@vger.kernel.org
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] fstests: update _filter_btrfs_version
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs cmd now sometimes emits "btrfs-progs" not "Btrfs-progs"
as it used to, so update the filter accordingly.

(This fixes a failure on btrfs/006 w/ btrfs-progs v3.19)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/filter.btrfs b/common/filter.btrfs
index c9b3f3a..ea047c5 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -5,7 +5,7 @@
 # Some, but not all, commands emit "Btrfs <version>"
 _filter_btrfs_version()
 {
-	sed -e "s/^Btrfs.*//g"
+	sed -e "s/^[Bb]trfs.*//g"
 }
 
 _filter_devid()

