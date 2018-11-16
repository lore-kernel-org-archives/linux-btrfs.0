Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF5FC43610
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3954208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3954208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389385AbeKPSFy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:05:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:46156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSFy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:05:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B15B4ABDC
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 07:54:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] btrfs-progs: Fix Wempty-body warning
Date:   Fri, 16 Nov 2018 15:54:21 +0800
Message-Id: <20181116075426.4142-5-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116075426.4142-1-wqu@suse.com>
References: <20181116075426.4142-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

messages.h:49:24: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
    PRINT_TRACE_ON_ERROR;    \

Just extra braces would solve the problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 messages.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/messages.h b/messages.h
index ec7d93381a36..16f650d19a4b 100644
--- a/messages.h
+++ b/messages.h
@@ -45,13 +45,16 @@
 
 #define error_on(cond, fmt, ...)					\
 	do {								\
-		if ((cond))						\
+		if ((cond)) {						\
 			PRINT_TRACE_ON_ERROR;				\
-		if ((cond))						\
+		}							\
+		if ((cond)) {						\
 			PRINT_VERBOSE_ERROR;				\
+		}							\
 		__btrfs_error_on((cond), (fmt), ##__VA_ARGS__);		\
-		if ((cond))						\
+		if ((cond)) {						\
 			DO_ABORT_ON_ERROR;				\
+		}							\
 	} while (0)
 
 #define error_btrfs_util(err)						\
@@ -76,10 +79,12 @@
 
 #define warning_on(cond, fmt, ...)					\
 	do {								\
-		if ((cond))						\
+		if ((cond)) {						\
 			PRINT_TRACE_ON_ERROR;				\
-		if ((cond))						\
+		}							\
+		if ((cond)) {						\
 			PRINT_VERBOSE_ERROR;				\
+		}							\
 		__btrfs_warning_on((cond), (fmt), ##__VA_ARGS__);	\
 	} while (0)
 
-- 
2.19.1

