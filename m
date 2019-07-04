Return-Path: <SRS0=R2l8=VB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF87C0651F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Jul 2019 15:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61162083B
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Jul 2019 15:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562253847;
	bh=2D5hc6YueiAs+xbSdEl7paXWYfuHN9usgSH3+zbbyDY=;
	h=From:To:Subject:Date:List-ID:From;
	b=c1FdBHzhbpIPBxhjq4Lyu2u9Qp1L9mLDk7/TLuBiNE+4pk4tiIaBgEt3fdyvPtfAt
	 vdCax6XQQcNuR0fl5akBADICWztcB2UhLfC2/PfT1l3YIb1hfasSMpfKcR160ZvWjS
	 0T89UG16HPlqjMzSOLdwEJNfcrjlUxiJQu84id+g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfGDPYG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Jul 2019 11:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfGDPYF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Jul 2019 11:24:05 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DF6A2083B
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Jul 2019 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562253845;
        bh=2D5hc6YueiAs+xbSdEl7paXWYfuHN9usgSH3+zbbyDY=;
        h=From:To:Subject:Date:From;
        b=MjDn4Sms+8LwBnGEXrAuN45To7ZUub5LPlbj1B/1uJ5Snxfizw9QuCjung3sYrYF7
         zSSbWPY/lrq2ejrMgxH4I+N4fyuYKym5/8NWVWFCEaqyfrfi3iefxMpwilrAVPzp2S
         nky/d2lxgQ1Ss0zIDP98MZvkQP6Kanzd3sWIYek4=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] Btrfs: fixes for inode cache (-o inode_cache)
Date:   Thu,  4 Jul 2019 16:24:00 +0100
Message-Id: <20190704152400.20614-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Just a small set of fixes for the inode cache feature, mostly hangs due to
missing wakeups or incomplete error handling, as well as an inode block
reserve leak when hitting ENOSPC.

Filipe Manana (5):
  Btrfs: fix hang when loading existing inode cache off disk
  Btrfs: fix inode cache block reserve leak on failure to allocate data
    space
  Btrfs: fix inode cache waiters hanging on failure to start caching
    thread
  Btrfs: fix inode cache waiters hanging on path allocation failure
  Btrfs: wake up inode cache waiters sooner to reduce waiting time

 fs/btrfs/inode-map.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

-- 
2.11.0

