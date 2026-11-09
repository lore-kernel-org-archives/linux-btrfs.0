Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794197430;
	b=H7VW28p43kKlJIsgELCG72Gp9s4Ro7MDY3no89uXgJWc87dfUZMZQw9SkfndS7x9pCyi
	 G5+XHOZdmZMZHJnGdxoTNwhsratYCX7Zp7goCE0QEmvlH8hYrxvJQCqedIDXG2dqyZLKv
	 PCZablMqRXrhF9PPK7JMHMoTL2Exj/XZYzdoRKihFZL5qTvmZNlFBpoGrx/1gi7ALSQjH
	 k4Dwmie/JkKn/ueN2z9s4o5up+sUJWL4FEGb6zQDsC+U+GIe5c/QPmK9woOJc4QqsCa1k
	 5MZv4uLUtiyLdnkQMTjAUKkOmy8zDnzEkyfJsjws1lIzsHUMOR2Kb2L7ggAmvBnYW6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794197430;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=ODCNEcHwzE1RtFxpYSskgCC+BYM3sjgvSn03ajtX2FI=;
	b=gcNqPMB4W2vtkgvih2sGe+XA6kO7O9dT/qEiqMdiuAe8du41WAv25rnIEG77Gl3ZvJZe
	 oZzPY9zGEBD6cnlUp7PwOW3kHOtLMGAVHDdOC2Cn9F7mEdl9sxaQAHVhdy4aC3Joq5fU/
	 5wZ2zmOrfu8ALj3YhC5M5iMLFOwIqjsWmNvjV4f1BdQSYeOCIj0vSwMiekOlCdYRWU21Q
	 /un8I2seCs62dDoO6+WyvcJyc5vEJt//Kq0ekAnunQZPy8uAg58mJaGRPjzHGo+VvNE4p
	 Fa5rp28kPJVUEi2lcD4gkpFfChbhYWBEn9VoQ0+a6dNw4lznWt380+bxt6kUK/ah/ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="L6W8iIy/";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="L6W8iIy/";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F33606A333
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59F33606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=L6W8iIy/;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=L6W8iIy/
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A65EA1FB6B
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ODCNEcHwzE1RtFxpYSskgCC+BYM3sjgvSn03ajtX2FI=;
	b=L6W8iIy/WmpCCozrzS9v61MqWqnmXXM/1nT0R2A+2CvIqdRaafjjItGlBrPGdxn1v3a7by
	6LwbG/K9UwEHUD3ghgCW6aq1x0aSxKTxXfYW2CxPHIO4KLeZzbjNUl0jIO51o9FAtZ/Jf9
	wPc/1pJxOJg+sC/qQKVeLk3nGvVCGGw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="L6W8iIy/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ODCNEcHwzE1RtFxpYSskgCC+BYM3sjgvSn03ajtX2FI=;
	b=L6W8iIy/WmpCCozrzS9v61MqWqnmXXM/1nT0R2A+2CvIqdRaafjjItGlBrPGdxn1v3a7by
	6LwbG/K9UwEHUD3ghgCW6aq1x0aSxKTxXfYW2CxPHIO4KLeZzbjNUl0jIO51o9FAtZ/Jf9
	wPc/1pJxOJg+sC/qQKVeLk3nGvVCGGw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BA8E13319
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKhEN6tH8WrIZAAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 04:10:27 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/7] btrfs-progs: simplify the cpu utils for future expanasion
Date: Mon,  9 Nov 2026 14:39:58 +1030
Message-ID: <4fae127ca2079d268eb4e096d567b69af772130f.1794196688.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim,configure.ac:url];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: A65EA1FB6B

Currently we define x86_64 specific cpu_detect_flags()/cpu_*_level(),
and all other architectures falls back to no-op for those 3 functions.

This makes future expansion much more complex. Change the code to make
future expansion easier by:

- Hide the architecture dependent code inside cpu_detect_flags()

- Use __builtin_cpu_supports("sha") for the previously unsupported flag
  If the compiler is not uptodate, skip the flag, just like what we did
  for pclmul.

  Now we no longer need the hardcoded cpuid test, nor the <cpuid.h>
  header.

- Remove the dead branch of cpu_set_level()
  All callers pass a non-zero bit in, so use UASSERT() to do a quick
  check, and remove the fallback branch.

- Use the same cpu_*_level() for all architectures
  So they do not need to be hide behind certain architecture.

