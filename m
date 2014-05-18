Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54331 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaERTsS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 15:48:18 -0400
Received: by mail-vc0-f177.google.com with SMTP id if17so8482952vcb.36
        for <linux-btrfs@vger.kernel.org>; Sun, 18 May 2014 12:48:17 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 18 May 2014 21:48:17 +0200
Message-ID: <CAFvQSYTwfgpd3-ndBzy8nfmCJeewN2-+zWpDmSmZXbYoYhmi5A@mail.gmail.com>
Subject: What do the "wait_current_trans" messages mean I see on my raspberry pi?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Over the weekend I tried to copy one external usb drive (on ext4) to
another one formatted with btrfs.
Now I came back, and 48h later only ~300GB were copied and I found
messages like the following on syslog:

May 16 18:33:13 raspberrypi kernel: [ 8161.213142] btrfs-endio-wri D
c0420f24     0  3593      2 0x00000000
May 16 18:33:13 raspberrypi kernel: [ 8161.213735] [<c0420f24>]
(__schedule+0x288/0x568) from [<bf24f488>]
(wait_current_trans+0xcc/0x13c [btrfs])
May 16 18:33:13 raspberrypi kernel: [ 8161.214357] [<bf24f488>]
(wait_current_trans+0xcc/0x13c [btrfs]) from [<bf250e68>]
(start_transaction+0x2d8/0x43c [btrfs])
May 16 18:33:13 raspberrypi kernel: [ 8161.214956] [<bf250e68>]
(start_transaction+0x2d8/0x43c [btrfs]) from [<bf2510c0>]
(btrfs_join_transaction+0x20/0x2c [btrfs])
May 16 18:33:13 raspberrypi kernel: [ 8161.215562] [<bf2510c0>]
(btrfs_join_transaction+0x20/0x2c [btrfs]) from [<bf25a334>]
(btrfs_finish_ordered_io+0x2c4/0x5b0 [btrfs])
May 16 18:33:13 raspberrypi kernel: [ 8161.216233] [<bf25a334>]
(btrfs_finish_ordered_io+0x2c4/0x5b0 [btrfs]) from [<bf28473c>]
(worker_loop+0x150/0x674 [btrfs])
May 16 18:33:13 raspberrypi kernel: [ 8161.216631] [<bf28473c>]
(worker_loop+0x150/0x674 [btrfs]) from [<c003a120>]
(kthread+0xa4/0xb0)
May 16 18:33:13 raspberrypi kernel: [ 8161.218363] [<c003a120>]
(kthread+0xa4/0xb0) from [<c000e218>] (ret_from_fork+0x14/0x3c)

More of them are available at: http://pastebin.com/th9tuSas

Any idea what they mean? Are they related to the slow speed I observed?

Thank you in advance, Clemens
