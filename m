Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34672 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbLaUL0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 15:11:26 -0500
Received: by mail-io0-f175.google.com with SMTP id 1so53882037ion.1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 12:11:26 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 31 Dec 2015 13:11:25 -0700
Message-ID: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
Subject: btrfs fail behavior when a device vanishes
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a torture test, no data is at risk.

Two devices, btrfs raid1 with some stuff on them.
Copy from that array, elsewhere.
During copy, yank the active device.

dmesg shows many of these:

[ 7179.373245] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr
652123, rd 697237, flush 0, corrupt 0, gen 0

Why are the write errors nearly as high as the read errors, when there
is only a copy from this device happening?

Is Btrfs trying to write the read error count (for dev stats) of sdc1
onto sdc1, and that causes a write error?

Also, is there a command to make a block device go away? At least in
gnome shell when I eject a USB stick, it isn't just umounted, it no
longer appears with lsblk or blkid, so I'm wondering if there's a way
to vanish a misbehaving device so that Btrfs isn't bogged down with a
flood of retries.

In case anyone is curious, the entire dmesg from device insertion,
formatting, mounting, copying to then from, and device yanking is here
(should be permanent):
http://pastebin.com/raw/Wfe1pY4N

And the copy did successfully complete anyway, and the resulting files
have the same hashes as their originals. So, yay, despite the noisy
messages.


-- 
Chris Murphy
