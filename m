Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:36409 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754574AbaDSAOd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 20:14:33 -0400
Date: Sat, 19 Apr 2014 03:14:29 +0300
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: cmds-subvolume: use parameter str instead of
 optarg
Message-ID: <20140419001428.GA5788@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix unused parameter str (commit e8cfa3c8): get_subvolid was called
with optarg passed as str, but get_subvolid kept using optarg.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 cmds-subvolume.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index bd81a8f..639fb10 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -596,9 +596,9 @@ static int get_subvolid(const char *str, u64 *subvolid)
 {
 	char *p;
 	errno = 0;
-	*subvolid = strtoull(optarg, &p, 10);
+	*subvolid = strtoull(str, &p, 10);
 	if (errno || *p != '\0') {
-		fprintf(stderr, "ERROR: invalid subvolume id '%s'\n", optarg);
+		fprintf(stderr, "ERROR: invalid subvolume id '%s'\n", str);
 		return -EINVAL;
 	}
 	return 0;
-- 
1.8.5.3

