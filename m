Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82820C433EF
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Mar 2022 15:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiCOPX7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 11:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbiCOPX6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Mar 2022 11:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAA4E6C
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2022 08:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A986120C
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2022 15:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6CBC340E8
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2022 15:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647357764;
        bh=6Ekq6U1u6Sx/IRswhOFPqPj4cA23rAhARe34p6QWM14=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Ief5amg8U4dzSgDTyHDZCDaqFsGoje3yEbs4104zmLC9EBzh1tEXCWfrY9YgP1SKD
         ouQHtfc/CGaijspnBnt18nEUDYptHe74cRBdxxLv3v9G/6WnCj5jlthLimlIlKm3SZ
         edHu+QLGHx0VQW27bR7UyGf4KViCgRb8IaiTCl19bRftH307JU6pzd7p3goWPpLt/z
         qXucWwDNdUEFBhGtHr6DIXH8usD8n/9e0gcKuF0k/iHlYCcl2sScEg8ZcWUzgcmK3k
         oHYm3cayVsCzpLjotoDJzZRme7R6cRWdPIiky1KvX2qWfK3c/RSsC7wlWE3Jd0B5w/
         vrgRKN4VOchiQ==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/7] btrfs: one fallocate fix and removing outdated code for fallocate and reflinks
Date:   Tue, 15 Mar 2022 15:22:34 +0000
Message-Id: <cover.1647357395.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1647340917.git.fdmanana@suse.com>
References: <cover.1647340917.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The first patch fixes a bug in fallocate (more details on its changelog),
while the remaining just remove some code and logic that is no longer
needed. The removals/clean ups are independent of the bug fix.

V3: Added missing inode unlock in error path (patch 5/7).
V2: Added one extra patch, 5/7, which was missing in v1. Fixed a typo
    in the changelog of the first patch as well.

Filipe Manana (7):
  btrfs: only reserve the needed data space amount during fallocate
  btrfs: remove useless dio wait call when doing fallocate zero range
  btrfs: remove inode_dio_wait() calls when starting reflink operations
  btrfs: remove ordered extent check and wait during fallocate
  btrfs: lock the inode first before flushing range when punching hole
  btrfs: remove ordered extent check and wait during hole punching and
    zero range
  btrfs: add and use helper to assert an inode range is clean

 fs/btrfs/ctree.h   |   1 +
 fs/btrfs/file.c    | 174 ++++++++++++++++++---------------------------
 fs/btrfs/inode.c   |  37 ++++++++++
 fs/btrfs/reflink.c |  23 +++---
 4 files changed, 118 insertions(+), 117 deletions(-)

-- 
2.33.0

