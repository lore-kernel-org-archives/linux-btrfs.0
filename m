Return-Path: <SRS0=op+e=4M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58291C11D2F
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 15:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 322FE20714
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 15:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgBXP0n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 10:26:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:48988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbgBXP0n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Feb 2020 10:26:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 99939ADBE;
        Mon, 24 Feb 2020 15:26:41 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 0/2] Refactor snapshot vs nocow writers locking
Date:   Mon, 24 Feb 2020 17:26:35 +0200
Message-Id: <20200224152637.30774-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is v3 of the DRW locking patches.

Main changes in this verison:
 * Removed EXPORT_SYMBOL for function since I do not intend to submit the locktorture
 patch
 * Added high-level comment as per David's request.

V2:
* Fixed all checkpatch warnings (Andrea Parri)
* Properly call write_unlock in btrfs_drw_try_write_lock (Filipe Manana)
* Comment fix.
* Stress tested it via locktorture. Survived for 8 straight days on a 4 socket
48 thread machine.

Nikolay Borisov (2):
  btrfs: convert snapshot/nocow exlcusion to drw lock
  btrfs: Hook btrfs' DRW lock to locktorture infrastructure

 fs/btrfs/ctree.h             |  9 +----
 fs/btrfs/disk-io.c           | 46 ++++++---------------
 fs/btrfs/extent-tree.c       | 44 ---------------------
 fs/btrfs/file.c              | 11 +++---
 fs/btrfs/inode.c             |  8 ++--
 fs/btrfs/ioctl.c             | 10 ++---
 fs/btrfs/locking.c           |  5 +++
 fs/btrfs/locking.h           |  1 +
 kernel/locking/locktorture.c | 77 +++++++++++++++++++++++++++++++++++-
 9 files changed, 107 insertions(+), 104 deletions(-)

--
2.17.1

