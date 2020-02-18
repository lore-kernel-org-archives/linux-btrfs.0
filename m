Return-Path: <SRS0=4mvY=4G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899E9C34026
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Feb 2020 14:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 695F121D56
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Feb 2020 14:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgBRO4M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 09:56:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:48200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgBRO4M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Feb 2020 09:56:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 33B77C12F;
        Tue, 18 Feb 2020 14:56:11 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Minor UUID cleanup
Date:   Tue, 18 Feb 2020 16:56:06 +0200
Message-Id: <20200218145609.13427-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is a short series that removes one indirect call in btrfs_uuid_tree_iterate
and making uuid rescan functions private to disk-io.c since they are used only
during mount. 

Nikolay Borisov (3):
  btrfs: Call btrfs_check_uuid_tree_entry directly in
    btrfs_uuid_tree_iterate
  btrfs: export btrfs_uuid_scan_kthread
  btrfs: Make btrfs_check_uuid_tree private to disk-io.c

 fs/btrfs/ctree.h     |  4 +--
 fs/btrfs/disk-io.c   | 35 +++++++++++++++++++
 fs/btrfs/uuid-tree.c | 50 ++++++++++++++++++++++++---
 fs/btrfs/volumes.c   | 82 +-------------------------------------------
 fs/btrfs/volumes.h   |  2 +-
 5 files changed, 84 insertions(+), 89 deletions(-)

-- 
2.17.1

