Return-Path: <SRS0=KM0e=5K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66C4C2D0E5
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 20:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F6AC20719
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 20:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="CUHRH/dw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgCYUKr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 16:10:47 -0400
Received: from smtp-16.italiaonline.it ([213.209.10.16]:41708 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727275AbgCYUKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Mar 2020 16:10:47 -0400
Received: from venice.bhome ([94.37.173.46])
        by smtp-16.iol.local with ESMTPA
        id HCMOjh5MEjfNYHCMPjKIfe; Wed, 25 Mar 2020 21:10:46 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1585167046; bh=bpZ4/tTRQsQ1WNRSrCe2Uslib9zT+AD10AVxSlUUxo0=;
        h=From;
        b=CUHRH/dw2uL37dcCVs90e1wB8PKe9GTJ578sC//nhChezARb76AiyUG2Ofh0mxXmA
         7gMegIWvCQq70QZKv7X0Wqb/d7f12kEyxTsw8LqKzQsSkUw5N2E3h2OniH2jCZdcNJ
         Ya5TOz5As3wAd3sPLW3VkhmaFJe9FdkOVSOtKw6f28STGS9p0ny/4+iGSpxgfH05ec
         XQvJItjLMwGyfSnD5tGmrjwnwqaYupzExnUsDMo4a7649NFAhq38jpp5nnJp9dSaRK
         7Q/cxeE6ZJmY4pF/9Tl5uJf6nF0RukqNQYko5M12saqLN06b2C/kETe6Q2IewJMGEM
         pXoXbHbdJ3bTg==
X-CNFS-Analysis: v=2.3 cv=av7M9hRV c=1 sm=1 tr=0
 a=TpQr5eyM7/bznjVQAbUtjA==:117 a=TpQr5eyM7/bznjVQAbUtjA==:17
 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=fdgFY_N7qoPLzqVp-50A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     linux-btrfs@vger.kernel.org
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/4] btrfs-progs: Add BTRFS_EXTENDED_PROFILE_MASK mask.
Date:   Wed, 25 Mar 2020 21:10:40 +0100
Message-Id: <20200325201042.190332-3-kreijack@libero.it>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200325201042.190332-1-kreijack@libero.it>
References: <20200325201042.190332-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfGkYcP/Y0c4qDFI5CyhfgKhAV9x4PrkfrfGxzSAkIbUt7yhQbguy7KdkSX9Lfi9dlZZlWkPGO4CWTvZoJ7dRC800nf3ZrGgrHItlj0Hn4XOtc7wuUh+P
 QdDKcPBN8Y4bJLHIfN+NZ9efykl50U0PIxwuBzVfTLRM5AeEr15cQ8/G7KaZNZiGVIfAY5EDMsDSlrZTpw/utLY1AgBzUYBy24j080Wz7AiQuJaxg3Rqg4jt
 FnlI9KkkOaiqfjgBkZKHrA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Add BTRFS_EXTENDED_PROFILE_MASK to consider also the
BTRFS_AVAIL_ALLOC_BIT_SINGLE bit.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 ctree.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ctree.h b/ctree.h
index 36f62732..017ac067 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1005,6 +1005,9 @@ enum btrfs_raid_types {
 /* used in struct btrfs_balance_args fields */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
 
+#define BTRFS_EXTENDED_PROFILE_MASK	(BTRFS_BLOCK_GROUP_PROFILE_MASK | \
+					 BTRFS_AVAIL_ALLOC_BIT_SINGLE)
+
 /*
  * GLOBAL_RSV does not exist as a on-disk block group type and is used
  * internally for exporting info about global block reserve from space infos
-- 
2.26.0.rc2

