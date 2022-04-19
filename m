Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2776C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Apr 2022 11:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351010AbiDSLVe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 07:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351119AbiDSLVK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Apr 2022 07:21:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A6A220E3
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2022 04:18:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9381C21123
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2022 11:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650367083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BemPf9ybNFF7HNZv9qdNef3YCBTrr6gGypUdwFrggrI=;
        b=Bp2fN+moKS3QoeY3kur0bzijdRdnQNRoL35wcNh1uDlwPgZEj+GYa5P55jEchnHKhfAOQj
        vx1Po0ImTzE11hK2YgE+sNHGKN4W0bd9H6A6ivowsnDhMCqBxz+rFikXqly1cw/GKsPmcw
        y6Bft+VE/qFrI8rXWXCq75P7pLE7zYw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BFEC8139BE
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2022 11:18:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HK3JH2qaXmJLRwAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2022 11:18:02 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs-progs: bug fixes exposed during delayed chunk items insertion
Date:   Tue, 19 Apr 2022 19:17:40 +0800
Message-Id: <cover.1650366929.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[CHANGELOG]
v2:
- Update the first patch to delaye memory allocation after all other
  checks


There are two bugs in the existing code base of btrfs-progs:

- Memory leak due to wrong error handling in btrfs_start_transaction()

- Empty rw device list due to missing error handling in create_chunk()

Just fix them.

Qu Wenruo (2):
  btrfs-progs: fix a memory leak when starting a transaction on fs with
    error
  btrfs-progs: fix an error path which can lead to empty device list

 kernel-shared/transaction.c | 13 +++++++------
 kernel-shared/volumes.c     | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 6 deletions(-)

-- 
2.35.1

