Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29906 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaEGK4t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 06:56:49 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s47AumsF026801
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:49 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s47AulZv002865
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:48 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s47Aukkm027100
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:46 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Crypto: xxhash: add tests
Date: Wed,  7 May 2014 18:56:31 +0800
Message-Id: <1399460193-1713-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
References: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 crypto/testmgr.c | 10 ++++++++++
 crypto/testmgr.h | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index dc3cf35..27ba702 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3153,6 +3153,16 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "xxh32",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = {
+				.vecs = xxh32_tv_template,
+				.count = XXH32_TEST_VECTORS
+			}
+		}
+	}, {
 		.alg = "zlib",
 		.test = alg_test_pcomp,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 3db83db..8e56884 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -26660,6 +26660,39 @@ static struct hash_testvec michael_mic_tv_template[] = {
 	}
 };
 
+#define XXH32_TEST_VECTORS 3
+
+static struct hash_testvec xxh32_tv_template[] = {
+	{
+		.plaintext = "\x9e",
+		.psize = 1,
+		.digest  = "\xe5\xbe\x5c\xb8",
+	},
+	{
+		.plaintext = "\x9e\xff\x1f\x4b\x5e\x53\x2f\xdd"
+			     "\xb5\x54\x4d\x2a\x95\x2b",
+		.psize = 14,
+		.digest = "\xb4\x0a\xaa\xe5",
+	},
+	{
+		.plaintext = "\x9e\xff\x1f\x4b\x5e\x53\x2f\xdd"
+			     "\xb5\x54\x4d\x2a\x95\x2b\x57\xae"
+			     "\x5d\xba\x74\xe9\xd3\xa6\x4c\x98"
+			     "\x30\x60\xc0\x80\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00\x00\x00\x00"
+			     "\x00\x00\x00\x00\x00",
+		.psize = 101,
+		.digest = "\x12\xa4\x1a\x1f",
+	}
+};
+
 /*
  * CRC32C test vectors
  */
-- 
1.8.1.4

