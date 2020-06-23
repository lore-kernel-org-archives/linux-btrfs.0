Return-Path: <SRS0=qk6s=AE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793A0C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 05:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A7320724
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 05:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgFWFsL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 01:48:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:59974 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728830AbgFWFsL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jun 2020 01:48:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AFF34AD39
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2020 05:48:09 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: build warning hunting routine
Date:   Tue, 23 Jun 2020 13:48:02 +0800
Message-Id: <20200623054804.67175-1-wqu@suse.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Two small cosmetic warning hunting with latest GCC/e2fsprogs.

Qu Wenruo (2):
  btrfs-progs: convert/ext2: fix the pointer sign warning
  btrfs-progs: Fix seemly wrong format overflow warning

 common/fsfeatures.c   | 2 +-
 convert/source-ext2.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.27.0

