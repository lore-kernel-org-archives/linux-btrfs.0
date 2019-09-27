Return-Path: <SRS0=fwPi=XW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B465C4360C
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 Sep 2019 10:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DAB3207E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 Sep 2019 10:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfI0KXX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 06:23:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:33024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726033AbfI0KXX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Sep 2019 06:23:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 21C62AFD0;
        Fri, 27 Sep 2019 10:23:22 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 0/3] btrfs llseek improvement, take 2
Date:   Fri, 27 Sep 2019 13:23:15 +0300
Message-Id: <20190927102318.12830-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is v2 of the llseek improvements, main changes are: 

 * Patch 1 - changed the locking scheme. I'm now using inode_lock_shared since 
 holding the extent lock is not sufficient to prevent concurrent truncates. 

 * Fixed lingo bugs in patch 2 changelog (Johaness)

Nikolay Borisov (3):
  btrfs: Speed up btrfs_file_llseek
  btrfs: Simplify btrfs_file_llseek
  btrfs: Return offset from find_desired_extent

 fs/btrfs/file.c | 62 ++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 34 deletions(-)

-- 
2.17.1

