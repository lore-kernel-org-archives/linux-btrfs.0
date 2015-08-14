Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39893 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbbHNKrV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:47:21 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH v5 0/3] dm error based test cases
Date: Fri, 14 Aug 2015 18:47:01 +0800
Message-Id: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is v5 of this patch set. Mainly accepts Filipe latest review comments.

Anand Jain (3):
  xfstests: btrfs: add functions to create dm-error device
  xfstests: btrfs: test device replace, with EIO on the src dev
  xfstests: btrfs: test device delete with EIO on src dev

 common/dmerror      | 69 ++++++++++++++++++++++++++++++++++++++++++++
 common/rc           | 16 +++++++++++
 tests/btrfs/098     | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/098.out | 11 +++++++
 tests/btrfs/099     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/099.out | 11 +++++++
 tests/btrfs/group   |  2 ++
 7 files changed, 272 insertions(+)
 create mode 100644 common/dmerror
 create mode 100755 tests/btrfs/098
 create mode 100644 tests/btrfs/098.out
 create mode 100755 tests/btrfs/099
 create mode 100644 tests/btrfs/099.out

-- 
2.4.1

