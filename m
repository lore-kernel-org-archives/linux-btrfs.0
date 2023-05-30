Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100ADC7EE29
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 May 2023 01:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjE3BSa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 May 2023 21:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjE3BS2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2023 21:18:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24920B0
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2023 18:18:25 -0700 (PDT)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9B7F41FDD3
        for <linux-btrfs@vger.kernel.org>; Tue, 30 May 2023 01:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685409503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=IlVlvBX5L4URReevTUtIYiVZdKL+1B85k/ZMAaee9iM=;
        b=eRW9IVNR0lCrv4XhfvrLIQ3XdhK8Gz+37L8ZR5x2FWzTz/D8s8NYBBA9ripLdTlx+SaYj4
        1HT5FEsC5JyfR/Pum8StO5i4xcq5iDIzdE5CZ7zH3LS63fITkF42+wZ52lgH+hXF1eUmAK
        KawUSKuxEVVcdTOjX1pfYYIvIzjjZTE=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0F6E71341B
        for <linux-btrfs@vger.kernel.org>; Tue, 30 May 2023 01:18:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id kDAgNN5OdWRIIQAAGKfGzw
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 May 2023 01:18:22 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: small cleanups mostly for subpage cases
Date:   Tue, 30 May 2023 09:18:02 +0800
Message-Id: <cover.1685408905.git.wqu@suse.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

During my hunt on the subpage uptodate desync bugs reported from Matt, I
exposed several PageUptodate usage which results inefficiency for
subpage cases.

Those two are fixed in the first two patches.

Furthermore I found processed_extent infrastructure is no longer needed
especially after all the csum verification is moved to storage layer (or
bio.c inside btrfs), we can easily unlock the full range without the
need for the infrastructure.

Thus the last patch would delete the processed_extent infrastructure
completely.

Qu Wenruo (3):
  btrfs: make alloc_extent_buffer() handle previously uptodate range
    more efficient for subpage
  btrfs: use the same @uptodate variable for end_bio_extent_readpage()
  btrfs: remove processed_extent infrastructure

 fs/btrfs/extent_io.c | 89 +++++---------------------------------------
 1 file changed, 10 insertions(+), 79 deletions(-)

-- 
2.40.1

