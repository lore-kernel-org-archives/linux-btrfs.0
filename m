Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794197435;
	b=IqIzbLIq3aBSG+kkg5YPVI+LjCfDol2vZztgbLzvAF57ocLV6m7PCiCEEt/Q5pvU11Ey
	 +Ab5R1aldI34X34VVa14Fz6P1GZL3hnl3Z3xgD/wCQEC7esqlFI4K9FOmOB0wbwKQ/vpW
	 vKVSNGVjQTg2d6hoDgzwWYG+PshdJmyOtw/4aSmYJAy9cIg571coejpeoA2/DvGwdXgib
	 7cTkufY5kkqPjZjtYxlLLOyQsjeKdEDbzY8N2fysB1cYl+1a4rBmFey/e/UWCNs8Ik+K4
	 ZM5W6wTsXQV/KXZeYOmEMi2Ndy/ZKF9ojNdZ+dQZzCxJcYM9ORiDD7ndW9Q8wb5kkwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794197435;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=EHTkKAoAx0x1IXCnaiV62m64RvzOh1PuCfQTaY2iqGo=;
	b=Knso/cdRlXYGDJ3n7vQtp4Ik3eq8rz2V/srGbnDiEkUQ2szAPYuy/2NlosPRyRh374yv
	 P+2Hix/AUfxeRCXcJHuOGjNeCfDbZP+ijIcCiRoD7l7i+ZB03AUu3EsUAPxWxDPlbxpwZ
	 ChPIs1m0RHvahTwtdhCmvknKqbgZzqurgkFTrgRh3YEtHg4oMi/8vgwbuBUeu89cRi7tg
	 A7ZFGOl2lWY1vvHZEOviCLvgAID4n3THUZkBYK7Re1ItpqPQoQR5C5dqCenoZ76xJpmA4
	 rzoqM0YoIbAry+mmZviU64vBs7M4Pwn5b1ySHSKP0w5KbVEwV/6DgMbmeLKAeiGzPQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kZkt8Vdr;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kZkt8Vdr;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BA3606A335
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33BA3606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kZkt8Vdr;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kZkt8Vdr
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F1941FB6A
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EHTkKAoAx0x1IXCnaiV62m64RvzOh1PuCfQTaY2iqGo=;
	b=kZkt8VdriJDXC5g7yh37KMgTc/LSVgE9K9ykvMRnsfdnfmboBX7r6+qrnZDlDF7MAJOELT
	pmdocCktRwum0hmBUup/t5OWuyWg/b138yM8AsLsOGP4IMhtbpwcZkhuhtyYevLsx+4ytx
	DP/6wBZ5O6PM+39sVlWgqjJT29TuR5U=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EHTkKAoAx0x1IXCnaiV62m64RvzOh1PuCfQTaY2iqGo=;
	b=kZkt8VdriJDXC5g7yh37KMgTc/LSVgE9K9ykvMRnsfdnfmboBX7r6+qrnZDlDF7MAJOELT
	pmdocCktRwum0hmBUup/t5OWuyWg/b138yM8AsLsOGP4IMhtbpwcZkhuhtyYevLsx+4ytx
	DP/6wBZ5O6PM+39sVlWgqjJT29TuR5U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85F4313319
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKhEN6tH8WrIZAAAD6G6ig:T8
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 04:10:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 7/7] btrfs-progs: crypto: hash-vectest: cover more block sizes
Date: Mon,  9 Nov 2026 14:40:01 +1030
Message-ID: <57c6f1a3a74881ceaa4ba63194003eb3064b6a7e.1794196688.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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

Currently hash-vectest only has small test vectors (up to 1023 bytes),
which does not exercise the code paths used for real btrfs workloads,
especially the accelerated ones which have different handling for
different lengths.

Add test vectors for the following sizes for all algorithms:

- BTRFS_NAME_LEN (255), the max file name length for btrfs_name_hash()
- SZ_4K, data checksum on 4K sectors
- SZ_16K - BTRFS_CSUM_SIZE, metadata checksum on 16K tree blocks
- SZ_16K

For those large vectors, the plaintext is generated at runtime by an
common LCG from "Numerical Recipes in C", instead of embedding tens of
KiB of data.

The expected digests are calculated by independent tools using python.

Also add the CRC32C test patterns from RFC 3720 (iSCSI).

Finally add a gitignore entry for hash-vectest.

Assisted-by: LLM (the idea of using LCG, coding)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .gitignore            |   1 +
 crypto/hash-vectest.c | 166 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 163 insertions(+), 4 deletions(-)

diff --git a/.gitignore b/.gitignore
index 78333d679a7d..b93a9f872c65 100644
--- a/.gitignore
+++ b/.gitignore
@@ -49,6 +49,7 @@
 /quick-test
 /json-formatter-test
 /hash-speedtest
+/hash-vectest
 
 /aclocal.m4
 /autom4te.cache
