Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE07DC433EF
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Mar 2022 09:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiC2Jqd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 05:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiC2Jqc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Mar 2022 05:46:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4769A146B7E
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2022 02:44:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DC9851FBB5
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2022 09:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648547087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=xyFSIO5luSUlnijWPMGHAFMm7FHXcUHT/Ov5ABgIvdw=;
        b=dcR53LJtz/RtA8REJf8ZiKXWQbm+EoM6rQNWotFfzNf2VnUBA15kGKVis60i5Qr4rR6kz1
        HWciFdeTDYpDnrBHyv9DJzR/XClIP/5BUUWAi6VupWPneohkqx0La368ud4mNNa7qBL2LG
        omOPMHTEd/cGORNpcbrVyplSPnmQk3k=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3867613A7E
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2022 09:44:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nG3XIQ7VQmKqUAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2022 09:44:46 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: check: avoid false alerts for --check-data-csum on RAID56
Date:   Tue, 29 Mar 2022 17:44:24 +0800
Message-Id: <cover.1648546873.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is a long existing bug that btrfs-progs doesn't really support
rebuilding its data using RAID56 P/Q.

This means any read with mirror_num > 1 for RAID56 won't work, and will
just return the P/Q raw data directly.

The RAID56 ability in btrfs-progs is only for data write.

This will cause tons of false alerts for "btrfs check
--check-data-csum", making it useless as an offline to verify RAID56
data.

The proper fix will need way more code modification (btrfs-fuse supports
that, so I believe it's possible).

But for now, let's just disable mirror_num > 1 read repair for progs.

Qu Wenruo (2):
  btrfs-progs: avoid checking wrong RAID5/6 P/Q data
  btrfs-progs: tests/fsck: add test case for data csum check on raid5

 kernel-shared/disk-io.c                       |  7 +++++
 kernel-shared/volumes.c                       | 10 +++---
 .../056-raid56-false-alerts/test.sh           | 31 +++++++++++++++++++
 3 files changed, 44 insertions(+), 4 deletions(-)
 create mode 100755 tests/fsck-tests/056-raid56-false-alerts/test.sh

-- 
2.35.1

