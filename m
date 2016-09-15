Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33654 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbcIOVS2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 17:18:28 -0400
Received: by mail-oi0-f44.google.com with SMTP id r126so88290285oib.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 14:18:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
References: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 15 Sep 2016 15:18:22 -0600
Message-ID: <CAJCQCtR6bcBjK+Npd1+8KOYFOp5GWUBQ8hxvjwNU7vEaLHH9Hg@mail.gmail.com>
Subject: Re: Size of scrubbed Data
To: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 9:48 AM, Stefan Malte Schumacher
<stefan.m.schumacher@gmail.com> wrote:

>
> btrfs --version
> btrfs-progs v4.7.1

Upgrade to 4.7.2 or downgrade to 4.6.1 before using btrfs check; see
the changelog for details. I'm not recommending that you use btrfs
check, just staying this version of tools is not reliable for some
file systems.



>  btrfs fi df /mnt/btrfs-raid/
> Data, RAID1: total=6.17TiB, used=6.05TiB
> System, RAID1: total=32.00MiB, used=916.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=10.00GiB, used=8.14GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

The 3rd line is possibly rather dangerous in that it might mean
there's some tiny amount of system data that has only one copy on one
drive. And since it's a system chunk, if it's true that there's only
one copy, if it were damaged or lost, it'd take out the whole volume.

btrfs balance start -mconvert=raid1,soft <mp>

See what that gets you, and then recheck with btrfs fi df or better
use btrfs fi us.

Unfortunately I don't have an answer for the original question.



-- 
Chris Murphy
