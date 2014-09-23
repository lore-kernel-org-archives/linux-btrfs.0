Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53497 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaIWEnK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 00:43:10 -0400
Received: by mail-pd0-f178.google.com with SMTP id ft15so5717251pdb.37
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 21:43:09 -0700 (PDT)
From: behanw@converseincode.com
To: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, herbert@gondor.apana.org.au, jbacik@fb.com,
        snitzer@redhat.com, tadeusz.struk@intel.com
Cc: akpm@linux-foundation.org, bruce.w.allan@intel.com, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, john.griffin@intel.com,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
        thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
        torvalds@linux-foundation.org,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>, pageexec@freemail.hu
Subject: [PATCH v4 09/12] crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
Date: Mon, 22 Sep 2014 21:42:14 -0700
Message-Id: <1411447337-22362-10-git-send-email-behanw@converseincode.com>
In-Reply-To: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
References: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jan-Simon Möller <dl9pf@gmx.de>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
compliant equivalent. This patch allocates the appropriate amount of memory
using a char array using the SHASH_DESC_ON_STACK macro.

The new code can be compiled with both gcc and clang.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: pageexec@freemail.hu
---
 crypto/hmac.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8d9544c..e392219 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -52,20 +52,17 @@ static int hmac_setkey(struct crypto_shash *parent,
 	struct hmac_ctx *ctx = align_ptr(opad + ss,
 					 crypto_tfm_ctx_alignment());
 	struct crypto_shash *hash = ctx->hash;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(hash)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, hash);
 	unsigned int i;
 
-	desc.shash.tfm = hash;
-	desc.shash.flags = crypto_shash_get_flags(parent) &
-			    CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm = hash;
+	shash->flags = crypto_shash_get_flags(parent)
+		& CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	if (keylen > bs) {
 		int err;
 
-		err = crypto_shash_digest(&desc.shash, inkey, keylen, ipad);
+		err = crypto_shash_digest(shash, inkey, keylen, ipad);
 		if (err)
 			return err;
 
@@ -81,12 +78,12 @@ static int hmac_setkey(struct crypto_shash *parent,
 		opad[i] ^= 0x5c;
 	}
 
-	return crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, ipad, bs) ?:
-	       crypto_shash_export(&desc.shash, ipad) ?:
-	       crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, opad, bs) ?:
-	       crypto_shash_export(&desc.shash, opad);
+	return crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, ipad, bs) ?:
+	       crypto_shash_export(shash, ipad) ?:
+	       crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, opad, bs) ?:
+	       crypto_shash_export(shash, opad);
 }
 
 static int hmac_export(struct shash_desc *pdesc, void *out)
-- 
1.9.1

