Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:50660 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3FRKaY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 06:30:24 -0400
Received: by mail-ob0-f193.google.com with SMTP id xk17so1870570obc.4
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 03:30:23 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 18 Jun 2013 12:30:23 +0200
Message-ID: <CAPQsFSVtLvvdaZ2QHigSRT40QgHLGGAGiDjR-HkrYh7+LdUU2A@mail.gmail.com>
Subject: My multi-device btrfs (3*2TB) won't mount anymore.
From: Retro Pirate <theretropirate@googlemail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My multi-device btrfs (3*2TB) won't mount anymore.
The fs was created with lubuntu 13.04 (amd64) and the default kernel
with -n 8192 -d single -m raid1, first with two devices the third was
added later.
Quotas where enabled after fs creation (btrfs quota enable) but
nothing else, there are several subvolumes and there should be around
100GB of free space.
Now I tried a more recent kernel but that does not help, I'm now
running mainline kernel 3.10-rc6 (amd64).

I tried btrfsck but it does nothing and won't react to ctrl-c (same
thing with mount), dmesg shows a lot of these
[ 1679.162829] INFO: task btrfsck:2786 blocked for more than 120 seconds.
[ 1679.162838] "echo 0 > /proc/sys/kernel/hung_task_
timeout_secs" disables this message.
[ 1679.162843] btrfsck         D 0000000000000000     0  2786   2785 0x00000004
[ 1679.162853]  ffff8800a1cc3d78 0000000000000046 ffff880115e1de00
ffff8800a1cdc8a0
[ 1679.162862]  ffff8800a1cc3fd8 ffff8800a1cc3fd8 ffff8800a1cc3fd8
0000000000013240
[ 1679.162869]  ffffffff81c11440 ffff880115b48000 ffff88011ac27000
ffffffffa0130ac0
[ 1679.162876] Call Trace:
[ 1679.162903]  [<ffffffff816cb899>] schedule+0x29/0x70
[ 1679.162911]  [<ffffffff816cbb9e>] schedule_preempt_disabled+0xe/0x10
[ 1679.162919]  [<ffffffff816c9fd2>] __mutex_lock_slowpath+0x112/0x1b0
[ 1679.162931]  [<ffffffff816c9b4a>] mutex_lock+0x2a/0x50
[ 1679.162981]  [<ffffffffa00d856b>] btrfs_scan_one_device+0x3b/0x200 [btrfs]
[ 1679.163011]  [<ffffffffa0085b89>] btrfs_control_ioctl+0xd9/0xf0 [btrfs]
[ 1679.163021]  [<ffffffff81198767>] do_vfs_ioctl+0x87/0x330
[ 1679.163029]  [<ffffffff81191ed6>] ? final_putname+0x26/0x50
[ 1679.163037]  [<ffffffff81198aa1>] SyS_ioctl+0x91/0xb0
[ 1679.163045]  [<ffffffff816d5586>] system_call_fastpath+0x1a/0x1f
[ 1799.027976] INFO: task btrfsck:2786 blocked for more than 120 seconds.
[ 1799.027985] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1799.027991] btrfsck         D 0000000000000000     0  2786   2785 0x00000004
[ 1799.028000]  ffff8800a1cc3d78 0000000000000046 ffff880115e1de00
ffff8800a1cdc8a0
[ 1799.028009]  ffff8800a1cc3fd8 ffff8800a1cc3fd8 ffff8800a1cc3fd8
0000000000013240
[ 1799.028017]  ffffffff81c11440 ffff880115b48000 ffff88011ac27000
ffffffffa0130ac0
[ 1799.028024] Call Trace:
[ 1799.028050]  [<ffffffff816cb899>] schedule+0x29/0x70
[ 1799.028059]  [<ffffffff816cbb9e>] schedule_preempt_disabled+0xe/0x10
[ 1799.028067]  [<ffffffff816c9fd2>] __mutex_lock_slowpath+0x112/0x1b0
[ 1799.028080]  [<ffffffff816c9b4a>] mutex_lock+0x2a/0x50
[ 1799.028129]  [<ffffffffa00d856b>] btrfs_scan_one_device+0x3b/0x200 [btrfs]
[ 1799.028159]  [<ffffffffa0085b89>] btrfs_control_ioctl+0xd9/0xf0 [btrfs]
[ 1799.028169]  [<ffffffff81198767>] do_vfs_ioctl+0x87/0x330
[ 1799.028177]  [<ffffffff81191ed6>] ? final_putname+0x26/0x50
[ 1799.028185]  [<ffffffff81198aa1>] SyS_ioctl+0x91/0xb0
[ 1799.028193]  [<ffffffff816d5586>] system_call_fastpath+0x1a/0x1f


iostat
sde               0.11         0.45         0.00        776          0
sdg               0.11         0.44         0.00        764          0
sdf               0.11         0.44         0.00        764          0


btrfs fi sho
Label: none  uuid:
    Total devices 3 FS bytes used 5.37TB
    devid    1 size 1.82TB used 1.79TB path /dev/sdf
    devid    2 size 1.82TB used 1.79TB path /dev/sdg
    devid    3 size 1.82TB used 1.79TB path /dev/sde


How do I get the fs to mount again?
