Return-Path: <SRS0=FrL0=PV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D8CC43444
	for <linux-btrfs@archiver.kernel.org>; Sun, 13 Jan 2019 16:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EB50206B6
	for <linux-btrfs@archiver.kernel.org>; Sun, 13 Jan 2019 16:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfAMQkI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 13 Jan 2019 11:40:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:46966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbfAMQkI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Jan 2019 11:40:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03A70AE2B;
        Sun, 13 Jan 2019 16:40:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 08424DA7FB; Sun, 13 Jan 2019 17:39:38 +0100 (CET)
Date:   Sun, 13 Jan 2019 17:39:38 +0100
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.0-rc2
Message-ID: <cover.1547396230.git.dsterba@suse.com>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, torvalds@linux-foundation.org,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

please pull the following branch to get:

- 2 regression fixes in clone/dedupe ioctls, the generic check callback
  needs to lock extents properly and wait for io to avoid problems with
  writeback and relocation

- fix deadlock when using free space tree due to block group creation

- a recently added check refuses a valid fileystem with seeding device,
  make that work again with a quickfix, proper solution needs more
  intrusive changes

Thanks.

----------------------------------------------------------------
The following changes since commit 52042d8e82ff50d40e76a275ac0b97aa663328b0:

  btrfs: Fix typos in comments and strings (2018-12-17 14:51:50 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.0-rc1-tag

for you to fetch changes up to 1b3922a8bc74231f9a767d1be6d9a061a4d4eeab:

  btrfs: Use real device structure to verify dev extent (2019-01-10 17:13:00 +0100)

----------------------------------------------------------------
Filipe Manana (3):
      Btrfs: fix race between cloning range ending at eof and writeback
      Btrfs: fix race between reflink/dedupe and relocation
      Btrfs: fix deadlock when using free space tree due to block group creation

Qu Wenruo (1):
      btrfs: Use real device structure to verify dev extent

 fs/btrfs/ctree.c   | 16 +++++++++-------
 fs/btrfs/ioctl.c   | 49 +++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/volumes.c | 12 ++++++++++++
 3 files changed, 64 insertions(+), 13 deletions(-)
