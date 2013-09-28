Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:53638 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3I1Tt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 15:49:58 -0400
Received: by mail-lb0-f180.google.com with SMTP id q8so3340918lbi.11
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Sep 2013 12:49:57 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 28 Sep 2013 21:49:56 +0200
Message-ID: <CAOEw3RbDhA9_VhkuiewMWCXg5z4jqM9hR_=Uvq61a2A-w0vZxA@mail.gmail.com>
Subject: Not possible to read device stats for devices added after mount
From: =?ISO-8859-2?Q?Ond=F8ej_Kunc?= <kunc88@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I discovered one minor bug in BTRFS filesystem. I made nagios check
for btrfs which reads device statistics for all devices in mounted
btrfs filesystem, calling btrfs dev stats /btrfs.

But there is one problem ... it's output looks like this:

[/dev/sda].corruption_errs 0
..
...
[/dev/sdt].generation_errs 0
ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sdb2 failed: No such device
ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sdh failed: No such device
ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sdj failed: No such device
ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sdk failed: No such device
ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sdl failed: No such device
ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sdp failed: No such device
ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sdq failed: No such device
ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sds failed: No such device
ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sde failed: No such device

But this is not true ... all specified devices exist and are members
of btrfs filesystem. In dmesg I see this:
...
[973077.098957] btrfs: get dev_stats failed, not yet valid
[973077.098984] btrfs: get dev_stats failed, not yet valid
[973077.099011] btrfs: get dev_stats failed, not yet valid
[973077.099038] btrfs: get dev_stats failed, not yet valid
[973077.099065] btrfs: get dev_stats failed, not yet valid
[973077.099092] btrfs: get dev_stats failed, not yet valid
[973077.099118] btrfs: get dev_stats failed, not yet valid
....

What makes device statistics valid ? I tried doing full filesystem
scrub ... but it did not fix that issue.

Thank you for any hints

Using this kernel (if it matters):
3.10-2-amd64 #1 SMP Debian 3.10.7-1 (2013-08-17) x86_64 GNU/Linux

Ondøej Kunc
