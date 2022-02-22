Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6908AC433FE
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Feb 2022 12:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiBVMKJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 07:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiBVMKI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Feb 2022 07:10:08 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8728D158EA7
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Feb 2022 04:09:43 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E9D1B1F399
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Feb 2022 12:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645531781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OuFjOB+zt89DCiSSGFEgiKIwlDSk9m0SNzuIn6R/xnc=;
        b=RFX64QlxOI/j2F2fdsg0CAVWsOnh5iz3cRwRVdaeV3sPimkPs1qTAjGl9aw+TA03x+AKzu
        plwV3Bj8cZE7UEvSts58/9+kkxeJ6gzL3c0wskqmmGwcHA81PZgKGH8e3TZfprda+LORlx
        V31kHy346IF+fGFU3RgVE/wI2OS8LFc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3EE7113BA0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Feb 2022 12:09:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5vjrAYXSFGILNAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Feb 2022 12:09:41 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: scrub: big renaming to address the page and sector difference
Date:   Tue, 22 Feb 2022 20:09:35 +0800
Message-Id: <cover.1645530899.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From the ancient day, btrfs doesn't support sectorsize < PAGE_SIZE, thus
a lot of the old code consider one page == one sector, not only the
behavior, but also the naming.

This is no longer true after v5.16 since we have subpage support.

One of the worst location is scrub, we have tons of things named like
scrub_page, scrub_block::pagev, scrub_bio::pagev.

Even scrub for subpage is supported, the naming is not touched yet.

This patchset will first do the rename, providing the basis for later
scrub enhancement for subpage.

This patchset should not bring any behavior change.

Qu Wenruo (3):
  btrfs: scrub: rename members related to scrub_block::pagev
  btrfs: scrub: rename scrub_page to scrub_sector
  btrfs: scrub: rename scrub_bio::pagev and related members

 fs/btrfs/scrub.c | 678 +++++++++++++++++++++++------------------------
 1 file changed, 339 insertions(+), 339 deletions(-)

-- 
2.35.1

