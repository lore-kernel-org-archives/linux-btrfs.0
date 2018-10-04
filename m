Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E49AC64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 05:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00710213A2
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 05:49:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00710213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbeJDMla (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 08:41:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:53120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbeJDMl3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 08:41:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4709DB063
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 05:49:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: btrfs_super_block::log_root_transid related enhancement
Date:   Thu,  4 Oct 2018 13:49:48 +0800
Message-Id: <20181004054950.11651-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Even we have btrfs_super_block::log_root_transid, it's never really
populated.

This patchset will populate that member and use it to detect corrupted
log tree early.

Qu Wenruo (2):
  btrfs: Populate btrfs_super_block::log_root_transid
  btrfs: Validate btrfs_super_block::log_root_transid

 fs/btrfs/disk-io.c     | 28 ++++++++++++++++++++++------
 fs/btrfs/transaction.c |  1 +
 fs/btrfs/tree-log.c    |  2 ++
 3 files changed, 25 insertions(+), 6 deletions(-)

-- 
2.19.0

