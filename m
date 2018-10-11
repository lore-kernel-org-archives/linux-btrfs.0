Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C6DC4161D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E91C92075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E91C92075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbeJKWbl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:50018 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726843AbeJKWbl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E419EACB5
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:04:06 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/8] FSID change userspace v2
Date:   Thu, 11 Oct 2018 18:03:56 +0300
Message-Id: <1539270244-27076-1-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is the second posting of the FSID change support for user space. For 
background information refer to the the initial posting [0]. The major changes
in this version are: 
 - Modified the sequence of operations when changing the fsid. Now it's split
 among 2 transactions with the first one setting a flag (similarly to what 
 the old fsid change code does) and the second transaction applying the new 
 FSID and incompat flag

 - Expanded the test coverage with several crafted images which simulate 
 failure scenarios that could occur while fsid change is in progress. 

 - Also added the last 2 clean up patches which can be merged independently of
 the fsid changes.



[0] https://lore.kernel.org/linux-btrfs/1535531754-29774-1-git-send-email-nborisov@suse.com/
Nikolay Borisov (8):
  btrfstune: Remove fs_info arg from change_device_uuid
  btrfstune: Rename change_header_uuid to change_buffer_header_uuid
  btrfs-progs: Add support for metadata_uuid field.
  btrfstune: Add support for changing the user uuid
  btrfs-progs: tests: Add tests for changing fsid feature
  btrfs-progs: Remove fsid/metdata_uuid fields from fs_info
  btrfs-progs: Remove btrfs_fs_info::new_fsid
  btrfs-progs: Directly pass root to change_devices_uuid

 btrfstune.c                                     | 237 ++++++++++++++++++------
 check/main.c                                    |   2 +-
 chunk-recover.c                                 |  17 +-
 cmds-filesystem.c                               |   2 +
 cmds-inspect-dump-super.c                       |  22 ++-
 convert/common.c                                |   2 +
 ctree.c                                         |  15 +-
 ctree.h                                         |  10 +-
 disk-io.c                                       |  62 +++++--
 image/main.c                                    |  25 ++-
 tests/misc-tests/033-metadata-uuid/disk1.raw.xz | Bin 0 -> 78336 bytes
 tests/misc-tests/033-metadata-uuid/disk2.raw.xz | Bin 0 -> 77664 bytes
 tests/misc-tests/033-metadata-uuid/disk3.raw.xz | Bin 0 -> 78328 bytes
 tests/misc-tests/033-metadata-uuid/disk4.raw.xz | Bin 0 -> 77592 bytes
 tests/misc-tests/033-metadata-uuid/disk5.raw.xz | Bin 0 -> 78348 bytes
 tests/misc-tests/033-metadata-uuid/disk6.raw.xz | Bin 0 -> 77552 bytes
 tests/misc-tests/033-metadata-uuid/test.sh      | 225 ++++++++++++++++++++++
 volumes.c                                       |  37 +++-
 volumes.h                                       |   1 +
 19 files changed, 557 insertions(+), 100 deletions(-)
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk1.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk2.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk3.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk4.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk5.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk6.raw.xz
 create mode 100755 tests/misc-tests/033-metadata-uuid/test.sh

-- 
2.7.4

