Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79511C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 06:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B14020664
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 06:04:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B14020664
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbeKZQ5w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 11:57:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:43090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726145AbeKZQ5v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 11:57:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6A1FCAF41
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 06:04:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs-progs: check update
Date:   Mon, 26 Nov 2018 14:04:38 +0800
Message-Id: <20181126060438.26075-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi David,

Please merge this pull request:
https://github.com/kdave/btrfs-progs/pull/155


This patch can be fetch from the following branch:
https://github.com/adam900710/btrfs-progs/tree/check-next

The base commit is:
commit 5d64c40240135cc22f4ba2b902bfe20418a599ea (david/devel)
Author: David Sterba <dsterba@suse.com>
Date:   Tue Nov 20 11:13:08 2018 +0100

    btrfs-progs: docs: fix rendering of exponents in manual pages
    
    Reported on IRC that the inode number limit appears to be 264, while the
    actual value is 2^64. Fix that for the manual page backend by redefining
    the format.
    
    Signed-off-by: David Sterba <dsterba@suse.com>


This small patchset contains 2 check related functionality:
1) Ability to repair dir item with mismatch hash
   Both lowmem and original check, along with test case update.

2) Check qgroup limit exceed
   The patch to deprecate BTRFS_QGROUP_LIMIT_RSV_RFER|EXCL is dropped
   for this pull request, as it's still uncertain if it's OK or not, and
   it's very easy to rebase that patch.

The patchset passes all selftest with one exception:
misc-tests/021-image-multi-devices

That test case failure is caused by poorly recovered multi-device
btrfs-image.
The problem exists from the very beginning, just recent enhanced kernel
code will refuse to mount and I'll address it later in another patchset.

There is some other check related patches, naming "btrfs-progs: fixes of
file extent in original and lowmem check" from Fujitsu, which is still
being updated. I'll push them in next update.

Thanks,
Qu

Qu Wenruo (5):
  btrfs-progs: lowmem check: Add ability to repair dir item with
    mismatch hash
  btrfs-progs: original check: Use mismatch_dir_hash_record to record
    bad dir items
  btrfs-progs: original check: Add ability to repair dir item with
    invalid hash
  btrfs-progs: fsck-tests: Make 026-bad-dir-item-name test case to
    verify if btrfs-check can also repair it
  btrfs-progs: qgroup-verify: Check if qgroup limit is exceeded

 check/main.c                                  | 121 +++++++++++++++++-
 check/mode-common.c                           |  51 ++++++++
 check/mode-common.h                           |   5 +-
 check/mode-lowmem.c                           |  46 ++++++-
 check/mode-lowmem.h                           |   1 +
 check/mode-original.h                         |  14 ++
 ctree.h                                       |   3 +
 dir-item.c                                    |   6 +-
 qgroup-verify.c                               |  82 ++++++++++++
 .../026-bad-dir-item-name/description.txt     |  41 ++++++
 .../fsck-tests/026-bad-dir-item-name/test.sh  |  13 --
 11 files changed, 354 insertions(+), 29 deletions(-)
 create mode 100644 tests/fsck-tests/026-bad-dir-item-name/description.txt
 delete mode 100755 tests/fsck-tests/026-bad-dir-item-name/test.sh

-- 
2.19.2

