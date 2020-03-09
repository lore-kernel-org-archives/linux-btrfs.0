Return-Path: <SRS0=wiEv=42=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C29C10F27
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Mar 2020 12:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF0E420848
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Mar 2020 12:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583757673;
	bh=rzNWzOJEgWYMq8MvztHy7DvTRIsqvXkWYmj6eztKhP4=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ODndkPE+yvEJvysVdeI2B7ijwiqeIJNWVwViZCfb4Pr8wY2/48m/jPInvPjR0FOIz
	 BEuI3mn6ywLIyzn9ou8fKVCW3/DfB3JtQsKAEpgLv9iQY7IewSSBQ3YBW0Psbp0mht
	 hJ6d9nbjpCiiSAGv6hzrT+kH4xQ0rBPAJiak7Zdw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgCIMlN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Mar 2020 08:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgCIMlM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Mar 2020 08:41:12 -0400
Received: from debian6.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D85920674;
        Mon,  9 Mar 2020 12:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583757672;
        bh=rzNWzOJEgWYMq8MvztHy7DvTRIsqvXkWYmj6eztKhP4=;
        h=From:To:Cc:Subject:Date:From;
        b=rQOatyfMwupVub+ggiihJoyiJlvVxd80BsWcDKhY+u+m9RqXWKLez8zwH0g/itmnm
         R5N/vaJ975diw2IRuqS5eQTrjnQnSfMsDLFwZOWd2ArYLHP0zhI3XAZLCh3CK9/x9f
         Q/Ghg1HWo38NM8u2MF8JAyirzMxd58Xcoq7U8gB8=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     josef@toxicpanda.com
Subject: [PATCH v3 0/4] Btrfs: make ranged fsyncs always respect the given range
Date:   Mon,  9 Mar 2020 12:41:04 +0000
Message-Id: <20200309124108.18952-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

This patchset fixes a bug when not using NO_HOLES and makes ranged fsyncs
respect the given file range when using the NO_HOLES feature.

The bug is about missing file extents items representing a hole after doing
a ranged fsync on a file and replaying the log.

Btrfs doesn't respect the given range for a fsync when the inode's has the
"need full sync" bit set - it treats the fsync as a full ranged one, operating
on the whole file, doing more IO and cpu work then needed.

That behaviour was needed to fix a corruption bug. Commit 0c713cbab6200b
("Btrfs: fix race between ranged fsync and writeback of adjacent ranges")
fixed that bug by turning the ranged fsync into a full ranged one.

Later the hole detection code of fsync was simplified a lot in order to
fix another bug when using the NO_HOLES feature - done by commit
0e56315ca147b3 ("Btrfs: fix missing hole after hole punching and fsync when
using NO_HOLES"). That commit now makes it easy to avoid turning the ranged
fsyncs into non-ranged fsyncs.

This patchset does those two changes. The first patch fixes the bug mentioned
before, patches 2 and 3 are preparation cleanups for patch 4, which is the
one that makes fsync respect the given file range when using NO_HOLES.

V3: Updated patch one so that the ranged is set to full before locking the
    inode. To make sure we do writeback and wait for ordered extent
    completion as much as possible before locking the inode.
    Remaining patches are unchanged.

V2: Added one more patch to the series, which is the first patch, that
    fixes the bug regarding missing holes after doing a ranged fsync.

    The remaining patches remain the same, only patch 4 had a trivial
    conflict when rebasing against patch 1 and got its changelog
    updated. Now all fstests pass with version 2 of this patchset.

Filipe Manana (4):
  Btrfs: fix missing file extent item for hole after ranged fsync
  Btrfs: add helper to get the end offset of a file extent item
  Btrfs: factor out inode items copy loop from btrfs_log_inode()
  Btrfs: make ranged full fsyncs more efficient

 fs/btrfs/ctree.h     |   1 +
 fs/btrfs/file-item.c |  40 ++++--
 fs/btrfs/file.c      |  23 ++--
 fs/btrfs/inode.c     |  10 +-
 fs/btrfs/send.c      |  44 +-----
 fs/btrfs/tree-log.c  | 379 +++++++++++++++++++++++++++++----------------------
 6 files changed, 261 insertions(+), 236 deletions(-)

-- 
2.11.0