diff --git a/crypto/hash-vectest.c b/crypto/hash-vectest.c
index c190a7a01b95..6032daa030f9 100644
--- a/crypto/hash-vectest.c
+++ b/crypto/hash-vectest.c
@@ -15,10 +15,16 @@
  */
 
 #include "kerncompat.h"
+#include "kernel-lib/sizes.h"
+#include "kernel-shared/uapi/btrfs_tree.h"
 #include "crypto/hash.h"
 #include "common/messages.h"
 #include "common/cpu-utils.h"
 
+/*
+ * For test vectors with no plaintext but a non-zero psize, the plaintext is
+ * generated by fill_pattern().
+ */
 struct hash_testvec {
 	const char *plaintext;
 	size_t psize;
@@ -45,6 +51,55 @@ static const struct hash_testvec crc32c_tv[] = {
 		.psize = 7,
 		.digest = "\x41\xf4\x27\xe6",
 	},
+	/* CRC32C test patterns from RFC 3720 (iSCSI), section B.4 */
+	{
+		.plaintext = "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.psize = 32,
+		.digest = "\xaa\x36\x91\x8a",
+	},
+	{
+		.plaintext = "\xff\xff\xff\xff\xff\xff\xff\xff"
+			     "\xff\xff\xff\xff\xff\xff\xff\xff"
+			     "\xff\xff\xff\xff\xff\xff\xff\xff"
+			     "\xff\xff\xff\xff\xff\xff\xff\xff",
+		.psize = 32,
+		.digest = "\x43\xab\xa8\x62",
+	},
+	{
+		.plaintext = "\x00\x01\x02\x03\x04\x05\x06\x07"
+			     "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			     "\x10\x11\x12\x13\x14\x15\x16\x17"
+			     "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.psize = 32,
+		.digest = "\x4e\x79\xdd\x46",
+	},
+	{
+		.plaintext = "\x1f\x1e\x1d\x1c\x1b\x1a\x19\x18"
+			     "\x17\x16\x15\x14\x13\x12\x11\x10"
+			     "\x0f\x0e\x0d\x0c\x0b\x0a\x09\x08"
+			     "\x07\x06\x05\x04\x03\x02\x01\x00",
+		.psize = 32,
+		.digest = "\x5c\xdb\x3f\x11",
+	},
+	{
+		.psize = BTRFS_NAME_LEN,
+		.digest = "\xbb\xd7\xaa\xea",
+	},
+	{
+		.psize = SZ_4K,
+		.digest = "\xb6\xaa\xa5\x04",
+	},
+	{
+		.psize = SZ_16K - BTRFS_CSUM_SIZE,
+		.digest = "\x1d\xb1\xa7\x39",
+	},
+	{
+		.psize = SZ_16K,
+		.digest = "\xd7\xd1\x5b\x37",
+	},
 };
 
 static const struct hash_testvec xxhash64_tv[] = {
@@ -94,7 +149,23 @@ static const struct hash_testvec xxhash64_tv[] = {
 			     "\xed\xfd\x08\xf7\xe8\x04",
 		.psize = 222,
 		.digest = "\x41\xfc\xd4\x29\xfe\xe7\x85\x17",
-	}
+	},
+	{
+		.psize = BTRFS_NAME_LEN,
+		.digest = "\x83\x5a\xfd\x3d\xdb\xda\x73\xfe",
+	},
+	{
+		.psize = SZ_4K,
+		.digest = "\x8a\x21\x49\xcf\x03\x49\x7c\x70",
+	},
+	{
+		.psize = SZ_16K - BTRFS_CSUM_SIZE,
+		.digest = "\xda\x59\x52\x99\x9f\x4e\x0b\x4e",
+	},
+	{
+		.psize = SZ_16K,
+		.digest = "\xf8\xec\x5d\xe3\x99\x47\xaa\x5d",
+	},
 };
 
 static const struct hash_testvec sha256_tv[] = {
@@ -260,7 +331,35 @@ static const struct hash_testvec sha256_tv[] = {
 			     "\x32\x32\x17\xcc\xd4\x6a\x71\xa9"
 			     "\xf3\xed\x50\x10\x64\x8e\x06\xbe"
 			     "\x9b\x4a\xa6\xbb\x05\x89\x59\x51",
-	}
+	},
+	{
+		.psize = BTRFS_NAME_LEN,
+		.digest = "\xde\x26\x80\x6a\x0d\x54\x41\x6d"
+			  "\xc6\x11\x04\x97\x16\xc5\xd1\x46"
+			  "\x7f\x90\x15\xb1\xe8\x99\x10\x4e"
+			  "\x16\xd5\x62\x46\xb8\x55\x01\x6c",
+	},
+	{
+		.psize = SZ_4K,
+		.digest = "\x28\xc7\x4f\x56\xd2\xc9\x59\x95"
+			  "\x5f\x64\xec\x0e\x74\x0b\xe7\xd0"
+			  "\x8a\x02\x3a\x0a\xbf\x03\x2c\x25"
+			  "\x7e\x8e\xf7\x58\x6a\x6b\xb7\x75",
+	},
+	{
+		.psize = SZ_16K - BTRFS_CSUM_SIZE,
+		.digest = "\x9e\x81\xe5\x25\xe3\x9f\xe6\x1b"
+			  "\x69\x74\xb0\x83\xb8\x30\x3d\x4e"
+			  "\xc7\x38\xf0\xb4\x66\x73\x61\x25"
+			  "\xa8\x2e\x4c\x6b\x58\xb9\x55\xa3",
+	},
+	{
+		.psize = SZ_16K,
+		.digest = "\xfb\xbb\xb4\x2b\xbd\xf4\xee\xb7"
+			  "\x85\xdd\x39\x84\xd8\x88\xa5\xa2"
+			  "\xa4\x38\xd4\xff\xb3\x45\xed\x5e"
+			  "\xa1\x2f\x06\x1d\x86\xa5\x4b\x77",
+	},
 };
 
 static const struct hash_testvec blake2b_256_tv[] = {
@@ -423,7 +522,35 @@ static const struct hash_testvec blake2b_256_tv[] = {
 			     "\xbf\xe6\x82\x94\x3f\x59\x91\xee"
 			     "\x18\xa6\x27\xc3\x00\x12\xa5\xd0"
 			     "\x92\x3a\xb1\xc6\xa3\x46\x5a\xea",
-	}
+	},
+	{
+		.psize = BTRFS_NAME_LEN,
+		.digest = "\x1e\x1f\xab\x3d\xb0\x47\x44\x16"
+			  "\x0a\xa7\x57\xd7\xc3\x5b\x61\xe0"
+			  "\x8b\xe5\xba\x1e\x4b\x6a\x31\xec"
+			  "\xc3\xcd\x5e\x33\x98\x21\x0a\xac",
+	},
+	{
+		.psize = SZ_4K,
+		.digest = "\x8b\x28\x0b\xea\xd0\x4d\x22\x0f"
+			  "\x6f\x20\xc8\xdb\x23\x91\xdc\x2e"
+			  "\x97\x90\xee\x86\x73\x12\xbc\x56"
+			  "\xe7\x17\x08\x34\xd9\x00\xf8\xc8",
+	},
+	{
+		.psize = SZ_16K - BTRFS_CSUM_SIZE,
+		.digest = "\x71\x89\xeb\x26\x42\x2e\xb5\x1d"
+			  "\x30\xb5\x76\xe5\x76\x8a\xf7\x53"
+			  "\x3a\x39\xb9\x1d\xad\x13\xcf\x92"
+			  "\x17\xe3\x70\x32\x34\xd2\xd4\x23",
+	},
+	{
+		.psize = SZ_16K,
+		.digest = "\x28\x4d\xcc\xe6\x6b\x9e\x55\xb1"
+			  "\x27\x0a\xa6\x7a\x6e\x5f\x8f\xca"
+			  "\xcf\x45\xff\x6e\xd4\xbc\x0d\x6d"
+			  "\x33\x24\x22\x7a\xab\x3e\xe4\x90",
+	},
 };
 
 static const struct hash_testspec test_spec[] = {
@@ -594,6 +721,24 @@ static const struct hash_testspec test_spec[] = {
 	}
 };
 
