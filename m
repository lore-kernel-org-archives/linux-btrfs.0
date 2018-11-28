Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C47C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 08:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3994A2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 08:55:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3994A2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbeK1Tz5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 14:55:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:44804 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727341AbeK1Tz5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 14:55:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6A243AC15
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 08:55:04 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 0/3] Misc cosmetic changes for map_private_extent_buffer
Date:   Wed, 28 Nov 2018 09:54:53 +0100
Message-Id: <20181128085456.5702-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While trying to understand the checksum code I came across some oddities
regarding map_private_extent_buffer() and it's interaction with
csum_tree_block().

These patches address them but are either purely cosmetic or only add a
comment documenting behaviour.

Changes to v1:
* Add Reviewed-by tags
* Change wording of commit message in patch 3/3

Johannes Thumshirn (3):
  btrfs: don't initialize 'offset' in map_private_extent_buffer()
  btrfs: use offset_in_page for start_offset in
    map_private_extent_buffer()
  btrfs: document extent mapping assumptions in checksum

 fs/btrfs/disk-io.c   | 6 ++++++
 fs/btrfs/extent_io.c | 4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.16.4

