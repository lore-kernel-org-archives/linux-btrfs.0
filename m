Return-Path: <SRS0=Ghwh=BB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54AAC433E4
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jul 2020 08:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A06220717
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jul 2020 08:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgGVIJ1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 04:09:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:45702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbgGVIJ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Jul 2020 04:09:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D335BAFE8;
        Wed, 22 Jul 2020 08:09:33 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Misc cleanups around device addition
Date:   Wed, 22 Jul 2020 11:09:21 +0300
Message-Id: <20200722080925.6802-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here are 4 minor cleanups around btrfs_init_new_device. First one converts
a readonly usage of device_lists to using RCU. Second patch slightly simplifies
the logic around locking when seed device is used. Third one removes a leftover
from rewrite of btrfs_free_stale_devices. And the final one replaces an
opencoded filemap_write_and_wait on the bdev inode with the more consistent
sync_blockdev.

All these have passed xfstest and don't constitute functional changes.

Nikolay Borisov (4):
  btrfs: Use rcu when iterating devices in btrfs_init_new_device
  btrfs: Refactor locked condition in btrfs_init_new_device
  btrfs: Remove redundant code from btrfs_free_stale_devices
  btrfs: Don't opencode sync_blockdev

 fs/btrfs/volumes.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--
2.17.1

