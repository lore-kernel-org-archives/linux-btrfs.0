Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:47339 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaFDWpt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 18:45:49 -0400
Received: by mail-qg0-f42.google.com with SMTP id q107so316737qgd.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 15:45:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG1y0sfrmSD31iKfqyR9jMJSBNvs=dihiHtd8nMwiawkhykUQw@mail.gmail.com>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<CAG1y0sfrmSD31iKfqyR9jMJSBNvs=dihiHtd8nMwiawkhykUQw@mail.gmail.com>
Date: Thu, 5 Jun 2014 00:45:49 +0200
Message-ID: <CAEezp7uCfnYJOfN0v1CS3hGy1ccupe6=WaX_+k3MzDSbyQkX0g@mail.gmail.com>
Subject: Re: Very slow filesystem
From: Igor M <igork20@gmail.com>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 5, 2014 at 12:27 AM, Fajar A. Nugraha <list@fajar.net> wrote:
> On Thu, Jun 5, 2014 at 5:15 AM, Igor M <igork20@gmail.com> wrote:
>> Hello,
>>
>> Why btrfs becames EXTREMELY slow after some time (months) of usage ?
>
>> # btrfs fi show
>> Label: none  uuid: b367812a-b91a-4fb2-a839-a3a153312eba
>>         Total devices 1 FS bytes used 2.36TiB
>>         devid    1 size 2.73TiB used 2.38TiB path /dev/sde
>
>> # btrfs fi df /mnt/old
>> Data, single: total=2.36TiB, used=2.35TiB
>
> Is that the fs that is slow?
>
> It's almost full. Most filesystems would exhibit really bad
> performance when close to full due to fragmentation issue (threshold
> vary, but 80-90% full usually means you need to start adding space).
> You should free up some space (e.g. add a new disk so it becomes
> multi-device, or delete some files) and rebalance/defrag.
>
> --
> Fajar

Yes this one is slow. I know it's getting full I'm just copying to new
disk (it will take days or even weeks!).
It shouldn't be so much fragmented, data is mostly just added. But
still, can reading became so slow just because fullness and
fragmentation ?
It just seems strange to me. If it would be 60Mb/s instead 130, but so
much slower. I'll delete some files and see if it will be faster, but
it will take hours to copy them to new disk.
