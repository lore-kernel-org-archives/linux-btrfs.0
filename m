Return-Path: <SRS0=c8Io=V3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E27C0650F
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 17:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29FD42089E
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 17:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfG3RJe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jul 2019 13:09:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:41718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728184AbfG3RJd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jul 2019 13:09:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBE5DAC10
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2019 17:09:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B4BFBDA808; Tue, 30 Jul 2019 19:10:07 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Sysfs updates
Date:   Tue, 30 Jul 2019 19:10:07 +0200
Message-Id: <cover.1564505777.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Export the potential debugging data in the per-filesystem directories we
already have, so we can drop debugfs. The new directories depend on
CONFIG_BTRFS_DEBUG so they're not affecting normal builds.

David Sterba (2):
  btrfs: sysfs: add debugging exports
  btrfs: delete debugfs code

 fs/btrfs/sysfs.c | 68 +++++++++++++++++++++++-------------------------
 fs/btrfs/sysfs.h |  5 ----
 2 files changed, 32 insertions(+), 41 deletions(-)

-- 
2.22.0

