Return-Path: <SRS0=NX0b=ZS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C84C432C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Nov 2019 03:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 010A42071A
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Nov 2019 03:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKZDPU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Nov 2019 22:15:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:34090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbfKZDPT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Nov 2019 22:15:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4163DAE00;
        Tue, 26 Nov 2019 03:15:18 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, hch@infradead.org,
        darrick.wong@oracle.com, fdmanana@kernel.org
Subject: [PATCH 0/5 v2] btrfs direct-io using iomap
Date:   Mon, 25 Nov 2019 21:14:51 -0600
Message-Id: <20191126031456.12150-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an effort to use iomap for direct I/O in btrfs. This would
change the call from __blockdev_direct_io() to iomap_dio_rw().

The main objective is to lose the buffer head and use bio defined by
iomap code, and hopefully to use more of generic-FS codebase.

These patches are based on xfs/iomap-for-next, though I tested it
against the patches on xfs/iomap-for-next on top of v5.4 (there are no
changes to existing iomap patches).

I have tested it against xfstests/btrfs.

Changes since v1
- Incorporated back the efficiency change for inode locking
- Review comments about coding style and git comments
- Merge related patches into one
- Direct read to go through btrfs_direct_IO()
- Removal of no longer used function dio_end_io()

 fs/btrfs/ctree.h      |    2 
 fs/btrfs/extent_io.c  |   33 ++++-----
 fs/btrfs/file.c       |   15 +++-
 fs/btrfs/inode.c      |  171 +++++++++++++++++++++++---------------------------
 fs/direct-io.c        |   19 -----
 fs/iomap/direct-io.c  |   14 ++--
 include/linux/fs.h    |    3 
 include/linux/iomap.h |    2 
 mm/filemap.c          |   13 ++-
 9 files changed, 131 insertions(+), 141 deletions(-)

--
Goldwyn

