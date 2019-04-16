Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267BEC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFAE320821
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfDPQmI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:42:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:36100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726816AbfDPQmI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 12:42:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4CF57AF1B;
        Tue, 16 Apr 2019 16:42:07 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com,
        willy@infradead.org, hch@lst.de, darrick.wong@oracle.com,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org
Subject: [PATCH v3 00/18] btrfs dax support
Date:   Tue, 16 Apr 2019 11:41:36 -0500
Message-Id: <20190416164154.30390-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch set adds support for dax on the BTRFS filesystem.
In order to support for CoW for btrfs, there were changes which had to be
made to the dax handling. The important one is copying blocks into the
same dax device before using them which is performed by iomap
type IOMAP_DAX_COW.

Snapshotting and CoW features are supported (including mmap preservation
across snapshots).

Git: https://github.com/goldwynr/linux/tree/btrfs-dax

Changes since v2:
 - Created a new type IOMAP_DAX_COW as opposed to flag IOMAP_F_COW
 - CoW source address is presented in iomap.inline_data
 - Split the patches to more elaborate dax/iomap patches

Changes since v1:
 - use iomap instead of redoing everything in btrfs
 - support for mmap writeprotecting on snapshotting


 fs/btrfs/Makefile            |    1 
 fs/btrfs/ctree.h             |   38 +++++
 fs/btrfs/dax.c               |  288 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/disk-io.c           |    4 
 fs/btrfs/file.c              |   37 ++++-
 fs/btrfs/inode.c             |  114 ++++++++++++-----
 fs/btrfs/ioctl.c             |   29 +++-
 fs/btrfs/send.c              |    4 
 fs/btrfs/super.c             |   30 ++++
 fs/dax.c                     |  152 ++++++++++++++++++++--
 fs/iomap.c                   |    9 -
 fs/ocfs2/file.c              |    2 
 fs/read_write.c              |   10 -
 fs/xfs/xfs_reflink.c         |    2 
 include/linux/dax.h          |   13 +
 include/linux/fs.h           |    7 -
 include/linux/iomap.h        |    7 +
 include/trace/events/btrfs.h |   56 ++++++++
 18 files changed, 717 insertions(+), 86 deletions(-)

-- 
Goldwyn


