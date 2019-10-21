Return-Path: <SRS0=SF3a=YO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71C1CA9EB5
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Oct 2019 09:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93745206C2
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Oct 2019 09:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfJUJiD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 05:38:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:37914 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726977AbfJUJiD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Oct 2019 05:38:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8F494B8F6
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2019 09:38:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: check: Introduce optional argument for -b|--backup
Date:   Mon, 21 Oct 2019 17:37:52 +0800
Message-Id: <20191021093755.56835-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Before this patchset, if we want to use backup roots, it's only possible
to let btrfs-check to automatically choose the backup.

If user want to use a specified backup, it can only use -r|--tree-root
option along with backup roots dump from "btrfs ins dump-super".

This patchset will introduce optional argument for -b|--backup, so user
can specify which backup to use by providing the generation difference
(-3, -2, -1).

If the optional argument is not provided, the default value is -1, and
the behavior should be pretty much the same.

Qu Wenruo (3):
  btrfs-progs: utils-lib: Use error() to replace fprintf(stderr, "ERROR:
    ")
  btrfs-progs: disk-io: Handle backup root more correctly
  btrfs-progs: check: Introduce optional argument for -b|--backup

 Documentation/btrfs-check.asciidoc |  6 ++--
 check/main.c                       | 33 +++++++++++++++---
 common/utils.h                     |  1 +
 ctree.h                            |  8 +++++
 disk-io.c                          | 55 ++++++++++++++++++++++++------
 disk-io.h                          | 33 +++++++++++-------
 utils-lib.c                        | 25 +++++++++++---
 7 files changed, 127 insertions(+), 34 deletions(-)

-- 
2.23.0

