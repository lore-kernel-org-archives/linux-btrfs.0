Return-Path: <SRS0=ITJn=CR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FBDC433E2
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 10:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDA4220C09
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 10:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599560916;
	bh=1tVdy1vsBMLkQWIP/D7cNhyMXhZpZgmJy2RifBuj1xM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=QMsV5FyKeEcjavG7cUo3Jl6xOlG+sEQlGed2eWsl7QDq7fKmmqWWic0AYcWf8ipOB
	 6CNrSvVYcMHcZIz7xX9gQORkBeBJ69Jgips9zOspcO2FBztaTMDYNZv9x+2qiXTaBw
	 rspThRz+FfSM8h5mF/S5rIgp8XMpBAO57mOofdsw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgIHK2g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 06:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729573AbgIHK1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Sep 2020 06:27:32 -0400
Received: from falcondesktop.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C86E2208C7;
        Tue,  8 Sep 2020 10:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599560852;
        bh=1tVdy1vsBMLkQWIP/D7cNhyMXhZpZgmJy2RifBuj1xM=;
        h=From:To:Cc:Subject:Date:From;
        b=vzxrIIBocClXRClvgxX5CUVPq7DnYvIbf3ERJYxo3FcQcn2mNEhHYbhznUuiDElIt
         8x1387nVZr+7pMTuZ8vkQE8C9ufjcp26nxFDEe52iSsyt9Zfm3rNw1bswRnoW/w4dE
         sMQb3r+HwBC1xIHmJW2kxLEJOw/j5RmwZCcS5Jjo=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 0/5] btrfs: fix enospc and transaction aborts during fallocate
Date:   Tue,  8 Sep 2020 11:27:19 +0100
Message-Id: <cover.1599560101.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When attempting to fallocate on a large file range with many file extent
items, the operation can fail with ENOSPC when it shouldn't and, more
critical, abort the transaction and turn the filesystem to RO mode.

First patch fixes the issue, the remaining just do some cleanups after it.

Filipe Manana (5):
  btrfs: fix metadata reservation for fallocate that leads to
    transaction aborts
  btrfs: remove item_size member of struct btrfs_clone_extent_info
  btrfs: rename struct btrfs_clone_extent_info to a more generic name
  btrfs: rename btrfs_punch_hole_range() to a more generic name
  btrfs: rename btrfs_insert_clone_extent() to a more generic name

 fs/btrfs/ctree.h   |  28 +++++++++--
 fs/btrfs/file.c    | 119 ++++++++++++++++++++++++++-------------------
 fs/btrfs/inode.c   |  67 ++++++++++++++++---------
 fs/btrfs/reflink.c |   8 +--
 4 files changed, 142 insertions(+), 80 deletions(-)

-- 
2.26.2

