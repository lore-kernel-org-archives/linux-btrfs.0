Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794197435;
	b=HuJjwgqt1Do+QGjM0kJHED+y1xJ4oKG9wD1pxHk0NySU8QM2FVggZH3RFxMKtthYrmHr
	 T5IB2bZ6pCnU5VDAGRfYn5pnT58EIB4PsHW3p4ZrYI4BIBIUSBpkcCC1M1BF+676gDyir
	 pgcAhBE/4Vv2y7xBXC2BKzFwzBuiyhiIec+r6CAmvi/V011wQDMepD7go5U+TBvJ10VKz
	 W5373VQBUcVzDE6iTBLvfNRFmtEOYPdzWyWcZgps+zuDCy6jTp4IMhS2gLPZ8+h4O8b0d
	 1xX6Zj9Hw6Uf1sXeQGS9pg0QSVrGdobzD8TCuK68gOCCzZZFVIEBzsLnESyAU7hQkBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794197435;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=1/ZE23CptGCutw9IvgcI8F8KEWAGIPDUpaYAGbiHMxo=;
	b=uv4l7gVc8gTjzVPN/jitt7rZR3OtKA2P2LGDgZMdl79vdhBozBkt+nRCar5rIyPZ2zqI
	 2rpZBJZCsJOxdNpVuInYk1LXpN0hCfxr0nUAU/guJ4ZfFCYEHatU/AtEidZMqPqsjUB5l
	 K4qNoxkXBhKoaFv+DYWXomlSIH5wy8YOOmfa59SIvH4FLsrQUJpq10mALgg4xomeCubis
	 15NgdUgJv52L8/e/8b/4ZRNVctqNd8iqQCzwEGKHDtbV9/ce5RAMM5nWaxxW29qZ1ur0P
	 AEe7tYCHKss7ynH4t9uT4BceU29Z1g4YTx+SxCr/Tzsrbo+Yasz3DM4QeP6jpeSv8rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GWZ+Ha70;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GWZ+Ha70;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E8E606A331
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55E8E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GWZ+Ha70;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GWZ+Ha70
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 052BF1FB15
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1/ZE23CptGCutw9IvgcI8F8KEWAGIPDUpaYAGbiHMxo=;
	b=GWZ+Ha7095xad+67jZhnLgM821B3B7ZlYPBFao8AXhq4zAO4rs/o4ffbnxFGPEfFcsHuaG
	xkDE+yIRAi5rQsLd6nC3J8lzKCm8+zeO4Dva76EtQkqZSyD03B293CnPRuIXe9GC954d3d
	T0/wC8QGnX+mkD3uoF9b+zq98Xu59Hc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GWZ+Ha70
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1/ZE23CptGCutw9IvgcI8F8KEWAGIPDUpaYAGbiHMxo=;
	b=GWZ+Ha7095xad+67jZhnLgM821B3B7ZlYPBFao8AXhq4zAO4rs/o4ffbnxFGPEfFcsHuaG
	xkDE+yIRAi5rQsLd6nC3J8lzKCm8+zeO4Dva76EtQkqZSyD03B293CnPRuIXe9GC954d3d
	T0/wC8QGnX+mkD3uoF9b+zq98Xu59Hc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE6E513479
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKhEN6tH8WrIZAAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 04:10:25 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/7] btrfs-progs: rename cpu features to prepare for other archs
Date: Mon,  9 Nov 2026 14:39:57 +1030
Message-ID: <f77ff5d4ca8e91fb092deaa04450bc542ad40aab.1794196688.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 052BF1FB15
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

Currently btrfs-progs only implements extra instructions for x86_64 for
hardware accelerated hash algorithms.

But we're soon going to support arm64 hardware accelerated hashes, so
rename the follow names to include arch prefixes:

- CPU_FLAG_*
  Now it's CPU_FLAG_NONE and CPU_FLAG_X64_*.
  CPU_FLAG_ARM64_* will come soon.

- FLAG() helper
  Now it's only FLAG_X64(). Will have FLAG_ARM64() in the future.

