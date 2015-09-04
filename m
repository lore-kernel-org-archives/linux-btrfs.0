Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38296 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646AbbIDGRj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 02:17:39 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com, eguan@redhat.com
Subject: [PATCH v9 0/3] dm error based test cases
Date: Fri,  4 Sep 2015 14:15:20 +0800
Message-Id: <1441347323-4682-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch 1/3 provides a framework to use dmerror device to
test volume manager operations.
Patch 2/3 adds a test case to test replacing a dmerror device
Patch 3/3 adds a test case to test deleting a dmerror device

This is v9 of this patch set.
In this version it mainly accepts Eryu's review comments with thanks.
For actual change-list please ref to the individual patch.

Anand Jain (3):
  xfstests: btrfs: add functions to create dm-error device
  xfstests: btrfs: test device replace, with EIO on the src dev
  xfstests: btrfs: test device delete with EIO on src dev

 common/dmerror      | 74 +++++++++++++++++++++++++++++++++++++++++++++++
 common/rc           | 20 +++++++++++--
 tests/btrfs/098     | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/098.out | 11 +++++++
 tests/btrfs/099     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/099.out | 11 +++++++
 tests/btrfs/group   |  2 ++
 7 files changed, 279 insertions(+), 2 deletions(-)
 create mode 100644 common/dmerror
 create mode 100755 tests/btrfs/098
 create mode 100644 tests/btrfs/098.out
 create mode 100755 tests/btrfs/099
 create mode 100644 tests/btrfs/099.out

-- 
2.4.1

