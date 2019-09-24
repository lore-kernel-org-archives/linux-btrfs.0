Return-Path: <SRS0=VYXz=XT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851CEC432C1
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 08:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F96F214AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 08:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405850AbfIXIL0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 04:11:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:38874 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390364AbfIXIL0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Sep 2019 04:11:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1DBB4B63B
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2019 08:11:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: Add check and repair for invalid inode generation
Date:   Tue, 24 Sep 2019 16:11:17 +0800
Message-Id: <20190924081120.6283-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have at least two user reports about bad inode generation makes
kernel reject the fs.

According to the creation time, the inode is created by some 2014
kernel.
And the generation member of INODE_ITEM is not updated (unlike the
transid member) so the error persists until latest tree-checker detects.

Even the situation can be fixed by reverting back to older kernel and
copying the offending dir/file to another inode and delete the offending
one, it still should be done by btrfs-progs.

This patchset adds such check and repair ability to btrfs-check, with a
simple test image.

Qu Wenruo (3):
  btrfs-progs: check/lowmem: Add check and repair for invalid inode
    generation
  btrfs-progs: check/original: Add check and repair for invalid inode
    generation
  btrfs-progs: fsck-tests: Add test image for invalid inode generation
    repair

 check/main.c                                  |  50 +++++++++++-
 check/mode-lowmem.c                           |  76 ++++++++++++++++++
 check/mode-original.h                         |   1 +
 .../.lowmem_repairable                        |   0
 .../bad_inode_geneartion.img.xz               | Bin 0 -> 2012 bytes
 5 files changed, 126 insertions(+), 1 deletion(-)
 create mode 100644 tests/fsck-tests/043-bad-inode-generation/.lowmem_repairable
 create mode 100644 tests/fsck-tests/043-bad-inode-generation/bad_inode_geneartion.img.xz

-- 
2.23.0

