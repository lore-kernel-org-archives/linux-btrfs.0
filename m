Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794197434;
	b=vh/ZO4t1S0zPGwR94UjkTEXMyXOEB9vPdjM0c0DOyNA1F15e5v3MMFvoi2N4PA1i3gzi
	 ZfSMJ4QCGs/Ii6wOTAJ4UNnHFO8CQUz+hO2o9uU1ezT9VIqOnARqQUhdpnDkT5eA+gErY
	 vc3rtnDVHtl7la91ovtue4gUwXbUmXox3SeMEu2zVtkOyv0WkROZeTmYTgZ/yroJ/OfTb
	 7UApHxyR07uWQbadwW79CZSSY8mlaSpco2yV3N6KCwGmaA9EhPLZCsiuTrVKKS0D9rEyF
	 fxpGUaHFTDqUWaJrAFeKgOLHhTNt1uJIyT4E+vBkTO39g3IDRguqrQIATKCjyoZGlww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794197434;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=+yY4/k5WOF03/TkNYQqUTF4bf3qu1iZofvHWh25+4HA=;
	b=0ZCtoWlDPJPfjvLXFsL0CIrI00A66fmMSOkbV7WYabtkoNMSj5FrnV5dllJb0xIDexOT
	 cgVMhhgsSMud99TFBfKZ+m+XQMzmj98hoJPT7NK4bXPvzEJvHSGRDbhjJUYcIwoHtDA89
	 TVrdBFErynNZyggvPpZkLKiIVai8bPgS1yyO+/2QjZMhBlzFLvhRv3H9JoUIQZopNOals
	 AoDBvW2TBUS5Mx2C+/TSrKwVLdpmMdr0olhMZvrYsDzhjZSeAcceiiPZcdwkF3YESGuzz
	 5Ji9Jr4MrJLz4XBsZElVyPV+muZbu0w3F30iK/sGHVtvwbbjRiviSXixvxiRb4ytOLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dMZmUXe7;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dMZmUXe7;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE00606A338
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CE00606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dMZmUXe7;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dMZmUXe7
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F31E71F82A
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+yY4/k5WOF03/TkNYQqUTF4bf3qu1iZofvHWh25+4HA=;
	b=dMZmUXe7+Cku0DYxQ/25+p58oYSnw1BQhs8I8KOSnuY3kB3vJeGzj/teS4jlD8d736k4Uj
	zWvnmAtkCRRkvQBjPtA7vDAWscLcXtuvUwryw3GK4ymMg2RHk/2MuPuI6FJwJhRr0EiVgT
	0/pFQxgo+fwQ0YNw/OVDAFkFi1zVLis=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+yY4/k5WOF03/TkNYQqUTF4bf3qu1iZofvHWh25+4HA=;
	b=dMZmUXe7+Cku0DYxQ/25+p58oYSnw1BQhs8I8KOSnuY3kB3vJeGzj/teS4jlD8d736k4Uj
	zWvnmAtkCRRkvQBjPtA7vDAWscLcXtuvUwryw3GK4ymMg2RHk/2MuPuI6FJwJhRr0EiVgT
	0/pFQxgo+fwQ0YNw/OVDAFkFi1zVLis=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D96A213319
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKhEN6tH8WrIZAAAD6G6ig:T7
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 04:10:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/7] btrfs-progs: crypto: hash-speedtest: cover more block sizes
Date: Mon,  9 Nov 2026 14:40:00 +1030
Message-ID: <586e2432deb39abb1934dd4c8a9868c42832fd68.1794196688.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794196688.git.wqu@suse.com>
References: <cover.1794196688.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Currently hash-speedtest only benchmarks 4K blocks, but btrfs hashes
buffers of very different sizes:

- btrfs_name_hash() on file names, up to 255 bytes
- data checksum on 4K sectors
- metadata checksum on tree blocks, 16K by default

Run every contestant against 16, 255 (BTRFS_NAME_LEN), 4K and 16K,
printing a separate section for each block size.

For the 16K case, the real metadata checksum length is 16K - 32 as the
csum header is skipped, but the difference to a full 16K is minimal, so
just use 16K.

Also fix the MiB/s calculation, which can overflow int for large sizes.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 crypto/hash-speedtest.c | 132 ++++++++++++++++++++++------------------
 1 file changed, 74 insertions(+), 58 deletions(-)

diff --git a/crypto/hash-speedtest.c b/crypto/hash-speedtest.c
index a26959ae66e8..9a7d81d582fb 100644
--- a/crypto/hash-speedtest.c
+++ b/crypto/hash-speedtest.c
@@ -27,7 +27,9 @@
 #endif
 #include "crypto/hash.h"
 #include "common/messages.h"
+#include "kernel-lib/sizes.h"
 #include "common/cpu-utils.h"
+#include "kernel-shared/uapi/btrfs_tree.h"
 
 #ifdef __x86_64__
 #include <x86intrin.h>
@@ -42,7 +44,15 @@ enum {
 	UNITS_PERF,
 };
 
