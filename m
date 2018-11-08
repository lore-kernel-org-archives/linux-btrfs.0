Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C00AC32789
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E06ED20825
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:18:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E06ED20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbeKHRwf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 12:52:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:35032 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726509AbeKHRwd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 12:52:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3E1BEAE02
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 08:18:12 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Cleanups following optional extent_io_ops callbacks removal
Date:   Thu,  8 Nov 2018 10:18:05 +0200
Message-Id: <20181108081808.16920-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here are 3 minor patches that further clean up writepage_delalloc. The first
one moves the extent locked check in the caller of writepage_delalloc since
this seems more natural. This paves the way for the second patch which removes
epd as an argument to writepage_delalloc. The final patch was suggested by 
Josef and removes an extent_state argument which has never been used. 

Nikolay Borisov (3):
  btrfs: Move epd::extent_locked check to writepage_delalloc's caller
  btrfs: Remove extent_page_data argument from writepage_delalloc
  btrfs: Remove unused extent_state argument from
    btrfs_writepage_endio_finish_ordered

 fs/btrfs/compression.c |  6 ++++--
 fs/btrfs/ctree.h       |  4 ++--
 fs/btrfs/extent_io.c   | 36 +++++++++++++++++-------------------
 fs/btrfs/inode.c       |  7 +++----
 4 files changed, 26 insertions(+), 27 deletions(-)

-- 
2.17.1

