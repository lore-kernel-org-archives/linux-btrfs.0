Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C06ECC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 02:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 946DB20873
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 02:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfARCUB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 21:20:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:46856 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbfARCUB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 21:20:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4B347AD54
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 02:20:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
Date:   Fri, 18 Jan 2019 10:19:51 +0800
Message-Id: <20190118021956.22949-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Patchset can be fetched from github:
https://github.com/adam900710/linux/tree/write_time_tree_checker
Which is based on v5.0-rc1 tag.

This patchset has the following two features:
- Tree block validation output enhancement
  * Output validation failure timing (write time or read time)
  * Always output tree block level/key mismatch error message
    This part is already submitted and reviewed.

- Write time tree block validation check
  To catch memory corruption either from hardware or kernel.
  Example output would be:

    BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
    BTRFS error (device dm-3): write time tree block corruption detected
    BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
    BTRFS error (device dm-3): write time tree block corruption detected
    BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
    BTRFS info (device dm-3): forced readonly
    BTRFS warning (device dm-3): Skipping commit of aborted transaction.
    BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
    BTRFS info (device dm-3): delayed_refs has NO entry

Changelog:
v2:
- Unlock locked pages in lock_extent_buffer_for_io() for error handling.
- Added Reviewed-by tags.

v3:
- Remove duplicated error message.
- Use IS_ENABLED() macro to replace #ifdef.
- Added Reviewed-by tags.

Qu Wenruo (5):
  btrfs: Always output error message when key/level verification fails
  btrfs: extent_io: Kill the forward declaration of flush_write_bio()
  btrfs: extent_io: Kill the BUG_ON() in flush_write_bio()
  btrfs: disk-io: Show the timing of corrupted tree block explicitly
  btrfs: Do mandatory tree block check before submitting bio

 fs/btrfs/disk-io.c   |  21 +++++--
 fs/btrfs/extent_io.c | 135 +++++++++++++++++++++++++++----------------
 2 files changed, 101 insertions(+), 55 deletions(-)

-- 
2.20.1

