Return-Path: <SRS0=NtSv=ZH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F056C43141
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Nov 2019 16:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2160520692
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Nov 2019 16:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfKOQR1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 11:17:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:36786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727520AbfKOQR1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Nov 2019 11:17:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C486EAC4A;
        Fri, 15 Nov 2019 16:17:25 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, hch@infradead.org,
        darrick.wong@oracle.com
Subject: btrfs direct-io using iomap
Date:   Fri, 15 Nov 2019 10:16:53 -0600
Message-Id: <20191115161700.12305-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an effort to use iomap for direct I/O in btrfs. This would
change the call from __blockdev_direct_io() to iomap_dio_rw().

The main objective is to lose the buffer head and use bio defined by
iomap code, and hopefully to use more of generic-FS codebase.

I have tested it against xfstests. The performance seems to be nearly
the same on my VMs.

-- 
Goldwyn

 fs/btrfs/ctree.h      |    1 
 fs/btrfs/extent_io.c  |    8 ++-
 fs/btrfs/file.c       |   67 +++++++++++++++++++++++++-
 fs/btrfs/inode.c      |  128 +++++++++++++++++++++-----------------------------
 fs/iomap/direct-io.c  |   14 +++--
 include/linux/fs.h    |    2 
 include/linux/iomap.h |    2 
 mm/filemap.c          |   13 ++---
 8 files changed, 147 insertions(+), 88 deletions(-)

