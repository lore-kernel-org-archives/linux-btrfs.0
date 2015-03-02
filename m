Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:7290 "EHLO mail.synology.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbbCBMWr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 07:22:47 -0500
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com [209.85.213.175])
	(Authenticated sender: robbieko@synology.com)
	by mail.synology.com (Postfix) with ESMTPSA id 452595D002D0
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Mar 2015 20:22:37 +0800 (CST)
Received: by igjz20 with SMTP id z20so16550713igj.4
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Mar 2015 04:22:40 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 2 Mar 2015 20:22:40 +0800
Message-ID: <CAJiZgco09Busd5DkXrqo4hL7u_t=g0NkN+54Q8eu0jgY7j8nEQ@mail.gmail.com>
Subject: Btrfs Send/Receive "no such file or directory" bug
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been testing btrfs send/receive recently.
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

  $ mkdir -p /mnt/data/n1/n2/p1/p2
  $ mkdir /mnt/data/n4
  $ mkdir -p /mnt/data/p1/p2

  $ btrfs subvolume snapshot -r /mnt /mnt/snap1

  $ mv /mnt/data/p1/p2 /mnt/data
  $ mv /mnt/data/n1/n2/p1/p2 /mnt/data/p1
  $ mv /mnt/data/p2 /mnt/data/n1/n2/p1
  $ mv /mnt/data/n1/n2 /mnt/data/p1
  $ mv /mnt/data/p1 /mnt/data/n4
  $ mv /mnt/data/n4/p1/n2/p1 /mnt/data

  $ btrfs subvolume snapshot -r /mnt /mnt/snap2

  $ btrfs send /mnt/snap1 -f /tmp/1.send
  $ btrfs send -p /mnt/snap1 /mnt/snap2 -f /tmp/2.send

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt2
  $ btrfs receive /mnt2 -f /tmp/1.send
  $ btrfs receive /mnt2 -f /tmp/2.send
  ERROR: rename data/p1/p2 -> data/n4/p1/p2 failed. no such file or directory

  Thanks.

  Robbie Ko
