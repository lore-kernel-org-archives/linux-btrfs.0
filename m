Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7165CC4338F
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Aug 2021 06:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4802F60F5A
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Aug 2021 06:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhHBGzA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 02:55:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50006 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbhHBGzA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Aug 2021 02:55:00 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C8D4A21FC1
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Aug 2021 06:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627887290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=xsIyUDhOmHFGbVdUxKWn9cGbrl5GNlsK5dWXuASixGw=;
        b=K4brJ17IRr0H/OFJIWF2a2ohrpgS0Kgz9Tl4X9Jtg2VPtAwvJ9uaLVmY7vk/3yIOWxGY2k
        v0tn6NP06SW3dhZNv5B2UCi0d05Ad7bAkGZlUTwdeRNLyVfL5NuI04Ra+mYZbB5Na4A/+S
        KB8hDxJ/zzgnb70YA9KJa9gH7kU3DqM=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 04FB11371C
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Aug 2021 06:54:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 0c9hLrmWB2FtawAAGKfGzw
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Aug 2021 06:54:49 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix the generic/475 crash for subpage case
Date:   Mon,  2 Aug 2021 14:54:45 +0800
Message-Id: <20210802065447.178726-1-wqu@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Test case generic/475 expose random crash (1/20~1/5) trigged by the
BUG_ON() inside btrfs_csum_one_bio().

The direct cause is we're trying to submit a write bio, even after we hit
some error and already have ordered extent cleaned up.

The first patch will try to fix all those call sites, then the 2nd patch
will add an extra safe net to prevent such case to be escalated into a
crash.

Qu Wenruo (2):
  btrfs: don't try to flush data write bio if we hit error preparing it
  btrfs: replace BUG_ON() in btrfs_csum_one_bio() with proper error
    handling

 fs/btrfs/extent_io.c | 17 ++++++++++++-----
 fs/btrfs/file-item.c | 14 +++++++++++++-
 2 files changed, 25 insertions(+), 6 deletions(-)

-- 
2.32.0

