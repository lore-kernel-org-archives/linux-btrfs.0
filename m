Return-Path: <SRS0=Q7pU=SY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1486C282E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 07:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2E020857
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 07:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfDVHq4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Apr 2019 03:46:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:39682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726475AbfDVHq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Apr 2019 03:46:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34D32ACD1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2019 07:46:55 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Factor out common ordered extent flushing code
Date:   Mon, 22 Apr 2019 10:46:50 +0300
Message-Id: <20190422074653.13075-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are a couple of places in the code which need to ensure that a particular 
range is locked and doesn't have pending ordered extents. Currently this logic is
open-coded in said places. This patchset refactors the code such that we now 
have btrfs_lock_and_flush_ordered_range which encompasses this logic. 

Patch 1 introduces a new function which contains the duplicated logic. 

Patch 2 replaces occurences of given code pattern in callers 

Patch 3 Introduces a micro-op so that unlocks in the function can happen without
looking up in the ordered tree. This change is careful to not leak extra 
extent_state references. 

Patches have undergone multiple successful xfstest runs. 


Nikolay Borisov (3):
  btrfs: Implement btrfs_lock_and_flush_ordered_range
  btrfs: Use newly introduced btrfs_lock_and_flush_ordered_range
  btrfs: Always use a cached extent_state in
    btrfs_lock_and_flush_ordered_range

 fs/btrfs/extent_io.c    | 27 +++----------------------
 fs/btrfs/file.c         | 14 ++-----------
 fs/btrfs/inode.c        | 17 ++--------------
 fs/btrfs/ordered-data.c | 44 +++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ordered-data.h |  3 +++
 5 files changed, 54 insertions(+), 51 deletions(-)

-- 
2.17.1

