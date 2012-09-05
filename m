Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:42060 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356Ab2IEJVU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2012 05:21:20 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <wuzhy@linux.vnet.ibm.com>;
	Wed, 5 Sep 2012 03:21:19 -0600
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 0/2] btrfs-progs: some bugfixes 
Date: Wed,  5 Sep 2012 17:21:05 +0800
Message-Id: <1346836867-1060-1-git-send-email-wuzhy@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  Some misc bugs are found when i work on other tasks.
Now send out them for interview, thanks.

Zhi Yong Wu (2):
  btrfs-progs: Close file descriptor on exit
  btrfs-progs: Fix up memory leakage

 cmds-filesystem.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

-- 
1.7.6.5

