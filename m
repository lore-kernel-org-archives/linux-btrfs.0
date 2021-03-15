Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4A2C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Mar 2021 05:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C5D64E1F
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Mar 2021 05:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhCOFjp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 01:39:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:42522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230046AbhCOFjV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Mar 2021 01:39:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615786761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=qlyiAoqmx4SfEkoYjNi8iAQwbg1RGbLLZQsCx8u+A1s=;
        b=iB5hgtJkC9oc2temsBBjT6ljqfakwntZhaFX6CHbRv3DxJnQiGbPWqpvDOZ2YNwynPy8Hc
        RECkGObp7ZVEFipulRelfJSvJZuIL55ZsZsLXBx9VFOoKrlWjusUV5eDIqP7kZfrAJamph
        3oGujtIEE0Ro5nuD7tSSt2BE5EO2CnE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E0FA5AC1F
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Mar 2021 05:39:20 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fixes for subpage which also affect read-only mount
Date:   Mon, 15 Mar 2021 13:39:13 +0800
Message-Id: <20210315053915.62420-1-wqu@suse.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

During the fstests run for btrfs subpage read-write support, generic/475
crashes the system with a very high chance.

It turns out the cause is also affecting btrfs subpage read-only mount
so it's worthy a quick fix.

Also the crash call site shows a new rabbit hole of hard coded
PAGE_SHIFT in readahead.
This reada problem does not only greatly slow down my test on my ARM
board, but also affects read-only mount.

So this patchset is here to address the problems, and hope these fixes
can fit into current merge window.

Qu Wenruo (2):
  btrfs: fix wild pointer access during metadata read failure for
    subpage
  btrfs: make reada to be subpage compatible

 fs/btrfs/extent_io.c | 31 ++++++++++++++++++++++++++++++-
 fs/btrfs/reada.c     | 35 ++++++++++++++++++-----------------
 2 files changed, 48 insertions(+), 18 deletions(-)

-- 
2.30.1

