Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43276 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbaIWEmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 00:42:55 -0400
Received: by mail-pd0-f169.google.com with SMTP id fp1so1659014pdb.14
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 21:42:55 -0700 (PDT)
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
Subject: [PATCH v4 04/12] crypto: LLVMLinux: Remove VLAIS from crypto/mv_cesa.c
Date: Mon, 22 Sep 2014 21:42:09 -0700
Message-Id: <1411447337-22362-5-git-send-email-behanw@converseincode.com>
In-Reply-To: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
References: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
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
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/mv_cesa.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 29d0ee5..032c72c 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -402,26 +402,23 @@ static int mv_hash_final_fallback(struct ahash_request *req)
 {
 	const struct mv_tfm_hash_ctx *tfm_ctx = crypto_tfm_ctx(req->base.tfm);
 	struct mv_req_hash_ctx *req_ctx = ahash_request_ctx(req);
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm_ctx->fallback)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, tfm_ctx->fallback);
 	int rc;
 
-	desc.shash.tfm = tfm_ctx->fallback;
-	desc.shash.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm = tfm_ctx->fallback;
+	shash->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	if (unlikely(req_ctx->first_hash)) {
-		crypto_shash_init(&desc.shash);
-		crypto_shash_update(&desc.shash, req_ctx->buffer,
+		crypto_shash_init(shash);
+		crypto_shash_update(shash, req_ctx->buffer,
 				    req_ctx->extra_bytes);
 	} else {
 		/* only SHA1 for now....
 		 */
-		rc = mv_hash_import_sha1_ctx(req_ctx, &desc.shash);
+		rc = mv_hash_import_sha1_ctx(req_ctx, shash);
 		if (rc)
 			goto out;
 	}
-	rc = crypto_shash_final(&desc.shash, req->result);
+	rc = crypto_shash_final(shash, req->result);
 out:
 	return rc;
 }
@@ -794,23 +791,21 @@ static int mv_hash_setkey(struct crypto_ahash *tfm, const u8 * key,
 	ss = crypto_shash_statesize(ctx->base_hash);
 
 	{
-		struct {
-			struct shash_desc shash;
-			char ctx[crypto_shash_descsize(ctx->base_hash)];
-		} desc;
+		SHASH_DESC_ON_STACK(shash, ctx->base_hash);
+
 		unsigned int i;
 		char ipad[ss];
 		char opad[ss];
 
-		desc.shash.tfm = ctx->base_hash;
-		desc.shash.flags = crypto_shash_get_flags(ctx->base_hash) &
+		shash->tfm = ctx->base_hash;
+		shash->flags = crypto_shash_get_flags(ctx->base_hash) &
 		    CRYPTO_TFM_REQ_MAY_SLEEP;
 
 		if (keylen > bs) {
 			int err;
 
 			err =
-			    crypto_shash_digest(&desc.shash, key, keylen, ipad);
+			    crypto_shash_digest(shash, key, keylen, ipad);
 			if (err)
 				return err;
 
@@ -826,12 +821,12 @@ static int mv_hash_setkey(struct crypto_ahash *tfm, const u8 * key,
 			opad[i] ^= 0x5c;
 		}
 
-		rc = crypto_shash_init(&desc.shash) ? :
-		    crypto_shash_update(&desc.shash, ipad, bs) ? :
-		    crypto_shash_export(&desc.shash, ipad) ? :
-		    crypto_shash_init(&desc.shash) ? :
-		    crypto_shash_update(&desc.shash, opad, bs) ? :
-		    crypto_shash_export(&desc.shash, opad);
+		rc = crypto_shash_init(shash) ? :
+		    crypto_shash_update(shash, ipad, bs) ? :
+		    crypto_shash_export(shash, ipad) ? :
+		    crypto_shash_init(shash) ? :
+		    crypto_shash_update(shash, opad, bs) ? :
+		    crypto_shash_export(shash, opad);
 
 		if (rc == 0)
 			mv_hash_init_ivs(ctx, ipad, opad);
-- 
1.9.1

