Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35940 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbeHWU5v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 16:57:51 -0400
Received: by mail-io0-f193.google.com with SMTP id q5-v6so1703420iop.3
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 10:27:07 -0700 (PDT)
Subject: Re: Device Delete Stalls
To: Stefan Malte Schumacher <s.schumacher@netcologne.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAA3ktqnSR59hSxpj1Pme-3fqJBqNu-A_kRu-VmX-5NrVpjHOoQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2b26a04d-726c-c457-55b1-f1f6a6b455d7@gmail.com>
Date: Thu, 23 Aug 2018 13:27:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAA3ktqnSR59hSxpj1Pme-3fqJBqNu-A_kRu-VmX-5NrVpjHOoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-23 10:04, Stefan Malte Schumacher wrote:
> Hallo,
> 
> I originally had RAID with six 4TB drives, which was more than 80
> percent full. So now I bought
> a 10TB drive, added it to the Array and gave the command to remove the
> oldest drive in the array.
> 
>   btrfs device delete /dev/sda /mnt/btrfs-raid
> 
> I kept a terminal with "watch btrfs fi show" open and It showed that
> the size of /dev/sda had been set to zero and that data was being
> redistributed to the other drives. All seemed well, but now the
> process stalls at 8GB being left on /dev/sda/. It also seems that the
> size of the drive has been reset the original value of 3,64TiB.
> 
> Label: none  uuid: 1609e4e1-4037-4d31-bf12-f84a691db5d8
>          Total devices 7 FS bytes used 8.07TiB
>          devid    1 size 3.64TiB used 8.00GiB path /dev/sda
>          devid    2 size 3.64TiB used 2.73TiB path /dev/sdc
>          devid    3 size 3.64TiB used 2.73TiB path /dev/sdd
>          devid    4 size 3.64TiB used 2.73TiB path /dev/sde
>          devid    5 size 3.64TiB used 2.73TiB path /dev/sdf
>          devid    6 size 3.64TiB used 2.73TiB path /dev/sdg
>          devid    7 size 9.10TiB used 2.50TiB path /dev/sdb
> 
> I see no more btrfs worker processes and no more activity in iotop.
> How do I proceed? I am using a current debian stretch which uses
> Kernel 4.9.0-8 and btrfs-progs 4.7.3-1.
> 
> How should I proceed? I have a Backup but would prefer an easier and
> less time-comsuming way out of this mess.

Not exactly what you asked for, but I do have some advice on how to 
avoid this situation in the future:

If at all possible, use `btrfs device replace` instead of an add/delete 
cycle.  The replace operation requires two things.  First, you have to 
be able to connect the new device to the system while all the old ones 
except the device you are removing are present.  Second, the new device 
has to be at least as big as the old one.  Assuming both conditions are 
met and you can use replace, it's generally much faster and is a lot 
more reliable than an add/delete cycle (especially when the array is 
near full).  This is because replace just copies the data that's on the 
old device directly (or rebuilds it directly if it's not present anymore 
or corrupted), whereas the add/delete method implicitly re-balances the 
entire array (which takes a long time and may fail if the array is 
mostly full).


Now, as far as what's actually going on here, I'm unfortunately not 
quite sure, and therefore I'm really not the best person to be giving 
advice on how to fix it.  I will comment that having info on the 
allocations for all the devices (not just /dev/sda) would be useful in 
debugging, but even with that I don't know that I personally can help.
