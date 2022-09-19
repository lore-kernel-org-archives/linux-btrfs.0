Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47129C54EE9
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Sep 2022 14:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiISOGq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Sep 2022 10:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiISOGp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2022 10:06:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293D22A956
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2022 07:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9E4C61CFD
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2022 14:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5CFC433D6
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2022 14:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663596404;
        bh=SJSt7BBQheqD0FK1Llfx9m2lltg+4N4J9Jtc/56MIb0=;
        h=From:To:Subject:Date:From;
        b=SzxiYeTDJpep4w/LKPbEqOdAVNb8WMRG9E7tUWUYT3t2w8q+ChyAhCZeJkwDYwsbM
         C+pnr9FnULCZAI78m+53Zaqa7N6xJa6iRa/Ny9GUfLFuvrl/ABuRCSfsNQ69+JSOMt
         eySt52WyFDyfIwm5kY7fRJB7wPyRRzaxjXZPDH95zXTlKq6gIF0lRrl67w0qYOQcg8
         G2SbXI/fgjXme79hY9++pfhhc+CLZcEFijGoLPOREInxk/SrfoXb0Z5YTxEr6z9Ehn
         REyDlVMtpIvQpeOuJ5PGq9v8I4zScdDAM0BYdWQa7aVXshyzY7Udvses/7Cxr58DLJ
         xZPP58JItDXsw==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 00/13] btrfs: fixes and cleanups around extent maps
Date:   Mon, 19 Sep 2022 15:06:27 +0100
Message-Id: <cover.1663594828.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The following patchset fixes a bug related to dropping extent maps that
can make an fsync miss a new extent, does several cleanups and some
small performance improvements when dropping and searching for extent
maps as well as when flushing delalloc in COW mode. These came out while
working on some upcoming changes for fiemap, but since they are really
independent, I'm sending them as a separate patchset.
The last patch in the series has a test and results in its changelog.

Filipe Manana (13):
  btrfs: fix missed extent on fsync after dropping extent maps
  btrfs: move btrfs_drop_extent_cache() to extent_map.c
  btrfs: use extent_map_end() at btrfs_drop_extent_map_range()
  btrfs: use cond_resched_rwlock_write() during inode eviction
  btrfs: move open coded extent map tree deletion out of inode eviction
  btrfs: add helper to replace extent map range with a new extent map
  btrfs: remove the refcount warning/check at free_extent_map()
  btrfs: remove unnecessary extent map initializations
  btrfs: assert tree is locked when clearing extent map from logging
  btrfs: remove unnecessary NULL pointer checks when searching extent maps
  btrfs: remove unnecessary next extent map search
  btrfs: avoid pointless extent map tree search when flushing delalloc
  btrfs: drop extent map range more efficiently

 fs/btrfs/ctree.h             |   2 -
 fs/btrfs/extent_map.c        | 343 ++++++++++++++++++++++++++++++++---
 fs/btrfs/extent_map.h        |   8 +
 fs/btrfs/file.c              | 184 ++-----------------
 fs/btrfs/free-space-cache.c  |   2 +-
 fs/btrfs/inode.c             | 101 +++--------
 fs/btrfs/relocation.c        |  20 +-
 fs/btrfs/tests/inode-tests.c |   2 +-
 8 files changed, 373 insertions(+), 289 deletions(-)

-- 
2.35.1

