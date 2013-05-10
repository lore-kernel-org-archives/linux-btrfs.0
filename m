Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52331 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3EJUH4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 16:07:56 -0400
Received: by mail-qc0-f178.google.com with SMTP id l11so2454782qcy.37
        for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 13:07:56 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 May 2013 22:07:56 +0200
Message-ID: <CAB_++mrnzWd9BNHMEK=k7rVdV1x+VjX7JW2ANnEaJ_i1PG-rUA@mail.gmail.com>
Subject: Btrfs balance invalid argument error
From: =?ISO-8859-1?Q?Marcus_L=F6vgren?= <marcuslvgrn@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I am using kernel 3.9.0, btrfs-progs 0.20-rc1-253-g7854c8b.

I have a three disk array of level single:

# btrfs fi sh
Label: none  uuid: 2e905f8f-e525-4114-afa6-cce48f77b629
        Total devices 3 FS bytes used 3.80TB
        devid    1 size 2.73TB used 2.25TB path /dev/sdd
        devid    2 size 2.73TB used 1.55TB path /dev/sdc
        devid    3 size 2.73TB used 0.00 path /dev/sdb

Btrfs v0.20-rc1-253-g7854c8b

# btrfs fi df /mnt/data
Data: total=3.79TB, used=3.79TB
System: total=4.00MB, used=420.00KB
Metadata: total=6.01GB, used=4.87GB


When running
# btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/data

I get

ERROR: error during balancing '/mnt/data' - Invalid argument
There may be more info in syslog - try dmesg | tail

dmesg | tail says:

btrfs: unable to start balance with target data profile 128

Isn't it possible to convert raid level to raid5?

Thanks,

Marcus