-const int blocksize = 4096;
+/*
+ * Default sizes:
+ * - 16, 255	btrfs_name_hash() on short and max name length
+ * - 4096	data checksum with 4K sectorsize
+ * - 16384	metadata checksum with 16K nodesize, the difference from the
+ *		real size (16K - 32, no csum header) is minimal
+ */
+static const size_t sizes[] = { SZ_16, BTRFS_NAME_LEN, SZ_4K, SZ_16K };
+
 int iterations = 100000;
 
 #ifdef __x86_64__
@@ -162,10 +172,8 @@ static const char *units_to_str(int units)
 }
 
 int main(int argc, char **argv) {
-	u8 buf[blocksize];
+	u8 *buf;
 	u8 hash[32];
-	int idx;
-	int iter;
 	char *filter = NULL;
 	struct contestant {
 		char name[20];
@@ -282,69 +290,77 @@ int main(int argc, char **argv) {
 			iterations = 1;
 	}
 
-	memset(buf, 0, 4096);
+	buf = malloc(SZ_16K);
+	if (!buf) {
+		error_mem("buffer");
+		return 1;
+	}
 
-	printf("Block size:     %d\n", blocksize);
 	printf("Iterations:     %d\n", iterations);
 	printf("Implementation: %s\n", CRYPTOPROVIDER);
 	printf("Units:          %s\n", units_to_desc(units));
-	printf("\n");
 
-	for (idx = 0; idx < ARRAY_SIZE(contestants); idx++) {
-		struct contestant *c = &contestants[idx];
-		u64 start, end;
-		u64 tstart, tend;
-		u64 total = 0;
+	for (int i = 0; i < ARRAY_SIZE(sizes); i++) {
+		size_t size = sizes[i];
 
-		if (c->cpu_flag != 0 && !cpu_has_feature(c->cpu_flag)) {
-			printf("%16s: no CPU support\n", c->name);
-			continue;
+		printf("\nBlock size:     %zu\n", size);
+		for (int idx = 0; idx < ARRAY_SIZE(contestants); idx++) {
+			struct contestant *c = &contestants[idx];
+			u64 start, end;
+			u64 tstart, tend;
+			u64 total = 0;
+
+			if (c->cpu_flag != 0 && !cpu_has_feature(c->cpu_flag)) {
+				printf("%16s: no CPU support\n", c->name);
+				continue;
+			}
+			/* Backend not compiled in */
+			if (c->backend == 1)
+				continue;
+
+			if (c->digest == hash_null_memcpy)
+				/* Always run NULL-MEMCPY to warm up memory. */;
+			else if (filter && fnmatch(filter, c->name, FNM_CASEFOLD) != 0)
+				continue;
+
+			printf("%16s: ", c->name);
+			fflush(stdout);
+
+			if (c->cpu_flag)
+				hash_force_accel(c->cpu_flag);
+			tstart = get_time();
+			start = get_cycles(units);
+			for (int iter = 0; iter < iterations; iter++) {
+				memset(buf, iter & 0xFF, size);
+				memset(hash, 0, 32);
+				c->digest(buf, size, hash);
+			}
+			end = get_cycles(units);
+			tend = get_time();
+			c->cycles = end - start;
+			c->time = tend - tstart;
+
+			if (units == UNITS_CYCLES || units == UNITS_PERF)
+				total = c->cycles;
+			if (units == UNITS_TIME)
+				total = c->time;
+
+			printf("%s: %12llu, %s/i %8llu",
+					units_to_str(units), total,
+					units_to_str(units), total / iterations);
+			if (idx > 0) {
+				float t;
+				float mb;
+
+				t = (float)c->time / 1000 / 1000 / 1000;
+				mb = (float)size * iterations / 1024 / 1024;
+				printf(", %12.3f MiB/s", mb / t);
+			}
+			putchar('\n');
 		}
-		/* Backend not compiled in */
-		if (c->backend == 1)
-			continue;
-
-		if (c->digest == hash_null_memcpy)
-			/* Always run NULL-MEMCPY to warm up memory. */;
-		else if (filter && fnmatch(filter, c->name, FNM_CASEFOLD) != 0)
-			continue;
-
-		printf("%16s: ", c->name);
-		fflush(stdout);
-
-		if (c->cpu_flag)
-			hash_force_accel(c->cpu_flag);
-		tstart = get_time();
-		start = get_cycles(units);
-		for (iter = 0; iter < iterations; iter++) {
-			memset(buf, iter & 0xFF, blocksize);
-			memset(hash, 0, 32);
-			c->digest(buf, blocksize, hash);
-		}
-		end = get_cycles(units);
-		tend = get_time();
-		c->cycles = end - start;
-		c->time = tend - tstart;
-
-		if (units == UNITS_CYCLES || units == UNITS_PERF)
-			total = c->cycles;
-		if (units == UNITS_TIME)
-			total = c->time;
-
-		printf("%s: %12llu, %s/i %8llu",
-				units_to_str(units), total,
-				units_to_str(units), total / iterations);
-		if (idx > 0) {
-			float t;
-			float mb;
-
-			t = (float)c->time / 1000 / 1000 / 1000;
-			mb = blocksize * iterations / 1024 / 1024;
-			printf(", %12.3f MiB/s", mb / t);
-		}
-		putchar('\n');
 	}
 	perf_finish();
+	free(buf);
 	free(filter);
 
 	return 0;
-- 
2.56.0

