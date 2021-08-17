Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77BAC4338F
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Aug 2021 09:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A36DE6044F
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Aug 2021 09:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhHQJje (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:39:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50232 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbhHQJj3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Aug 2021 05:39:29 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id ED8EB2000E
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Aug 2021 09:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629193135; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=wI1NaN0yir/qS7MDwm/FlJbl8/f+roQhd2tgWJ0muvE=;
        b=qLpwCkN0KGEJ9+PG1xM6eQi+f6rVg8KX5Lp9X++QCpxnKTFlCLb9VbW75aNDmnMTAgdpfm
        NkEbd3KFs5UI3VIVQ2ldvc7NenUkWbOxlDaantcMjGDhpxai8QNL0nDXCR+NGGosoa3GFR
        z1NG4UoUTKiJE7ePVsqFLxFelTH8qTs=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2DF05132AB
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Aug 2021 09:38:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id uKdFN66DG2FcCwAAGKfGzw
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Aug 2021 09:38:54 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: subpage: pack all subpage bitmaps into a larger bitmap
Date:   Tue, 17 Aug 2021 17:38:48 +0800
Message-Id: <20210817093852.48126-1-wqu@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently we use u16 bitmap to make 4k sectorsize work for 64K page
size.

But this u16 bitmap is not large enough to contain larger page size like
128K, nor is space efficient for 16K page size.

To handle both cases, here we pack all subpage bitmaps into a larger
bitmap, now btrfs_subpage::bitmaps[] will be the ultimate bitmap for
subpage usage.

This is the first step towards more page size support.

Although to really enable extra page size like 16K and 128K, we need to
rework the metadata alignment check.
Which will happen in another patchset.

Changelog:
v2:
- Add two refactor patches to make btrfs_alloc_subpage() more readable
- Fix a break inside two loops bug
- Rename subpage_info::*_start to subpage_info::*_offset
- Add extra comment on what each subpage_info::*_offset works


Qu Wenruo (4):
  btrfs: only call btrfs_alloc_subpage() when sectorsize is smaller than
    PAGE_SIZE
  btrfs: make btrfs_alloc_subpage() to return struct btrfs_subpage *
    directly
  btrfs: introduce btrfs_subpage_bitmap_info
  btrfs: subpage: pack all subpage bitmaps into a larger bitmap

 fs/btrfs/ctree.h     |   1 +
 fs/btrfs/disk-io.c   |  12 ++-
 fs/btrfs/extent_io.c |  76 +++++++++-------
 fs/btrfs/subpage.c   | 205 ++++++++++++++++++++++++++++++-------------
 fs/btrfs/subpage.h   |  54 ++++++++----
 5 files changed, 238 insertions(+), 110 deletions(-)

-- 
2.32.0

