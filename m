Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34510 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbcH2VFY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 17:05:24 -0400
Received: by mail-oi0-f41.google.com with SMTP id l203so214061298oib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 14:05:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKzrAgTcrjN_qLqzqQ_izpB_AvypaGV=TGNEeH=-18GmOVjAAg@mail.gmail.com>
References: <CAKzrAgTcrjN_qLqzqQ_izpB_AvypaGV=TGNEeH=-18GmOVjAAg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 29 Aug 2016 15:05:20 -0600
Message-ID: <CAJCQCtQhFHX2ba3gYUHw0XtbLousVz8s7ZxMnT1ThU46iOxNOA@mail.gmail.com>
Subject: Re: `btrfs dev del` fails with `No space left on device`
To: "ojab //" <ojab@ojab.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 29, 2016 at 10:04 AM, ojab // <ojab@ojab.ru> wrote:
> Hi,
> [and I hope that this message will not be sent during compose]
> I've had BTRFS filesystem with two 1Tb drives (sdb1 & sdc1), data
> raid0 & metadata raid1. I need to replace one drive with 2Tb drive, so
> I've done `btrfs dev add /dev/sdd /mnt/xxx` and now trying to do
> `btrfs dev del /dev/sdc1 /mnt/xxx` which fails due to `ERROR: error
> removing device '/dev/sdc1': No space left on device`. Right now FS
> looks like:
>
> $ sudo btrfs fi show /mnt/xxx
> Label: none  uuid: 8a65465d-1a8c-4f80-abc6-c818c38567c3
>            Total devices 3 FS bytes used 1.80TiB
>            devid    1 size 931.51GiB used 931.51GiB path /dev/sdc1
>            devid    2 size 931.51GiB used 931.51GiB path /dev/sdb1
>            devid    3 size 1.82TiB used 0.00B path /dev/sdd1


sdc1 and sdb1 are completely allocated so no new chunks can be made,
it's not clear what's going on with sdd1 but the first two might be so
full that sdd1 is just stuck being part of the volume

What do you get for 'btrfs fi us <mp>'

>
> Is there any way to delete /dev/sdc1 without full rebalance?

You can see what the state of block groups are with btrfs-debugfs
which is in kdave btrfs-progs git. Chances are you need a larger
value, -dusage=15 -musage=15 to free up space on devid 1 and 2. Then
maybe devid 3 can be removed.


-- 
Chris Murphy
