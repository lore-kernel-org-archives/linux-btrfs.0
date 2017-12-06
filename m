Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41397 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbdLFQor (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 11:44:47 -0500
From: Pravin Shedge <pravin.shedge4linux@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pravin.shedge4linux@gmail.com
Subject: [PATCH 23/45] fs: btrfs: remove duplicate includes
Date: Wed,  6 Dec 2017 22:14:31 +0530
Message-Id: <1512578671-4988-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
---
 fs/btrfs/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3a4dce1..b34fe15 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -61,7 +61,6 @@
 #include "tests/btrfs-tests.h"
 
 #include "qgroup.h"
-#include "backref.h"
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
 
-- 
2.7.4

