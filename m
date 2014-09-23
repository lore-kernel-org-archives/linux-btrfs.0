Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46169 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaIWEmx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 00:42:53 -0400
Received: by mail-pa0-f41.google.com with SMTP id ey11so6546435pad.28
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 21:42:52 -0700 (PDT)
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
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH v4 03/12] crypto: LLVMLinux: Remove VLAIS from crypto/ccp/ccp-crypto-sha.c
Date: Mon, 22 Sep 2014 21:42:08 -0700
Message-Id: <1411447337-22362-4-git-send-email-behanw@converseincode.com>
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
---
 drivers/crypto/ccp/ccp-crypto-sha.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 873f234..9653157 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -198,10 +198,9 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 	struct crypto_shash *shash = ctx->u.sha.hmac_tfm;
-	struct {
-		struct shash_desc sdesc;
-		char ctx[crypto_shash_descsize(shash)];
-	} desc;
+
+	SHASH_DESC_ON_STACK(sdesc, shash);
+
 	unsigned int block_size = crypto_shash_blocksize(shash);
 	unsigned int digest_size = crypto_shash_digestsize(shash);
 	int i, ret;
@@ -216,11 +215,11 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 	if (key_len > block_size) {
 		/* Must hash the input key */
-		desc.sdesc.tfm = shash;
-		desc.sdesc.flags = crypto_ahash_get_flags(tfm) &
+		sdesc->tfm = shash;
+		sdesc->flags = crypto_ahash_get_flags(tfm) &
 			CRYPTO_TFM_REQ_MAY_SLEEP;
 
-		ret = crypto_shash_digest(&desc.sdesc, key, key_len,
+		ret = crypto_shash_digest(sdesc, key, key_len,
 					  ctx->u.sha.key);
 		if (ret) {
 			crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-- 
1.9.1

