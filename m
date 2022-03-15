Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0482C43217
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Mar 2022 10:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345173AbiCOKuU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 06:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348527AbiCOKtc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Mar 2022 06:49:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C48D50B3F
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2022 03:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBC00B81230
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2022 10:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5659C340E8
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2022 10:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647341235;
        bh=bxU+N+5RElol/dNZItcdxNIWygmw5i2gi9qMmg9tYb4=;
        h=From:To:Subject:Date:From;
        b=i6bB9NTOiejE1QnfWqz9mN6O+xE4FepX3xmPBr28i2qRITysR/1kogSTXfP6Ak7jS
         M5qd0SZS6K8D9WQvx56zB407Mnb4mJfuTFyX8qSs0OyBnQqutAzRMw6IOGuqfhLJgQ
         h/BoTItO0hasDS7c2jMnPLCeFxpYPj08LNmWDvneFm1aohw2Lt9gI0p9vMEMXeLKPg
         IP4QzOOAsh5MUswifdDKxR7GK4z6tYuiGwd2nMxJgU+J0Rp7Be+w2iGtEje1WRqcqU
         Ad+H9xBo47ih45uIFP22cLc14ZOImND0GMrhY6NayguV0Nv7osjX3Bx9XnLx9WIWqQ
         piK3ydA2e59Ew==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs: one fallocate fix and removing outdated code for fallocate and reflinks
Date:   Tue, 15 Mar 2022 10:47:05 +0000
Message-Id: <cover.1647340917.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The first patch fixes a bug in fallocate (more details on its changelog),
while the remaining just remove some code and logic that is no longer
needed. The removals/clean ups are independent of the bug fix.

Filipe Manana (6):
  btrfs: only reserve the needed data space amount during fallocate
  btrfs: remove useless dio wait call when doing fallocate zero range
  btrfs: remove inode_dio_wait() calls when starting reflink operations
  btrfs: remove ordered extent check and wait during fallocate
  btrfs: remove ordered extent check and wait during hole punching and
    zero range
  btrfs: add and use helper to assert an inode range is clean

 fs/btrfs/ctree.h   |   1 +
 fs/btrfs/file.c    | 169 ++++++++++++++++++---------------------------
 fs/btrfs/inode.c   |  37 ++++++++++
 fs/btrfs/reflink.c |  23 +++---
 4 files changed, 115 insertions(+), 115 deletions(-)

-- 
2.33.0

