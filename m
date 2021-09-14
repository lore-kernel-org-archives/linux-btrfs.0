Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB399C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Sep 2021 09:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6136112E
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Sep 2021 09:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhINJHU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Sep 2021 05:07:20 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60608 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhINJHR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Sep 2021 05:07:17 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2D33E21FC6;
        Tue, 14 Sep 2021 09:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631610360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=o6lZLwqHZtexiB2Tz2DDzq75S7W2pMW+z0UScEks9Gc=;
        b=H8p3xQbJ6t8RcE8t8TcpNQz45xXBBFlWFZuaQChV1Tn09N4yM3nan2xQEu+LBskuaXA6Gn
        gQWfibtRdJ6Dt0o6mgJHpdihUNcmWrCKlMvpSZmDGFr5zKo3xGRxrUKgcmZVtF+37O1IQC
        h9PkRA1jGAQfC+++w/87mEI8mn8ykQc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0DF113D3F;
        Tue, 14 Sep 2021 09:05:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 219NOPdlQGH5NwAAMHmgww
        (envelope-from <nborisov@suse.com>); Tue, 14 Sep 2021 09:05:59 +0000
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 0/8] Implement progs support for removing received uuid on RW vols
Date:   Tue, 14 Sep 2021 12:05:50 +0300
Message-Id: <20210914090558.79411-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here's V2 which takes into account Qu's suggestions, namely:

- Add a helper which contains the common code to clear receive-related data
- Now there is a single patch which impements the check/clear for both orig and
lowmem modes
- Added Reviewed-by from Qu.


Nikolay Borisov (8):
  btrfs-progs: Add btrfs_is_empty_uuid
  btrfs-progs: Remove root argument from btrfs_fixup_low_keys
  btrfs-progs: Remove fs_info argument from leaf_data_end
  btrfs-progs: Remove root argument from btrfs_truncate_item
  btrfs-progs: Add btrfs_uuid_tree_remove
  btrfs-progs: Implement helper to remove received information of RW
    subvol
  btrfs-progs: check: Implement removing received data for RW subvols
  btrfs-progs: tests: Add test for received information removal

 check/main.c                                  |  21 +++-
 check/mode-common.c                           |  40 ++++++++
 check/mode-common.h                           |   1 +
 check/mode-lowmem.c                           |  11 ++-
 kernel-shared/ctree.c                         |  62 +++++-------
 kernel-shared/ctree.h                         |  12 ++-
 kernel-shared/dir-item.c                      |   2 +-
 kernel-shared/extent-tree.c                   |   2 +-
 kernel-shared/file-item.c                     |   4 +-
 kernel-shared/inode-item.c                    |   4 +-
 kernel-shared/uuid-tree.c                     |  93 ++++++++++++++++++
 .../050-subvol-recv-clear/test.raw.xz         | Bin 0 -> 493524 bytes
 12 files changed, 202 insertions(+), 50 deletions(-)
 create mode 100644 tests/fsck-tests/050-subvol-recv-clear/test.raw.xz

--
2.17.1

