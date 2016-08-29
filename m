Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:52823 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750730AbcH2G21 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 02:28:27 -0400
Subject: Re: btrfs and systemd
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
 <0fa90a35-587e-7bfc-9418-ea8416b8f02e@cn.fujitsu.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <f3a27bf7-fecd-e295-991a-8b69c3b92f12@profihost.ag>
Date: Mon, 29 Aug 2016 08:28:22 +0200
MIME-Version: 1.0
In-Reply-To: <0fa90a35-587e-7bfc-9418-ea8416b8f02e@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Am 29.08.2016 um 03:48 schrieb Qu Wenruo:
> 
> 
> At 08/29/2016 04:15 AM, Stefan Priebe - Profihost AG wrote:
>> Hi,
>>
>> i'm trying to get my 60TB btrfs volume to mount with systemd at boot.
>> But this always fails with: "mounting timed out. Stopping." after 90s.
> 
> 60TB is quite large, and under most case it will already cause mount
> speed problem.
> 
> In our test environment, filling a fs with 16K small files to 2T (just
> 128K files)will already slow the mount process to 10s.
> 
> For larger fs, or more specifically, large extent tree, will slow the
> mount process obviously.
> 
> The root fix will need a rework of extent tree.
> AFAIK Josef is working on the rework.
> 
> So the btrfs fix will need some time.

thanks but i've no problem with the long mount time (in my case 6
minutes) i'm just wondering how to live with it with systemd. As it
always cancels the mount process after 90s and i see no fstab option to
change this.

Greets,
Stefan

> 
> Thanks,
> Qu
>>
>> I can't find any fstab setting for systemd to higher this timeout.
>> There's just  the x-systemd.device-timeout but this controls how long to
>> wait for the device and not for the mount command.
>>
>> Is there any solution for big btrfs volumes and systemd?
>>
>> Greets,
>> Stefan
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> 
