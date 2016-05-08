Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35852 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbcEHHKv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 May 2016 03:10:51 -0400
Received: by mail-wm0-f52.google.com with SMTP id n129so101357121wmn.1
        for <linux-btrfs@vger.kernel.org>; Sun, 08 May 2016 00:10:51 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Sun, 8 May 2016 12:10:35 +0500
Message-ID: <CABXGCsMnqD1kSDipKzq3FN6+mE0Zct6r3HsCpZMO7qDr6aRi2g@mail.gmail.com>
Subject: block group xxx has wrong amount of free space
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ journalctl -b -1 --no-pager | grep BTRFS
May 08 01:28:23 localhost kernel: BTRFS: device fsid
a22dd8bc-24ef-4f97-bb62-01fcd7c3f11c devid 1 transid 25 /dev/sda4
May 08 01:28:23 localhost kernel: BTRFS: device fsid
eaa531cd-25f4-4e00-b31f-22665faa9768 devid 1 transid 333 /dev/sdb
May 08 01:28:23 localhost kernel: BTRFS: device label home devid 1
transid 2326870 /dev/sdc1
May 08 01:28:26 localhost.localdomain kernel: BTRFS info (device
sdc1): disk space caching is enabled
May 08 01:28:26 localhost.localdomain kernel: BTRFS info (device
sdc1): bdev /dev/sdc1 errs: wr 0, rd 14, flush 0, corrupt 0, gen 0
May 08 01:28:39 localhost.localdomain kernel: BTRFS error (device
sdc1): could not find root 8
May 08 01:40:30 localhost.localdomain kernel: BTRFS warning (device
sdc1): block group 2286562574336 has wrong amount of free space
May 08 01:40:30 localhost.localdomain kernel: BTRFS warning (device
sdc1): failed to load free space cache for block group 2286562574336,
rebuilding it now
May 08 02:06:09 localhost.localdomain kernel: BTRFS warning (device
sdc1): block group 3844117364736 has wrong amount of free space
May 08 02:06:09 localhost.localdomain kernel: BTRFS warning (device
sdc1): failed to load free space cache for block group 3844117364736,
rebuilding it now


These messages appear on every boot.
That they means? And how fix it?

$ uname -r
4.5.3-300.fc24.x86_64

--
Best Regards,
Mike Gavrilov.
