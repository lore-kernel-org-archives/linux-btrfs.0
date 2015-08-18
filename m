Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44270 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbHRGsJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 02:48:09 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com, eguan@redhat.com,
        fdmanana@gmail.com
Subject: [PATCH v7 0/3] dm error based test cases
Date: Tue, 18 Aug 2015 14:47:41 +0800
Message-Id: <1439880464-23887-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is v7 of this patch set.
Mainly accepts Dave's latest review comments with thanks.
For actual change-list please ref to the individial patch. 

Anand Jain (3):
  xfstests: btrfs: add functions to create dm-error device
  xfstests: btrfs: test device replace, with EIO on the src dev
  xfstests: btrfs: test device delete with EIO on src dev

 common/dmerror      | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 common/rc           |  7 +++++
 tests/btrfs/098     | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/098.out | 11 +++++++
 tests/btrfs/099     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/099.out | 11 +++++++
 tests/btrfs/group   |  2 ++
 7 files changed, 265 insertions(+)
 create mode 100644 common/dmerror
 create mode 100755 tests/btrfs/098
 create mode 100644 tests/btrfs/098.out
 create mode 100755 tests/btrfs/099
 create mode 100644 tests/btrfs/099.out

-- 
2.4.1

