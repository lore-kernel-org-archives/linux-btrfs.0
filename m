Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:39430 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbaBUPVk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 10:21:40 -0500
Received: by mail-oa0-f51.google.com with SMTP id i7so1052941oag.10
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 07:21:39 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 21 Feb 2014 10:21:38 -0500
Message-ID: <CAAVQaYCkxpp8vX8PnO3OLffSm_MMCt6N2qFT=5DWjseZmZ1xbA@mail.gmail.com>
Subject: Hard drive hangs after excessive I/O
From: Dave <dave@thekilempire.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm currently running kernel 3.13.3 with Chris's for-linus merged in
(up to commit 93de4ba86480a9e0d1062cb1d535fa97fb81af48).  After about
a day of heavy IO I'll start to see the following in my kernel log:

[22223.454967] INFO: task qemu-system-x86:27673 blocked for more than
120 seconds.
[22223.454970]       Not tainted 3.13.3-2-dzk #1
[22223.454972] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[22223.454974] qemu-system-x86 D ffff8804039d7800     0 27673      1 0x00000000
[22223.454978]  ffff8800d1d6bda0 0000000000000082 ffff8800096aec00
ffff8800d1d6bfd8
[22223.454983]  0000000000014440 0000000000014440 ffff8800096aec00
ffffffffa04aafa0
[22223.454988]  000000000000018b ffff8802e8870000 0000000000003000
0000000000001000
[22223.454993] Call Trace:
[22223.455015]  [<ffffffffa04aafa0>] ? btrfs_set_token_64+0x60/0xf0 [btrfs]
[22223.455036]  [<ffffffffa04ae8fb>] ? release_extent_buffer+0x2b/0xd0 [btrfs]
[22223.455041]  [<ffffffff8151d429>] schedule+0x29/0x70
[22223.455061]  [<ffffffffa04ce282>] wait_log_commit.isra.18+0x102/0x130 [btrfs]
[22223.455066]  [<ffffffff810a2bf0>] ? __wake_up_sync+0x20/0x20
[22223.455085]  [<ffffffffa04d1465>] btrfs_sync_log+0x3e5/0x6b0 [btrfs]
[22223.455091]  [<ffffffff811ba0a0>] ? dput+0x20/0x100
[22223.455112]  [<ffffffffa04a4681>] btrfs_sync_file+0x2c1/0x2f0 [btrfs]
[22223.455117]  [<ffffffff811d2541>] do_fsync+0x51/0x80
[22223.455122]  [<ffffffff811d2823>] SyS_fdatasync+0x13/0x20
[22223.455127]  [<ffffffff81528d6d>] system_call_fastpath+0x1a/0x1f

During this time, all IO totally freezes.  Atop reports no disk
activity, while my desktop is totally hung.  After a few minutes
everything comes back to life, only to freeze again after a few more
minutes.

A reboot clears everything up for a day or so but the problem
invariably comes back.  Can anybody shed some light on this?

PS, the above qemu process is accessing image files on a btrfs volume.
 These files were created as such:
touch winxp.img
chattr +C winxp.img
fallocate -l20G winxp.img

I'm actually quite pleased with VM performance on top of btrfs (until
the above problem starts occurring).
-- 
-=[dave]=-

Entropy isn't what it used to be.
