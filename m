Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794197432;
	b=TmVlKDhgTZZBo/TLf+9IV8SjdRohMRLA00vt9+hI3RiXMEkkH96t97A3xsWCV3Xhinpj
	 Cw2bZvhoJQGz66KCt/PxEjHZTpe06vkQ9B2PC3QR7OmgwoctvBgji+mlgQjCbavEclVT9
	 FeaaYo7w40QEdBsLZcf74Nv/sI6ypLiOh0GtgVPi/i7fSH02p/gMpDv/vb3409ExjBXbW
	 SbNuxQTiXSTby6SVw3fSxDNJWiP9TXASMspA6Qhvdc5h6aMjf+lNMq3WJUqyCtV2RDpBN
	 tn4q0n6mR9OflnEI8zX3+DBRklDbUwiJo97IHUPCkjmeU2gw6e/7vOxGf8d1hm45sWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794197432;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=/e2nXgLec3evPGvNloxFKIl1sZ36oC/JNRUYCAfts7Y=;
	b=ibcPjPBd9Fm0XKx3QXzEdjnX4NiHoCJJvUPmmmIEerLmO8utG5xcNPUAOO+X8DIbpADy
	 ZqEU2lUyMVP01nykJUg5FqA4PLPrqZ2ISSxmIqghpdIQ7xIQiyXoH7blL6d44JJItggoM
	 kYocygvC1GHr+6FHPHji5Y1Z2ItSuj4Nd295+zHBr5IX4Dqg893YtB5GBECbxwrioinE9
	 7EdzcpPJvmgsgIJ6ubCaDp94l4c8xQoTVEp4U0MN+98gPSUkgH9QXJoGKEdMEA0fMY0jo
	 y09vHqs0lB5sH89vrV1k8HUNMk5aM1C8Ht/FQZvLdjiIthXaYe38KlIm9Q1ASp1EcaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NO9PRrW2;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NO9PRrW2;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D208606A331
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D208606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NO9PRrW2;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NO9PRrW2
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5402922155
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/e2nXgLec3evPGvNloxFKIl1sZ36oC/JNRUYCAfts7Y=;
	b=NO9PRrW2l+DJoW/5jz32H7N3z2hN8aSp8NuzNBfbdqVRHcW7IAdBnyyLOjBNp918dcJlYU
	h+ni4jpD78oXs66FoiERRSyXQCAic8znNgiJctWsqLOlt3agiEirP8oPvS6CN5Dp87hl+e
	xLq8MjDOe0eps/ZcqTGeSLesuf22698=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=NO9PRrW2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/e2nXgLec3evPGvNloxFKIl1sZ36oC/JNRUYCAfts7Y=;
	b=NO9PRrW2l+DJoW/5jz32H7N3z2hN8aSp8NuzNBfbdqVRHcW7IAdBnyyLOjBNp918dcJlYU
	h+ni4jpD78oXs66FoiERRSyXQCAic8znNgiJctWsqLOlt3agiEirP8oPvS6CN5Dp87hl+e
	xLq8MjDOe0eps/ZcqTGeSLesuf22698=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38E2A13319
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKhEN6tH8WrIZAAAD6G6ig:T6
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 04:10:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/7] btrfs-progs: crypto: select accelerated algo directly for testing
Date: Mon,  9 Nov 2026 14:39:59 +1030
Message-ID: <e79babfb56c4a78559209c275a14cec1e304869d.1794196688.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 5402922155
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

Currently hash-speedtest and hash-vectest use cpu_set_level() to mask
out CPU flags, then call hash_init_accel() to pick the "best" algo under
that mask.

This relies on the CPU flag bit order being a strict capability ladder,
which is true for x86_64 but will not hold for other architectures like
arm64.

Since only hash-*test need to select a specific backend, introduce
hash_force_accel() to select the algo bound to the exact CPU flag
directly, falling back to the reference one if there is none.
All other users still use hash_init_accel() to get the fastest one.

With that, remove cpu_set_level(), cpu_reset_level() and
__cpu_flags_orig, as they have no user anymore.

Also do some cleanups:

- Only one crc32c_init_accel() for all architectures
  Do the __x86_64__ check inside the function, instead of defining
  duplicated functions.

