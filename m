Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9767C4361B
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Dec 2020 18:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC69122ADC
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Dec 2020 18:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgLOSHT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Dec 2020 13:07:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:58344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729683AbgLOSHS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Dec 2020 13:07:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0BAB9AC7F;
        Tue, 15 Dec 2020 18:06:37 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, hch@infradead.org, nborisov@suse.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH v2 0/2] Fix locking for btrfs direct writes
Date:   Tue, 15 Dec 2020 12:06:34 -0600
Message-Id: <cover.1608053602.git.rgoldwyn@suse.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

BTRFS direct write takes the inode lock for performing the direct write.
In case of a failure or an incomplete write, it falls back to buffered
writes. Before initiating the buffered write, it releases the inode lock
and reacquires it for buffered write. This may lead to corruption if
another process attempts to write around the same offset between the
unlock and the relock. The patches change the flow so that the lock is
taken only once before the write and released only after the I/O is
complete.


Goldwyn Rodrigues (2):
  iomap: Separate out generic_write_sync() from iomap_dio_complete()
  btrfs: Make btrfs_direct_write atomic with respect to inode_lock

 fs/btrfs/file.c       | 69 +++++++++++++++++++++++++------------------
 fs/iomap/direct-io.c  | 16 ++++++++--
 include/linux/iomap.h |  2 +-
 3 files changed, 54 insertions(+), 33 deletions(-)

-- 
2.29.2

