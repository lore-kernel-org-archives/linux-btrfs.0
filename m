Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C28C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF27E20700
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbfCZTJM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:09:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:37594 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726278AbfCZTJM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:09:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06F27AF79;
        Tue, 26 Mar 2019 19:09:11 +0000 (UTC)
Date:   Tue, 26 Mar 2019 14:09:08 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 00/15] btrfs dax support
Message-ID: <20190326190908.uz5rqakhr5er3r3z@merlin>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-1-rgoldwyn@suse.de>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Sorry, messed up the subject the first time.

This patch set adds support for dax on the BTRFS filesystem.
In order to support for CoW for btrfs, there were changes which had to be
made to the dax handling. The important one is copying blocks into the
same dax device before using them.

I have some doubts: I have put them in patch headers of the individual
patches.

Git: https://github.com/goldwynr/linux/tree/btrfs-dax

Changes since V1:
- use iomap instead of redoing everything in btrfs
- support for mmap writeprotecting on snapshotting


 fs/btrfs/Makefile            |    1 
 fs/btrfs/ctree.h             |   32 +++++-
 fs/btrfs/dax.c               |  225 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/disk-io.c           |    4 
 fs/btrfs/file.c              |   34 +++++-
 fs/btrfs/inode.c             |  114 ++++++++++++++++-----
 fs/btrfs/ioctl.c             |   31 +++++
 fs/btrfs/send.c              |    4 
 fs/btrfs/super.c             |   26 ++++
 fs/dax.c                     |  164 ++++++++++++++++++++++++++++---
 fs/iomap.c                   |    9 -
 fs/ocfs2/file.c              |    2 
 fs/read_write.c              |    9 +
 fs/xfs/xfs_reflink.c         |    2 
 include/linux/dax.h          |   13 +-
 include/linux/fs.h           |    4 
 include/linux/iomap.h        |    9 +
 include/trace/events/btrfs.h |   56 ++++++++++
 18 files changed, 662 insertions(+), 77 deletions(-)

-- 
Goldwyn
