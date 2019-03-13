Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA65C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B191206BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfCMPpp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:45:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:60714 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfCMPpo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:45:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 962BFB117
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:45:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F37F4DA875; Wed, 13 Mar 2019 16:46:58 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/9] Extent buffer locking cleanups
Date:   Wed, 13 Mar 2019 16:46:58 +0100
Message-Id: <cover.1552489554.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The series moves several atomic counters under CONFIG_BTRFS_DEBUG. The
selected counters are not essential for the extent buffer locking to
work. There's some space saving (4x 4B at least) and the cachelines are
less stressed on non-debugging builds.

The final size is 264 from 280, getting to 256 would be nice but hard or
making the code unreadable. I have ideas to shave 7 more bytes but
that's for another patchset.

David Sterba (9):
  btrfs: add assertion helpers for spinning writers
  btrfs: use assertion helpers for spinning writers
  btrfs: add assertion helpers for spinning readers
  btrfs: use assertion helpers for spinning readers
  btrfs: add assertion helpers for extent buffer read lock counters
  btrfs: use assertion helpers for extent buffer read lock counters
  btrfs: add assertion helpers for extent buffer write lock counters
  btrfs: use assertion helpers for extent buffer write lock counters
  btrfs: switch extent_buffer::lock_nested to bool

 fs/btrfs/extent_io.c |  13 +++--
 fs/btrfs/extent_io.h |  11 ++--
 fs/btrfs/locking.c   | 133 ++++++++++++++++++++++++++++++-------------
 3 files changed, 107 insertions(+), 50 deletions(-)

-- 
2.20.1

