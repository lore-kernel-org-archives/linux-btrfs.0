Return-Path: <SRS0=1OQK=CF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E91CC433E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Aug 2020 15:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33AFA20678
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Aug 2020 15:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgH0PE5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 11:04:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:44530 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgH0PEa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Aug 2020 11:04:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3BB0EAC2B;
        Thu, 27 Aug 2020 15:05:01 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/1 NOT FOR MERGE] Basic subdir tracking in nlink
Date:   Thu, 27 Aug 2020 18:04:23 +0300
Message-Id: <20200827150426.23842-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here are the various bits and pieces needed to have a full-fledged subdir
tracking in nlink. The kernel code is complete and the accompanying fstests
proves that. Nevertheless, progs would need a bit more work, with the attached
progs patch I get only the following tests failing due to progs' nlink code:
	generic/077, generic/107, generic/498 and generic/547

At this point I won't be working anymore on this unless there is a really
compelling argument to do so, however I'm sending the patches now so that if
anyone should feel inclined to finish the work they they can base their efforts
on mine. At this point what's left is:

* Decide how old kernels are supposed to be supported - tree-checker won't allow
them too mount an fs whose hard link counter for directories is != 1. This would
either require an incompat_ro flag or a coordinated effort to backport the patch
to LTS kernels.

* The remaining fstests failures need to be investigated and fixed.

* btrfs-progs lowmem mode would likely consider a filesystem broken so it will
also need to be adjusted.

Nikolay Borisov (1):
  btrfs: Track subdirectories in nlink

 fs/btrfs/inode.c        | 13 +++++++++++--
 fs/btrfs/ioctl.c        | 10 +++++++---
 fs/btrfs/transaction.c  | 12 ++++++++----
 fs/btrfs/tree-checker.c |  7 +------
 4 files changed, 27 insertions(+), 15 deletions(-)

--
2.17.1

