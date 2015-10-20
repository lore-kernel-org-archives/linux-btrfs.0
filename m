Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37858 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbJTRYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 13:24:48 -0400
Received: by igbhv6 with SMTP id hv6so19615461igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 10:24:48 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Oct 2015 10:24:48 -0700
Message-ID: <CAM9fjH6M2yqSiqXbT4DBvHbQGq9Cdw-wzMvsYkztPSsQG=PLqQ@mail.gmail.com>
Subject: How to remove missing device on RAID1?
From: Kyle Manna <2bluesc@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have a collection of three (was 4) 1-2TB devices with data and
metadata in a RAID1 mirror.  Last night I was struck by the Click of
Death on an old Samsung drive.

I removed the device from the system, rebooted and mounted the volume
with `-o degraded` and the file system seems fine and usable.  I'm
waiting on a replacement, drive but want to remove the old drive and
re-balance in the meantime.

How do I remove the missing device?  I tried the `btrfs device delete
missing /mnt` but was greeted with "ERROR: missing is not a block
device".  A quick look at that btrfs-progs git repo shows that
`stat("missing")` is called, which of course fails since missing isn't
a block device.  Nothing other then `btrfs replace` seemed intuitive
and all the docs mention the older command.  What's the move?

Thanks!
- Kyle

Versions:
Kernel: 4.2.3-1-ARCH
btrfs-progs: 4.2.2-1
ᐧ
