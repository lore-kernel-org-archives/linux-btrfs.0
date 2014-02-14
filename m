Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:36970 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaBNKf5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 05:35:57 -0500
Received: by mail-ob0-f179.google.com with SMTP id wo20so13775034obc.10
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 02:35:56 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 14 Feb 2014 11:35:56 +0100
Message-ID: <CANKzOHBR6oYRrfDKtS-qh3JZ_LZTmUFwDtaAb7+N+A4MOTe-cg@mail.gmail.com>
Subject: Recovering from hard disk failure in a pool
From: Axelle <aafortinet@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I've just encountered a hard disk crash in one of my btrfs pools.

sudo btrfs filesystem show
failed to open /dev/sr0: No medium found
Label: none  uuid: 545e95c6-d347-4a8c-8a49-38b9f9cb9add
        Total devices 3 FS bytes used 112.70GB
        devid    1 size 100.61GB used 89.26GB path /dev/sdc6
        devid    2 size 93.13GB used 84.00GB path /dev/sdc1
        *** Some devices missing

The device which is missing is /dev/sdb. I have replaced it with a new
hard disk. How do I add it back to the volume and fix the device
missing?
The pool is expected to mount to /samples (it is not mounted yet).

I tried this - which fails:
sudo btrfs device add /dev/sdb /samples
ERROR: error adding the device '/dev/sdb' - Inappropriate ioctl for device

Why isn't this working?

I also tried this:
sudo mount -o recovery /dev/sdc1 /samples
mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
same with /dev/sdc6

I ran btrfsck --repair on /dev/sdc1 and /dev/sdc6. Apart that it
reports a device is missing (/dev/sdb) seems okay.

I also tried:
sudo btrfs filesystem df /samples
ERROR: couldn't get space info on '/samples' - Inappropriate ioctl for device

and as I'm supposed to have a snapshot, this (but I suppose it's
helpless as the volume isn't mounted)
btrfs subvolume snapshot /samples/malwareSnapshot /before
ERROR: error accessing '/samples/malwareSnapshot'

Please help me out, thanks
Axelle.
