Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from c.mail.sonic.net ([64.142.111.80]:51788 "EHLO c.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbbC1RbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Mar 2015 13:31:16 -0400
Message-ID: <5516E266.6030400@gmail.com>
Date: Sat, 28 Mar 2015 10:18:30 -0700
From: Konstantin Svist <fry.kun@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: "corrupt 1", but no other indicators
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm seeing the following message on every bootup in dmesg &
/var/log/messages:
  BTRFS: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0

I've tried running scrub and it doesn't indicate any errors occurred
Is this normal? Is something actually corrupted? Can I fix it?


Details:

[root@mireille ~]# uname -a
Linux mireille.svist.net 3.19.1-201.fc21.x86_64 #1 SMP Wed Mar 18
04:29:24 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
[root@mireille ~]# btrfs fi show
Label: none  uuid: 5ac56e7d-3d04-4ffa-8160-5a47f46c2939
    Total devices 1 FS bytes used 237.28GiB
    devid    1 size 465.76GiB used 465.76GiB path /dev/sda2

Btrfs v3.18.1
[root@mireille ~]# btrfs --version
Btrfs v3.18.1
[root@mireille ~]# btrfs fi show
Label: none  uuid: 5ac56e7d-3d04-4ffa-8160-5a47f46c2939
    Total devices 1 FS bytes used 237.28GiB
    devid    1 size 465.76GiB used 465.76GiB path /dev/sda2

Btrfs v3.18.1
[root@mireille ~]# btrfs fi df /
Data, single: total=457.75GiB, used=232.64GiB
System, single: total=4.00MiB, used=80.00KiB
Metadata, single: total=8.01GiB, used=4.64GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


dmesg: http://pastebin.com/9B0h4SuA
