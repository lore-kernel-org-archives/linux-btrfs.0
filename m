Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6BBC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 12:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECFB72081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 12:28:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECFB72081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbeK1X35 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 18:29:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:58656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727783AbeK1X34 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 18:29:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70A6BB046;
        Wed, 28 Nov 2018 12:28:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EDCCCDA837; Wed, 28 Nov 2018 13:28:08 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.20-rc4
Date:   Wed, 28 Nov 2018 13:28:05 +0100
Message-Id: <cover.1543407525.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

please pull the following fixes. Some of them are being hit during
testing so we'd like to get them merged, otherwise there are usual
stability fixes for stable trees. Thanks.

----------------------------------------------------------------
The following changes since commit d6fd0ae25c6495674dc5a41a8d16bc8e0073276d:

  Btrfs: fix missing delayed iputs on unmount (2018-11-07 20:17:45 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.20-rc4-tag

for you to fetch changes up to 42a657f57628402c73237547f0134e083e2f6764:

  btrfs: relocation: set trans to be NULL after ending transaction (2018-11-23 13:47:46 +0100)

----------------------------------------------------------------
Filipe Manana (3):
      Btrfs: fix rare chances for data loss when doing a fast fsync
      Btrfs: ensure path name is null terminated at btrfs_control_ioctl
      Btrfs: fix race between enabling quotas and subvolume creation

Nikolay Borisov (1):
      btrfs: Always try all copies when reading extent buffers

Pan Bian (1):
      btrfs: relocation: set trans to be NULL after ending transaction

Robbie Ko (1):
      Btrfs: send, fix infinite loop due to directory rename dependencies

 fs/btrfs/disk-io.c    | 11 +----------
 fs/btrfs/file.c       | 24 ++++++++++++++++++++++++
 fs/btrfs/qgroup.c     |  3 ++-
 fs/btrfs/relocation.c |  1 +
 fs/btrfs/send.c       | 11 ++++++++---
 fs/btrfs/super.c      |  1 +
 6 files changed, 37 insertions(+), 14 deletions(-)
