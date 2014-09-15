Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54941 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaIOHbl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 03:31:41 -0400
Received: by mail-pd0-f171.google.com with SMTP id p10so5699260pdj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 00:31:41 -0700 (PDT)
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
Subject: [PATCH v3 07/12] crypto: LLVMLinux: Remove VLAIS from crypto/.../qat_algs.c
Date: Mon, 15 Sep 2014 00:30:29 -0700
Message-Id: <1410766234-1634-8-git-send-email-behanw@converseincode.com>
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
 drivers/crypto/qat/qat_common/qat_algs.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 59df488..9cabadd 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -152,10 +152,7 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 				  const uint8_t *auth_key,
 				  unsigned int auth_keylen, uint8_t *auth_state)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(ctx->hash_tfm)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, ctx->hash_tfm);
 	struct sha1_state sha1;
 	struct sha256_state sha256;
 	struct sha512_state sha512;
@@ -167,12 +164,12 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	__be64 *hash512_state_out;
 	int i, offset;
 
-	desc.shash.tfm = ctx->hash_tfm;
-	desc.shash.flags = 0x0;
+	shash->tfm = ctx->hash_tfm;
+	shash->flags = 0x0;
 
 	if (auth_keylen > block_size) {
 		char buff[SHA512_BLOCK_SIZE];
-		int ret = crypto_shash_digest(&desc.shash, auth_key,
+		int ret = crypto_shash_digest(shash, auth_key,
 					      auth_keylen, buff);
 		if (ret)
 			return ret;
@@ -195,10 +192,10 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 		*opad_ptr ^= 0x5C;
 	}
 
-	if (crypto_shash_init(&desc.shash))
+	if (crypto_shash_init(shash))
 		return -EFAULT;
 
-	if (crypto_shash_update(&desc.shash, ipad, block_size))
+	if (crypto_shash_update(shash, ipad, block_size))
 		return -EFAULT;
 
 	hash_state_out = (__be32 *)hash->sha.state1;
@@ -206,19 +203,19 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 
 	switch (ctx->qat_hash_alg) {
 	case ICP_QAT_HW_AUTH_ALGO_SHA1:
-		if (crypto_shash_export(&desc.shash, &sha1))
+		if (crypto_shash_export(shash, &sha1))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out = cpu_to_be32(*(sha1.state + i));
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA256:
-		if (crypto_shash_export(&desc.shash, &sha256))
+		if (crypto_shash_export(shash, &sha256))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out = cpu_to_be32(*(sha256.state + i));
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA512:
-		if (crypto_shash_export(&desc.shash, &sha512))
+		if (crypto_shash_export(shash, &sha512))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
 			*hash512_state_out = cpu_to_be64(*(sha512.state + i));
@@ -227,10 +224,10 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 		return -EFAULT;
 	}
 
-	if (crypto_shash_init(&desc.shash))
+	if (crypto_shash_init(shash))
 		return -EFAULT;
 
-	if (crypto_shash_update(&desc.shash, opad, block_size))
+	if (crypto_shash_update(shash, opad, block_size))
 		return -EFAULT;
 
 	offset = round_up(qat_get_inter_state_size(ctx->qat_hash_alg), 8);
@@ -239,19 +236,19 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 
 	switch (ctx->qat_hash_alg) {
 	case ICP_QAT_HW_AUTH_ALGO_SHA1:
-		if (crypto_shash_export(&desc.shash, &sha1))
+		if (crypto_shash_export(shash, &sha1))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out = cpu_to_be32(*(sha1.state + i));
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA256:
-		if (crypto_shash_export(&desc.shash, &sha256))
+		if (crypto_shash_export(shash, &sha256))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out = cpu_to_be32(*(sha256.state + i));
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA512:
-		if (crypto_shash_export(&desc.shash, &sha512))
+		if (crypto_shash_export(shash, &sha512))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
 			*hash512_state_out = cpu_to_be64(*(sha512.state + i));
-- 
1.9.1

