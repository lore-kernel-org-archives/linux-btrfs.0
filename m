Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53520 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752103AbaETQ42 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 12:56:28 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49449 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WmnL1-0029yV-FI
	for linux-btrfs@vger.kernel.org; Tue, 20 May 2014 10:56:27 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs check, btrfsck, fsck.btrfs
Message-Id: <9B5A4230-5A2F-4C00-AC4F-D9CA36A91620@colorremedies.com>
Date: Tue, 20 May 2014 10:56:26 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Should the initrd/initramfs no longer include btrfsck, and instead include btrfs and fsck.btrfs?

In btrfs-progs 3.14 there is now a 1K /sbin/fsck.btrfs placeholder file.

btrfs and btrfsck files are the same binary, the difference is btrfsck only can do check/repair. Including btrfs instead allows more flexibility to use additional subcommands, and it's also consistent with fsck.btrfs which references btrfs not btrfsck.


Chris Murphy