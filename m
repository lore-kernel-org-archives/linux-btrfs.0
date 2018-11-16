Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208ADC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3E37208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3E37208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389420AbeKPSGC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:06:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:46210 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSGB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:06:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 338E6ABDC
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 07:54:46 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] btrfs-progs: Fix Wtype-limits warning
Date:   Fri, 16 Nov 2018 15:54:25 +0800
Message-Id: <20181116075426.4142-9-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116075426.4142-1-wqu@suse.com>
References: <20181116075426.4142-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The only hit is the following code:

 		tlv_len = le16_to_cpu(tlv_hdr->tlv_len);

		if (tlv_type == 0 || tlv_type > BTRFS_SEND_A_MAX
		    || tlv_len > BTRFS_SEND_BUF_SIZE) {
 			error("invalid tlv in cmd tlv_type = %hu, tlv_len = %hu",
 					tlv_type, tlv_len);

@tlv_len is u16, while BTRFS_SEND_BUF_SIZE is 64K.
u16 MAX is 64K - 1, so the final check is always false.

Just remove it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 send-stream.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/send-stream.c b/send-stream.c
index 3b8e39c9486a..25461e92c37b 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -157,8 +157,7 @@ static int read_cmd(struct btrfs_send_stream *sctx)
 		tlv_type = le16_to_cpu(tlv_hdr->tlv_type);
 		tlv_len = le16_to_cpu(tlv_hdr->tlv_len);
 
-		if (tlv_type == 0 || tlv_type > BTRFS_SEND_A_MAX
-		    || tlv_len > BTRFS_SEND_BUF_SIZE) {
+		if (tlv_type == 0 || tlv_type > BTRFS_SEND_A_MAX) {
 			error("invalid tlv in cmd tlv_type = %hu, tlv_len = %hu",
 					tlv_type, tlv_len);
 			ret = -EINVAL;
-- 
2.19.1