- Skip accelerated algos that are not supported by compiler
  If the compiler is too old to detect sha/pclmul, there is no need to
  show them in the hash-*test.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/cpu-utils.c       | 36 ++++++++++--------------------------
 config/ax_gcc_builtin.m4 |  1 +
 configure.ac             |  1 +
 crypto/hash-speedtest.c  |  4 ++++
 crypto/hash-vectest.c    | 17 +++++++++++++----
 5 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/common/cpu-utils.c b/common/cpu-utils.c
index d8fbf664b998..e933b8322dc5 100644
--- a/common/cpu-utils.c
+++ b/common/cpu-utils.c
@@ -15,10 +15,8 @@
  */
 
 #include <stdio.h>
-#ifdef __x86_64__
-#include <cpuid.h>
-#endif
 #include "common/cpu-utils.h"
+#include "common/messages.h"
 
 unsigned long __cpu_flags = CPU_FLAG_NONE;
 unsigned long __cpu_flags_orig = CPU_FLAG_NONE;
@@ -39,14 +37,12 @@ void cpu_print_flags(void) {
 }
 #undef FLAG_X64
 
-#ifdef __x86_64__
 
 void cpu_detect_flags(void)
 {
-	unsigned int a, b, c, d;
-
-	__builtin_cpu_init();
 	__cpu_flags = CPU_FLAG_NONE;
+#ifdef __x86_64__
+	__builtin_cpu_init();
 	if (__builtin_cpu_supports("sse2"))
 		__cpu_flags |= CPU_FLAG_X64_SSE2;
 	if (__builtin_cpu_supports("ssse3"))
@@ -58,39 +54,27 @@ void cpu_detect_flags(void)
 #if HAVE___BUILTIN_CPU_SUPPORTS__PCLMUL
 	if (__builtin_cpu_supports("pclmul"))
 		__cpu_flags |= CPU_FLAG_X64_PCLMUL;
-#endif
+#endif /* HAVE___BUILTIN_CPU_SUPPORTS__PCLMUL */
 	if (__builtin_cpu_supports("avx"))
 		__cpu_flags |= CPU_FLAG_X64_AVX;
 	if (__builtin_cpu_supports("avx2"))
 		__cpu_flags |= CPU_FLAG_X64_AVX2;
-
-	/* Flags unsupported by builtins */
-	__cpuid_count(7, 0, a, b, c, d);
-	if (b & (1UL << 29))
+#if HAVE___BUILTIN_CPU_SUPPORTS__SHA
+	if (__builtin_cpu_supports("sha"))
 		__cpu_flags |= CPU_FLAG_X64_SHA;
+#endif /* HAVE___BUILTIN_CPU_SUPPORTS__SHA */
+#endif /* __x86_64__ */
 
 	__cpu_flags_orig = __cpu_flags;
 }
 
 void cpu_set_level(unsigned long topbit)
 {
-	if (topbit)
-		__cpu_flags &= (topbit << 1) - 1;
-	else
-		__cpu_flags = CPU_FLAG_NONE;
+	UASSERT(topbit);
+	__cpu_flags &= (topbit << 1) - 1;
 }
 
 void cpu_reset_level(void)
 {
 	__cpu_flags = __cpu_flags_orig;
 }
