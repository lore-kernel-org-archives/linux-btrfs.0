Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35287 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755489AbaDTUS6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 16:18:58 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:63118 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WbyCX-000rVY-Gz
	for linux-btrfs@vger.kernel.org; Sun, 20 Apr 2014 14:18:57 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs fi df "unknown"
Message-Id: <9C28A5D6-F223-400F-9471-85C0F88FA939@colorremedies.com>
Date: Sun, 20 Apr 2014 14:18:56 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel 3.15.0-0.rc1.git0.1.fc21.x86_64
btrfs-progs v3.14

One 80GB virtual disk, formatted btrfs by installer and Fedora Rawhide installed to it. Post-install I see:

[root@localhost ~]# btrfs fi show
Label: 'fedora'  uuid: d372e5d1-386f-460c-b036-611469e0155e
	Total devices 1 FS bytes used 4.00GiB
	devid    1 size 79.31GiB used 6.04GiB path /dev/sda3

Btrfs v3.14
[root@localhost ~]# btrfs fi df /
Data, single: total=4.01GiB, used=3.79GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.00GiB, used=215.69MiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=80.00MiB, used=0.00


What is unknown?


Chris Murphy