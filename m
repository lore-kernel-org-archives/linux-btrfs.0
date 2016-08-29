Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:35441 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbcH2QBw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 12:01:52 -0400
Received: by mail-ua0-f180.google.com with SMTP id i32so83216764uai.2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 09:01:51 -0700 (PDT)
MIME-Version: 1.0
From: "ojab //" <ojab@ojab.ru>
Date: Mon, 29 Aug 2016 16:01:50 +0000
Message-ID: <CAKzrAgSXK2ejcJ1bZ2M7-L6kJcmrVv1rtHzHQL--Pf87ENzwLg@mail.gmail.com>
Subject: `btrfs dev delz fails with `No space left on device`
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've had BTRFS filesystem with two 1Tb drives (sdb1 & sdc1), data
raid0 & metadata raid1. I need to replace one drive with 2Tb drive, so
I've done `btrfs dev add /dev/sdd /mnt/xxx` and now trying to do
`btrfs dev del /dev/sdc1 /mnt/xxx` which fails due to `ERROR: error
removing device '/dev/sdc1': No space left on device`. Right now FS
looks like:

$ sudo btrfs fi show /mnt/xxx
Label: none  uuid: 8a65465d-1a8c-4f80-abc6-c818c38567c3
           Total devices 3 FS bytes used 1.80TiB
           devid    1 size 931.51GiB used 931.51GiB path /dev/sdc1
           devid    2 size 931.51GiB used 931.51GiB path /dev/sdb1
           devid    3 size 1.82TiB used 0.00B path /dev/sdd1

$ sudo btrfs device usage /mnt/xxx/
/dev/sdb1, ID: 2
   Device size:           931.51GiB
   Device slack:              0.00B
   Data,RAID0:            928.48GiB
   Metadata,RAID1:          3.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             1.01MiB

/dev/sdc1, ID: 1
   Device size:           931.51GiB
   Device slack:            3.50KiB
   Data,RAID0:            928.48GiB
   Metadata,RAID1:          3.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             1.00MiB

/dev/sdd1, ID: 3
   Device size:             1.82TiB
   Device slack:              0.00B
   Unallocated:             1.82TiB

As far as I understand, no data is allocated on `/dev/sdc1`, so it
should be no space for metadata, but I don't really understand how can
I balance only metadata:
$btrfs fi balance start -musage=1 -dusage=0 /mnt/torrents/
