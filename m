Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF7FC10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED93920850
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfDLJFf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:05:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:42986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726678AbfDLJFf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 05:05:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 190B1AFCD
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 09:05:34 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: Intelligent item offset/size bit flip detector for dump-tree
Date:   Fri, 12 Apr 2019 17:05:28 +0800
Message-Id: <20190412090530.29132-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This will make dump-tree less dumb when it gets some item offset/size
bit flip.

The output example can be found in the first patch, and the 2nd patch is
the test case to ensure it works as expected.

The design goal is to make debugging a little easier, I don't think
bit flip handler should be fixed in btrfs-progs directly, as the
complexity isn't worthy.
We should ensure it's not btrfs or some other strange kernel module
modifying eb memory in the first place.

So only dump-tree supports item size/offset bit flip detection, just to
make debugging a little easier.

Qu Wenruo (2):
  btrfs-progs: dump-tree: Do simple bit flip check and continue if we
    can handle it
  btrfs-progs: misc-tests: Test if dump-tree can handle obviously
    flipped bit in btrfs item

 print-tree.c                                  | 100 ++++++++++++++----
 .../misc-tests/036-dump-tree-bit-flip/test.sh |  21 ++++
 .../two_corrupted_items.raw.xz                | Bin 0 -> 22024 bytes
 3 files changed, 102 insertions(+), 19 deletions(-)
 create mode 100755 tests/misc-tests/036-dump-tree-bit-flip/test.sh
 create mode 100644 tests/misc-tests/036-dump-tree-bit-flip/two_corrupted_items.raw.xz

-- 
2.21.0