- Use early return in sha256_*_accel()
  So the reference implementation no longer needs an else branch across
  the #endif.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/cpu-utils.c      | 15 ---------------
 common/cpu-utils.h      |  3 ---
 crypto/blake2.h         |  2 ++
 crypto/blake2b-ref.c    | 24 +++++++++++++++++++++++
 crypto/crc32c.c         | 42 +++++++++++++++++++++++------------------
 crypto/crc32c.h         |  2 ++
 crypto/hash-speedtest.c |  7 ++-----
 crypto/hash-vectest.c   |  7 ++-----
 crypto/hash.c           |  9 +++++++++
 crypto/hash.h           |  2 ++
 crypto/sha.h            |  2 ++
 crypto/sha224-256.c     | 18 +++++++++++++++---
 12 files changed, 84 insertions(+), 49 deletions(-)

diff --git a/common/cpu-utils.c b/common/cpu-utils.c
index e933b8322dc5..76959c0b729f 100644
--- a/common/cpu-utils.c
+++ b/common/cpu-utils.c
@@ -16,10 +16,8 @@
 
 #include <stdio.h>
 #include "common/cpu-utils.h"
-#include "common/messages.h"
 
 unsigned long __cpu_flags = CPU_FLAG_NONE;
-unsigned long __cpu_flags_orig = CPU_FLAG_NONE;
 
 #define FLAG_X64(name)	if (__cpu_flags & CPU_FLAG_X64_ ## name) printf(" " #name)
 void cpu_print_flags(void) {
@@ -64,17 +62,4 @@ void cpu_detect_flags(void)
 		__cpu_flags |= CPU_FLAG_X64_SHA;
 #endif /* HAVE___BUILTIN_CPU_SUPPORTS__SHA */
 #endif /* __x86_64__ */
-
-	__cpu_flags_orig = __cpu_flags;
-}
-
-void cpu_set_level(unsigned long topbit)
-{
-	UASSERT(topbit);
-	__cpu_flags &= (topbit << 1) - 1;
-}
-
-void cpu_reset_level(void)
-{
-	__cpu_flags = __cpu_flags_orig;
 }
