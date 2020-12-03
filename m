Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672C3C64E7B
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Dec 2020 08:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1183F20BED
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Dec 2020 08:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgLCISa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:18:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:35078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgLCIS3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Dec 2020 03:18:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1606983463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YsnELQpV8jGSY6Mjm4MWkw9DLmXAMjK90RP/Rb8bIFQ=;
        b=UvPo9N05pkHFEHzuaMjji/2XK0PhXauaHE5MswbBhPfqMPVnOYt4oy19aaUoxZM4bA0NAR
        aMNT5zqns9PvrcKcDv8wuH7RRAmzVrb8Ju4TR819WkBrWTQw0P/lHWojoDunetarTFLsi7
        rIGBiq6xilnbvHpI8nEuXDTUNQCghk8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B2A33AE46;
        Thu,  3 Dec 2020 08:17:43 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Support removal of ino cache leftover by btrfs check
Date:   Thu,  3 Dec 2020 10:17:40 +0200
Message-Id: <20201203081742.3759528-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Following the removal of ino cache support in the kernel, let's add support
for 'btrfs check --clear-ino-cache'. 2nd patch also adds a test to ensure we
don't regress this functionality in the future.

Nikolay Borisov (2):
  btrfs-progi: check: Add support for ino cache deletion
  btrfs-progs: tests: Test operation of newly added --clear-ino-cache

 Documentation/btrfs-check.asciidoc            |   3 +
 check/main.c                                  | 162 +++++++++++++++++-
 .../ino-cache-enabled.raw.xz                  | Bin 0 -> 160420 bytes
 tests/misc-tests/042-ino-cache-clean/test.sh  |  51 ++++++
 4 files changed, 215 insertions(+), 1 deletion(-)
 create mode 100644 tests/misc-tests/042-ino-cache-clean/ino-cache-enabled.raw.xz
 create mode 100755 tests/misc-tests/042-ino-cache-clean/test.sh

--
2.17.1

