Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:46414 "EHLO
        cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbeHWRlg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 13:41:36 -0400
Received: from cc-smtpin3.netcologne.de (cc-smtpin3.netcologne.de [89.1.8.203])
        by cc-smtpout3.netcologne.de (Postfix) with ESMTP id 37409129EC
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 16:04:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by cc-smtpin3.netcologne.de (Postfix) with ESMTP id 324B611DA8
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 16:04:36 +0200 (CEST)
Received: from [209.85.213.50] (helo=cc-smtpin3.netcologne.de)
        by localhost with ESMTP (eXpurgate 4.6.0)
        (envelope-from <s.schumacher@netcologne.de>)
        id 5b7ebef4-0bea-7f0000012729-7f000001a634-1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 16:04:36 +0200
Received: from mail-vk0-f50.google.com (mail-vk0-f50.google.com [209.85.213.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by cc-smtpin3.netcologne.de (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 16:04:35 +0200 (CEST)
Received: by mail-vk0-f50.google.com with SMTP id q184-v6so2631470vke.7
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 07:04:35 -0700 (PDT)
MIME-Version: 1.0
From: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Date: Thu, 23 Aug 2018 16:04:34 +0200
Message-ID: <CAA3ktqnSR59hSxpj1Pme-3fqJBqNu-A_kRu-VmX-5NrVpjHOoQ@mail.gmail.com>
Subject: Device Delete Stalls
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I originally had RAID with six 4TB drives, which was more than 80
percent full. So now I bought
a 10TB drive, added it to the Array and gave the command to remove the
oldest drive in the array.

 btrfs device delete /dev/sda /mnt/btrfs-raid

I kept a terminal with "watch btrfs fi show" open and It showed that
the size of /dev/sda had been set to zero and that data was being
redistributed to the other drives. All seemed well, but now the
process stalls at 8GB being left on /dev/sda/. It also seems that the
size of the drive has been reset the original value of 3,64TiB.

Label: none  uuid: 1609e4e1-4037-4d31-bf12-f84a691db5d8
        Total devices 7 FS bytes used 8.07TiB
        devid    1 size 3.64TiB used 8.00GiB path /dev/sda
        devid    2 size 3.64TiB used 2.73TiB path /dev/sdc
        devid    3 size 3.64TiB used 2.73TiB path /dev/sdd
        devid    4 size 3.64TiB used 2.73TiB path /dev/sde
        devid    5 size 3.64TiB used 2.73TiB path /dev/sdf
        devid    6 size 3.64TiB used 2.73TiB path /dev/sdg
        devid    7 size 9.10TiB used 2.50TiB path /dev/sdb

I see no more btrfs worker processes and no more activity in iotop.
How do I proceed? I am using a current debian stretch which uses
Kernel 4.9.0-8 and btrfs-progs 4.7.3-1.

How should I proceed? I have a Backup but would prefer an easier and
less time-comsuming way out of this mess.

Yours
Stefan
