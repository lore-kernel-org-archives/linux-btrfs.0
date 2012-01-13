From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/3] Add snappy interface to crypto API
Date: Thu, 12 Jan 2012 16:28:50 -0800
Message-ID: <1326414530-10789-4-git-send-email-andi@firstfloor.org>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Andi Kleen <ak@linux.intel.com>
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Andi Kleen <ak@linux.intel.com>

Mainly so that ubifs can use it.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 crypto/Kconfig  |    9 +++++
 crypto/Makefile |    1 +
 crypto/snappy.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 crypto/snappy.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e6cfe1a..768943dc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -924,6 +924,15 @@ config CRYPTO_LZO
 	help
 	  This is the LZO algorithm.
 
+config CRYPTO_SNAPPY
+	tristate "Snappy compression algorithm"
+	select CRYPTO_ALGAPI
+	select SNAPPY
+	help
+	  snappy is a faster alternative to the lzo compression algorithm
+	  with comparable compression. It is very fast on 64bit systems, but also
+	  good on 32bit systems. It especially excels at already compressed data.
+
 comment "Random Number Generation"
 
 config CRYPTO_ANSI_CPRNG
diff --git a/crypto/Makefile b/crypto/Makefile
index f638063..8a0e6c6 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
+obj-$(CONFIG_CRYPTO_SNAPPY) += snappy.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
diff --git a/crypto/snappy.c b/crypto/snappy.c
new file mode 100644
index 0000000..43a64b9
--- /dev/null
+++ b/crypto/snappy.c
@@ -0,0 +1,99 @@
+/*
+ * Cryptographic API.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/vmalloc.h>
+#include <linux/snappy.h>
+
+struct snappy_ctx {
+	struct snappy_env env;
+};
+
+/* Only needed for compression actually */
+static int snappy_init(struct crypto_tfm *tfm)
+{
+	struct snappy_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return snappy_init_env(&ctx->env);
+}
+
+static void snappy_exit(struct crypto_tfm *tfm)
+{
+	struct snappy_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	snappy_free_env(&ctx->env);
+}
+
+static int snp_compress(struct crypto_tfm *tfm, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct snappy_ctx *ctx = crypto_tfm_ctx(tfm);
+	size_t olen;
+	int err;
+
+	/* XXXX very pessimistic. check in snappy? */
+	if (*dlen < snappy_max_compressed_length(*dlen))
+		return -EINVAL;
+	err = snappy_compress(&ctx->env, src, slen, dst, &olen);
+	*dlen = olen;
+	return err;
+}
+
+static int snp_decompress(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	size_t ulen;
+
+	if (!snappy_uncompressed_length(src, slen, &ulen))
+		return -EIO;
+	if (*dlen < ulen)
+		return -EINVAL;
+	*dlen = ulen;
+	return snappy_uncompress(src, slen, dst) ? 0 : -EIO;
+}
+
+static struct crypto_alg alg = {
+	.cra_name		= "snappy",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct snappy_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(alg.cra_list),
+	.cra_init		= snappy_init,
+	.cra_exit		= snappy_exit,
+	.cra_u			= { .compress = {
+	.coa_compress 		= snp_compress,
+	.coa_decompress  	= snp_decompress } }
+};
+
+static int __init snappy_mod_init(void)
+{
+	return crypto_register_alg(&alg);
+}
+
+static void __exit snappy_mod_fini(void)
+{
+	crypto_unregister_alg(&alg);
+}
+
+module_init(snappy_mod_init);
+module_exit(snappy_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Snappy Compression Algorithm");
-- 
1.7.7.4
