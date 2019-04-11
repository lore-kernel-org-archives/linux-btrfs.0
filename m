Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323DCC10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 17:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131ED2073F
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 17:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfDKReJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 13:34:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:53816 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbfDKReJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 13:34:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26F6FABC1;
        Thu, 11 Apr 2019 17:34:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4B580DA85B; Thu, 11 Apr 2019 19:35:16 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.1-rc5
Date:   Thu, 11 Apr 2019 19:35:13 +0200
Message-Id: <cover.1555003647.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

please pull the following updates that have some user-visible effects:

- fix parsing of compression algorithm when set as a inode property,
  this could end up with eg. 'zst' or 'zli' in the value

- don't allow trim on a filesystem with unreplayed log, this could cause
  data loss if there are pending updates to the block groups that would
  not be subject to trim after replay

Thanks.

----------------------------------------------------------------
The following changes since commit 0ccc3876e4b2a1559a4dbe3126dda4459d38a83b:

  Btrfs: fix assertion failure on fsync with NO_HOLES enabled (2019-03-20 19:53:39 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.1-rc4-tag

for you to fetch changes up to 272e5326c7837697882ce3162029ba893059b616:

  btrfs: prop: fix vanished compression property after failed set (2019-04-04 17:57:53 +0200)

----------------------------------------------------------------
Anand Jain (2):
      btrfs: prop: fix zstd compression parameter validation
      btrfs: prop: fix vanished compression property after failed set

Filipe Manana (1):
      Btrfs: do not allow trimming when a fs is mounted with the nologreplay option

 fs/btrfs/ioctl.c | 10 ++++++++++
 fs/btrfs/props.c |  8 ++++----
 2 files changed, 14 insertions(+), 4 deletions(-)
