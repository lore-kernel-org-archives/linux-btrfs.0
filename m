Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38950 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751672AbaEKBwb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 21:52:31 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49735 helo=[192.168.1.120])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WjIw3-002jYk-25
	for linux-btrfs@vger.kernel.org; Sat, 10 May 2014 19:52:15 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: bug adding device to seed device, btrfs fi show fails
Message-Id: <29B81ECC-8877-4BBB-9701-1CB5C46717ED@colorremedies.com>
Date: Sat, 10 May 2014 19:51:59 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel 3.15.0-0.rc5.git0.1.fc21.x86_64
btrfs-progs 3.14

/dev/sdb2 = existing btrfs fs
/dev/sdc3 = unformatted partition


# btrfstune -S1 /dev/sdb2
# mount /dev/sdb2 /mnt
mount: /dev/sdb2 is write-protected, mounting read-only
# btrfs device add /dev/sdc3 /mnt
Performing full device TRIM (75.90GiB) ...
# btrfs fi show
Label: 'rawhide'  uuid: d372e5d1-386f-460c-b036-611469e0155e
	Total devices 1 FS bytes used 7.55GiB
	devid    1 size 79.31GiB used 11.04GiB path /dev/sda3

btrfs: utils.c:1769: get_fs_info: Assertion `!(ndevs >= fi_args->num_devices)' failed.

Nothing listed in dmesg.