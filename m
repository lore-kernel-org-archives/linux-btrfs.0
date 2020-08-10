Return-Path: <SRS0=JIB5=BU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1565C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Aug 2020 07:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C9E2073E
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Aug 2020 07:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgHJH1y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 03:27:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:39506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgHJH1x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Aug 2020 03:27:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F0BFAAC24
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2020 07:28:11 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs-progs: check: add the ability to repair extent item generation corruption
Date:   Mon, 10 Aug 2020 15:27:43 +0800
Message-Id: <20200810072747.64439-1-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although we have introduced the check ability to detect bad extent item
generation, there is no repair ability.

I thought it would be rare to hit, but real world cases prove I'm a
total idiot.

So this patchset will add the ability to repair, for both lowmem mode
and original mode, along with enhanced test images.

There is also a bug fix for original mode, which fails to detect such
problem if it's a tree block.

Qu Wenruo (4):
  btrfs-progs: check/lowmem: add the ability to repair extent item
    generation
  btrfs-progs: check/original: don't reset extent generation for
    check_block()
  btrfs-progs: check/original: add the ability to repair extent item
    generation
  btrfs-progs: tests/fsck: enhance invalid extent item geneartion test
    cases

 check/main.c                                  |  77 ++++++++++++++-
 check/mode-common.c                           |  59 ++++++++++++
 check/mode-common.h                           |   3 +
 check/mode-lowmem.c                           |  89 ++++++++++++++++--
 ...xz => bad_extent_item_gen_for_data.img.xz} | Bin
 .../bad_extent_item_gen_for_tree_block.img.xz | Bin 0 -> 1804 bytes
 .../test.sh                                   |  19 ----
 7 files changed, 216 insertions(+), 31 deletions(-)
 rename tests/fsck-tests/044-invalid-extent-item-generation/{bad_extent_item_gen.img.xz => bad_extent_item_gen_for_data.img.xz} (100%)
 create mode 100644 tests/fsck-tests/044-invalid-extent-item-generation/bad_extent_item_gen_for_tree_block.img.xz
 delete mode 100755 tests/fsck-tests/044-invalid-extent-item-generation/test.sh

-- 
2.28.0