- hash-speedtest and hash-vectest names
  The following are affected:
  * CRC32C-SSE42
    CRC32C-X64-SSE42

  * CRC32c-NI
    CRC32C-X64-NI

  * SHA256-NI
    SHA256-X64-NI

  * BALKE2-SSE2
    BLAKE2-X64-SSE2

  * BALKE2-SSE41
    BLAKE2-X64-SSE41

  * BLAKE2-AVX2
    BLAKE2-X64-AVX2

  This change also makes the name[] array larger, now it's 20 bytes.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/cpu-utils.c      | 36 ++++++++++++++++++------------------
 common/cpu-utils.h      | 16 ++++++++--------
 crypto/blake2b-ref.c    |  6 +++---
 crypto/crc32c.c         |  6 +++---
 crypto/hash-speedtest.c | 30 +++++++++++++++---------------
 crypto/hash-vectest.c   | 24 ++++++++++++------------
 crypto/sha224-256.c     |  2 +-
 7 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/common/cpu-utils.c b/common/cpu-utils.c
index a99efb932ff2..d8fbf664b998 100644
--- a/common/cpu-utils.c
+++ b/common/cpu-utils.c
@@ -23,21 +23,21 @@
 unsigned long __cpu_flags = CPU_FLAG_NONE;
 unsigned long __cpu_flags_orig = CPU_FLAG_NONE;
 
-#define FLAG(name)	if (__cpu_flags & CPU_FLAG_ ## name) printf(" " #name)
+#define FLAG_X64(name)	if (__cpu_flags & CPU_FLAG_X64_ ## name) printf(" " #name)
 void cpu_print_flags(void) {
 	printf("CPU flags: 0x%lx\n", __cpu_flags);
 	printf("CPU features:");
-	FLAG(SSE2);
-	FLAG(SSSE3);
-	FLAG(SSE41);
-	FLAG(SSE42);
-	FLAG(PCLMUL);
-	FLAG(SHA);
-	FLAG(AVX);
-	FLAG(AVX2);
+	FLAG_X64(SSE2);
+	FLAG_X64(SSSE3);
+	FLAG_X64(SSE41);
+	FLAG_X64(SSE42);
+	FLAG_X64(PCLMUL);
+	FLAG_X64(SHA);
+	FLAG_X64(AVX);
+	FLAG_X64(AVX2);
 	putchar(10);
 }
-#undef FLAG
+#undef FLAG_X64
 
 #ifdef __x86_64__
 
@@ -48,26 +48,26 @@ void cpu_detect_flags(void)
 	__builtin_cpu_init();
 	__cpu_flags = CPU_FLAG_NONE;
 	if (__builtin_cpu_supports("sse2"))
-		__cpu_flags |= CPU_FLAG_SSE2;
+		__cpu_flags |= CPU_FLAG_X64_SSE2;
 	if (__builtin_cpu_supports("ssse3"))
-		__cpu_flags |= CPU_FLAG_SSSE3;
+		__cpu_flags |= CPU_FLAG_X64_SSSE3;
 	if (__builtin_cpu_supports("sse4.1"))
-		__cpu_flags |= CPU_FLAG_SSE41;
+		__cpu_flags |= CPU_FLAG_X64_SSE41;
 	if (__builtin_cpu_supports("sse4.2"))
-		__cpu_flags |= CPU_FLAG_SSE42;
+		__cpu_flags |= CPU_FLAG_X64_SSE42;
 #if HAVE___BUILTIN_CPU_SUPPORTS__PCLMUL
 	if (__builtin_cpu_supports("pclmul"))
-		__cpu_flags |= CPU_FLAG_PCLMUL;
+		__cpu_flags |= CPU_FLAG_X64_PCLMUL;
 #endif
 	if (__builtin_cpu_supports("avx"))
-		__cpu_flags |= CPU_FLAG_AVX;
+		__cpu_flags |= CPU_FLAG_X64_AVX;
 	if (__builtin_cpu_supports("avx2"))
-		__cpu_flags |= CPU_FLAG_AVX2;
+		__cpu_flags |= CPU_FLAG_X64_AVX2;
 
 	/* Flags unsupported by builtins */
 	__cpuid_count(7, 0, a, b, c, d);
 	if (b & (1UL << 29))
-		__cpu_flags |= CPU_FLAG_SHA;
+		__cpu_flags |= CPU_FLAG_X64_SHA;
 
 	__cpu_flags_orig = __cpu_flags;
 }
