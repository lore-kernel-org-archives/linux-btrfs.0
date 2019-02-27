Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51818C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B58E21852
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbfB0GGq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 01:06:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:34136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729824AbfB0GGp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 01:06:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9218AC9A;
        Wed, 27 Feb 2019 06:06:44 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v1.1 13/14] btrfs-progs: fsck-test: enable lowmem repair for case 001
Date:   Wed, 27 Feb 2019 14:05:51 +0800
Message-Id: <20190227060552.3841-14-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190227060552.3841-1-wqu@suse.com>
References: <20190227060552.3841-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

Lowmem can repair after commit
       'btrfs-progs: lowmem: move nbytes check before isize check',
so add the beacon file.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem_repairable | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem_repairable

diff --git a/tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem_repairable b/tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem_repairable
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.21.0

