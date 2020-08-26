Return-Path: <SRS0=f55l=CE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97584C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 00:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C0B92072D
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 00:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHZArj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:47:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:45232 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgHZArj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Aug 2020 20:47:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9A213B004
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2020 00:48:09 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: small compile warning fixes
Date:   Wed, 26 Aug 2020 08:47:32 +0800
Message-Id: <20200826004734.89905-1-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although the global parameter fs_info would affect all repair tests...

Qu Wenruo (2):
  btrfs-progs: fix compile warning due to global fs_info cleanup
  btrfs-progs: remove the unused variable in
    check_chunks_and_extents_lowmem()

 check/mode-lowmem.c         | 15 ++++++---------
 kernel-shared/ctree.h       |  3 +--
 kernel-shared/extent-tree.c |  2 +-
 3 files changed, 8 insertions(+), 12 deletions(-)

-- 
2.28.0

