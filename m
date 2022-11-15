Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FECC433FE
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Nov 2022 18:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbiKOSBf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 13:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238244AbiKOSBH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2022 13:01:07 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DCE1EAE5
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2022 10:00:39 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 009BA33688
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2022 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668535238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=tYhbJPqxgATr+a9X6mj3raA6uYa8UhskZW+9aWHPt7E=;
        b=kZwO9/LOTKVHo+/XPVEOocmVVwpiZGhdnhc/BLC7B4MkF1ZZ/01eGDgHCctqLtzvKGS0YZ
        qJF5709RxPXcb1Exhn923Wz4Y2+waRazD1OCpH/ZAxKJLqUKNCAHHxCVHm7QGSSfNzdJNd
        xk1HysHdGnSrUOeCKdaQ/tbx7Btsrfo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668535238;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=tYhbJPqxgATr+a9X6mj3raA6uYa8UhskZW+9aWHPt7E=;
        b=g+Qx0fxXO49NgwMQmCBRkRRgVPplcxZUrzxNZ1QByBVJzbPot2QbbLNFP9WhoDdpS0Pg4f
        LF6Z6AxfIV0w6dDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ACA7013A91
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2022 18:00:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5PMlIsXTc2OBZAAAMHmgww
        (envelope-from <rgoldwyn@suse.de>)
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2022 18:00:37 +0000
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 00/16] Lock extents before pages
Date:   Tue, 15 Nov 2022 12:00:18 -0600
Message-Id: <20221115180034.8206-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The main idea is that instead of handling extent locks per page, lock
the extents before handling the pages. This will help in calling iomap
functions from within extent locks, so all page/folio handling is
performed by iomap code.

I want to know if there is any sequence which should be locked but isn't,
or vice versa.

It survived xfstests/btrfs tests for a single device.

Goldwyn Rodrigues (16):
  btrfs: check for range correctness while locking or setting extent
    bits
  btrfs: qgroup flush responsibility of the caller
  btrfs: wait ordered range before locking during truncate
  btrfs: lock extents while truncating
  btrfs: No need to lock extent while performing invalidate_folio()
  btrfs: Lock extents before pages in writepages
  btrfs: Lock extents before folio for read()s
  btrfs: Lock extents before pages for buffered write()
  btrfs: lock/unlock extents while creation/end of async_chunk
  btrfs: decide early if range should be async
  btrfs: lock extents before pages - defrag
  btrfs: Perform memory faults under locked extent
  btrfs: writepage fixup lock rearrangement
  btrfs: lock extent before pages for encoded read ioctls
  btrfs: lock extent before pages in encoded write
  btrfs: btree_writepages lock extents before pages

 fs/btrfs/block-group.c    |   2 +-
 fs/btrfs/compression.c    |   9 +-
 fs/btrfs/defrag.c         |  48 ++-----
 fs/btrfs/delalloc-space.c |  17 +--
 fs/btrfs/delalloc-space.h |   5 +-
 fs/btrfs/disk-io.c        |  28 +++-
 fs/btrfs/extent-io-tree.c |   6 +
 fs/btrfs/extent_io.c      |  73 +----------
 fs/btrfs/extent_io.h      |   2 -
 fs/btrfs/file.c           | 136 ++++++++++----------
 fs/btrfs/inode.c          | 264 ++++++++++++++++++++------------------
 fs/btrfs/ordered-data.c   |   3 +
 fs/btrfs/qgroup.c         |  27 +---
 fs/btrfs/qgroup.h         |  16 +--
 fs/btrfs/relocation.c     |   3 +-
 fs/btrfs/root-tree.c      |   3 +-
 16 files changed, 277 insertions(+), 365 deletions(-)

