Return-Path: <SRS0=iRg2=DB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE154C4363D
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B1E72395C
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgIXQji (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:39:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:35796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgIXQji (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Sep 2020 12:39:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7F965ABD1;
        Thu, 24 Sep 2020 16:39:36 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        johannes.thumshirn@wdc.com, dsterba@suse.com,
        darrick.wong@oracle.com, josef@toxicpanda.com
Subject: [PATCH 0/14 v3] BTRFS DIO inode locking/D_SYNC fix
Date:   Thu, 24 Sep 2020 11:39:07 -0500
Message-Id: <20200924163922.2547-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This series attempts to arrange inode locking and unlocking to be more
aligned to ext4 and xfs handling of things, and makes it simpler in
logic. The main goal is to have shared inode lock for direct reads and
direct writes within EOF to make sure we do not race with truncate.

I have merged two series here:
(1) Using inode_lock_shared for <EOF DIO writes
(2) Fix O_DSYNC | O_DIRECT

Both require inode locking to be pushed closer to I/O calls and thought
was relevant. (2) requires changes in iomap code.

Tested xfstests on btrfs, ext4 and xfs

Git: https://github.com/goldwynr/linux/tree/btrfs-inode-lock

Changes since v1:

 - Changed fix for deadlock due to O_DSYNC (iomap patches added)
 - btrfs_inode_lock() shifted to inode.c
 - Reinstated lockdep_assert_held() in iomap_dio_rw()

Changes since v2:
 - Review comments incorporated:
   - comments got BTRFS_SUPER_FLAG_ERROR deleted
   - Function comments for btrfs_inode_lock()/unlock()
   - Unsetting current->backing_dev_info
 - Corrected ret from __iomap_dio_rw()
 - Removed unused err in btrfs_file_write_iter()

--
Goldwyn



