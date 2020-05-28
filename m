Return-Path: <SRS0=T3D7=7K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A87AC433E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 18:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F035D20814
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 18:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="IMTpu5ZX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405873AbgE1SnQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 May 2020 14:43:16 -0400
Received: from smtp-35-i2.italiaonline.it ([213.209.12.35]:54804 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391484AbgE1SnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 May 2020 14:43:14 -0400
Received: from venice.bhome ([78.12.136.199])
        by smtp-35.iol.local with ESMTPA
        id eNMpjt6z1LNQWeNMqjtDfU; Thu, 28 May 2020 20:35:00 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1590690900; bh=anjEbj0kAIPpZNzbLlLMgqr42XvZRW3qpJZ4JsTTh7c=;
        h=From;
        b=IMTpu5ZX9b7+rA7a/V1RL8WTwO4sOllikIo0xi63PDolkbp0Pylf8mkF7T3QJlKMJ
         Hmc2atEsbLMWvyMSN6HXvdgA2wQgiUTnUMiLjke8hGH36wN73Lk+ojtaahqlnma0Oo
         cW1T2ux7tYfSVpePYhmz0/6NcuvYrODCOuFGJ73iZqKuokvXNwGNAkpxrFPVDdq0cs
         d4s2t1iucDB71/vz4csUHU5OdHEyKuxbr2COG2xCyr0rPhEQy6vpqriZMn4NXfRdBy
         Vdo0MAcKeynUkPe94Z9CN84XOi7RLfyFuHDSZ4mWRlh7+KBfKngEQ0ZwqXvz+Zwch1
         rS2dHCuDH7UAw==
X-CNFS-Analysis: v=2.3 cv=LKsYv6e9 c=1 sm=1 tr=0
 a=kx39m2EDZI1V9vDwKCQCcA==:117 a=kx39m2EDZI1V9vDwKCQCcA==:17
 a=tDkV-r6f1uA8TNYtaPcA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     linux-btrfs@vger.kernel.org
Cc:     Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/3] Update headers for the BTRFS_IOC_DEV_PROPERTIES.
Date:   Thu, 28 May 2020 20:34:54 +0200
Message-Id: <20200528183456.18030-2-kreijack@libero.it>
X-Mailer: git-send-email 2.27.0.rc2
In-Reply-To: <20200528183456.18030-1-kreijack@libero.it>
References: <20200528183456.18030-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfLMktXZF/NLz8gW5JWErp17mvovLSk3VXUW20thWXTr8hbT3unapcCAqjKxNdJdNwAd8tMv4+ohQzRZLbu+2QPw2PdfPhyaZShww1V9z/wKAKOF51aTC
 tYvZXiM25snZBOsDgVi9Mum4NM9uvkOOY7tnew8yBYCsmnOhud85lJdLN7ld/DcGAMASlhyrFMN5lwba9g0/euCjkwTidlfwQMQ=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Update the header to add the BTRFS_IOC_DEV_PROPERTIES ioctl:
- add ioctl BTRFS_IOC_DEV_PROPERTIES define
- add struct btrfs_ioctl_dev_properties
- add the BTRFS_DEV_PROPERTY_ define

This ioctl is a base for returning / setting information from / to  the
fields of the btrfs_dev_item object.

For now only the "type" field is returned / set.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 ctree.h |  2 ++
 ioctl.h | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/ctree.h b/ctree.h
index 7757e50c..aa027e1c 100644
--- a/ctree.h
+++ b/ctree.h
@@ -219,6 +219,8 @@ struct btrfs_mapping_tree {
 	struct cache_tree cache_tree;
 };
 
+#define BTRFS_DEV_DEDICATED_METADATA (1ULL << 0)
+
 #define BTRFS_UUID_SIZE 16
 struct btrfs_dev_item {
 	/* the internal btrfs device id */
diff --git a/ioctl.h b/ioctl.h
index ade6dcb9..a4febb95 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -775,6 +775,44 @@ struct btrfs_ioctl_get_subvol_rootref_args {
 };
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_get_subvol_rootref_args) == 4096);
 
+#define BTRFS_DEV_PROPERTY_TYPE		(1ULL << 0)
+#define BTRFS_DEV_PROPERTY_DEV_GROUP	(1ULL << 1)
+#define BTRFS_DEV_PROPERTY_SEEK_SPEED	(1ULL << 2)
+#define BTRFS_DEV_PROPERTY_BANDWIDTH	(1ULL << 3)
+#define BTRFS_DEV_PROPERTY_READ		(1ULL << 60)
+
+/*
+ * The ioctl BTRFS_IOC_DEV_PROPERTIES can read and write the device properties.
+ *
+ * The properties that the user want to write have to be set
+ * in the 'properties' field using the BTRFS_DEV_PROPERTY_xxxx constants.
+ *
+ * If the ioctl is used to read the device properties, the bit
+ * BTRFS_DEV_PROPERTY_READ has to be set in the 'properties' field.
+ * In this case the properties that the user want have to be set in the
+ * 'properties' field. The kernel doesn't return a property that was not
+ * required, however it may return a subset of the requested properties.
+ * The returned properties have the corrispondent BTRFS_DEV_PROPERTY_xxxx
+ * flag set in the 'properties' field.
+ *
+ * Up to 2020/05/11 the only properties that can be read/write is the 'type'
+ * one.
+ */
+struct btrfs_ioctl_dev_properties {
+	__u64	devid;
+	__u64	properties;
+	__u64	type;
+	__u32	dev_group;
+	__u8	seek_speed;
+	__u8	bandwidth;
+
+	/*
+	 * for future expansion
+	 */
+	__u8	unused1[2];
+	__u64	unused2[4];
+};
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	notused,
@@ -949,6 +987,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				struct btrfs_ioctl_ino_lookup_user_args)
 #define BTRFS_IOC_SNAP_DESTROY_V2 _IOW(BTRFS_IOCTL_MAGIC, 63, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_DEV_PROPERTIES _IOW(BTRFS_IOCTL_MAGIC, 64, \
+				struct btrfs_ioctl_dev_properties)
 
 #ifdef __cplusplus
 }
-- 
2.27.0.rc2

