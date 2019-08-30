Return-Path: <SRS0=9BDA=W2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E849FC3A5A4
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6E1B21874
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfH3LgP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:36:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:50260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727620AbfH3LgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Aug 2019 07:36:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B1A55AEBD;
        Fri, 30 Aug 2019 11:36:13 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5 0/4] btrfs: support xxhash64 checksums
Date:   Fri, 30 Aug 2019 13:36:07 +0200
Message-Id: <20190830113611.16865-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now that Nikolay's XXHASH64 support for the Crypto API has landed and BTRFS is
prepared for an easy addition of new checksums, this patchset implements
XXHASH64 as a second, fast but not cryptographically secure checksum hash.

For changelogs, please see the individual patches.

David Sterba (1):
  btrfs: sysfs: export supported checksums

Johannes Thumshirn (3):
  btrfs: turn checksum type define into a enum
  btrfs: create structure to encode checksum type and length
  btrfs: add xxhash64 to checksumming algorithms

 fs/btrfs/Kconfig                |  1 +
 fs/btrfs/ctree.c                | 23 +++++++++++++++++++++++
 fs/btrfs/ctree.h                | 20 ++------------------
 fs/btrfs/disk-io.c              |  1 +
 fs/btrfs/super.c                |  1 +
 fs/btrfs/sysfs.c                | 29 +++++++++++++++++++++++++++++
 include/uapi/linux/btrfs_tree.h |  5 ++++-
 7 files changed, 61 insertions(+), 19 deletions(-)

-- 
2.16.4

