Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35666 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaIWEnC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 00:43:02 -0400
Received: by mail-pd0-f171.google.com with SMTP id y13so5719238pdi.30
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 21:43:01 -0700 (PDT)
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
Subject: [PATCH v4 06/12] crypto: LLVMLinux: Remove VLAIS from crypto/omap_sham.c
Date: Mon, 22 Sep 2014 21:42:11 -0700
Message-Id: <1411447337-22362-7-git-send-email-behanw@converseincode.com>
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
 drivers/crypto/omap-sham.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 710d863..24ef489 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -949,17 +949,14 @@ static int omap_sham_finish_hmac(struct ahash_request *req)
 	struct omap_sham_hmac_ctx *bctx = tctx->base;
 	int bs = crypto_shash_blocksize(bctx->shash);
 	int ds = crypto_shash_digestsize(bctx->shash);
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(bctx->shash)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, bctx->shash);
 
-	desc.shash.tfm = bctx->shash;
-	desc.shash.flags = 0; /* not CRYPTO_TFM_REQ_MAY_SLEEP */
+	shash->tfm = bctx->shash;
+	shash->flags = 0; /* not CRYPTO_TFM_REQ_MAY_SLEEP */
 
-	return crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, bctx->opad, bs) ?:
-	       crypto_shash_finup(&desc.shash, req->result, ds, req->result);
+	return crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, bctx->opad, bs) ?:
+	       crypto_shash_finup(shash, req->result, ds, req->result);
 }
 
 static int omap_sham_finish(struct ahash_request *req)
@@ -1118,18 +1115,15 @@ static int omap_sham_update(struct ahash_request *req)
 	return omap_sham_enqueue(req, OP_UPDATE);
 }
 
-static int omap_sham_shash_digest(struct crypto_shash *shash, u32 flags,
+static int omap_sham_shash_digest(struct crypto_shash *tfm, u32 flags,
 				  const u8 *data, unsigned int len, u8 *out)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(shash)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, tfm);
 
-	desc.shash.tfm = shash;
-	desc.shash.flags = flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm = tfm;
+	shash->flags = flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	return crypto_shash_digest(&desc.shash, data, len, out);
+	return crypto_shash_digest(shash, data, len, out);
 }
 
 static int omap_sham_final_shash(struct ahash_request *req)
-- 
1.9.1

