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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E3EC2D0E8
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 20:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2690A20719
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 20:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="kjHlstE6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCYUKt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 16:10:49 -0400
Received: from smtp-16.italiaonline.it ([213.209.10.16]:46036 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727401AbgCYUKs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Mar 2020 16:10:48 -0400
Received: from venice.bhome ([94.37.173.46])
        by smtp-16.iol.local with ESMTPA
        id HCMOjh5MEjfNYHCMQjKIfm; Wed, 25 Mar 2020 21:10:46 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1585167046; bh=vu66BpH1Lo3ylvI4taVXtDBD7KH57ipaKWWkymNMjvQ=;
        h=From;
        b=kjHlstE6OKk3bSANp0A/K11jbDiDddjJSDUaiBiz1q6ZLyxc7jQdabcYEDbl5+1Yq
         Y64ba5lpYa1icrfsRI9Mk909QCzb/rFnA6uj0ru9WQ8pIIv095mZdJORZboEEV0zoA
         61kIemi6wY2o9D4j3TnNECn6GJmAJfWaX2kh7NGZTQs5YEERAlRMZ/BSElN33hboT2
         DSxQUpiYGn/Yfh/XpA25CjnYHimef3VduqnUzsbST8YWPZ3yTaW+8aqO61xidW/6bN
         lRSlzHVJ1bM9KAgBPk4LrR1BDePsx8N1UKhxYOsjNU9qBoy6Hv4hyDuFkarb58DWlo
         KcI3WDSRfhRAw==
X-CNFS-Analysis: v=2.3 cv=av7M9hRV c=1 sm=1 tr=0
 a=TpQr5eyM7/bznjVQAbUtjA==:117 a=TpQr5eyM7/bznjVQAbUtjA==:17
 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=UgUa7-a2uSEx3604ThYA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     linux-btrfs@vger.kernel.org
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/4] btrfs-progs: Add mixed profiles check to 'btrfs fi us'
Date:   Wed, 25 Mar 2020 21:10:42 +0100
Message-Id: <20200325201042.190332-5-kreijack@libero.it>
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

Add a check in 'btrfs fi us' command to detect if a filesystem has
mixed profiles for data/metadata/system. In this case
a warning is showed.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds/filesystem-usage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds/filesystem-usage.c b/cmds/filesystem-usage.c
index aa7065d5..b867dc15 100644
--- a/cmds/filesystem-usage.c
+++ b/cmds/filesystem-usage.c
@@ -1030,6 +1030,8 @@ static int cmd_filesystem_usage(const struct cmd_struct *cmd,
 		if (more_than_one)
 			printf("\n");
 
+		btrfs_check_for_mixed_profiles_by_fd(fd);
+
 		ret = load_chunk_and_device_info(fd, &chunkinfo, &chunkcount,
 				&devinfo, &devcount);
 		if (ret)
-- 
2.26.0.rc2

