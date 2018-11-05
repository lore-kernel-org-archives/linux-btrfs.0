Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B156C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 19:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC5A20862
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 19:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GHY53zCT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBC5A20862
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387709AbeKFE1w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 23:27:52 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35528 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387460AbeKFE1w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 23:27:52 -0500
Received: by mail-pf1-f195.google.com with SMTP id v9-v6so2573984pff.2
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2018 11:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Vhx7eYMScFPejpPB1vXQviRFU8zBlgYRSxKYKY86920=;
        b=GHY53zCTKv9Y60VtwI/J5PrTgAZTNA75puCRI7mqU0aGqfhLzQLKAxu6xlsHofo6dz
         +eM2ybdwQNJV6o0OKtYZf16j2XOzyGt4VEMwymrmszgNPe1uDQJKQI9qfN8NIfXH2qj5
         GC6FObaItXzF2Hhb33a/MU7gDg9q/GViJxTQSB8nQNeN1GC3R/ApHpb4tFohZwElxvEB
         pf+eH+RKdTvzEVCb2yHJl8VQ9pzn4gniZqU1GXPd/Fz/j0fTULAb/F6NuigEVwzf4y8G
         ATvw0hizBDaQzI2//oux2mXaG3qbWRBsSLDn8ztunYEsEGT0DhKur0oDqNhOYQh29Uoe
         r/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vhx7eYMScFPejpPB1vXQviRFU8zBlgYRSxKYKY86920=;
        b=kfHB9z3k+t/iGjynnMCJZrvPSxejyAw/ZyZXQ5a/RgXce/28+6sOvqBEp0QsGayuKj
         mlsSqIcerW+vvpR977AWUjhgRRuocSyHcFCyS39BJDoLyY7FBecE2DZNHI45NAJizlI9
         ezmbqSd09W1oXNwsnppxBEd6mz2XQpirt6OC7qBqf2utfBpvFFmrRqA8uWQ+XOCxcKOI
         e1+VSDR3I+zq0lmaSfpfpN7LU+Zbxu79DPJHzbZ58XWadB4qQWPASLZ8Jdnwfx41ES3E
         6JfDdVQN+hrgZKyxFyObA/deWaJTw6ASW4NAf6q0kNyNISNuLA2X7kdkz3bfXL0D0xNi
         UOLw==
X-Gm-Message-State: AGRZ1gK2PhjItDjtBxYBjaxDL/t813XTqe5vRRe0uqVLZ9YFDAEnBeUa
        hw1HkqIU1p29BZOaDiYqxVtHAWec
X-Google-Smtp-Source: AJdET5fmOMo57/v/Bmd49BRYN37ekpBM3CfhyywpHo09QFKkOAEHYvQ+CjsaEjSrIfY1pz1x2snY5A==
X-Received: by 2002:a65:664e:: with SMTP id z14-v6mr20402623pgv.347.1541444807634;
        Mon, 05 Nov 2018 11:06:47 -0800 (PST)
Received: from desktop.lan (astound-69-42-16-32.ca.astound.net. [69.42.16.32])
        by smtp.gmail.com with ESMTPSA id l129-v6sm55872516pfc.155.2018.11.05.11.06.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 11:06:47 -0800 (PST)
From:   Rosen Penev <rosenp@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] task-utils: Fix comparison between pointer and integer
Date:   Mon,  5 Nov 2018 11:06:42 -0800
Message-Id: <20181105190643.13578-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181105190643.13578-1-rosenp@gmail.com>
References: <20181105190643.13578-1-rosenp@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

pthread_t is a pointer type, not an integer one. The > 0 makes no sense
and throws a warning.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 task-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/task-utils.c b/task-utils.c
index a9bee8f..e4dcd36 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -67,7 +67,7 @@ void task_stop(struct task_info *info)
 	if (!info)
 		return;
 
-	if (info->id > 0) {
+	if (info->id) {
 		pthread_cancel(info->id);
 		pthread_join(info->id, NULL);
 		info->id = 0;
-- 
2.19.1

