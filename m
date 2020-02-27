Return-Path: <SRS0=+uyb=4P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A0EC11D3D
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5221024699
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbgB0UBE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:01:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:55508 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727159AbgB0UBE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Feb 2020 15:01:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D4C0B117;
        Thu, 27 Feb 2020 20:01:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1F4EFDA83A; Thu, 27 Feb 2020 21:00:43 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Misc cleanups
Date:   Thu, 27 Feb 2020 21:00:42 +0100
Message-Id: <cover.1582832619.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A few more cleanups that needed more testing.

David Sterba (4):
  btrfs: inline checksum name and driver definitions
  btrfs: simplify tree block checksumming loop
  btrfs: return void from csum_tree_block
  btrfs: balance: factor out convert profile validation

 fs/btrfs/ctree.c   |  7 ++++---
 fs/btrfs/disk-io.c | 45 +++++++++++----------------------------------
 fs/btrfs/volumes.c | 45 +++++++++++++++++++++------------------------
 3 files changed, 36 insertions(+), 61 deletions(-)

-- 
2.25.0

