Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43692 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbbFGLH5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jun 2015 07:07:57 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] sysfs support for the replace of the seed device
Date: Sun,  7 Jun 2015 17:44:31 +0800
Message-Id: <1433670272-1563-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I couldn't add this feature earlier because there was an issue
as reported here: http://www.spinics.net/lists/linux-btrfs/msg41365.html
Now I don't see this bug, however couldn't identify the patch which
fixed it.
moving on, now added sysfs support to support the scenario of
replacing the seed device.

This is on top the patch set sent before:
[PATCH 00/27 V5] provide framework so that sysfs attributes from the fs_devices can be added

Anand Jain (1):
  Btrfs: sysfs support for the replace of the seed device

 fs/btrfs/dev-replace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.4.1

