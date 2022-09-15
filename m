Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0534EECAAD3
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Sep 2022 08:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiIOIYQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Sep 2022 04:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiIOIXr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2022 04:23:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A5F98A53
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2022 01:23:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5CCC6204EC
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2022 08:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663230191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Cpc7ebwHxVD7L2H9NmF/JASu76nzPYSsXWh0KLXfVk8=;
        b=n4xE2+lqYCLKGiDiPJnuf47lmsRIv2/KbWi3i2ylYijOb/ezr4eBlNQvrtMpkYJ1D1N8pM
        yyvtpUWgTuQ1CXhFMQnR/uzJE05FFWXAXqKOcfSS6KJ9iqm/0Q+yR9HaAgeBuBuLjp4t8f
        QhDQmIA865/ijFiCGAgicUe+Tjkb3y4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A3551139C8
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2022 08:23:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id a5EUGu7gImNaeQAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2022 08:23:10 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: btrfs_get_extent() cleanup
Date:   Thu, 15 Sep 2022 16:22:50 +0800
Message-Id: <cover.1663229903.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are some small but weird behavior in btrfs_get_extent() for inline
extent handling

- Resetting em members only for inline extent read

  If btrfs_get_extent() is called with @page (aka, for file read path),
  it will reset @em members even it's already updated by
  btrfs_extent_item_to_extent_map()

  The behavior itself is no longer needed as tree-checker has ensured
  inline extents are only valid if they have 0 file offset.

  Thus this means, in that path, @extent_offset must be 0, and a lot of
  calculations can be simplified and the em member reset is unnecessary.

- Unnecessarily complex handling for inline extent read

  The truth is, since inline extents can only exist at file offset 0, we
  don't need such complex calculation at all.

- Unnecessary argument for btrfs_extent_item_to_extent_map()

- Unnecessarily complex selftest for btrfs_get_extent()
  It has an inline extent at file offset 5, which is no longer valid.

The root cause is, the old code just assumes we can have inline extents
at non-zero file offset.

The patchset will replace those complex code, with just ASSERT()s, and
use much cleaner code to implement the same behavior, and also to update
the selftest to reflect the modern behavior.

Qu Wenruo (2):
  btrfs: refactor the inline extent read code inside btrfs_get_extent()
  btrfs: selftests: remove impossible inline extent at non-zero file
    offset

 fs/btrfs/ctree.h             |  1 -
 fs/btrfs/extent_map.c        |  7 +++
 fs/btrfs/file-item.c         |  6 +--
 fs/btrfs/inode.c             | 93 +++++++++++++++++++++---------------
 fs/btrfs/ioctl.c             |  2 +-
 fs/btrfs/tests/inode-tests.c | 56 +++++++---------------
 6 files changed, 82 insertions(+), 83 deletions(-)

-- 
2.37.3

