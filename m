Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33110 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbaIOHbX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 03:31:23 -0400
Received: by mail-pa0-f46.google.com with SMTP id kq14so5755670pab.19
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 00:31:22 -0700 (PDT)
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
Subject: [PATCH v3 01/12] crypto: LLVMLinux: Add macro to remove use of VLAIS in crypto code
Date: Mon, 15 Sep 2014 00:30:23 -0700
Message-Id: <1410766234-1634-2-git-send-email-behanw@converseincode.com>
In-Reply-To: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Behan Webster <behanw@converseincode.com>

Add a macro which replaces the use of a Variable Length Array In Struct (VLAIS)
with a C99 compliant equivalent. This macro instead allocates the appropriate
amount of memory using an char array.

The new code can be compiled with both gcc and clang.

struct shash_desc contains a flexible array member member ctx declared with
CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
of the array declared after struct shash_desc with long long.

No trailing padding is required because it is not a struct type that can
be used in an array.

The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
as would be the case for a struct containing a member with
CRYPTO_MINALIGN_ATTR.

Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 include/crypto/hash.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index a391955..541125b 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -58,6 +58,11 @@ struct shash_desc {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+#define SHASH_DESC_ON_STACK(shash, tfm)				  \
+	char __desc[sizeof(struct shash_desc) +                   \
+		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR; \
+	struct shash_desc *shash = (struct shash_desc *)__desc
+
 struct shash_alg {
 	int (*init)(struct shash_desc *desc);
 	int (*update)(struct shash_desc *desc, const u8 *data,
-- 
1.9.1

