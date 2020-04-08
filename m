Return-Path: <SRS0=tPet=5Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05FCC2D0F4
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 18:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92C5E20784
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 18:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586369534;
	bh=TcPNRCJme7IaXE/FYkUUYDMDLIwcirmTHJy/ltbojaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OSK++4siInsx6UXbF4s1BBXS1WlU1DJ+M+Wjtq1IwwbCbFTNqSMvpCfNA59XBFiDu
	 ukqAFcX4wtu3un2Fb9MiAwokZfRoztaLbV1O21MyromoAHs+BcHBq12Fm1+u13V3x0
	 14wfi7rLjJHFMLFXl8M7p+ByHNqcNMAzYdXj1MT0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgDHSMO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 14:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgDHSMO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Apr 2020 14:12:14 -0400
Received: from debian6.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A7212075E;
        Wed,  8 Apr 2020 18:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586369532;
        bh=TcPNRCJme7IaXE/FYkUUYDMDLIwcirmTHJy/ltbojaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtWXekea1N4XhLirg90o5mmmvMI3DMXeDpfQSb3+LyceemEjP1gHnNqGJwOaMMQ3r
         eA4/kFvoKz8pQNG+06bPhxnZXWfQRzj1Z8dW4x93wZcoXfzCISgJ+ndnZU2xRmMwFb
         LlKNzCMlSPIdTJLnZaKjker9LnO/890nUCkDwffc=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 4/4] fsx: move range generation logic into a common helper
Date:   Wed,  8 Apr 2020 19:12:08 +0100
Message-Id: <20200408181208.12054-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200408103627.11514-1-fdmanana@kernel.org>
References: <20200408103627.11514-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We have very similar code that generates the destination range for clone,
dedupe and copy_file_range operations, so avoid duplicating the code three
times and move it into a helper function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Turned the first parameter of the helper into a boolean as Darrick suggested.

 ltp/fsx.c | 91 +++++++++++++++++++++++++--------------------------------------
 1 file changed, 36 insertions(+), 55 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 89a5f60e..9bfc98e0 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1930,6 +1930,36 @@ range_overlaps(
 	return llabs((unsigned long long)off1 - off0) < size;
 }
 
+static void generate_dest_range(bool readbdy_align,
+				unsigned long max_range_end,
+				unsigned long *src_offset,
+				unsigned long *size,
+				unsigned long *dst_offset)
+{
+	int tries = 0;
+
+	TRIM_OFF_LEN(*src_offset, *size, file_size);
+	if (readbdy_align) {
+		*src_offset -= *src_offset % readbdy;
+		if (o_direct)
+			*size -= *size % readbdy;
+	} else {
+		*src_offset = *src_offset & ~(block_size - 1);
+		*size = *size & ~(block_size - 1);
+	}
+
+	do {
+		if (tries++ >= 30) {
+			*size = 0;
+			break;
+		}
+		*dst_offset = random();
+		TRIM_OFF(*dst_offset, max_range_end);
+		*dst_offset = *dst_offset & ~(block_size - 1);
+	} while (range_overlaps(*src_offset, *dst_offset, *size) ||
+		 *dst_offset + *size > max_range_end);
+}
+
 int
 test(void)
 {
@@ -2004,63 +2034,14 @@ test(void)
 			keep_size = random() % 2;
 		break;
 	case OP_CLONE_RANGE:
-		{
-			int tries = 0;
-
-			TRIM_OFF_LEN(offset, size, file_size);
-			offset = offset & ~(block_size - 1);
-			size = size & ~(block_size - 1);
-			do {
-				if (tries++ >= 30) {
-					size = 0;
-					break;
-				}
-				offset2 = random();
-				TRIM_OFF(offset2, maxfilelen);
-				offset2 = offset2 & ~(block_size - 1);
-			} while (range_overlaps(offset, offset2, size) ||
-				 offset2 + size > maxfilelen);
-			break;
-		}
+		generate_dest_range(false, maxfilelen, &offset, &size, &offset2);
+		break;
 	case OP_DEDUPE_RANGE:
-		{
-			int tries = 0;
-
-			TRIM_OFF_LEN(offset, size, file_size);
-			offset = offset & ~(block_size - 1);
-			size = size & ~(block_size - 1);
-			do {
-				if (tries++ >= 30) {
-					size = 0;
-					break;
-				}
-				offset2 = random();
-				TRIM_OFF(offset2, file_size);
-				offset2 = offset2 & ~(block_size - 1);
-			} while (range_overlaps(offset, offset2, size) ||
-				 offset2 + size > file_size);
-			break;
-		}
+		generate_dest_range(false, file_size, &offset, &size, &offset2);
+		break;
 	case OP_COPY_RANGE:
-		{
-			int tries = 0;
-
-			TRIM_OFF_LEN(offset, size, file_size);
-			offset -= offset % readbdy;
-			if (o_direct)
-				size -= size % readbdy;
-			do {
-				if (tries++ >= 30) {
-					size = 0;
-					break;
-				}
-				offset2 = random();
-				TRIM_OFF(offset2, maxfilelen);
-				offset2 -= offset2 % writebdy;
-			} while (range_overlaps(offset, offset2, size) ||
-				 offset2 + size > maxfilelen);
-			break;
-		}
+		generate_dest_range(true, maxfilelen, &offset, &size, &offset2);
+		break;
 	}
 
 have_op:
-- 
2.11.0

