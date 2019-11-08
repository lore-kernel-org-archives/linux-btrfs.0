Return-Path: <SRS0=5HN8=ZA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0A2FC6197
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96B9C20650
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732091AbfKHVi5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:38:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:45836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727768AbfKHVi5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Nov 2019 16:38:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AE87AAF7E;
        Fri,  8 Nov 2019 21:38:55 +0000 (UTC)
From:   =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH next 0/2] btrfs: Fix build warnings for arm
Date:   Fri,  8 Nov 2019 22:38:51 +0100
Message-Id: <20191108213853.16635-1-afaerber@suse.de>
X-Mailer: git-send-email 2.16.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello Wenruo and Dave,

This mini-series fixes two build warnings found while cross-compiling for arm,
using openSUSE's cross-arm-binutils and cross-arm-none-gcc9 packages.

Replacing BUG_ON() with btrfs_crit() error handling is noble work, but please
be careful not to hardcode format specifiers for x86_64's size_t.

https://www.kernel.org/doc/Documentation/printk-formats.txt

In one case it could've been noticed during review, in another it was hidden
through a macro and would've only been found through compile-testing.
Probably a 32-bit i386 build would do; otherwise ARCH=arm multi_v7_defconfig
plus CONFIG_BTRFS_FS should reproduce.

It's around for maybe three weeks, so I wonder why kbuild bot didn't catch it.

Cheers,
Andreas

Andreas Färber (2):
  btrfs: tree-checker: Fix error format string
  btrfs: extent-tree: Fix error format string

 fs/btrfs/extent-tree.c  | 2 +-
 fs/btrfs/tree-checker.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.16.4

