Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:34375 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdHaLAR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 07:00:17 -0400
Subject: Re: mount time for big filesystems
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        linux-btrfs@vger.kernel.org
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <7fbe45ea-9991-8e81-831f-10c9526b2a01@mendix.com>
Date: Thu, 31 Aug 2017 13:00:13 +0200
MIME-Version: 1.0
In-Reply-To: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/31/2017 12:43 PM, Marco Lorenzo Crociani wrote:
> Hi,
> this 37T filesystem took some times to mount. It has 47
> subvolumes/snapshots and is mounted with
> noatime,compress=zlib,space_cache. Is it normal, due to its size?

Yes, unfortunately it is. It depends on the size of the metadata extent
tree. During mount, the BLOCK_GROUP_ITEM objects are loaded from that
tree. They're scattered all around, causing a lot of random reads when
your disk cache is still ice cold.

> # time mount /data/R6HW
> 
> real    1m32.383s
> user    0m0.000s
> sys    0m1.348s
> 
> # time umount /data/R6HW
> 
> real    0m2.562s
> user    0m0.000s
> sys    0m0.466s
> 
> 
> # df -h
> /dev/sdo                          37T   20T     18T  53% /data/R6HW
> 
> # btrfs fi df /data/R6HW/
> Data, single: total=19.12TiB, used=19.12TiB
> System, DUP: total=8.00MiB, used=2.05MiB
> Metadata, DUP: total=37.50GiB, used=36.52GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> # btrfs device usage /data/R6HW/
> /dev/sdo, ID: 1
>    Device size:            36.38TiB
>    Device slack:              0.00B
>    Data,single:            19.12TiB
>    Metadata,DUP:           75.00GiB
>    System,DUP:             16.00MiB
>    Unallocated:            17.18TiB


-- 
Hans van Kranenburg

