Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51956 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbaIBWdW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 18:33:22 -0400
Received: by mail-pd0-f174.google.com with SMTP id ft15so9523268pdb.5
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 15:33:22 -0700 (PDT)
From: behanw@converseincode.com
To: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, herbert@gondor.apana.org.au, jbacik@fb.com,
        snitzer@redhat.com
Cc: akpm@linux-foundation.org, james.l.morris@oracle.com,
        john.johansen@canonical.com, linux-btrfs@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        neilb@suse.de, serge@hallyn.com, torvalds@linux-foundation.org,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH RFC 5/6] apparmor: LLVMLinux: Remove VLAIS
Date: Tue,  2 Sep 2014 15:32:32 -0700
Message-Id: <1409697153-7006-6-git-send-email-behanw@converseincode.com>
In-Reply-To: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Vinícius Tinti <viniciustinti@gmail.com>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
compliant equivalent. This is the original VLAIS struct.

struct {
	struct shash_desc shash;
	char ctx[crypto_shash_descsize(apparmor_tfm)];
} desc;

This patch instead allocates the appropriate amount of memory using an
char array.

The new code can be compiled with both gcc and clang.

struct shash_desc contains a flexible array member member ctx declared with
CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
of the array declared after struct shash_desc with long long.

No trailing padding is required because it is not a struct type that can
be used in an array.

The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
as would be the case for a struct containing a member with
CRYPTO_MINALIGN_ATTR.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
---
 security/apparmor/crypto.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
index 532471d..62b32e7 100644
--- a/security/apparmor/crypto.c
+++ b/security/apparmor/crypto.c
@@ -32,10 +32,9 @@ unsigned int aa_hash_size(void)
 int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
 			 size_t len)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(apparmor_tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc)
+		+ crypto_shash_descsize(apparmor_tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 	int error = -ENOMEM;
 	u32 le32_version = cpu_to_le32(version);
 
@@ -46,19 +45,19 @@ int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
 	if (!profile->hash)
 		goto fail;
 
-	desc.shash.tfm = apparmor_tfm;
-	desc.shash.flags = 0;
+	shash->tfm = apparmor_tfm;
+	shash->flags = 0;
 
-	error = crypto_shash_init(&desc.shash);
+	error = crypto_shash_init(shash);
 	if (error)
 		goto fail;
-	error = crypto_shash_update(&desc.shash, (u8 *) &le32_version, 4);
+	error = crypto_shash_update(shash, (u8 *) &le32_version, 4);
 	if (error)
 		goto fail;
-	error = crypto_shash_update(&desc.shash, (u8 *) start, len);
+	error = crypto_shash_update(shash, (u8 *) start, len);
 	if (error)
 		goto fail;
-	error = crypto_shash_final(&desc.shash, profile->hash);
+	error = crypto_shash_final(shash, profile->hash);
 	if (error)
 		goto fail;
 
-- 
1.9.1

