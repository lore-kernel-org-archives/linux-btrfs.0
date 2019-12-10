Return-Path: <SRS0=ik6r=2A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D9CC43603
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Dec 2019 23:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B242073B
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Dec 2019 23:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLJXCJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 18:02:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:49588 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbfLJXCJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Dec 2019 18:02:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4DF05AD69;
        Tue, 10 Dec 2019 23:02:08 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     hch@infradead.org, darrick.wong@oracle.com, fdmanana@kernel.org,
        nborisov@suse.com, dsterba@suse.cz, jthumshirn@suse.de,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/8 v4] btrfs direct-io using iomap
Date:   Tue, 10 Dec 2019 17:01:47 -0600
Message-Id: <20191210230155.22688-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an effort to use iomap for direct I/O in btrfs. This would
change the call from __blockdev_direct_io() to iomap_dio_rw().

The main objective is to lose the buffer head and use bio defined by
iomap code, and hopefully to use more of generic-FS codebase.

These patches are based and tested on v5.5-rc1. I have tested it against
xfstests/btrfs.

The tree is available at
https://github.com/goldwynr/linux/tree/btrfs-iomap-dio


Changes since v1
- Incorporated back the efficiency change for inode locking
- Review comments about coding style and git comments
- Merge related patches into one
- Direct read to go through btrfs_direct_IO()
- Removal of no longer used function dio_end_io()

Changes since v2
- aligning iomap offset/length to the position/length of I/O
- Removed btrfs_dio_data
- Removed BTRFS_INODE_READDIO_NEED_LOCK
- Re-incorporating write efficiency changes caused lockdep_assert() in
  iomap to be triggered, remove that code.

Changes since v3
- Fixed freeze on generic/095. Use iomap_end() to account for
  failed/incomplete dio instead of btrfs_dio_data

--
Goldwyn

 fs/btrfs/btrfs_inode.h |   18 ---
 fs/btrfs/ctree.h       |    1
 fs/btrfs/extent_io.c   |   37 ++----
 fs/btrfs/extent_io.h   |    2
 fs/btrfs/file.c        |   21 +++
 fs/btrfs/inode.c       |  282 ++++++++++++++++++-------------------------------
 fs/direct-io.c         |   19 ---
 fs/iomap/direct-io.c   |   16 +-
 include/linux/fs.h     |    4
 include/linux/iomap.h  |    2
 mm/filemap.c           |   13 +-
 11 files changed, 162 insertions(+), 253 deletions(-)


