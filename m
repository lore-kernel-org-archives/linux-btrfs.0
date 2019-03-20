Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8175C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA8A2184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfCTG1y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:27:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:39738 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726935AbfCTG1y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:27:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C20FAD3B
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:27:52 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5.3 00/11] btrfs: tree-checker: Write time tree checker
Date:   Wed, 20 Mar 2019 14:27:38 +0800
Message-Id: <20190320062749.30953-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Patchset can be fetched from github:
https://github.com/adam900710/linux/tree/write_time_tree_checker
Which is based on v5.1-rc1 tag.

This patchset has the following 3 features:
- Tree block validation output enhancement
  * Output validation failure timing (write time or read time)
  * Always output tree block level/key mismatch error message
    This part is already submitted and reviewed.

- Write time tree block validation check
  To catch memory corruption either from hardware or kernel.
  Example output would be:

    BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
    BTRFS error (device dm-3): block=1350630375424 write time tree block corruption detected
    BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
    BTRFS info (device dm-3): forced readonly
    BTRFS warning (device dm-3): Skipping commit of aborted transaction.
    BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
    BTRFS info (device dm-3): delayed_refs has NO entry

- Better error handling before calling flush_write_bio()
  One hidden reason of calling flush_write_bio() under all cases is,
  flush_write_bio() will trigger endio function and endio function of
  epd->bio will free the bio under all cases.
  So we're in fact abusing flush_write_bio() as cleanup.

  Since now flush_write_bio() has its own return value, we shouldn't call
  flush_write_bio() no-brain, here we introduce proper cleanup helper,
  end_write_bio(). Now we call flush_write_bio() like:
              New                 |           Old
  --------------------------------------------------------------
  ret = do_some_evil(&epd);       | ret = do_some_evil(&epd);
  if (ret < 0) {                  | flush_write_bio(&epd);
  	end_write_bio(&epd, ret); | ^^^ submitting half-backed epd->bio?
  	return ret;               | return ret;
  }                               |
  ret = flush_write_bio(&epd);    |
  return ret;                     |

  Above code should be more streamline for the error handling part.

Changelog:
v2:
- Unlock locked pages in lock_extent_buffer_for_io() for error handling.
- Added Reviewed-by tags.

v3:
- Remove duplicated error message.
- Use IS_ENABLED() macro to replace #ifdef.
- Added Reviewed-by tags.

v4:
- Re-organized patch split
  Now each BUG_ON() cleanup has its own patch
- Dig much further into the call sites to eliminate unexpected >0 return
  May be a little paranoid and abuse some ASSERT(), but it should be
  much safer against further code change.
- Fix the false alert caused by balance and memory pressure
  The fix it skip owner checker for non-essential tree at write time.
  Since owner root can't always be reliable, either due to commit root
  created in current transaction or balance + memory pressure.

v5:
- Do proper error-out handling other than relying on flush_write_bio()
  to clean up.
  This has a side effect that no Reviewed-by tags for modified patches.
- New comment for why we don't need to do anything about ebp->bio when
  submit_one_bio() fails.
- Add some Reviewed-by tag.

v5.1:
- Add "block=%llu " output for write/read time error line.
- Also output read time error message for fsid/start/level check.

v5.2:
- Fix a missing page_unlock() in error hanlding

v5.3:
- Rebase to v5.1-rc1 tag

Qu Wenruo (11):
  btrfs: Always output error message when key/level verification fails
  btrfs: disk-io: Show the timing of corrupted tree block explicitly
  btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level up
  btrfs: extent_io: Handle error better in extent_write_full_page()
  btrfs: extent_io: Handle error better in btree_write_cache_pages()
  btrfs: extent_io: Kill the dead branch in extent_write_cache_pages()
  btrfs: extent_io: Handle error better in extent_write_locked_range()
  btrfs: extent_io: Kill the BUG_ON() in lock_extent_buffer_for_io()
  btrfs: extent_io: Kill the BUG_ON() in extent_write_cache_pages()
  btrfs: extent_io: Handle error better in extent_writepages()
  btrfs: Do mandatory tree block check before submitting bio

 fs/btrfs/disk-io.c      |  24 ++++++---
 fs/btrfs/extent_io.c    | 109 +++++++++++++++++++++++++++++++++-------
 fs/btrfs/tree-checker.c |  24 +++++++--
 fs/btrfs/tree-checker.h |   8 +++
 4 files changed, 137 insertions(+), 28 deletions(-)

-- 
2.21.0

