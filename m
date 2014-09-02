Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51892 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbaIBWdT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 18:33:19 -0400
Received: by mail-pd0-f170.google.com with SMTP id r10so9661896pdi.29
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 15:33:19 -0700 (PDT)
From: behanw@converseincode.com
To: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, herbert@gondor.apana.org.au, jbacik@fb.com,
        snitzer@redhat.com
Cc: akpm@linux-foundation.org, james.l.morris@oracle.com,
        john.johansen@canonical.com, linux-btrfs@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        neilb@suse.de, serge@hallyn.com, torvalds@linux-foundation.org,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>, pageexec@freemail.hu
Subject: [PATCH RFC 4/6] crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c
Date: Tue,  2 Sep 2014 15:32:31 -0700
Message-Id: <1409697153-7006-5-git-send-email-behanw@converseincode.com>
In-Reply-To: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jan-Simon Möller <dl9pf@gmx.de>

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). This patch instead allocates the appropriate amount of memory
using an char array.

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
Cc: pageexec@freemail.hu
---
 crypto/testmgr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ac2b631..f4bf5c2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1714,16 +1714,16 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 	}
 
 	do {
-		struct {
-			struct shash_desc shash;
-			char ctx[crypto_shash_descsize(tfm)];
-		} sdesc;
+		char sdesc[sizeof(struct shash_desc)
+			+ crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
+		struct shash_desc *shash = (struct shash_desc *)sdesc;
+		u32 *ctx = (u32 *)shash_desc_ctx(shash);
 
-		sdesc.shash.tfm = tfm;
-		sdesc.shash.flags = 0;
+		shash->tfm = tfm;
+		shash->flags = 0;
 
-		*(u32 *)sdesc.ctx = le32_to_cpu(420553207);
-		err = crypto_shash_final(&sdesc.shash, (u8 *)&val);
+		*ctx = le32_to_cpu(420553207);
+		err = crypto_shash_final(shash, (u8 *)&val);
 		if (err) {
 			printk(KERN_ERR "alg: crc32c: Operation failed for "
 			       "%s: %d\n", driver, err);
-- 
1.9.1

