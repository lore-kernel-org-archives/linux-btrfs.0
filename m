Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52368 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbaIBWdR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 18:33:17 -0400
Received: by mail-pa0-f48.google.com with SMTP id ey11so15709659pad.7
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 15:33:17 -0700 (PDT)
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
Subject: [PATCH RFC 3/6] crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
Date: Tue,  2 Sep 2014 15:32:30 -0700
Message-Id: <1409697153-7006-4-git-send-email-behanw@converseincode.com>
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
 lib/libcrc32c.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index b3131f5..03f2cf3 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -41,20 +41,20 @@ static struct crypto_shash *tfm;
 
 u32 crc32c(u32 crc, const void *address, unsigned int length)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc)
+		+ crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
+	u32 *ctx = (u32 *)shash_desc_ctx(shash);
 	int err;
 
-	desc.shash.tfm = tfm;
-	desc.shash.flags = 0;
-	*(u32 *)desc.ctx = crc;
+	shash->tfm = tfm;
+	shash->flags = 0;
+	*ctx = crc;
 
-	err = crypto_shash_update(&desc.shash, address, length);
+	err = crypto_shash_update(shash, address, length);
 	BUG_ON(err);
 
-	return *(u32 *)desc.ctx;
+	return *ctx;
 }
 
 EXPORT_SYMBOL(crc32c);
-- 
1.9.1

