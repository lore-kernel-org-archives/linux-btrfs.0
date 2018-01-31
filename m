Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:37640 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbeAaHvP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 02:51:15 -0500
Received: by mail-lf0-f49.google.com with SMTP id 63so19236527lfv.4
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 23:51:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180130063020.14850-1-anand.jain@oracle.com>
References: <20180130063020.14850-1-anand.jain@oracle.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Wed, 31 Jan 2018 08:51:13 +0100
Message-ID: <CAEtw4r2rj7YF+c3wXprM+PNXKVJZDFLMTznjc9egqB1bSR+Wxw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Policy to balance read across mirrored devices
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A little question about mount -o read_mirror_policy=<devid>.

How would this work with RAID1 over 3 or 4 HDD's?
In particular, if the desired block is not available on device <devid>.
Could i repeat this option like the device-option to specify a
order/priority like this:

mount -o read_mirror_policy= 1,read_mirror_policy= 3

2018-01-30 7:30 GMT+01:00 Anand Jain <anand.jain@oracle.com>:
> In case of RAID1 and RAID10 devices are mirror-ed, a read IO can
> pick any device for reading. This choice of picking a device for
> reading should be configurable. In short not one policy would
> satisfy all types of workload and configs.
>
> So before we add more policies, this patch-set makes existing
> $pid policy configurable from the mount option and adds a devid
> based read_mirror device policy. And keeps $pid based policy as
> the default option for now. So this mount option helps to try out
> different read mirror load balances.
>
> Further we can add more policies on top of it, for example..
>
>   mount -o read_mirror_policy=pid (current, default) [1]
>   mount -o read_mirror_policy=<devid> [2]
>   mount -o read_mirror_policy=lba (illustration only) [3]
>   mount -o read_mirror_policy=ssd (illustration only) [4]
>   mount -o read_mirror_policy=io (illustration only) [5]
>   mount -o read_mirror_policy=<heuristic1> (illustration only) [6]
>
> [1]
>  Current PID based read mirror balance.
>
> [2]
>  Set the devid of the device which should be used for read. That
>  means all the normal read will go to that particular device only.
>  This also helps testing and gives a better control for the test
>  scripts including mount context reads.
>
> [3]
>  In case of SAN storage, some storage prefers that host access the
>  LUN based on the LBA so that there won't be duplications of
>  caching on the storage.
>
> [4]
>  In case of mix of SSD and HD we may want to use SSD as the primary
>  read device.
>
> [5]
>  If storage caching is not the bottleneck but the transport layer
>  is then read load should be tuned based on the IO load.
>
> [6]
>  Or a combination of any of above as per the priority.
>  Timofey should consider to base his patch on top of this.
>     Btrfs: enchanse raid1/10 balance heuristic
>
> This patch set is on top of the preparatory patch set:
>   [PATCH 0/2] Preparatory to add read_mirror mount option
>
>
> Anand Jain (2):
>   btrfs: add mount option read_mirror_policy
>   btrfs: add read_mirror_policy parameter devid
>
>  fs/btrfs/ctree.h   |  2 ++
>  fs/btrfs/super.c   | 31 +++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.c | 18 +++++++++++++++++-
>  fs/btrfs/volumes.h |  7 +++++++
>  4 files changed, 57 insertions(+), 1 deletion(-)
>
> --
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
