Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIMWL_WL_MED,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E96AC6786F
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F40120831
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="2CrmXRva"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F40120831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbeKCGi6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 02:38:58 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36029 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbeKCGi6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 02:38:58 -0400
Received: by mail-io1-f67.google.com with SMTP id o19-v6so2395315iod.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2018 14:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EQlijbwv+Tr3pUQAHsipW5yfTslWROfiw9T5rb7jgu0=;
        b=2CrmXRvaIi60DMI2J1g6sHeOhxeb7nAsaBjhmrPq1JdDFWNPdDFZFvW3GqWePCJq1L
         LYaJrGehYiw4NWwFN9OXd5Olat0rqgqJOqhanxoKX4VYQc7+zq2hk15ABO95erQwjqtb
         1dGSiDtktpSQwBdS0d2I4sTPtxg9N2oYMyVCu0g9TKvfvR4UPZUK/WkklOSScC4mpm12
         ioiGaTvI/EhG6rkHZXiVgE8wAjt7+JMGiMKkW92DVE7Pkv9QEVsUxIwTPjF/2txpi5Z1
         m9gkZye71mAimrKlZ0sQj0ubAQ+J08mcS1jKAOkY9S6bmIUr/QS//MfOmM3eAXVi+Hx5
         mFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EQlijbwv+Tr3pUQAHsipW5yfTslWROfiw9T5rb7jgu0=;
        b=BCoAkIuayl4MY83svvCBSFWYGDxsZsvSwrjSA5IpvZxG7ocZOBoXeOFYtQpLfVzwfL
         toq8hdJWo30K8JkTHc7bxIOd5Q4IWzri9tLtG7+HgPrTiwYXRtaPHPsMHrhBcR+NqeoZ
         7MBl44hF4JqyLIaagGHU7gv5N8+S078bzZqcQldUIjBgBiMpOieGc30iU9J9Gevyx3EY
         AqSMmJjKSLZhfjGNP06okL7e3xSBTAqBCFGsdUmCffjCKk3bngO3lIIbbTlopIgZRdGc
         iHyJx3BoCUpgiodRVxELOIKlMgEYELrC4ct5cbO0+UY0he5tW17340xpXB+3HkRTZ0mo
         m5uA==
X-Gm-Message-State: AGRZ1gJEeaEoDS80YhYVJxVPwz/BHvGF6JKmgSM1m3nVg5x19Kw/MKzw
        Z+b0P+S6RCPidx2QHYpcgk+0Kg==
X-Google-Smtp-Source: AJdET5edwha3rIfxJul9TnrVpVxmft3j4L5wiwshdotFlIyYE+VdISJMBThQ8iBOqOzDbikxz3c/WA==
X-Received: by 2002:a6b:1412:: with SMTP id 18-v6mr10433619iou.214.1541194210497;
        Fri, 02 Nov 2018 14:30:10 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::4:e24f])
        by smtp.gmail.com with ESMTPSA id n130-v6sm929419itb.36.2018.11.02.14.30.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 14:30:10 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/7] generic/{472,496,497}: fix $seeqres typo
Date:   Fri,  2 Nov 2018 14:29:36 -0700
Message-Id: <c9a9f45d901273f88c9ecb7bc4f64635d2ab9ba5.1541193856.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541193856.git.osandov@fb.com>
References: <cover.1541193856.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/generic/472 | 2 +-
 tests/generic/496 | 2 +-
 tests/generic/497 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/generic/472 b/tests/generic/472
index c74d6c70..04ed3e73 100755
--- a/tests/generic/472
+++ b/tests/generic/472
@@ -51,7 +51,7 @@ swapfile_cycle() {
 	$CHATTR_PROG +C $swapfile >> $seqres.full 2>&1
 	"$here/src/mkswap" $swapfile >> $seqres.full
 	"$here/src/swapon" $swapfile 2>&1 | _filter_scratch
-	swapoff $swapfile 2>> $seeqres.full
+	swapoff $swapfile 2>> $seqres.full
 	rm -f $swapfile
 }
 
diff --git a/tests/generic/496 b/tests/generic/496
index 1c9651ad..968b8012 100755
--- a/tests/generic/496
+++ b/tests/generic/496
@@ -53,7 +53,7 @@ swapfile_cycle() {
 	$CHATTR_PROG +C $swapfile >> $seqres.full 2>&1
 	"$here/src/mkswap" $swapfile >> $seqres.full
 	"$here/src/swapon" $swapfile 2>&1 | _filter_scratch
-	swapoff $swapfile 2>> $seeqres.full
+	swapoff $swapfile 2>> $seqres.full
 	rm -f $swapfile
 }
 
diff --git a/tests/generic/497 b/tests/generic/497
index 584af58a..3d5502ef 100755
--- a/tests/generic/497
+++ b/tests/generic/497
@@ -53,7 +53,7 @@ swapfile_cycle() {
 	$CHATTR_PROG +C $swapfile >> $seqres.full 2>&1
 	"$here/src/mkswap" $swapfile >> $seqres.full
 	"$here/src/swapon" $swapfile 2>&1 | _filter_scratch
-	swapoff $swapfile 2>> $seeqres.full
+	swapoff $swapfile 2>> $seqres.full
 	rm -f $swapfile
 }
 
-- 
2.19.1

