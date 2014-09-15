Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45856 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaIOHbf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 03:31:35 -0400
Received: by mail-pd0-f181.google.com with SMTP id w10so5588163pde.26
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 00:31:35 -0700 (PDT)
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
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH v3 05/12] crypto: LLVMLinux: Remove VLAIS from crypto/n2_core.c
Date: Mon, 15 Sep 2014 00:30:27 -0700
Message-Id: <1410766234-1634-6-git-send-email-behanw@converseincode.com>
In-Reply-To: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Behan Webster <behanw@converseincode.com>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
compliant equivalent. This patch allocates the appropriate amount of memory
using a char array using the SHASH_DESC_ON_STACK macro.

The new code can be compiled with both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 drivers/crypto/n2_core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 7263c10..f8e3207 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -445,10 +445,7 @@ static int n2_hmac_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 	struct n2_hmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct crypto_shash *child_shash = ctx->child_shash;
 	struct crypto_ahash *fallback_tfm;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(child_shash)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, child_shash);
 	int err, bs, ds;
 
 	fallback_tfm = ctx->base.fallback_tfm;
@@ -456,15 +453,15 @@ static int n2_hmac_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (err)
 		return err;
 
-	desc.shash.tfm = child_shash;
-	desc.shash.flags = crypto_ahash_get_flags(tfm) &
+	shash->tfm = child_shash;
+	shash->flags = crypto_ahash_get_flags(tfm) &
 		CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	bs = crypto_shash_blocksize(child_shash);
 	ds = crypto_shash_digestsize(child_shash);
 	BUG_ON(ds > N2_HASH_KEY_MAX);
 	if (keylen > bs) {
-		err = crypto_shash_digest(&desc.shash, key, keylen,
+		err = crypto_shash_digest(shash, key, keylen,
 					  ctx->hash_key);
 		if (err)
 			return err;
-- 
1.9.1

