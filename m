Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC260C4338F
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Aug 2021 07:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A53D76125F
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Aug 2021 07:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhHVHCr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 03:02:47 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54386 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhHVHCp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Aug 2021 03:02:45 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C67411FEDC
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Aug 2021 07:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629615723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+Sh04HABAnnjrWMF1Dldgis7Lvu2RCUp7mxGEp70YdU=;
        b=AxvNg3BcVB/MT572+J1P/OX4MFd5wqJRk7JtAPanprkg23GB8Jm6IwCUzYMPFOt/of1e3Z
        X3OlDWGw5ZB9Ekb0K7W7u5ZCsO7Vvgtw9RsBtD7+LlzxNVPhWdM98ILrcqA7TUnXeUoN3W
        nxKcL0zzXZKl6EcJ5d8qUrzaP3/raXQ=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 06C2213C43
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Aug 2021 07:02:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 2llMLmr2IWHLBwAAGKfGzw
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Aug 2021 07:02:02 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 0/4] btrfs: qgroup: rescan enhancement related to INCONSISTENT flag
Date:   Sun, 22 Aug 2021 15:01:56 +0800
Message-Id: <20210822070200.36953-1-wqu@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is a long existing window that if we did some operations marking
qgroup INCONSISTENT during a qgroup rescan, the INCONSISTENT bit will be
cleared by rescan, leaving incorrect qgroup numbers unnoticed.

Furthermore, when we mark qgroup INCONSISTENT, we can in theory skip all
qgroup accountings.
Since the numbers are already crazy, we don't really need to waste time
updating something that's already wrong.

So here we introduce two runtime flags:

- BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN
  To inform any running rescan to exit immediately and don't clear
  the INCONSISTENT bit on its exit.

- BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING
  To inform qgroup code not to do any accounting for dirty extents.

  But still allow operations on qgroup relationship to be continued.

Both flags will be set when an operation marks the qgroup INCONSISTENT
and only get cleared when a new rescan is started.


With those flags, we can have the following enhancement:

- Prevent qgroup rescan to clear inconsistent flag which should be kept
  If an operation marks qgroup inconsistent when a rescan is running,
  qgroup rescan will clear the inconsistent flag while the qgroup
  numbers are already wrong.

- Skip qgroup accountings while qgroup numbers are already inconsistent

- Skip huge subtree accounting when dropping subvolumes
  With the obvious cost of marking qgroup inconsistent


Reason for RFC:
- If the runtime qgroup flags are acceptable

- If the behavior of marking qgroup inconsistent when dropping large
  subvolumes

- If the lifespan of runtime qgroup flags are acceptable
  They have longer than needed lifespan (from inconsistent time point to
  next rescan), not sure if it's OK.

Qu Wenruo (4):
  btrfs: introduce BTRFS_QGROUP_STATUS_FLAGS_MASK for later expansion
  btrfs: introduce BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN
  btrfs: introduce BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING to skip
    qgroup accounting
  btrfs: skip subtree scan if it's too high to avoid low stall in
    btrfs_commit_transaction()

 fs/btrfs/qgroup.c               | 82 ++++++++++++++++++++++++---------
 fs/btrfs/qgroup.h               |  3 ++
 include/uapi/linux/btrfs_tree.h |  4 ++
 3 files changed, 67 insertions(+), 22 deletions(-)

-- 
2.32.0

