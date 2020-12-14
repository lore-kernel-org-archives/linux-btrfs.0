Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A56C1B0E3
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Dec 2020 10:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD19225A9
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Dec 2020 10:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgLNKLc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Dec 2020 05:11:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbgLNKLc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Dec 2020 05:11:32 -0500
From:   fdmanana@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs: fix transaction leaks and crashes during unmount
Date:   Mon, 14 Dec 2020 10:10:44 +0000
Message-Id: <cover.1607940240.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

There are some cases where we can leak a transaction and crash during unmount
after remounting the filesystem in RO mode or mounting RO. These issues were
actually being hit by automated tests from the openQA for openSUSE Tumbleweed
(bugzilla https://bugzilla.suse.com/show_bug.cgi?id=1164503).

Filipe Manana (5):
  btrfs: fix transaction leak and crash after RO remount caused by
    qgroup rescan
  btrfs: fix transaction leak and crash after cleaning up orphans on RO
    mount
  btrfs: fix race between RO remount and the cleaner task
  btrfs: add assertion for empty list of transactions at late stage of
    umount
  btrfs: run delayed iputs when remounting RO to avoid leaking them

 fs/btrfs/ctree.h   | 20 +++++++++++++++++++-
 fs/btrfs/disk-io.c | 13 ++++++++-----
 fs/btrfs/qgroup.c  | 13 ++++++++++---
 fs/btrfs/super.c   | 40 +++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.c |  4 ++--
 5 files changed, 76 insertions(+), 14 deletions(-)

-- 
2.28.0

