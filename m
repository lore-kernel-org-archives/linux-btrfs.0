Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f50.google.com ([209.85.167.50]:43189 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbeIEBEZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 21:04:25 -0400
Received: by mail-lf1-f50.google.com with SMTP id h64-v6so4095115lfi.10
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 13:37:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOdf3gqtbGJD29sYCOgL4+RC3a5ypvUbXP=F4r+pVDa_D+bCjg@mail.gmail.com>
References: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
 <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com> <CAOdf3goVwcAwKXhNDcO0va-PJFu0mAWbBUeu-yQWkb-2SNPnxQ@mail.gmail.com>
 <43e5b6dc-a963-6d67-732f-c13c2f5abc78@gmx.com> <CAOdf3gqtbGJD29sYCOgL4+RC3a5ypvUbXP=F4r+pVDa_D+bCjg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 4 Sep 2018 14:37:37 -0600
Message-ID: <CAJCQCtR_UmeksUjVKx3SeDJEttg=QHtW6oeAjp0W1Ov8XUsbvg@mail.gmail.com>
Subject: Re: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
To: Etienne Champetier <champetier.etienne@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 4, 2018 at 10:22 AM, Etienne Champetier
<champetier.etienne@gmail.com> wrote:

> Do you have a procedure to copy all subvolumes & skip error ? (I have
> ~200 snapshots)

If they're already read-only snapshots, then script an iteration of
btrfs send receive to a new volume.

Btrfs seed-sprout would be ideal, however in this case I don't think
can help because a.) it's temporarily one file system, which could
mean the corruption is inherited; and b.) I'm not sure it's multiple
device aware, so either the btrfs-tune -S1 might fail on 2+ device
Btrfs volumes, or possibly it insists on a two device sprout in order
to replicate a two device seed.

If they're not already read-only, it's tricky because it sounds like
mounting rw is possibly risky, and taking read only snapshots might
fail anyway. There is no way to make read only snapshots unless the
volume can be written to; and no way to force a rw subvolume to be
treated as if it were read only even if the volume is mounted read
only. And it takes a read only subvolume for send to work.


-- 
Chris Murphy