-
-#else
-
-void cpu_detect_flags() { }
-
-void cpu_set_level(unsigned long topbit) { }
-
-void cpu_reset_level(void) { }
-
-#endif
diff --git a/config/ax_gcc_builtin.m4 b/config/ax_gcc_builtin.m4
index 224e824c1dfb..a9eb4aa85a66 100644
--- a/config/ax_gcc_builtin.m4
+++ b/config/ax_gcc_builtin.m4
@@ -125,6 +125,7 @@ AC_DEFUN([AX_GCC_BUILTIN], [
                 [__builtin_cpu_is], [$1("intel")],
                 [__builtin_cpu_supports], [$1("sse")],
                 [__builtin_cpu_supports__pclmul], [__builtin_cpu_supports("pclmul")],
+                [__builtin_cpu_supports__sha], [__builtin_cpu_supports("sha")],
                 [__builtin_ctz], [$1(0)],
                 [__builtin_ctzl], [$1(0)],
                 [__builtin_ctzll], [$1(0)],
diff --git a/configure.ac b/configure.ac
index 07cd92df5947..b4fa907f6656 100644
--- a/configure.ac
+++ b/configure.ac
@@ -97,6 +97,7 @@ AX_GCC_BUILTIN([__builtin_add_overflow])
 AX_GCC_BUILTIN([__builtin_sub_overflow])
 AX_GCC_BUILTIN([__builtin_mul_overflow])
 AX_GCC_BUILTIN([__builtin_cpu_supports__pclmul])
+AX_GCC_BUILTIN([__builtin_cpu_supports__sha])
 
 AC_CHECK_HEADERS([fcntl.h])
 AC_CHECK_HEADERS([inttypes.h])
diff --git a/crypto/hash-speedtest.c b/crypto/hash-speedtest.c
index 5446161af997..b51ccbb19284 100644
--- a/crypto/hash-speedtest.c
+++ b/crypto/hash-speedtest.c
@@ -182,8 +182,10 @@ int main(int argc, char **argv) {
 		  .cpu_flag = CPU_FLAG_NONE },
 		{ .name = "CRC32C-X64-SSE42", .digest = hash_crc32c, .digest_size = 4,
 		  .cpu_flag = CPU_FLAG_X64_SSE42 },
+#if HAVE___BUILTIN_CPU_SUPPORTS__PCLMUL
 		{ .name = "CRC32C-X64-NI", .digest = hash_crc32c, .digest_size = 4,
 		  .cpu_flag = CPU_FLAG_X64_PCLMUL },
+#endif /* HAVE___BUILTIN_CPU_SUPPORTS__PCLMUL */
 		{ .name = "XXHASH", .digest = hash_xxhash, .digest_size = 8 },
 		{ .name = "SHA256-ref", .digest = hash_sha256, .digest_size = 32,
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
@@ -197,8 +199,10 @@ int main(int argc, char **argv) {
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_BOTAN + 1 },
 		{ .name = "SHA256-openssl", .digest = hash_sha256, .digest_size = 32,
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_OPENSSL + 1 },
+#if HAVE___BUILTIN_CPU_SUPPORTS__SHA
 		{ .name = "SHA256-X64-NI", .digest = hash_sha256, .digest_size = 32,
 		  .cpu_flag = CPU_FLAG_X64_SHA, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
+#endif /* HAVE___BUILTIN_CPU_SUPPORTS__SHA */
 		{ .name = "BLAKE2-ref", .digest = hash_blake2b, .digest_size = 32,
 		  .cpu_flag = CPU_FLAG_NONE, .backend = CRYPTOPROVIDER_BUILTIN + 1 },
 		{ .name = "BLAKE2-gcrypt", .digest = hash_blake2b, .digest_size = 32,
diff --git a/crypto/hash-vectest.c b/crypto/hash-vectest.c
index 2d9cc5da8df6..3b1b79eae138 100644
--- a/crypto/hash-vectest.c
+++ b/crypto/hash-vectest.c
@@ -441,14 +441,19 @@ static const struct hash_testspec test_spec[] = {
 		.count = ARRAY_SIZE(crc32c_tv),
 		.cpu_flag = CPU_FLAG_X64_SSE42,
 		.hash = hash_crc32c,
-	}, {
+	},
+
+#if HAVE___BUILTIN_CPU_SUPPORTS__PCLMUL
+	{
 		.name = "CRC32C-X64-NI",
 		.digest_size = 4,
 		.testvec = crc32c_tv,
 		.count = ARRAY_SIZE(crc32c_tv),
 		.cpu_flag = CPU_FLAG_X64_PCLMUL,
 		.hash = hash_crc32c
-	}, {
+	},
+#endif /* HAVE___BUILTIN_CPU_SUPPORTS__PCLMUL */
+	{
 		.name = "XXHASH",
 		.digest_size = 8,
 		.testvec = xxhash64_tv,
@@ -502,7 +507,9 @@ static const struct hash_testspec test_spec[] = {
 		.cpu_flag = CPU_FLAG_NONE,
 		.hash = hash_sha256,
 		.backend = CRYPTOPROVIDER_OPENSSL + 1
-	}, {
+	},
+#ifdef HAVE___BUILTIN_CPU_SUPPORTS__SHA
+	{
 		.name = "SHA256-X64-NI",
 		.digest_size = 32,
 		.testvec = sha256_tv,
@@ -510,7 +517,9 @@ static const struct hash_testspec test_spec[] = {
 		.cpu_flag = CPU_FLAG_X64_SHA,
 		.hash = hash_sha256,
 		.backend = CRYPTOPROVIDER_BUILTIN + 1
-	}, {
+	},
+#endif /* HAVE___BUILTIN_CPU_SUPPORTS__SHA */
+	{
 		.name = "BLAKE2-ref",
 		.digest_size = 32,
 		.testvec = blake2b_256_tv,
-- 
2.56.0

