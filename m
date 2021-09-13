Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BF3C433F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Sep 2021 13:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 535C761875
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Sep 2021 13:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbhIMNfv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 09:35:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41310 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241157AbhIMNdp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Sep 2021 09:33:45 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EE2FA21D16;
        Mon, 13 Sep 2021 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631539948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=q8LS1QUypMog8TTaFm9oryZStJHz25XFKglrM5n0Wz4=;
        b=bWwvDGzyfT40TwEvG798VTj74YkbV+CrTreODSWqwvqnPYInYxhtCh2nQSAyfcWPXELVIm
        imbsaRxvlU8Hgezk6q5VbZdW6wd3ri5sGZZ14Bn22UjnCQpumN/iUQMnLT8WyA7ZScYrmA
        Jtxo7NHa9oHl4ro2okAlw3aIAwHvj8E=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A946913AB4;
        Mon, 13 Sep 2021 13:32:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +2t/JuxSP2G1RAAAMHmgww
        (envelope-from <nborisov@suse.com>); Mon, 13 Sep 2021 13:32:28 +0000
From:   Nikolay Borisov <nborisov@suse.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Make 233 be part of subvol group
Date:   Mon, 13 Sep 2021 16:32:26 +0300
Message-Id: <20210913133226.39007-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All but this test use 'subvol' to designate they relate to btrfs
subvolume functionality. For the sake of consistency make btrfs/233
also be part of 'subvol' rather than 'subvolume'. This brings no
functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/btrfs/233 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/233 b/tests/btrfs/233
index f3e3762c6951..6a4144433073 100755
--- a/tests/btrfs/233
+++ b/tests/btrfs/233
@@ -9,7 +9,7 @@
 # performed.
 #
 . ./common/preamble
-_begin_fstest auto quick subvolume
+_begin_fstest auto quick subvol
 
 # Override the default cleanup function.
 _cleanup()
-- 
2.17.1

