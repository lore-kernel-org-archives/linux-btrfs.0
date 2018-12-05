Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699EEC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36BD62083F
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:23:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36BD62083F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbeLEOXO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:23:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:46004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727297AbeLEOXO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 09:23:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CF629ACC2
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 14:23:12 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 0/3] btrfs: use offset_in_page and PAGE_ALIGNED 
Date:   Wed,  5 Dec 2018 15:23:02 +0100
Message-Id: <20181205142305.15361-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Use the offset_in_page() and PAGE_ALIGNED() macros instead of open-coding them
throughout btrfs.

This series also includes a patch for 'make coccicheck' which is marked as an
RFC and I've CCed Julia in the hoping to get input from her.

Johannes Thumshirn (3):
  btrfs: use offset_in_page instead of open-coding it
  btrfs: use PAGE_ALIGNED instead of open-coding it
  coccinelle: api: add offset_in_page.cocci

 fs/btrfs/check-integrity.c                  | 20 +++----
 fs/btrfs/compression.c                      |  4 +-
 fs/btrfs/extent_io.c                        | 53 +++++++++----------
 fs/btrfs/file.c                             |  4 +-
 fs/btrfs/inode.c                            |  9 ++--
 fs/btrfs/send.c                             |  2 +-
 fs/btrfs/volumes.c                          |  2 +-
 scripts/coccinelle/api/offset_in_page.cocci | 81 +++++++++++++++++++++++++++++
 8 files changed, 125 insertions(+), 50 deletions(-)
 create mode 100644 scripts/coccinelle/api/offset_in_page.cocci

-- 
2.16.4

