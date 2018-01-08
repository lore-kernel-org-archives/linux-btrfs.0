Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46152 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756365AbeAHJpP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 04:45:15 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] libcrc32c: Add crc32c_impl function
Date: Mon,  8 Jan 2018 11:45:04 +0200
Message-Id: <1515404705-490-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1515404705-490-1-git-send-email-nborisov@suse.com>
References: <1515404705-490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function returns a string with the currently in-use implementation
of the crc32c algorithm, i.e crc32c-generic (for unoptimised, generic
implementation) or crc32c-intel for the sse optimised version. This
will be used by btrfs.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 include/linux/crc32c.h | 1 +
 lib/libcrc32c.c        | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/crc32c.h b/include/linux/crc32c.h
index 357ae4611a45..bd21af828ff6 100644
--- a/include/linux/crc32c.h
+++ b/include/linux/crc32c.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 
 extern u32 crc32c(u32 crc, const void *address, unsigned int length);
+extern const char *crc32c_impl(void);
 
 /* This macro exists for backwards-compatibility. */
 #define crc32c_le crc32c
diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 9f79547d1b97..eaf71e0e04be 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -71,6 +71,12 @@ static void __exit libcrc32c_mod_fini(void)
 	crypto_free_shash(tfm);
 }
 
+const char *crc32c_impl(void)
+{
+	return crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm));
+}
+EXPORT_SYMBOL(crc32c_impl);
+
 module_init(libcrc32c_mod_init);
 module_exit(libcrc32c_mod_fini);
 
-- 
2.7.4

