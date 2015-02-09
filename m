Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22265 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbbBIHGI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:06:08 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 0/4 v2] test-btrfs-devmgt.sh
Date: Mon,  9 Feb 2015 15:05:02 +0800
Message-Id: <1423465506-30934-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

simple controllable test script to exercise btrfs devices and at the same time collect sysfs (optional) to test for regression.

v1->v2: add some clean ups

Anand Jain (4):
  Btrfs-progs: add regression tests for sysfs contents during btrfs
    device management
  Btrfs-progs: adds simple to use seed test for test-btrfs-devmgt.sh
  Btrfs-progs: test-btrfs-devmgt.sh support if btrfs is root fs
  Btrfs-progs: test-btrfs-devmgt.sh have a safe defaults

 tests/test-btrfs-devmgt.sh | 935 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 935 insertions(+)
 create mode 100755 tests/test-btrfs-devmgt.sh

-- 
1.9.1

