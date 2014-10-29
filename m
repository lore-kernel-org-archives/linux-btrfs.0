Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48120 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753465AbaJ2CTl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 22:19:41 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:50602 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XjIrN-0040yX-4C
	for linux-btrfs@vger.kernel.org; Tue, 28 Oct 2014 20:19:41 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: [bug] df reports wrong Size and Avail on raid1, 3.18rc2
Message-Id: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
Date: Tue, 28 Oct 2014 20:19:40 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

3.18.0-0.rc2.git1.1.fc22.x86_64
btrfs-progs-3.17-1.fc21.x86_64

# btrfs fi show /mnt
Label: 'btrfs1'  uuid: 0f1c615f-30a0-4166-8a3c-987849551513
	Total devices 2 FS bytes used 233.54GiB
	devid    1 size 465.76GiB used 236.03GiB path /dev/sdb
	devid    2 size 298.09GiB used 236.03GiB path /dev/sdc

# df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb        382G  234G   65G  79% /mnt


a. df -h should report Size as 298GiB rather than as 382GiB.
Because this is 2 device raid1, the limiting factor is devid 2 @ 298GiB.

b. df -h should report Avail as 62GiB or less, rather than as 65GiB.
298.09 - 236.03 = 62.06


Chris Murphy
