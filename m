Return-Path: <SRS0=fwWV=VW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27005C7618B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 08:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5DB721871
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 08:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389627AbfGYI1c (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Jul 2019 04:27:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:58896 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389189AbfGYI1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jul 2019 04:27:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9A94AF40
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2019 08:27:30 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Misc locking fixes
Date:   Thu, 25 Jul 2019 11:27:27 +0300
Message-Id: <20190725082729.14109-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here are two patches cleaning up unused functions and fixing a newly introduced
deadlock due to memory barriers. Especially the memory barrier one needs to be 
sent merged ASAP. 

Nikolay Borisov (2):
  btrfs: Remove unused locking functions
  btrfs: Fix deadlock caused by missing memory barrier

 fs/btrfs/locking.c           | 45 +++++-------------------------------
 fs/btrfs/locking.h           |  2 --
 include/trace/events/btrfs.h |  2 --
 3 files changed, 6 insertions(+), 43 deletions(-)

-- 
2.17.1

