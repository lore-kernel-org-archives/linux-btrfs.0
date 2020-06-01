Return-Path: <SRS0=ZM7b=7O=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679C9C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47AC5207D5
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgFAPXE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 11:23:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:56926 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgFAPXE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Jun 2020 11:23:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2E442ADF7;
        Mon,  1 Jun 2020 15:23:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 354F6DA79B; Mon,  1 Jun 2020 17:23:01 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/9] Scrub cleanups
Date:   Mon,  1 Jun 2020 17:23:00 +0200
Message-Id: <cover.1591024792.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Remove kmaps, simplify the checksum calculations.

David Sterba (9):
  btrfs: scrub: remove kmap/kunmap of pages
  btrfs: scrub: unify naming of page address variables
  btrfs: scrub: simplify superblock checksum calculation
  btrfs: scrub: remove temporary csum array in scrub_checksum_super
  btrfs: scrub: clean up temporary page variables in
    scrub_checksum_super
  btrfs: scrub: simplify data block checksum calculation
  btrfs: scrub: clean up temporary page variables in scrub_checksum_data
  btrfs: scrub: simplify tree block checksum calculation
  btrfs: scrub: clean up temporary page variables in
    scrub_checksum_tree_block

 fs/btrfs/scrub.c | 151 +++++++++++++----------------------------------
 1 file changed, 42 insertions(+), 109 deletions(-)

-- 
2.25.0

