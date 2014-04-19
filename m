Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:25166 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077AbaDSLMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 07:12:07 -0400
Date: Sat, 19 Apr 2014 14:12:03 +0300
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fi-disk_usage: free memory if realloc fails
Message-ID: <20140419111201.GA4762@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lets not assign *info_ptr to 0 before calling free on it and lose
track of already allocated memory if realloc fails in
add_info_to_list. Lets call free first.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 cmds-fi-disk_usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 2bd591d..cd71c8d 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -104,6 +104,7 @@ static int add_info_to_list(struct chunk_info **info_ptr,
 			struct chunk_info *res = realloc(*info_ptr, size);
 
 			if (!res) {
+				free(*info_ptr);
 				fprintf(stderr, "ERROR: not enough memory\n");
 				return -1;
 			}
@@ -224,7 +225,6 @@ static int load_chunk_info(int fd,
 
 			if (add_info_to_list(info_ptr, info_count, item)) {
 				*info_ptr = 0;
-				free(*info_ptr);
 				return -100;
 			}
 
-- 
1.8.5.3

