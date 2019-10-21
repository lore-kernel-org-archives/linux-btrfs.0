Return-Path: <SRS0=SF3a=YO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D05CA9EAF
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Oct 2019 16:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F411B20659
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Oct 2019 16:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbfJUQpC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:45:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:52876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726847AbfJUQpC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Oct 2019 12:45:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1B4CABC7;
        Mon, 21 Oct 2019 16:45:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D918BDA733; Mon, 21 Oct 2019 18:45:13 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2 + 0/2] Add BLAKE2 checksumming support
Date:   Mon, 21 Oct 2019 18:45:13 +0200
Message-Id: <cover.1571674940.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The two patches apply on top of Johaness' series adding SHA256. To
make it actually work the patch adding BLAKE2 to kernel is needed. You
can find it here (v5) https://patchwork.kernel.org/patch/11188109/ .

WARNING: This is for testing only!

All in one can be pulled from

  git://github.com/kdave/btrfs-devel preview/checksums-5

and the btrfs-progs patches are in the devel branch

  git://github.com/kdave/btrfs-progs devel

David Sterba (2):
  btrfs: add member for a specific checksum driver
  btrfs: add blake2b to checksumming algorithms

 fs/btrfs/ctree.c                | 14 ++++++++++++++
 fs/btrfs/ctree.h                |  1 +
 fs/btrfs/disk-io.c              |  7 ++++---
 fs/btrfs/super.c                |  1 +
 include/uapi/linux/btrfs_tree.h |  1 +
 5 files changed, 21 insertions(+), 3 deletions(-)

-- 
2.23.0