diff --git a/common/cpu-utils.h b/common/cpu-utils.h
index 97107f3f9086..2ca195567b84 100644
--- a/common/cpu-utils.h
+++ b/common/cpu-utils.h
@@ -44,12 +44,9 @@ enum cpu_feature {
 
 /* Private but in public header to allow inlining */
 extern unsigned long __cpu_flags;
-extern unsigned long __cpu_flags_orig;
 
 /* Public API */
 void cpu_detect_flags(void);
-void cpu_set_level(unsigned long topbit);
-void cpu_reset_level(void);
 void cpu_print_flags(void);
 
 static inline bool cpu_has_feature(enum cpu_feature f)
diff --git a/crypto/blake2.h b/crypto/blake2.h
index 052afe34a651..c4cc079ba04e 100644
--- a/crypto/blake2.h
+++ b/crypto/blake2.h
@@ -17,6 +17,7 @@
 
 #include <stddef.h>
 #include <stdint.h>
+#include "common/cpu-utils.h"
 
 #if defined(_MSC_VER)
 #define BLAKE2_PACKED(x) __pragma(pack(push, 1)) x __pragma(pack(pop))
@@ -91,6 +92,7 @@ extern "C" {
   int blake2b( void *out, size_t outlen, const void *in, size_t inlen, const void *key, size_t keylen );
 
   void blake2_init_accel(void);
+  void blake2_force_accel(enum cpu_feature f);
 
   /* Export optimized versions to silent -Wmissing-prototypes warnings. */
   void blake2b_compress_avx2( blake2b_state *S, const uint8_t block[BLAKE2B_BLOCKBYTES] );
diff --git a/crypto/blake2b-ref.c b/crypto/blake2b-ref.c
index 56774ccb04f9..e8d2adb0498e 100644
--- a/crypto/blake2b-ref.c
+++ b/crypto/blake2b-ref.c
@@ -239,6 +239,30 @@ void blake2_init_accel(void)
 		blake2b_compress = blake2b_compress_ref;
 }
 
+void blake2_force_accel(enum cpu_feature f)
+{
+	switch (f) {
+#if HAVE_CFLAG_mavx2 == 1
+	case CPU_FLAG_X64_AVX2:
+		blake2b_compress = blake2b_compress_avx2;
+		break;
+#endif
+#if HAVE_CFLAG_msse41 == 1
+	case CPU_FLAG_X64_SSE41:
+		blake2b_compress = blake2b_compress_sse41;
+		break;
+#endif
+#if HAVE_CFLAG_msse2 == 1
+	case CPU_FLAG_X64_SSE2:
+		blake2b_compress = blake2b_compress_sse2;
+		break;
+#endif
+	default:
+		blake2b_compress = blake2b_compress_ref;
+		break;
+	}
+}
+
 int blake2b_update( blake2b_state *S, const void *pin, size_t inlen )
 {
   const unsigned char * in = (const unsigned char *)pin;
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 0da4a1573c30..b7a7ce74b526 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -332,30 +332,36 @@ static uint32_t crc32c_sse42(uint32_t crc, unsigned char const *data, uint32_t l
 	return crc;
 }
 
-void crc32c_init_accel(void)
-{
-	if (0) {
-	} else if (cpu_has_feature(CPU_FLAG_X64_PCLMUL) &&
-		   cpu_has_feature(CPU_FLAG_X64_SSE42)) {
-		/* printf("CRC32C: pcl\n"); */
-		crc32c_impl = crc32c_pcl;
-	} else if (cpu_has_feature(CPU_FLAG_X64_SSE42)) {
-		/* printf("CRC32c: intel\n"); */
-		crc32c_impl = crc32c_sse42;
-	} else {
-		/* printf("CRC32c: fallback\n"); */
-		crc32c_impl = crc32c_ref;
-	}
-}
-
-#else
+#endif /* __x86_64__ */
 
 void crc32c_init_accel(void)
 {
 	crc32c_impl = crc32c_ref;
+#ifdef __x86_64__
+	if (cpu_has_feature(CPU_FLAG_X64_PCLMUL) &&
+	    cpu_has_feature(CPU_FLAG_X64_SSE42))
+		crc32c_impl = crc32c_pcl;
+	else if (cpu_has_feature(CPU_FLAG_X64_SSE42))
+		crc32c_impl = crc32c_sse42;
+#endif
 }
 
-#endif /* __x86_64__ */
+void crc32c_force_accel(enum cpu_feature f)
+{
+	switch (f) {
+#ifdef __x86_64__
+	case CPU_FLAG_X64_PCLMUL:
+		crc32c_impl = crc32c_pcl;
+		break;
+	case CPU_FLAG_X64_SSE42:
+		crc32c_impl = crc32c_sse42;
+		break;
+#endif
+	default:
+		crc32c_impl = crc32c_ref;
+		break;
+	}
+}
 
 /*
  * This is the CRC-32C table
diff --git a/crypto/crc32c.h b/crypto/crc32c.h
index f990177147e5..dd427893cf99 100644
--- a/crypto/crc32c.h
+++ b/crypto/crc32c.h
@@ -20,9 +20,11 @@
 #define __CRC32C__
 
 #include <inttypes.h>
+#include "common/cpu-utils.h"
 
 uint32_t crc32c_le(uint32_t seed, unsigned char const *data, uint32_t length);
 void crc32c_init_accel(void);
+void crc32c_force_accel(enum cpu_feature f);
 
 #define crc32c(seed, data, length) crc32c_le(seed, (unsigned char const *)data, length)
 
diff --git a/crypto/hash-speedtest.c b/crypto/hash-speedtest.c
index b51ccbb19284..a26959ae66e8 100644
--- a/crypto/hash-speedtest.c
+++ b/crypto/hash-speedtest.c
@@ -312,10 +312,8 @@ int main(int argc, char **argv) {
 		printf("%16s: ", c->name);
 		fflush(stdout);
 
-		if (c->cpu_flag) {
-			cpu_set_level(c->cpu_flag);
-			hash_init_accel();
-		}
+		if (c->cpu_flag)
+			hash_force_accel(c->cpu_flag);
 		tstart = get_time();
 		start = get_cycles(units);
 		for (iter = 0; iter < iterations; iter++) {
@@ -327,7 +325,6 @@ int main(int argc, char **argv) {
 		tend = get_time();
 		c->cycles = end - start;
 		c->time = tend - tstart;
-		cpu_reset_level();
 
 		if (units == UNITS_CYCLES || units == UNITS_PERF)
 			total = c->cycles;
diff --git a/crypto/hash-vectest.c b/crypto/hash-vectest.c
index 3b1b79eae138..c190a7a01b95 100644
--- a/crypto/hash-vectest.c
+++ b/crypto/hash-vectest.c
@@ -617,12 +617,9 @@ static int test_hash(const struct hash_testspec *spec)
 			header = true;
 		}
 
-		if (spec->cpu_flag) {
-			cpu_set_level(spec->cpu_flag);
-			hash_init_accel();
-		}
+		if (spec->cpu_flag)
+			hash_force_accel(spec->cpu_flag);
 		ret = spec->hash((const u8 *)vec->plaintext, vec->psize, csum);
-		cpu_reset_level();
 		if (ret < 0) {
 			error("hash %s = %d", spec->name, ret);
 			return 1;
diff --git a/crypto/hash.c b/crypto/hash.c
index 4af7b04a2507..675051873ef9 100644
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -49,6 +49,15 @@ int hash_xxhash(const u8 *buf, size_t length, u8 *out)
 	return 0;
 }
 
+void hash_force_accel(enum cpu_feature f)
+{
+	crc32c_force_accel(f);
+#if CRYPTOPROVIDER_BUILTIN == 1
+	blake2_force_accel(f);
+	sha256_force_accel(f);
+#endif
+}
+
 /*
  * Implementations of cryptographic primitives
  */
diff --git a/crypto/hash.h b/crypto/hash.h
index 4f8f668ad260..11d977922039 100644
--- a/crypto/hash.h
+++ b/crypto/hash.h
@@ -18,6 +18,7 @@
 #define CRYPTO_HASH_H
 
 #include "kerncompat.h"
+#include "common/cpu-utils.h"
 #include <stddef.h>
 
 #define CRYPTO_HASH_SIZE_MAX	32
@@ -28,6 +29,7 @@ int hash_sha256(const u8 *buf, size_t length, u8 *out);
 int hash_blake2b(const u8 *buf, size_t length, u8 *out);
 
 void hash_init_accel(void);
+void hash_force_accel(enum cpu_feature f);
 void hash_init_crc32c(void);
 
 #endif
diff --git a/crypto/sha.h b/crypto/sha.h
index ea387c212dc6..0292b292f357 100644
--- a/crypto/sha.h
+++ b/crypto/sha.h
@@ -71,6 +71,7 @@
  */
 
 #include <stdint.h>
+#include "common/cpu-utils.h"
 /*
  * If you do not have the ISO standard stdint.h header file, then you
  * must typedef the following:
@@ -210,6 +211,7 @@ extern int hmacResult(HMACContext *context,
                       uint8_t digest[USHAMaxHashSize]);
 
 void sha256_init_accel(void);
+void sha256_force_accel(enum cpu_feature f);
 
 /* Export for optimized version to silent -Wmissing-prototypes. */
 void sha256_process_x86(uint32_t state[8], const uint8_t data[], uint32_t length);
diff --git a/crypto/sha224-256.c b/crypto/sha224-256.c
index 69e7ce5b9bd2..1df03825fa8f 100644
--- a/crypto/sha224-256.c
+++ b/crypto/sha224-256.c
@@ -110,11 +110,23 @@ static void sha256_process_x86_dispatch(SHA256Context *context)
 void sha256_init_accel(void)
 {
 #if HAVE_CFLAG_msha == 1
-	if (cpu_has_feature(CPU_FLAG_X64_SHA))
+	if (cpu_has_feature(CPU_FLAG_X64_SHA)) {
 		sha256_process_message_block = sha256_process_x86_dispatch;
-	else
+		return;
+	}
 #endif
-		sha256_process_message_block = SHA224_256ProcessMessageBlock;
+	sha256_process_message_block = SHA224_256ProcessMessageBlock;
+}
+
+void sha256_force_accel(enum cpu_feature f)
+{
+#if HAVE_CFLAG_msha == 1
+	if (f == CPU_FLAG_X64_SHA) {
+		sha256_process_message_block = sha256_process_x86_dispatch;
+		return;
+	}
+#endif
+	sha256_process_message_block = SHA224_256ProcessMessageBlock;
 }
 
 /*
-- 
2.56.0

