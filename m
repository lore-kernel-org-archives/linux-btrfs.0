Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:48919 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2IYCCy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 22:02:54 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 24 Sep 2012 20:02:54 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jbacik@fusionio.com, dave@jikos.cz,
        linuxram@linux.vnet.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [resend][PATCH v2 0/2] btrfs-progs: some bugfixes 
Date: Tue, 25 Sep 2012 10:02:14 +0800
Message-Id: <1348538536-29838-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Some misc bugs are found when i work on other tasks.
Now send out them for interview, thanks.

Zhi Yong Wu (2):
  btrfs-progs: Close file descriptor on exit
  btrfs-progs: Fix up memory leakage

 cmds-filesystem.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

-- 
1.7.6.5

