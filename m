Return-Path: <SRS0=C73g=6L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68071C54FD0
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Apr 2020 13:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 507C820656
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Apr 2020 13:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgD0NqQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 09:46:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:37476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgD0NqP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Apr 2020 09:46:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5345EABB2;
        Mon, 27 Apr 2020 13:46:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1D9F3DA781; Mon, 27 Apr 2020 15:45:28 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.7-rc4
Date:   Mon, 27 Apr 2020 15:45:28 +0200
Message-Id: <cover.1587992189.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

please pull the following branch with regression fixes and some stable
material. Thanks.

* regression fixes:
  * transaction leak when deleting unused block group
  * log cleanup after transaction abort

* fix block group leak when removing fails

* transaction leak if relocation recovery fails

* fix SPDX header

----------------------------------------------------------------
The following changes since commit aec7db3b13a07d515c15ada752a7287a44a79ea0:

  btrfs: fix setting last_trans for reloc roots (2020-04-17 15:20:08 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc3-tag

for you to fetch changes up to 1402d17dfd9657be0da8458b2079d03c2d61c86a:

  btrfs: fix transaction leak in btrfs_recover_relocation (2020-04-23 17:24:56 +0200)

----------------------------------------------------------------
Filipe Manana (1):
      btrfs: fix memory leak of transaction when deleting unused block group

Josef Bacik (1):
      btrfs: drop logs when we've aborted a transaction

Nishad Kamdar (1):
      btrfs: discard: Use the correct style for SPDX License Identifier

Xiyu Yang (2):
      btrfs: fix block group leak when removing fails
      btrfs: fix transaction leak in btrfs_recover_relocation

 fs/btrfs/block-group.c | 20 ++++++++++++++------
 fs/btrfs/discard.h     |  2 +-
 fs/btrfs/disk-io.c     | 36 ++++++++++++++++++++++++++++++++----
 fs/btrfs/relocation.c  |  1 +
 4 files changed, 48 insertions(+), 11 deletions(-)
