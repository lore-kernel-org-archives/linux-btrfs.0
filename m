Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79172C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DEDC208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DEDC208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389401AbeKPSF6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:05:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:46198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:05:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB47CABDC
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 07:54:42 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs-progs: Fix Wsuggest-attribute=format warning
Date:   Fri, 16 Nov 2018 15:54:23 +0800
Message-Id: <20181116075426.4142-7-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116075426.4142-1-wqu@suse.com>
References: <20181116075426.4142-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add __attribute__ ((format (printf, 4, 0))) to fix the vprintf calling
function.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 string-table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/string-table.c b/string-table.c
index 95833768960d..455285702d51 100644
--- a/string-table.c
+++ b/string-table.c
@@ -48,6 +48,7 @@ struct string_table *table_create(int columns, int rows)
  * '>' the text is right aligned. If fmt is equal to '=' the text will
  * be replaced by a '=====' dimensioned on the basis of the column width
  */
+__attribute__ ((format (printf, 4, 0)))
 char *table_vprintf(struct string_table *tab, int column, int row,
 			  const char *fmt, va_list ap)
 {
-- 
2.19.1

