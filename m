Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36210 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbbKGPg5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2015 10:36:57 -0500
Received: by obdgf3 with SMTP id gf3so113257597obd.3
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 07:36:56 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 7 Nov 2015 16:36:56 +0100
Message-ID: <CAFhRPx8LiHHuuv+JfZZV+d9+rCDv2Y97WYm-eniFJTBhwKmdsw@mail.gmail.com>
Subject: Reproducible corruption issue in stable, with possible patch unmerged?
From: "Diego Call." <diegocg@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[repost, since the previous mail was rejected by vger.kernel.org]

I got these messages in my dmesg:

[ 2587.841376] BTRFS error (device sdc1): partial page write in btrfs
with offset 0 and length 8392704
[ 2588.814182] BTRFS critical (device sdc1): bad ordered accounting
left 0 size 4096

With no other errors before. After rebooting I got btrfs
errors and widespreading filesystem corruption (pool
of three disks created with -d raid0 and -m raid1)

I reinstalled the system (current arch linux installer, which
runs 4.2) and started to restore the backup. Surprisingly,
I got exactly the same errors again. I reinstalled again,
and after rebooting to the new system, running 4.2.5,
I tried to restore the backup and got the same messages
and corruption again. Then I tried reinstalling with
the 4.1.12 LTS version, and it all worked fine.

Now, the interesting thing is that, after googling this error, I didn't
found any interesting references except a patch sent to this
mailing list which seems to fix a problem that causes the same
error output. The patch doesn't seem to have been merged:

http://lkml.iu.edu/hypermail/linux/kernel/1412.1/03297.html
