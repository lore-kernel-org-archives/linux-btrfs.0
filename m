Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.smcindiaonline.com ([59.144.72.228]:39823 "EHLO
	mail2.smcindiaonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751371Ab3LIKa5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 05:30:57 -0500
Received: from mail2.smcindiaonline.com (localhost [127.0.0.1])
	by mail2.smcindiaonline.com (8.14.7/8.14.7) with ESMTP id rB99pYs5008234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Dec 2013 15:21:34 +0530
Received: (from vikram@localhost)
	by mail2.smcindiaonline.com (8.14.7/8.14.7/Submit) id rB99pYOx008233
	for linux-btrfs@vger.kernel.org; Mon, 9 Dec 2013 15:21:34 +0530
Date: Mon, 9 Dec 2013 15:21:34 +0530
From: Vikram Goyal <vikram@smcindiaonline.com>
To: linux-btrfs@vger.kernel.org
Subject: scub neither running nor canceling nor can be restarted.
Message-ID: <20131209095133.GA6579@mail2.smcindiaonline.com>
Reply-To: Vikram Goyal <vikigoyal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

I am having a problem where a stuck scrub on root FS cannot be
cancelled or restsrted.

Please See:
[root@mail2 ~]# btrfs filesystem show
Label: fedora_mail2  uuid: d2b3420c-99c1-44cc-a922-ac266072c7fb
Total devices 2 FS bytes used 58.88GiB
devid    2 size 73.51GiB used 31.03GiB path /dev/sdb6
devid    3 size 73.30GiB used 32.03GiB path /dev/sda2

Label: Vikram  uuid: 0809b072-35f3-4866-92b8-af4772b23ed6
Total devices 2 FS bytes used 98.05GiB
devid    1 size 158.03GiB used 99.04GiB path /dev/mapper/sda3
devid    2 size 157.00GiB used 99.03GiB path /dev/dm-1

Btrfs v3.12
[root@mail2 ~]# btrfs scrub status -d /
scrub status for d2b3420c-99c1-44cc-a922-ac266072c7fb
scrub device /dev/sdb6 (id 2) status
scrub started at Thu Apr 18 13:51:13 2013, running for 105 seconds
total bytes scrubbed: 3.81GiB with 0 errors
scrub device /dev/sda2 (id 3) status
scrub started at Thu Apr 18 13:51:13 2013, running for 105 seconds
total bytes scrubbed: 4.34GiB with 0 errors

[root@mail2 ~]# btrfs scrub cancel /
ERROR: scrub cancel failed on /: not running

[root@mail2 ~]# btrfs scrub start -Bd /
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /'.
To see the status use 'btrfs scrub status [-d] /'.

Thanks!
-- 
