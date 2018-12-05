Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14834C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D77082082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D77082082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbeLENeX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 08:34:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:35878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727135AbeLENeX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 08:34:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C8F29AC5F;
        Wed,  5 Dec 2018 13:34:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BCB5FDAB92; Wed,  5 Dec 2018 14:34:02 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fix for 4.20-rc5
Date:   Wed,  5 Dec 2018 14:34:01 +0100
Message-Id: <cover.1544016523.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

a patch in 4.19 introduced a sanity check that was too strict and a
filesystem cannot be mounted. This happens for filesystems with more
than 10 devices and has been reported a few users so we need the fix to
propagate to stable. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 42a657f57628402c73237547f0134e083e2f6764:

  btrfs: relocation: set trans to be NULL after ending transaction (2018-11-23 13:47:46 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.20-rc5-tag

for you to fetch changes up to 10950929e994c5ecee149ff0873388d3c98f12b5:

  btrfs: tree-checker: Don't check max block group size as current max chunk size limit is unreliable (2018-12-04 15:05:30 +0100)

----------------------------------------------------------------
Qu Wenruo (1):
      btrfs: tree-checker: Don't check max block group size as current max chunk size limit is unreliable

 fs/btrfs/tree-checker.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)
