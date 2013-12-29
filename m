Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56540 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3L2JtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Dec 2013 04:49:19 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so4565396eaj.18
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 01:49:17 -0800 (PST)
Received: from linux-suse.hu (dsl51B6A480.pool.t-online.hu. [81.182.164.128])
        by mx.google.com with ESMTPSA id h3sm97935544eem.15.2013.12.29.01.49.16
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Dec 2013 01:49:16 -0800 (PST)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Instant reboot while defragging on 3.13-rc5
Date: Sun, 29 Dec 2013 10:48:25 +0100
Message-ID: <73072351.X5HJy46hkl@linux-suse.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list members,

I upgraded to 3.13-rc5 kernel and started to defrag my whole file system with 
the following commands:

cd /
for i in */*; do if [[ "$i" != windows* ]]; then echo "------$i------"; btrfs 
fi defrag -clzo -r "$i"; fi; done 2>&1 | tee /root/defrag

After 10 or 15 seconds my computer reboots itself without any warning. In 
dmesg I see only the following:
[  531.866566] btrfs: device fsid 2cc2b266-3f04-4f1c-8477-cf7efd6ac139 devid 1 
transid 396679 /dev/sda7
[  532.001919] watchdog watchdog0: watchdog did not stop!
[  532.002719] watchdog watchdog0: watchdog did not stop!

Together with this I'm constantly getting sysfs WARNINGS into dmesg, but I 
don't think this would be related:

WARNING: CPU: 5 PID: 1644 at /home/abuild/rpmbuild/BUILD/kernel-
desktop-3.13.rc5/linux-3.13-rc5/fs/sysfs/group.c:214 device_del+0x3b/0x1b0()
sysfs group ffffffff81c7e040 not found for kobject 'hidraw2'

Versions:
OS: openSUSE 13.1
Kernel: 3.13.0-rc5-1.g7127d5f-desktop
btrfs: v3.12+20131125

Ákos
