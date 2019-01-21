Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EE4C282DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 07:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 090DA20989
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 07:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfAUHfU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:35:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:58258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728470AbfAUHfT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 02:35:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 404CFACD2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 07:35:18 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: Introduce new rescue= mount options
Date:   Mon, 21 Jan 2019 15:35:09 +0800
Message-Id: <20190121073512.17675-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/rescue_options

There are quite some btrfs extent tree corruption report in the mail
list.
Since btrfs will do mount time block group item search, one corrupted
leaf containing block group item will prevent the whole fs to be
mounted.

This patchset will try to address the problem by introducing a new mount
option, "rescue=skip_bg", as a last-resort rescue.
Of course this option will have a lot of restriction to prevent further
screwing up the fs, including:
- Permanent RO
  No remount rw is allowed

- No dirty log
  Either clean the log or use rescue=no_log_replay mount option

This "rescue=skip_bg" has some advantage compared to user space tool
like "btrfs-restore":
- Unified recovery tool
  User can use any tool they're familiar with, as long as the kernel
  doesn't panic.

- More info for subvolume.
  "btrfs subv list" can word now!


Although, move the following mount options to "rescue=" mount option:
- nologreplay
  to rescue=no_log_replay

- usebackuproot
  to rescue=use_backup_root

Old options are still available for compatibility purpose, but they are
deprecated in favor of new 'rescue=' super option.

Also different rescue sub options can be separated by ':', like:
"rescue=no_log_replay:skip_bg:use_backup_root".

The separation character is chosen by:
- No conflicts with existing character
  Especially no conflict with ','.

- No extra escaping/quota
  Original plan is ';', but since it'll be interpreted by bash, it's
  changed to current ':'.

Changelog:
v2:
- Introduce 'rescue=' super option.
- Rename original 'usebackuproot' and 'nologreplay'.
  It at least makes my vim spell check happier.
- Remove 'recovery' mount option.
  As its successor is now deprecated, not need to keep the predecessor.

Qu Wenruo (3):
  btrfs: Remove "recovery" mount option
  btrfs: Introduce "rescue=" mount option
  btrfs: Introduce new mount option to skip block group items scan

 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/disk-io.c     | 29 +++++++++++--
 fs/btrfs/extent-tree.c | 59 ++++++++++++++++++++++++++
 fs/btrfs/super.c       | 96 ++++++++++++++++++++++++++++++++++++------
 fs/btrfs/volumes.c     |  7 +++
 5 files changed, 176 insertions(+), 16 deletions(-)

-- 
2.20.1