diff --git a/common/cpu-utils.h b/common/cpu-utils.h
index 21678dc6e8e7..97107f3f9086 100644
--- a/common/cpu-utils.h
+++ b/common/cpu-utils.h
@@ -30,14 +30,14 @@
 
 enum cpu_feature {
 	ENUM_CPU_BIT(CPU_FLAG_NONE),
-	ENUM_CPU_BIT(CPU_FLAG_SSE2),
-	ENUM_CPU_BIT(CPU_FLAG_SSSE3),
-	ENUM_CPU_BIT(CPU_FLAG_SSE41),
-	ENUM_CPU_BIT(CPU_FLAG_SSE42),
-	ENUM_CPU_BIT(CPU_FLAG_PCLMUL),
-	ENUM_CPU_BIT(CPU_FLAG_SHA),
-	ENUM_CPU_BIT(CPU_FLAG_AVX),
-	ENUM_CPU_BIT(CPU_FLAG_AVX2),
+	ENUM_CPU_BIT(CPU_FLAG_X64_SSE2),
+	ENUM_CPU_BIT(CPU_FLAG_X64_SSSE3),
+	ENUM_CPU_BIT(CPU_FLAG_X64_SSE41),
+	ENUM_CPU_BIT(CPU_FLAG_X64_SSE42),
+	ENUM_CPU_BIT(CPU_FLAG_X64_PCLMUL),
+	ENUM_CPU_BIT(CPU_FLAG_X64_SHA),
+	ENUM_CPU_BIT(CPU_FLAG_X64_AVX),
+	ENUM_CPU_BIT(CPU_FLAG_X64_AVX2),
 };
 
 #undef ENUM_CPU_BIT
