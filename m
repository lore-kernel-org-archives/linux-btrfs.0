Return-Path: <SRS0=+hsm=T6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF09C28CC0
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 May 2019 16:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ECB025DA0
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 May 2019 16:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfE3QaF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 30 May 2019 12:30:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:60628 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726045AbfE3QaF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 May 2019 12:30:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18A53AFDB
        for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2019 16:30:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 18552DA85E; Thu, 30 May 2019 18:30:57 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Extent buffer lock cleanups
Date:   Thu, 30 May 2019 18:30:57 +0200
Message-Id: <cover.1559233731.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are 3 atomics that don't need to be, all related to writes where
the exclusivity is guaranteed by the lock.

David Sterba (3):
  btrfs: switch extent_buffer blocking_writers from atomic to int
  btrfs: switch extent_buffer spinning_writers from atomic to int
  btrfs: switch extent_buffer write_locks from atomic to int

 fs/btrfs/extent_io.c  |  6 ++---
 fs/btrfs/extent_io.h  |  6 ++---
 fs/btrfs/locking.c    | 62 +++++++++++++++++++------------------------
 fs/btrfs/print-tree.c |  6 ++---
 4 files changed, 37 insertions(+), 43 deletions(-)

-- 
2.21.0