+/*
+ * Fill the buffer with bytes from a 32-bit LCG, x = x * 1664525 + 1013904223,
+ * as used in "Numerical Recipes in C". The seed is arbitrary.
+ *
+ * Only the top byte is used, since the low bits of a power-of-2 modulus LCG
+ * have very short periods.
+ */
+static void fill_pattern(u8 *buf, size_t size)
+{
+	u32 x = 1;
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		x = x * 1664525 + 1013904223;
+		buf[i] = x >> 24;
+	}
+}
+
 static int test_hash(const struct hash_testspec *spec)
 {
 	int i;
@@ -603,6 +748,8 @@ static int test_hash(const struct hash_testspec *spec)
 		int ret;
 		const struct hash_testvec *vec = &spec->testvec[i];
 		u8 csum[CRYPTO_HASH_SIZE_MAX];
+		const u8 *data = (const u8 *)vec->plaintext;
+		u8 *buf = NULL;
 
 		if (spec->cpu_flag != 0 && !cpu_has_feature(spec->cpu_flag)) {
 			printf("%s skipped, no CPU support\n", spec->name);
@@ -617,9 +764,20 @@ static int test_hash(const struct hash_testspec *spec)
 			header = true;
 		}
 
+		if (!data && vec->psize) {
+			buf = malloc(vec->psize);
+			if (!buf) {
+				error_mem("test vector");
+				return 1;
+			}
+			fill_pattern(buf, vec->psize);
+			data = buf;
+		}
+
 		if (spec->cpu_flag)
 			hash_force_accel(spec->cpu_flag);
-		ret = spec->hash((const u8 *)vec->plaintext, vec->psize, csum);
+		ret = spec->hash(data, vec->psize, csum);
+		free(buf);
 		if (ret < 0) {
 			error("hash %s = %d", spec->name, ret);
 			return 1;
-- 
2.56.0

