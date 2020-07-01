Return-Path: <SRS0=5Fjf=AM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C0AC433E0
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Jul 2020 15:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC3C206C3
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Jul 2020 15:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731715AbgGAPQa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 11:16:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:51700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbgGAPQa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Jul 2020 11:16:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2C85CACBD;
        Wed,  1 Jul 2020 15:16:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6B4BFDA781; Wed,  1 Jul 2020 17:16:13 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Removal of deprecated mount options
Date:   Wed,  1 Jul 2020 17:16:13 +0200
Message-Id: <cover.1593616511.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Both options have no effect for a long time, no need to keep them
around.

David Sterba (2):
  btrfs: remove deprecated mount option alloc_start
  btrfs: remove deprecated mount option subvolrootid

 fs/btrfs/super.c | 12 ------------
 1 file changed, 12 deletions(-)

-- 
2.25.0

