Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28742 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbbAMWV4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 17:21:56 -0500
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t0DMLmoH011917
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 14:21:56 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1rwbqrg222-6
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 14:21:56 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Revert "btrfs-progs: disable backtrace and define __always_inline"
Date: Tue, 13 Jan 2015 17:20:19 -0500
Message-ID: <1421187619-24936-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit c2691f807ddd2c6b261c5707f6838a45d9275390 as it breaks
backtracing on actual glibc environments.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 kerncompat.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index 7397274..5c1cca9 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -29,12 +29,6 @@
 #include <stddef.h>
 #include <linux/types.h>
 #include <stdint.h>
-
-#ifndef __glibc__
-#define BTRFS_DISABLE_BACKTRACE
-#define __always_inline __inline __attribute__ ((__always_inline__))
-#endif
-
 #ifndef BTRFS_DISABLE_BACKTRACE
 #include <execinfo.h>
 #endif
-- 
1.8.3.1

