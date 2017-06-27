Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:46014 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750934AbdF0EVA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 00:21:00 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: dsterba@suse.cz, Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Tue, 27 Jun 2017 06:18:23 +0200
Message-Id: <20170627041823.1300-1-kilobyte@angband.pl>
In-Reply-To: <20170626121230.GF2866@twin.jikos.cz>
References: <20170626121230.GF2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH] lib/zstd: use div_u64() to let it build on 32-bit
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> > Thus, you want do_div() instead of /; do check widths and signedness of
> > arguments.
>
> No do_div please, div_u64 or div64_u64.

Good to know, the interface of do_div() is indeed weird.

I guess Nick has found and fixed the offending divisions in his tree
already, but this patch I'm sending is what I'm testing.

One thing to note is that it divides u64 by size_t, so the actual operation
differs on 32 vs 64-bit.  Yet the code fails to handle compressing pieces
bigger than 4GB in other places -- so use of size_t is misleading.  Perhaps
u32 would better convey this limitation?

Anyway, that this code didn't even compile on 32-bit also means it hasn't
been tested.  I just happen to have such an ARM machine doing Debian archive
rebuilds; I've rewritten the chroots with compress=zstd; this should be a
nice non-artificial test.  The load consists of snapshot+dpkg+gcc/etc+
assorted testsuites, two sbuild instances.  Seems to work fine for a whole
hour (yay!) already, let's see if there'll be any explosions.


-- >8 ---- >8 ---- >8 ---- >8 ---- >8 ---- >8 ---- >8 ---- >8 ---- >8 --
Note that "total" is limited to 2³²-1 elsewhere despite being declared
as size_t, so it's ok to use 64/32 -- it's much faster on eg. x86-32
than 64/64.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 lib/zstd/fse_compress.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/zstd/fse_compress.c b/lib/zstd/fse_compress.c
index e016bb177833..f59f9ebfe9c0 100644
--- a/lib/zstd/fse_compress.c
+++ b/lib/zstd/fse_compress.c
@@ -49,6 +49,7 @@
 #include "fse.h"
 #include <linux/compiler.h>
 #include <linux/string.h> /* memcpy, memset */
+#include <linux/math64.h>
 
 /* **************************************************************
 *  Error Management
@@ -575,7 +576,7 @@ static size_t FSE_normalizeM2(short *norm, U32 tableLog, const unsigned *count,
 	{
 		U64 const vStepLog = 62 - tableLog;
 		U64 const mid = (1ULL << (vStepLog - 1)) - 1;
-		U64 const rStep = ((((U64)1 << vStepLog) * ToDistribute) + mid) / total; /* scale on remaining */
+		U64 const rStep = div_u64((((U64)1 << vStepLog) * ToDistribute) + mid, total); /* scale on remaining */
 		U64 tmpTotal = mid;
 		for (s = 0; s <= maxSymbolValue; s++) {
 			if (norm[s] == NOT_YET_ASSIGNED) {
@@ -609,7 +610,7 @@ size_t FSE_normalizeCount(short *normalizedCounter, unsigned tableLog, const uns
 	{
 		U32 const rtbTable[] = {0, 473195, 504333, 520860, 550000, 700000, 750000, 830000};
 		U64 const scale = 62 - tableLog;
-		U64 const step = ((U64)1 << 62) / total; /* <== here, one division ! */
+		U64 const step = div_u64((U64)1 << 62, total); /* <== here, one division ! */
 		U64 const vStep = 1ULL << (scale - 20);
 		int stillToDistribute = 1 << tableLog;
 		unsigned s;
-- 
2.13.1

