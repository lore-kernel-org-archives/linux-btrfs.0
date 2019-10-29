Return-Path: <SRS0=DyoH=YW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5579CA9EAE
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Oct 2019 17:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB65320830
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Oct 2019 17:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfJ2R2o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 13:28:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:38242 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726261AbfJ2R2o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Oct 2019 13:28:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7729B241;
        Tue, 29 Oct 2019 17:28:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1E643DA734; Tue, 29 Oct 2019 18:28:52 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Minor parameter cleanups
Date:   Tue, 29 Oct 2019 18:28:52 +0100
Message-Id: <cover.1572369984.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can remove write_flags parameter in case the function also has wbc
(and the value is equal).

David Sterba (2):
  btrfs: sink write_flags to __extent_writepage_io
  btrfs: sink write flags to cow_file_range_async

 fs/btrfs/extent_io.c | 8 +++-----
 fs/btrfs/inode.c     | 8 +++-----
 2 files changed, 6 insertions(+), 10 deletions(-)

-- 
2.23.0

