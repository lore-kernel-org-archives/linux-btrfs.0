Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:34127 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbbCaDGP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 23:06:15 -0400
Received: from mail-ig0-f172.google.com (mail-ig0-f172.google.com [209.85.213.172])
	(Authenticated sender: robbieko@synology.com)
	by mail.synology.com (Postfix) with ESMTPSA id 46A1A67C0451
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 11:06:04 +0800 (CST)
Received: by igbud6 with SMTP id ud6so7198946igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 20:06:10 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 31 Mar 2015 11:06:10 +0800
Message-ID: <CAJiZgcqMPRk-Zr1V0rOz00HX4q6Lzs=iaT8iwSvKw5n4+f=4WQ@mail.gmail.com>
Subject: Btrfs Send/Receive "utime" error And "WARN_ON Cannot allocate memory"
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have  testing btrfs send/receive recently.

I got an error "send ioctl failed with -12: Cannot allocate memory" on
send side.
WARN_ON happened on "len > PATH_MAX" in fs_path_ensure_buf.

I got an error "utime failed: No such file or directory" on receive side.
The followings are simple reproduced steps and related information.

I have applied the following patch in the url :
https://patchwork.kernel.org/patch/6113581/.
However, it did not fix the problem.

Is there any  idea about what this might be or how to fix it?

Steps to reproduce:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt
  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt2

$ mkdir -p /mnt/data
$ mkdir -p /mnt/data/n1/n2
$ mkdir -p /mnt/data/n4
$ mkdir -p /mnt/data/t6/t7
$ mkdir -p /mnt/data/t5
$ mkdir -p /mnt/data/t7
$ mkdir -p /mnt/data/n4/t2
$ mkdir -p /mnt/data/t4
$ mkdir -p /mnt/data/t3
$ mv /mnt/data/t7 /mnt/data/n4/t2
$ mv /mnt/data/t4 /mnt/data/n4/t2/t7
$ mv /mnt/data/t5 /mnt/data/n4/t2/t7/t4
$ mv /mnt/data/t6 /mnt/data/n4/t2/t7/t4/t5
$ mv /mnt/data/n1/n2 /mnt/data/n4/t2/t7/t4/t5/t6
$ mv /mnt/data/n1 /mnt/data/n4/t2/t7/t4/t5/t6
$ mv /mnt/data/n4/t2/t7/t4/t5/t6/t7 /mnt/data/n4/t2/t7/t4/t5/t6/n2
$ mv /mnt/data/t3 /mnt/data/n4/t2/t7/t4/t5/t6/n2/t7

  $ btrfs subvolume snapshot -r /mnt /mnt/snap1

$ mv /mnt/data/n4/t2/t7/t4/t5/t6/n1 /mnt/data/n4
$ mv /mnt/data/n4/t2 /mnt/data/n4/n1
$ mv /mnt/data/n4/n1/t2/t7/t4/t5/t6/n2 /mnt/data/n4/n1/t2
$ mv /mnt/data/n4/n1/t2/n2/t7/t3 /mnt/data/n4/n1/t2
$ mv /mnt/data/n4/n1/t2/t7/t4/t5/t6 /mnt/data/n4/n1/t2
$ mv /mnt/data/n4/n1/t2/t7/t4 /mnt/data/n4/n1/t2/t6
$ mv /mnt/data/n4/n1/t2/t7 /mnt/data/n4/n1/t2/t3
$ mv /mnt/data/n4/n1/t2/n2/t7 /mnt/data/n4/n1/t2

  $ btrfs subvolume snapshot -r /mnt /mnt/snap2

  $ btrfs send /mnt/snap1 | btrfs receive /mnt2
  $ btrfs send -p /mnt/snap1 /mnt/snap2 | btrfs receive /mnt2
ERROR: send ioctl failed with -12: Cannot allocate memory
ERROR: utimes data/n4/t2/t7/t4/t5/t6/n2 failed. No such file or directory.
