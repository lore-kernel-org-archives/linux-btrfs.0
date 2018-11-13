Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C868C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EE7C22419
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:09:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EE7C22419
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbeKMQFx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 11:05:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:48540 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726535AbeKMQFx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 11:05:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26ED0B0AD
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 06:09:20 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: gitignore: Ignore compressed man pages
Date:   Tue, 13 Nov 2018 14:09:14 +0800
Message-Id: <20181113060914.27663-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181113060914.27663-1-wqu@suse.com>
References: <20181113060914.27663-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just to Make "git status" more clean.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 82620f3cf603..ae4dce545a7b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -67,6 +67,7 @@
 
 /Documentation/Makefile
 /Documentation/*.html
+/Documentation/*.gz
 /Documentation/btrfs-balance.8
 /Documentation/btrfs-check.8
 /Documentation/btrfs-convert.8
-- 
2.19.1

