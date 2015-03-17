Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:17765 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbbCQI62 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 04:58:28 -0400
Received: from mail-ie0-f171.google.com (mail-ie0-f171.google.com [209.85.223.171])
	(Authenticated sender: robbieko@synology.com)
	by mail.synology.com (Postfix) with ESMTPSA id A1A08A723C7
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 16:58:14 +0800 (CST)
Received: by ieclw3 with SMTP id lw3so3994371iec.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 01:58:19 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Mar 2015 16:58:19 +0800
Message-ID: <CAJiZgcoWzBtqNQo54GCAw=WH1BtMm2wdScJeTjyJWeypeep=Bw@mail.gmail.com>
Subject: Btrfs Send/Receive "WARN_ON Cannot allocate memory" And "no such file
 or directory" error
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been testing btrfs send/receive recently.
I got an error "send ioctl failed with -12: Cannot allocate memory" on
send side.
WARN_ON happened on "len > PATH_MAX" in fs_path_ensure_buf.

I got an error "rename failed: no such file or directory" on receive side.
The followings are simple reproduced steps and related information,
Is there any  idea about what this might be or how to fix it?

uanme -a
Linux ubuntu 4.0.0-rc1-custom #2 SMP Fri Feb 27 22:20:12 CST 2015
x86_64 x86_64 x86_64 GNU/Linux
btrfs --version
Btrfs v3.14.1

 Steps to reproduce:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt
  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt2

$ mkdir /mnt/data
$ mkdir /mnt/data/n1
$ mkdir /mnt/data/n1/n2
$ mkdir /mnt/data/n4
$ mkdir /mnt/data/n1/n2/p1
$ mkdir /mnt/data/n1/n2/p1/p2
$ mkdir /mnt/data/t6
$ mkdir /mnt/data/t7
$ mkdir -p /mnt/data/t5/t7
$ mkdir /mnt/data/t2
$ mkdir /mnt/data/t4
$ mkdir -p /mnt/data/t1/t3
$ mkdir /mnt/data/p1
$ mv /mnt/data/t1 /mnt/data/p1
$ mkdir -p /mnt/data/p1/p2
$ mv /mnt/data/t4 /mnt/data/p1/p2/t1
$ mv /mnt/data/t5 /mnt/data/n4/t5
$ mv /mnt/data/n1/n2/p1/p2 /mnt/data/n4/t5/p2
$ mv /mnt/data/t7 /mnt/data/n4/t5/p2/t7
$ mv /mnt/data/t2 /mnt/data/n4/t1
$ mv /mnt/data/p1 /mnt/data/n4/t5/p2/p1
$ mv /mnt/data/n1/n2 /mnt/data/n4/t5/p2/p1/p2/n2
$ mv /mnt/data/n4/t5/p2/p1/p2/t1 /mnt/data/n4/t5/p2/p1/p2/n2/t1
$ mv /mnt/data/n4/t5/t7 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7
$ mv /mnt/data/n4/t5/p2/p1/t1/t3 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t3
$ mv /mnt/data/n4/t5/p2/p1/p2/n2/p1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7/p1
$ mv /mnt/data/t6 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t3/t5
$ mv /mnt/data/n4/t5/p2/p1/t1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t3/t1
$ mv /mnt/data/n1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7/p1/n1

  $ btrfs subvolume snapshot -r /mnt /mnt/snap1

$ mv /mnt/data/n4/t1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7/p1/t1
$ mv /mnt/data/n4/t5/p2/p1/p2/n2/t1 /mnt/data/n4/
$ mv /mnt/data/n4/t5/p2/p1/p2/n2 /mnt/data/n4/t1/n2
$ mv /mnt/data/n4/t1/t7/p1 /mnt/data/n4/t1/n2/p1
$ mv /mnt/data/n4/t1/t3/t1 /mnt/data/n4/t1/n2/t1
$ mv /mnt/data/n4/t1/t3 /mnt/data/n4/t1/n2/t1/t3
$ mv /mnt/data/n4/t5/p2/p1/p2 /mnt/data/n4/t1/n2/p1/p2
$ mv /mnt/data/n4/t1/t7 /mnt/data/n4/t1/n2/p1/t7
$ mv /mnt/data/n4/t5/p2/p1 /mnt/data/n4/t1/n2/p1/p2/p1
$ mv /mnt/data/n4/t1/n2/t1/t3/t5 /mnt/data/n4/t1/n2/p1/p2/t5
$ mv /mnt/data/n4/t5 /mnt/data/n4/t1/n2/p1/p2/p1/t5
$ mv /mnt/data/n4/t1/n2/p1/p2/p1/t5/p2 /mnt/data/n4/t1/n2/p1/p2/p1/p2
$ mv /mnt/data/n4/t1/n2/p1/p2/p1/p2/t7 /mnt/data/n4/t1/t7

  $ btrfs subvolume snapshot -r /mnt /mnt/snap2

  $ btrfs send /mnt/snap1 | btrfs receive /mnt2
  $ btrfs send -p /mnt/snap1 /mnt/snap2 | btrfs receive -vv /mnt2
ERROR: send ioctl failed with -12: Cannot allocate memory
rename data/n4/t5/p2/p1/p2 -> o272-10-0
rename data/n4/t5/p2/p1/p2/n2/t1/t7 -> o266-9-0
ERROR: rename data/n4/t5/p2/p1/p2/n2/t1/t7 -> o266-9-0 failed. No such
file or directory

It seems that "data/n4/t5/p2/p1/p2" had been renamed but the file path
had not been updated to
"o272-10-0".
Thus it makes the next rename failed.

Thanks.
robbieko
