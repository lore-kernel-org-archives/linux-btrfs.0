Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39811 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753306AbcKJJSY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 04:18:24 -0500
Subject: Re: Deletion of the CoW snapshots causes BTRFS ENOSPC error.
To: =?UTF-8?B?0JrRgNCw0LLRhtC+0LIg0KDQvtC80LDQvSDQktC70LDQtNC40LzQuNGA0L4=?=
         =?UTF-8?B?0LLQuNGH?= <r.kravtsov@sigma-it.ru>,
        <linux-btrfs@vger.kernel.org>
References: <8dbbf4f2-9770-ea4d-00b7-768cee84ddc1@sigma-it.ru>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1e110719-e7f1-6004-d3dc-dbc7b09e7397@cn.fujitsu.com>
Date: Thu, 10 Nov 2016 17:18:21 +0800
MIME-Version: 1.0
In-Reply-To: <8dbbf4f2-9770-ea4d-00b7-768cee84ddc1@sigma-it.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/10/2016 03:40 PM, Кравцов Роман Владимирович wrote:
> Hello.
>
> We have two CI servers with Docker. Docker uses BTRFS storage driver,
> also we use BTRFS for storing some data. To perform cloning of the data,
> are used 'cp --reflink' command. When we trying to remove a few copies
> of the cloned data, the ENOSPC error occurring. This error strongly
> reproduced on the both servers. Before and after creation/deletion of
> the data snapshot 'btrfs filesystem sync /var/lib/docker/db/STANDS' are
> called.

This seems to be a known bug.

Would you please try the follow patch?
https://patchwork.kernel.org/patch/9319179/

Thanks,
Qu

>
> [root@OraCI2 ~]# uname -a
> Linux OraCI2.sigma-it.local 4.8.4-1.el7.elrepo.x86_64 #1 SMP Sat Oct 22
> 11:47:38 EDT 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> [root@OraCI2 ~]# btrfs --version
> btrfs-progs v4.8.1
>
> [root@OraCI2 ~]# btrfs fi show
> Label: 'BUILDS'  uuid: ce8952ff-30e5-48c5-8cd2-529c95667aa8
>     Total devices 1 FS bytes used 358.66GiB
>     devid    1 size 1000.00GiB used 383.00GiB path /dev/nvme0n1p1
>
> Label: none  uuid: a712598d-cc4f-4dc5-bdfb-de7ae432b109
>     Total devices 1 FS bytes used 4.81TiB
>     devid    1 size 7.66TiB used 5.03TiB path
> /dev/mapper/OraCI2-docker--data
>
> Label: none  uuid: 89c0495f-ed26-4d66-b83b-ffb5882bd082
>     Total devices 1 FS bytes used 880.43GiB
>     devid    1 size 1.93TiB used 913.01GiB path /dev/nvme0n1p2
>
> [root@OraCI2 ~]# btrfs fi df /var/lib/docker/db/STANDS
> Data, single: total=4.96TiB, used=4.79TiB
> System, DUP: total=8.00MiB, used=608.00KiB
> Metadata, DUP: total=35.00GiB, used=23.33GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> WBR,
> Roman Kravtsov
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


