Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C027C433FE
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Mar 2022 08:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiCBIpS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Mar 2022 03:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239416AbiCBIpM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2022 03:45:12 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F06A42ECE
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Mar 2022 00:44:29 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3113F21991
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Mar 2022 08:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646210668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=toRTbjyYxRsi2ctPejkvB4fWxyXYeHSTHxj7Xk5eLfs=;
        b=L0HLbsj6F4/ZtgR+80kL96KbjaLfo9oF1gWgdJfpuRJh4anN6YkUfYWZoEkkk3DgQR7pq6
        ru3dlWntS3+4gGzCe9bvyLQpBft2KkrHLKB7QBYI1DLxPKjzi17idmSog+vK4oimkAE943
        d4mK/vAgeLNPgoaD1v9+FXzyVd7yIR4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E591613345
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Mar 2022 08:44:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xgxvKWouH2JHTAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Mar 2022 08:44:26 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs: scrub: make scrub uses less memory for metadata scrub
Date:   Wed,  2 Mar 2022 16:44:03 +0800
Message-Id: <cover.1646210051.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although btrfs scrub works for subpage from day one, it has a small
pitfall:

  Scrub will always allocate a full page for each sector.

This causes increased memory usage, although not a big deal, it's still
not ideal.

The patchset will change the behavior by integrating all pages into
scrub_block::pages[], instead of using scrub_sector::page.

Now scrub_sector will no longer hold a page pointer, but uses its
logical bytenr to caculate which page and page range it should use.

This behavior unfortunately still only affects memory usage on metadata
scrub, which uses nodesize for scrub.

For the best case, 64K node size with 64K page size, we waste no memory
to scrub one tree block.

For the worst case, 4K node size with 64K page size, we are no worse
than the existing behavior (still one 64K page for the tree block)

For the default case (16K nodesize), we use one 64K page, compared to
4x64K pages previously.

For data scrubing, we uses sector size, thus it causes no difference.
We need to do more work on data scrubing size to properly handle mutilpe
sectors for non-RAID56 profiles.

The patchset requires the rename patchset.
(https://lore.kernel.org/linux-btrfs/cover.1645530899.git.wqu@suse.com/)

If David is not happy with the big change again, at least first 3
patches can be considered as some cleanup.

Qu Wenruo (5):
  btrfs: scrub: use pointer array to replace @sblocks_for_recheck
  btrfs: extract the initialization of scrub_block into a helper
    function
  btrfs: extract the allocation and initialization of scrub_sector into
    a helper
  btrfs: scrub: introduce scrub_block::pages for more efficient memory
    usage for subpage
  btrfs: scrub: remove scrub_sector::page and use scrub_block::pages
    instead

 fs/btrfs/scrub.c | 399 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 270 insertions(+), 129 deletions(-)

-- 
2.35.1

