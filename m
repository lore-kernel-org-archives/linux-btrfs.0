Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987BDC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68C9D2075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:03:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68C9D2075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbeJKWbD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:49674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726071AbeJKWbD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E55D8B62F
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:03:28 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/6] FSID change kernel support
Date:   Thu, 11 Oct 2018 18:03:20 +0300
Message-Id: <1539270206-27005-1-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello, 

Here is the second posting of the fsid change support for the kernel. For 
background information you can refer to v1 [0]. The main changes in this version
are around the handling of possible split-brain scenarios. I've changed a bit 
how the userspace code works and now the process is split among 2 transactions. 
The first one flagging "we are about to change fsid" and once it's persisted on
all disks a second one does the actual change. This of course is not enough 
to guarantee full consistency so I had to extend the device scanning to 
gracefully handle such cases. I believe I have covered everything but more 
review will be appreciated. 

So patch 1 implements the basic functionality with no split-brain handling 
whatsoever. Patch 2 is a minor cleanup. Patch 3 deals with a split-brain that 
can occur if power loss happens during the initial transaction (the one setting
the beginning flag). Patch 4 adds some information that is needed in the last 2 
patches. Patch 5 handles failure between transaction 1 and transaction 2 and 
finally patch 6 handles the case of power loss during transaction 1 but for an 
fs which has already undergone at least one successful fsid change. More 
details about the exact failure modes are in each respective patch.

One thing which could be improved but I ran out of ideas is the naming of the 
ancillary functions - find_fsid_inprogress and find_fsid_changed. 


I've actually tested the split-brain handing code with specially crafted images. 
They will be part of the user-space submissions and I believe I have full 
coverage for that. 

[0] https://lore.kernel.org/linux-btrfs/1535531774-29830-1-git-send-email-nborisov@suse.com/

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

