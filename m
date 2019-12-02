Return-Path: <SRS0=GUsV=ZY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898A3C43215
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Dec 2019 09:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69C0620833
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Dec 2019 09:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfLBJkU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 04:40:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:47434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbfLBJkU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Dec 2019 04:40:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EAE8FBB45;
        Mon,  2 Dec 2019 09:40:18 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Cleanups from pinned rework try
Date:   Mon,  2 Dec 2019 11:40:12 +0200
Message-Id: <20191202094015.19444-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here are 3 minor cleanups resulting from dwelling in pinned extents rework.
Those cleanup WARN_ONs and make it clear when btrfs_pin_reserved_extent is
called with active transaction. No functional changes in any of them.

Nikolay Borisov (3):
  btrfs: Remove WARN_ON in walk_log_tree
  btrfs: Remove redundant WARN_ON in walk_down_log_tree
  btrfs: Ensure btrfs_pin_reserved_extent is always called with valid
    transaction

 fs/btrfs/tree-log.c | 60 ++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 36 deletions(-)

--
2.17.1

