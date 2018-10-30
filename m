Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4EAC2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 14:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17A342075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 14:43:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17A342075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbeJ3XhQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 19:37:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:42298 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbeJ3XhQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 19:37:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 360BBB0E4
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 14:43:31 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 0/6] FSID change kernel support
Date:   Tue, 30 Oct 2018 16:43:22 +0200
Message-Id: <1540910608-4121-1-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is the 3rd submission for the kernel counterpart of the uuid change 
patchset. The only difference is that I (hope) have adressed all cosmetic 
feedback from David as well as have reworded some change logs to ease 
understanding. I've also re-run the regression tests and no failure were 
obsered. 

For background information refer to first posting [0] and the second one [1]

[0] https://lore.kernel.org/linux-btrfs/1535531754-29774-1-git-send-email-nborisov@suse.com/
[1] https://lore.kernel.org/linux-btrfs/1539270244-27076-1-git-send-email-nborisov@suse.com/

Nikolay Borisov (6):
  btrfs: Introduce support for FSID change without metadata rewrite
  btrfs: Remove fsid/metadata_fsid fields from btrfs_info
  btrfs: Add handling for disk split-brain scenario during fsid change
  btrfs: Introduce 2 more members to struct btrfs_fs_devices
  btrfs: Handle one more split-brain scenario during fsid change
  btrfs: Handle final split-brain possibility during fsid change

 fs/btrfs/check-integrity.c      |   2 +-
 fs/btrfs/ctree.c                |   5 +-
 fs/btrfs/ctree.h                |  10 +-
 fs/btrfs/disk-io.c              |  53 ++++++++---
 fs/btrfs/extent-tree.c          |   2 +-
 fs/btrfs/ioctl.c                |   2 +-
 fs/btrfs/super.c                |   2 +-
 fs/btrfs/volumes.c              | 196 ++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.h              |   6 ++
 include/trace/events/btrfs.h    |   2 +-
 include/uapi/linux/btrfs.h      |   1 +
 include/uapi/linux/btrfs_tree.h |   1 +
 12 files changed, 241 insertions(+), 41 deletions(-)

-- 
2.7.4

