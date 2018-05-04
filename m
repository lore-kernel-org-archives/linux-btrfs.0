Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:38689 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbeEDAP5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 May 2018 20:15:57 -0400
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-raid@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] raid6_pq: Add module options to prefer algorithm
Date: Fri,  4 May 2018 03:15:41 +0300
Message-Id: <20180504001541.2068-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Skip testing unnecessary algorithms to speedup module initialization

For my systems:
  Before: 1.510s (initrd)
  After:  977ms  (initrd) # I set prefer to fastest algorithm

Dmesg after patch:
[    1.190042] raid6: avx2x4   gen() 28153 MB/s
[    1.246683] raid6: avx2x4   xor() 19440 MB/s
[    1.246684] raid6: using algorithm avx2x4 gen() 28153 MB/s
[    1.246684] raid6: .... xor() 19440 MB/s, rmw enabled
[    1.246685] raid6: using avx2x2 recovery algorithm

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
CC: linux-btrfs@vger.kernel.org
---
 lib/raid6/algos.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 5065b1e7e327..abfcb4107fc3 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -30,6 +30,11 @@ EXPORT_SYMBOL(raid6_empty_zero_page);
 #endif
 #endif
 
+static char *prefer_name;
+
+module_param(prefer_name, charp, 0);
+MODULE_PARM_DESC(prefer_name, "Prefer gen/xor() algorithm");
+
 struct raid6_calls raid6_call;
 EXPORT_SYMBOL_GPL(raid6_call);
 
@@ -155,10 +160,27 @@ static inline const struct raid6_calls *raid6_choose_gen(
 {
 	unsigned long perf, bestgenperf, bestxorperf, j0, j1;
 	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half of the disks */
-	const struct raid6_calls *const *algo;
-	const struct raid6_calls *best;
+	const struct raid6_calls *const *algo = NULL;
+	const struct raid6_calls *best = NULL;
+
+	if (strlen(prefer_name)) {
+		for (algo = raid6_algos; strlen(prefer_name) && *algo; algo++) {
+			if (!strncmp(prefer_name, (*algo)->name, 8)) {
+				best = *algo;
+				break;
+			}
+		}
+		if (!best)
+			pr_info("raid6: %-8s prefer not found\n", prefer_name);
+	}
+
+
+
+	if (!algo) {
+		algo = raid6_algos;
+	}
 
-	for (bestgenperf = 0, bestxorperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
+	for (bestgenperf = 0, bestxorperf = 0; *algo; algo++) {
 		if (!best || (*algo)->prefer >= best->prefer) {
 			if ((*algo)->valid && !(*algo)->valid())
 				continue;
-- 
2.17.0
