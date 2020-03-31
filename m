Return-Path: <SRS0=zgmC=5Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0331DC43331
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Mar 2020 19:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAAC8208E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Mar 2020 19:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="XBWgdrhI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgCaTKy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 Mar 2020 15:10:54 -0400
Received: from smtp-16.italiaonline.it ([213.209.10.16]:47216 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726295AbgCaTKx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Mar 2020 15:10:53 -0400
Received: from venice.bhome ([94.37.173.46])
        by smtp-16.iol.local with ESMTPA
        id JMHijXV70jfNYJMHjj3qIa; Tue, 31 Mar 2020 21:10:51 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1585681851; bh=2A03QjPnWHEHDdEsb/WOGQ5nNmWI6TQsphlRQcpid7g=;
        h=From;
        b=XBWgdrhImDJN+F+EDryzdega19r9qCYhit5SUgOUKmTcyVj2xFXxFaRg8q5RK2zwk
         3//UAgjFqjNjBrMtaUx5QaHGAZB2lseApIFpnez7gDhvsb+4c7yjzhkqsnf5jk24uM
         T0BB+uBo2PPUyzLuotAfhLfhfw1N9BKa0bn74s91umthNukxHBImFXlrG1lLPuLHbG
         ZDaJYSnhBz5fClmehHktC8dVLmzvUQPJ7kGQMr5WV5tBkMgPMrC6/t2KXTxXjaJPbc
         4OKC4Zwi8PfXD4IKWGiFKxvLdhGB2rxr+8grq1G8VfiPk3QO4T1zgPuoCqQ8iiKZu4
         /ddF3mBWc1gFA==
X-CNFS-Analysis: v=2.3 cv=av7M9hRV c=1 sm=1 tr=0
 a=TpQr5eyM7/bznjVQAbUtjA==:117 a=TpQr5eyM7/bznjVQAbUtjA==:17
 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=fdgFY_N7qoPLzqVp-50A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     linux-btrfs@vger.kernel.org
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        David Sterba <dsterba@suse.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/4] btrfs-progs: Add BTRFS_EXTENDED_PROFILE_MASK mask.
Date:   Tue, 31 Mar 2020 21:10:43 +0200
Message-Id: <20200331191045.8991-3-kreijack@libero.it>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331191045.8991-1-kreijack@libero.it>
References: <20200331191045.8991-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfGNfLIHCkLZha9d5dLtr7lsKmMdrqTXWKjPExfzL24rKaiOhP05e2IuAS8mgYOBQ7n/WFTWzKxrs8waBs59DvmAOYl0UHtvoESmNGPjQQbe1Ct9ywePY
 cLjDv3yncj3M9CTr4Fnt06QQUtAUgp+oqHrlLNDVhAi2n5CQZTLaBYqNNx+HBp0wH5PLeOkL/D3SCMGfquR0QMF308wzWPbLVsXXTrS5GDT+YzW/HdlMcPrF
 Aj0OEcDmKJF7eKrmljdqxCa0FUZgSqsHX2Lja0lIaKUMElcIW733xuWE3etbT0otLV8Ar6e8zctT50v2X/QvOA==
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
index 691481bc..9d69fa94 100644
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
2.26.0

