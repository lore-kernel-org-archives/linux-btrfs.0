Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24820 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbbJJObZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 10:31:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH RESEND 0/3] btrfs-progs: Introduce device delete by devid
Date: Sat, 10 Oct 2015 22:30:55 +0800
Message-Id: <1444487458-2988-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the btrfs-progs part of the kernel patch
   Btrfs: Introduce device delete by devid

1/3 and 2/3 are preparatory patches to apply 3/3 below.

Anand Jain (3):
  btrfs-progs: Create is_numerical() helper function
  btrfs-progs: Code optimize and cleanup device add
  btrfs-progs: Introduce device delete by devid

 Documentation/btrfs-device.asciidoc |  4 +--
 cmds-device.c                       | 60 ++++++++++++++++++++++++++-----------
 cmds-replace.c                      | 11 -------
 ioctl.h                             | 14 ++++++++-
 utils-lib.c                         | 11 +++++++
 utils.h                             |  1 +
 6 files changed, 70 insertions(+), 31 deletions(-)

-- 
2.4.1

