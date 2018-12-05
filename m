Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A87C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8DF32082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8DF32082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbeLEGkr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:49774 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727161AbeLEGkq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BEB02AEB4
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:45 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 12/13] btrfs-progs: Add utils.h include to solve missing-prototypes warning
Date:   Wed,  5 Dec 2018 14:40:17 +0800
Message-Id: <20181205064018.27755-13-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Prototypes for arg_strtou64() and lookup_path_rootid() are included in
utils.c, resulting make W=1 warning for them.

Just include that header to make W=1 happier.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 utils-lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils-lib.c b/utils-lib.c
index 044f93fc4446..5bb89f2f1a8d 100644
--- a/utils-lib.c
+++ b/utils-lib.c
@@ -1,4 +1,5 @@
 #include "kerncompat.h"
+#include "utils.h"
 #include <unistd.h>
 #include <stdlib.h>
 #include <limits.h>
-- 
2.19.2

