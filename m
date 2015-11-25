Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40896 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbbKYMIo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:08:44 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
Subject: [PATCH 0/7] Let user specify the kernel version for features
Date: Wed, 25 Nov 2015 20:08:13 +0800
Message-Id: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes users may want to have a btrfs to be supported on multiple
kernel version. A simple example, USB drive can be used with multiple
system running different kernel versions. Or in a data center a SAN
LUN could be mounted on any system with different kernel version.

Thanks for providing comments and feedback.
Further to it, here below is a set of patch which will introduce, to
specify a kernel version so that default features can be set based on
what features were supported at that kernel version.

First of all to let user know what features was supported at what kernel
version. Patch 1/7 updates -O list-all which will list the feature with
version.

As we didn't maintain the sysfs and progs feature names consistent, so
to avoid confusion Patch 2/7 displays sysfs feature name as well again
in the list-all output.

Next, Patch 3,4,5/7 are helper functions.

Patch 6,7/7 provides the -O comp=<version> for mkfs.btrfs and
btrfs-convert respectively

Thanks, Anand

Anand Jain (7):
  btrfs-progs: show the version for -O list-all
  btrfs-progs: add kernel alias for each of the features in the list
  btrfs-progs: make is_numerical non static
  btrfs-progs: check for numerical in version_to_code()
  btrfs-progs: introduce framework version to features
  btrfs-progs: add -O comp= option for mkfs.btrfs
  btrfs-progs: add -O comp= option for btrfs-convert

 btrfs-convert.c | 21 +++++++++++++++++++++
 cmds-replace.c  | 11 -----------
 mkfs.c          | 24 ++++++++++++++++++++++--
 utils.c         | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 utils.h         |  2 ++
 5 files changed, 98 insertions(+), 18 deletions(-)

-- 
2.6.2

