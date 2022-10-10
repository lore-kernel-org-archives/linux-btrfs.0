Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DD5C433F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Oct 2022 10:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiJJKgb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 06:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiJJKga (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2022 06:36:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE4B578AB
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2022 03:36:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6E1A021940
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2022 10:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1665398188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Gu2tmm+llW7+h59XUeXR13NLy6MHJqmOZO1FkXVVEEY=;
        b=RmR9m/KZL7FGWQAM7b/XfqCUZce9DuipU9vD+sTsK8jjlwcGX1TaJHUbhKiXJ5SA+oNvdm
        WzO+Q258Fo9Hmxqwjj3S0aVHjDbL/S+0k4MBrPTmnWw5h7Gb8SIGN/3IiCzAcUUcU5beoT
        3woQhIGhtU+G/QBmBb0J3FwmKAXBX5I=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD18713AF4
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2022 10:36:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yqx9HKv1Q2M9LgAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2022 10:36:27 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs: raid56: part 1, refactor/cleanup
Date:   Mon, 10 Oct 2022 18:36:05 +0800
Message-Id: <cover.1665397731.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is the cleanup/refactor part for the incoming RAID56 feature, which
will do data checksum verification during RMW cycle to address
destructive RMW.

The important parts of the cleanup are:

- Make pointer members of btrfs_raid_bio to be allocated separately
  This will make later expanding (csum_buf and csum_bitmap) easier.

- Make it explicit that all cached rbio should have all its data sectors
  uptodate
  This means, if we steal one rbio, all the data sectors should be
  uptodate.

Qu Wenruo (5):
  btrfs: raid56: properly handle the error when unable to find the
    missing stripe
  btrfs: raid56: avoid double freeing for rbio if full_stripe_write()
    failed
  btrfs: raid56: cleanup for function __free_raid_bio()
  btrfs: raid56: allocate memory separately for rbio pointers
  btrfs: raid56: make it more explicit that cache rbio should have all
    its data sectors uptodate

 fs/btrfs/raid56.c | 189 +++++++++++++++++++++++++++-------------------
 1 file changed, 113 insertions(+), 76 deletions(-)

-- 
2.37.3

