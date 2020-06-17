Return-Path: <SRS0=y2QO=76=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECBAC433E1
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 09:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB0B72082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 09:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgFQJR0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 05:17:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:49518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgFQJRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jun 2020 05:17:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9923EAE0E;
        Wed, 17 Jun 2020 09:17:25 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Refactor prealloc_file_extent_cluster
Date:   Wed, 17 Jun 2020 12:10:41 +0300
Message-Id: <20200617091044.27846-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Those 3 minor patches refactor prealloc_file_extent_cluster by:

1. Removing useless check
2. Re-order code around to make heavyweight operations outside of inode lock,
(not that it matters for performance) and also get rid of the out label
3. Switch a while to a for loop to make the loop intentino more explicit.


Nikolay Borisov (3):
  btrfs: Remove hole  check in prealloc_file_extent_cluster
  btrfs: Perform data management operations outside of inode lock
  btrfs: Use for loop in prealloc_file_extent_cluster

 fs/btrfs/relocation.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--
2.17.1

