Return-Path: <SRS0=V6R8=6B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9504CC38A2B
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Apr 2020 13:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC762078E
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Apr 2020 13:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgDQNak (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 09:30:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:36900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730610AbgDQNaj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Apr 2020 09:30:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A7911AC94;
        Fri, 17 Apr 2020 13:30:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 789BDDA727; Fri, 17 Apr 2020 15:29:57 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fix for 5.7-rc2
Date:   Fri, 17 Apr 2020 15:29:54 +0200
Message-Id: <cover.1587129870.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

please pull a regression fix for a warning caused by running balance and
snapshot creation in parallel. Thanks.

----------------------------------------------------------------
The following changes since commit 34c51814b2b87cb2e5a98c92fe957db2ee8e27f4:

  btrfs: re-instantiate the removed BTRFS_SUBVOL_CREATE_ASYNC definition (2020-04-10 18:48:27 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc1-tag

for you to fetch changes up to aec7db3b13a07d515c15ada752a7287a44a79ea0:

  btrfs: fix setting last_trans for reloc roots (2020-04-17 15:20:08 +0200)

----------------------------------------------------------------
Josef Bacik (1):
      btrfs: fix setting last_trans for reloc roots

 fs/btrfs/relocation.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)
