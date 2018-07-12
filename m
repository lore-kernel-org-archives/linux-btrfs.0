Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55809 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbeGLFet (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 01:34:49 -0400
Subject: Why original mode doesn't use swap? (Original: Re: btrfs check
 lowmem, take 2)
To: Chris Murphy <lists@colorremedies.com>, Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Su Yue <Damenly_Su@gmx.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>
References: <20180710180915.onnxuak7vb7uywyn@merlins.org>
 <CAJCQCtRQdg56Hxk=U2JMXbE35Jj_Q5Ock_gn43jWxci4Nbs5UA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e0de5098-05ce-28f8-591c-39b87dea63fe@gmx.com>
Date: Thu, 12 Jul 2018 13:26:41 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRQdg56Hxk=U2JMXbE35Jj_Q5Ock_gn43jWxci4Nbs5UA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月12日 01:09, Chris Murphy wrote:
> On Tue, Jul 10, 2018 at 12:09 PM, Marc MERLIN <marc@merlins.org> wrote:
>> Thanks to Su and Qu, I was able to get my filesystem to a point that
>> it's mountable.
>> I then deleted loads of snapshots and I'm down to 26.
>>
>> IT now looks like this:
>> gargamel:~# btrfs fi show /mnt/mnt
>> Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
>>         Total devices 1 FS bytes used 12.30TiB
>>         devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2
>>
>> gargamel:~# btrfs fi df /mnt/mnt
>> Data, single: total=13.57TiB, used=12.19TiB
>> System, DUP: total=32.00MiB, used=1.55MiB
>> Metadata, DUP: total=124.50GiB, used=115.62GiB
>> Metadata, single: total=216.00MiB, used=0.00B
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>>
>> Problems
>> 1) btrfs check --repair _still_ takes all 32GB of RAM and crashes the
>> server, despite my deleting lots of snapshots.
>> Is it because I have too many files then?
> 
> I think originally needs most of metdata in memory.
> 
> I'm not understanding why btrfs check won't use swap like at least
> xfs_repair and pretty sure e2fsck will as well.

I don't understand either.

Isn't memory from malloc() swappable?

Thanks,
Qu

> 
> Using 128G swap on nvme with original check is still gonna be faster
> than lowmem mode.
> 
> 
> 
> 
