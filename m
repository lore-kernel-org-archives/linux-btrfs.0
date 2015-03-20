Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxf2.bahnhof.se ([213.80.101.26]:55211 "EHLO mxf2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbbCTBKq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 21:10:46 -0400
Received: from localhost (mxf2.local [127.0.0.1])
	by mxf2-reinject (Postfix) with ESMTP id 169681E944F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:10:45 +0100 (CET)
Received: from mxf2.bahnhof.se ([127.0.0.1])
	by localhost (mxf2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vz8c4JTVoRet for <linux-btrfs@vger.kernel.org>;
	Fri, 20 Mar 2015 02:10:39 +0100 (CET)
Received: from miria.naju.se (h-219-91.a163.priv.bahnhof.se [85.24.219.91])
	by mxf2.bahnhof.se (Postfix) with ESMTP id 981221E944E
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:10:39 +0100 (CET)
Received: from sebban (helo=localhost)
	by miria.naju.se with local-esmtp (Exim 4.80)
	(envelope-from <sebth@naju.se>)
	id 1YYlSR-0006zC-DX
	for linux-btrfs@vger.kernel.org; Fri, 20 Mar 2015 02:10:39 +0100
Date: Fri, 20 Mar 2015 02:10:39 +0100 (CET)
From: Sebastian Thorarensen <sebth@naju.se>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] btrfs-progs: Fix msgs in check_node_or_leaf_size
In-Reply-To: <cover.1426812639.git.sebth@naju.se>
Message-ID: <35c6041a8e16c9a0591b22ba2f2c582abbaf67ee.1426812639.git.sebth@naju.se>
References: <cover.1426812639.git.sebth@naju.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

check_node_or_leaf_size in utils.c now prints 'nodesize (or leafsize)'
instead of 'leafsize (or nodesize)' in the error messages, in order to
be less confusing for the user, as leafsize in mkfs is deprecated.
'ERROR: ' is also prepended to be consistent with other error messages.

Signed-off-by: Sebastian Thorarensen <sebth@naju.se>
---
 utils.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index ba01e0c..ffd3e6e 100644
--- a/utils.c
+++ b/utils.c
@@ -2725,17 +2725,17 @@ int check_node_or_leaf_size(u32 size, u32 sectorsize)
 {
 	if (size < sectorsize) {
 		fprintf(stderr,
-			"Illegal leafsize (or nodesize) %u (smaller than %u)\n",
+			"ERROR: Illegal nodesize (or leafsize) %u (smaller than %u)\n",
 			size, sectorsize);
 		return -1;
 	} else if (size > BTRFS_MAX_METADATA_BLOCKSIZE) {
 		fprintf(stderr,
-			"Illegal leafsize (or nodesize) %u (larger than %u)\n",
+			"ERROR: Illegal nodesize (or leafsize) %u (larger than %u)\n",
 			size, BTRFS_MAX_METADATA_BLOCKSIZE);
 		return -1;
 	} else if (size & (sectorsize - 1)) {
 		fprintf(stderr,
-			"Illegal leafsize (or nodesize) %u (not align to %u)\n",
+			"ERROR: Illegal nodesize (or leafsize) %u (not aligned to %u)\n",
 			size, sectorsize);
 		return -1;
 	}
-- 
1.7.10.4

