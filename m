Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750764AbeGCLmt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 07:42:49 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8476AAE79
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2018 11:42:48 +0000 (UTC)
From: David Disseldorp <ddiss@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: [PATCH] btrfs-progs: check: add experimental flag for lowmem mode
Date: Tue,  3 Jul 2018 13:42:37 +0200
Message-Id: <20180703114237.11053-1-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The experimental flag is already carried in the manpage, but was removed
from the btrfs check usage message as part of refactoring via
87c1bd13c1fca430c3dbf0da62e9aa33bde609c8. Add it back.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 3190b5d4..9aca0c09 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9386,7 +9386,7 @@ const char * const cmd_check_usage[] = {
 	"                            original - read inodes and extents to memory (requires",
 	"                                       more memory, does less IO)",
 	"                            lowmem   - try to use less memory but read blocks again",
-	"                                       when needed",
+	"                                       when needed (experimental)",
 	"--check-data-csum           verify checksums of data blocks",
 	"-Q|--qgroup-report          print a report on qgroup consistency",
 	"-E|--subvol-extents <subvolid>",
-- 
2.13.7

