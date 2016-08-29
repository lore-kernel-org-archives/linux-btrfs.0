Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34721 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756207AbcH2BtI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 21:49:08 -0400
Subject: Re: btrfs and systemd
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0fa90a35-587e-7bfc-9418-ea8416b8f02e@cn.fujitsu.com>
Date: Mon, 29 Aug 2016 09:48:56 +0800
MIME-Version: 1.0
In-Reply-To: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/29/2016 04:15 AM, Stefan Priebe - Profihost AG wrote:
> Hi,
>
> i'm trying to get my 60TB btrfs volume to mount with systemd at boot.
> But this always fails with: "mounting timed out. Stopping." after 90s.

60TB is quite large, and under most case it will already cause mount 
speed problem.

In our test environment, filling a fs with 16K small files to 2T (just 
128K files)will already slow the mount process to 10s.

For larger fs, or more specifically, large extent tree, will slow the 
mount process obviously.

The root fix will need a rework of extent tree.
AFAIK Josef is working on the rework.

So the btrfs fix will need some time.

Thanks,
Qu
>
> I can't find any fstab setting for systemd to higher this timeout.
> There's just  the x-systemd.device-timeout but this controls how long to
> wait for the device and not for the mount command.
>
> Is there any solution for big btrfs volumes and systemd?
>
> Greets,
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


