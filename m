Return-Path: <SRS0=R6Ud=C3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC85C43467
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8C4D2083B
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:16:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=suse.com header.i=@suse.com header.b="HSp3ggDW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgIRJP6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:15:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:52128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgIRJPz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Sep 2020 05:15:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600420554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=jPkvXNzqUdBl1f73RHDsBjrXL3LcfI3KjFoMCkQ84Q8=;
        b=HSp3ggDWJ1CziiukA8+9JIN4KVQa2uyIPks0WRuugA3dc1lNCa2GJHr5Vh9xnOOMuMvJAF
        q1ayO9wtsbb5T8Mk+R6wpEbsL+aPRgOBffWvBQSs1vZD0LwA44bZd2Wca8BYEUU0o5AUP4
        ADlL+ulPbS08hEFaE6chtZzavB+MDpg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9D147ACAC;
        Fri, 18 Sep 2020 09:16:28 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/5] Low risc cleanups
Date:   Fri, 18 Sep 2020 12:15:48 +0300
Message-Id: <20200918091553.29584-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here's an assortment of cleanups - mainly dealing with removing redundant
arguments of some functions. Pretty self-explanatory.

Nikolay Borisov (5):
  btrfs: Clean BTRFS_I usage in btrfs_destroy_inode
  btrfs: Switch btrfs_remove_ordered_extent to btrfs_inode
  btrfs: Sink inode argument in insert_ordered_extent_file_extent
  btrfs: Remove inode argument from add_pending_csums
  btrfs: Remove inode argument from btrfs_start_ordered_extent

 fs/btrfs/file.c         |  3 +-
 fs/btrfs/inode.c        | 67 ++++++++++++++++++++---------------------
 fs/btrfs/ioctl.c        |  2 +-
 fs/btrfs/ordered-data.c | 22 ++++++--------
 fs/btrfs/ordered-data.h |  5 ++-
 5 files changed, 47 insertions(+), 52 deletions(-)

--
2.17.1

