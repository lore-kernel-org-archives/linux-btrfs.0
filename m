Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:33550 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751430AbdGRTTu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 15:19:50 -0400
Received: by mail-wr0-f173.google.com with SMTP id v105so12738649wrb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 12:19:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAK8kL=N+nwRVR=Pvt+1nHT-UPW-02T0uf-RJAkgAjVA2oS5GA@mail.gmail.com>
References: <CAAK8kLn08QooOnG76opnaQFxSWjsbgBbKW2tLtfh=630NW1CXg@mail.gmail.com>
 <CAJCQCtTv7g+9CFxi1dCrgUGxmetRWPE-8=KmmTy1s35PswQNNA@mail.gmail.com> <CAAK8kL=N+nwRVR=Pvt+1nHT-UPW-02T0uf-RJAkgAjVA2oS5GA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 18 Jul 2017 13:19:48 -0600
Message-ID: <CAJCQCtQEAHbE_7uYN9qQucoC5O3q1nXnbbV+NyQ2-bhHLCoQ7Q@mail.gmail.com>
Subject: Re: BTRFS error on my raid1
To: Tom Kuschel <oe1tkt@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jul 17 06:55:13 black kernel: sd 2:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Jul 17 06:55:13 black kernel: sd 12:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Jul 17 06:55:13 black kernel: sd 13:0:1:0: [sdc] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA

I see this often, even with direct connect SATA SSD's of recent
vintage (like a Samsung 840 EVO I have).


Jul 17 23:19:52 black kernel: ata10.00: exception Emask 0x1 SAct 0x0
SErr 0x0 action 0x0
Jul 17 23:19:52 black kernel: ata10.00: irq_stat 0x40000001
Jul 17 23:19:52 black kernel: ata10.00: cmd
a0/01:00:00:00:01/00:00:00:00:00/a0 tag 3 dma 16640 in
                                       opcode=0x12 12 01 80 00 ff
00res 40/00:00:00:00:00/00:00:00:00:00/10 Emask 0x1 (device error)
Jul 17 23:19:52 black kernel: ata10.00: status: { DRDY }
Jul 17 23:19:52 black kernel: ata10.00: exception Emask 0x1 SAct 0x0
SErr 0x0 action 0x0
Jul 17 23:19:52 black kernel: ata10.00: irq_stat 0x40000001
Jul 17 23:19:52 black kernel: ata10.00: cmd
a0/01:00:00:00:01/00:00:00:00:00/a0 tag 4 dma 16640 in
                                       opcode=0x1a 1a 00 3f 00 ff
00res 40/00:00:00:00:00/00:00:00:00:00/10 Emask 0x1 (device error)
Jul 17 23:19:52 black kernel: ata10.00: status: { DRDY }
Jul 17 23:19:52 black kernel: ata10: exception Emask 0x1 SAct 0x0 SErr
0x0 action 0x0
Jul 17 23:19:52 black kernel: ata10: irq_stat 0x40000001


You've got device problems. I'm not sure if it's the drive,
controller, or cabling.

ls -l /sys/block  should help figure out if ata10 is actually sd
target 13:0:1:0 which is what matches up wth sdc, which is what Btrfs
is faceplanting on.




Chris Murphy