diff --git a/crypto/blake2b-ref.c b/crypto/blake2b-ref.c
index 2c7e72ee2026..56774ccb04f9 100644
--- a/crypto/blake2b-ref.c
+++ b/crypto/blake2b-ref.c
@@ -224,15 +224,15 @@ void blake2_init_accel(void)
 {
 	if (0);
 #if HAVE_CFLAG_mavx2 == 1
-	else if (cpu_has_feature(CPU_FLAG_AVX2))
+	else if (cpu_has_feature(CPU_FLAG_X64_AVX2))
 		blake2b_compress = blake2b_compress_avx2;
 #endif
 #if HAVE_CFLAG_msse41 == 1
-	else if (cpu_has_feature(CPU_FLAG_SSE41))
+	else if (cpu_has_feature(CPU_FLAG_X64_SSE41))
 		blake2b_compress = blake2b_compress_sse41;
 #endif
 #if HAVE_CFLAG_msse2 == 1
-	else if (cpu_has_feature(CPU_FLAG_SSE2))
+	else if (cpu_has_feature(CPU_FLAG_X64_SSE2))
 		blake2b_compress = blake2b_compress_sse2;
 #endif
 	else
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index daf232c44e4d..0da4a1573c30 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -335,11 +335,11 @@ static uint32_t crc32c_sse42(uint32_t crc, unsigned char const *data, uint32_t l
 void crc32c_init_accel(void)
 {
 	if (0) {
-	} else if (cpu_has_feature(CPU_FLAG_PCLMUL) &&
-		   cpu_has_feature(CPU_FLAG_SSE42)) {
+	} else if (cpu_has_feature(CPU_FLAG_X64_PCLMUL) &&
+		   cpu_has_feature(CPU_FLAG_X64_SSE42)) {
 		/* printf("CRC32C: pcl\n"); */
 		crc32c_impl = crc32c_pcl;
-	} else if (cpu_has_feature(CPU_FLAG_SSE42)) {
+	} else if (cpu_has_feature(CPU_FLAG_X64_SSE42)) {
 		/* printf("CRC32c: intel\n"); */
 		crc32c_impl = crc32c_sse42;
 	} else {
diff --git a/crypto/hash-speedtest.c b/crypto/hash-speedtest.c
index 95ba63ee6025..5446161af997 100644
--- a/crypto/hash-speedtest.c
+++ b/crypto/hash-speedtest.c
@@ -168,7 +168,7 @@ int main(int argc, char **argv) {
 	int iter;
 	char *filter = NULL;
 	struct contestant {
-		char name[16];
+		char name[20];
 		int (*digest)(const u8 *buf, size_t length, u8 *out);
 		int digest_size;
 		u64 cycles;
@@ -180,10 +180,10 @@ int main(int argc, char **argv) {
 		{ .name = "NULL-MEMCPY", .digest = hash_null_memcpy, .digest_size = 32 },
 		{ .name = "CRC32C-ref", .digest = hash_crc32c, .digest_size = 4,
 		  .cpu_flag = CPU_FLAG_NONE },
-		{ .name = "CRC32C-SSE42", .digest = hash_crc32c, .digest_size = 4,
-		  .cpu_flag = CPU_FLAG_SSE42 },
-		{ .name = "CRC32C-NI", .digest = hash_crc32c, .digest_size = 4,
-		  .cpu_flag = CPU_FLAG_PCLMUL },
+		{ .name = "CRC32C-X64-SSE42", .digest = hash_crc32c, .digest_size = 4,
+		  .cpu_flag = CPU_FLAG_X64_SSE42 },
+		{ .name = "CRC32C-X64-NI", .digest = hash_crc32c, .digest_size = 4,
+		  .cpu_flag = CPU_FLAG_X64_PCLMUL },
 		{ .name = "XXHASH", .digest = hash_xxhash, .digest_size = 8 },
 		{ .name = "SHA256-ref", .digest = hash_sha256, .digest_size = 32,
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
@@ -197,8 +197,8 @@ int main(int argc, char **argv) {
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_BOTAN + 1 },
 		{ .name = "SHA256-openssl", .digest = hash_sha256, .digest_size = 32,
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_OPENSSL + 1 },
-		{ .name = "SHA256-NI", .digest = hash_sha256, .digest_size = 32,
-		  .cpu_flag = CPU_FLAG_SHA, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
+		{ .name = "SHA256-X64-NI", .digest = hash_sha256, .digest_size = 32,
+		  .cpu_flag = CPU_FLAG_X64_SHA, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
 		{ .name = "BLAKE2-ref", .digest = hash_blake2b, .digest_size = 32,
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
 		{ .name = "BLAKE2-gcrypt", .digest = hash_blake2b, .digest_size = 32,
@@ -211,12 +211,12 @@ int main(int argc, char **argv) {
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_BOTAN + 1 },
 		{ .name = "BLAKE2-openssl", .digest = hash_blake2b, .digest_size = 32,
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_OPENSSL + 1 },
-		{ .name = "BLAKE2-SSE2", .digest = hash_blake2b, .digest_size = 32,
-		  .cpu_flag = CPU_FLAG_SSE2, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
-		{ .name = "BLAKE2-SSE41", .digest = hash_blake2b, .digest_size = 32,
-		  .cpu_flag = CPU_FLAG_SSE41, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
-		{ .name = "BLAKE2-AVX2", .digest = hash_blake2b, .digest_size = 32,
-		  .cpu_flag = CPU_FLAG_AVX2, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
+		{ .name = "BLAKE2-X64-SSE2", .digest = hash_blake2b, .digest_size = 32,
+		  .cpu_flag = CPU_FLAG_X64_SSE2, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
+		{ .name = "BLAKE2-X64-SSE41", .digest = hash_blake2b, .digest_size = 32,
+		  .cpu_flag = CPU_FLAG_X64_SSE41, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
+		{ .name = "BLAKE2-X64-AVX2", .digest = hash_blake2b, .digest_size = 32,
+		  .cpu_flag = CPU_FLAG_X64_AVX2, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
 	};
 	int units = UNITS_CYCLES;
 
@@ -293,7 +293,7 @@ int main(int argc, char **argv) {
 		u64 total = 0;
 
 		if (c->cpu_flag != 0 && !cpu_has_feature(c->cpu_flag)) {
-			printf("%14s: no CPU support\n", c->name);
+			printf("%16s: no CPU support\n", c->name);
 			continue;
 		}
 		/* Backend not compiled in */
@@ -305,7 +305,7 @@ int main(int argc, char **argv) {
 		else if (filter && fnmatch(filter, c->name, FNM_CASEFOLD) != 0)
 			continue;
 
-		printf("%14s: ", c->name);
+		printf("%16s: ", c->name);
 		fflush(stdout);
 
 		if (c->cpu_flag) {
diff --git a/crypto/hash-vectest.c b/crypto/hash-vectest.c
index e9c6eda976a4..2d9cc5da8df6 100644
--- a/crypto/hash-vectest.c
+++ b/crypto/hash-vectest.c
@@ -435,18 +435,18 @@ static const struct hash_testspec test_spec[] = {
 		.cpu_flag = CPU_FLAG_NONE,
 		.hash = hash_crc32c,
 	}, {
-		.name = "CRC32C-SSE42",
+		.name = "CRC32C-X64-SSE42",
 		.digest_size = 4,
 		.testvec = crc32c_tv,
 		.count = ARRAY_SIZE(crc32c_tv),
-		.cpu_flag = CPU_FLAG_SSE42,
+		.cpu_flag = CPU_FLAG_X64_SSE42,
 		.hash = hash_crc32c,
 	}, {
-		.name = "CRC32C-NI",
+		.name = "CRC32C-X64-NI",
 		.digest_size = 4,
 		.testvec = crc32c_tv,
 		.count = ARRAY_SIZE(crc32c_tv),
-		.cpu_flag = CPU_FLAG_PCLMUL,
+		.cpu_flag = CPU_FLAG_X64_PCLMUL,
 		.hash = hash_crc32c
 	}, {
 		.name = "XXHASH",
@@ -503,11 +503,11 @@ static const struct hash_testspec test_spec[] = {
 		.hash = hash_sha256,
 		.backend = CRYPTOPROVIDER_OPENSSL + 1
 	}, {
-		.name = "SHA256-NI",
+		.name = "SHA256-X64-NI",
 		.digest_size = 32,
 		.testvec = sha256_tv,
 		.count = ARRAY_SIZE(sha256_tv),
-		.cpu_flag = CPU_FLAG_SHA,
+		.cpu_flag = CPU_FLAG_X64_SHA,
 		.hash = hash_sha256,
 		.backend = CRYPTOPROVIDER_BUILTIN + 1
 	}, {
@@ -559,27 +559,27 @@ static const struct hash_testspec test_spec[] = {
 		.hash = hash_blake2b,
 		.backend = CRYPTOPROVIDER_OPENSSL + 1
 	}, {
-		.name = "BLAKE2-SSE2",
+		.name = "BLAKE2-X64-SSE2",
 		.digest_size = 32,
 		.testvec = blake2b_256_tv,
 		.count = ARRAY_SIZE(blake2b_256_tv),
-		.cpu_flag = CPU_FLAG_SSE2,
+		.cpu_flag = CPU_FLAG_X64_SSE2,
 		.hash = hash_blake2b,
 		.backend = CRYPTOPROVIDER_BUILTIN + 1
 	}, {
-		.name = "BLAKE2-SSE41",
+		.name = "BLAKE2-X64-SSE41",
 		.digest_size = 32,
 		.testvec = blake2b_256_tv,
 		.count = ARRAY_SIZE(blake2b_256_tv),
-		.cpu_flag = CPU_FLAG_SSE41,
+		.cpu_flag = CPU_FLAG_X64_SSE41,
 		.hash = hash_blake2b,
 		.backend = CRYPTOPROVIDER_BUILTIN + 1
 	}, {
-		.name = "BLAKE2-AVX2",
+		.name = "BLAKE2-X64-AVX2",
 		.digest_size = 32,
 		.testvec = blake2b_256_tv,
 		.count = ARRAY_SIZE(blake2b_256_tv),
-		.cpu_flag = CPU_FLAG_AVX2,
+		.cpu_flag = CPU_FLAG_X64_AVX2,
 		.hash = hash_blake2b,
 		.backend = CRYPTOPROVIDER_BUILTIN + 1
 	}
diff --git a/crypto/sha224-256.c b/crypto/sha224-256.c
index e2075de5abfb..69e7ce5b9bd2 100644
--- a/crypto/sha224-256.c
+++ b/crypto/sha224-256.c
@@ -110,7 +110,7 @@ static void sha256_process_x86_dispatch(SHA256Context *context)
 void sha256_init_accel(void)
 {
 #if HAVE_CFLAG_msha == 1
-	if (cpu_has_feature(CPU_FLAG_SHA))
+	if (cpu_has_feature(CPU_FLAG_X64_SHA))
 		sha256_process_message_block = sha256_process_x86_dispatch;
 	else
 #endif
-- 
2.56.0

