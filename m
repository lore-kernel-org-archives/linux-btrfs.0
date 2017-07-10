Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37276 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753224AbdGJMt3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 08:49:29 -0400
Received: by mail-it0-f51.google.com with SMTP id m84so37236362ita.0
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Jul 2017 05:49:29 -0700 (PDT)
Subject: Re: raid10 array lost with single disk failure?
To: Adam Bahe <adambahe@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACzgC9j026GHxX9m8=1iaYyV9ejFrzaC3nqwgn+j_awXA7D_Lw@mail.gmail.com>
 <pan$b8d9f$672ac146$c6d8fd45$3b1ed204@cox.net>
 <ojudab$mcr$1@blaine.gmane.org>
 <CACzgC9hn_9Pk=M02b4UX14WPpsvUke=ZVs3p_WsT1LJ0rPWaNg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <12f5de03-68e9-57fb-e228-bd12194886a3@gmail.com>
Date: Mon, 10 Jul 2017 08:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <CACzgC9hn_9Pk=M02b4UX14WPpsvUke=ZVs3p_WsT1LJ0rPWaNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-09 22:13, Adam Bahe wrote:
> I have finished all of the above suggestions, ran a scrub, remounted,
> rebooted, made sure the system didn't hang, and then kicked off
> another balance on the entire pool. It completed rather quickly but
> something still does not seem right.
> 
> Label: 'btrfs_pool1'  uuid: 04a7fa70-1572-47a2-a55c-7c99aef12603
>          Total devices 18 FS bytes used 23.64TiB
>          devid    1 size 1.82TiB used 1.82TiB path /dev/sdd
>          devid    2 size 1.82TiB used 1.82TiB path /dev/sdf
>          devid    3 size 3.64TiB used 3.07TiB path /dev/sdg
>          devid    4 size 3.64TiB used 3.06TiB path /dev/sdk
>          devid    5 size 1.82TiB used 1.82TiB path /dev/sdn
>          devid    6 size 3.64TiB used 3.06TiB path /dev/sdo
>          devid    7 size 1.82TiB used 1.82TiB path /dev/sds
>          devid    8 size 1.82TiB used 1.82TiB path /dev/sdj
>          devid    9 size 1.82TiB used 1.82TiB path /dev/sdi
>          devid   10 size 1.82TiB used 1.82TiB path /dev/sdq
>          devid   11 size 1.82TiB used 1.82TiB path /dev/sdr
>          devid   12 size 1.82TiB used 1.82TiB path /dev/sde
>          devid   13 size 1.82TiB used 1.82TiB path /dev/sdm
>          devid   14 size 7.28TiB used 4.78TiB path /dev/sdh
>          devid   15 size 7.28TiB used 4.99TiB path /dev/sdl
>          devid   16 size 7.28TiB used 4.97TiB path /dev/sdp
>          devid   17 size 7.28TiB used 4.99TiB path /dev/sdc
>          devid   18 size 5.46TiB used 210.12GiB path /dev/sdb
> 
> /dev/sdb is the new disk, but btrfs only moved 210.12GB over to it.
> Most disks in the array are >50% utilized or more. Is this normal?
> 
Was this from a full balance, or just running a scrub to repair chunks?

You have three ways you can repair a BTRFS volume that's lost a device:

* The first, quickest, and most reliable is to use `btrfs device 
replace` to replace the failing/missing device.  This will result in 
only reading data that needs to be read to go on the new device, so it 
completes quicker, but you will also need to resize the new device if 
you are going to a larger device, and can't replace the missing device 
with a smaller one.

* The second is to add the device to the array, then run a scrub on the 
whole array.  This will spit out a bunch of errors from the chunks that 
need to be rebuilt, but will make sure everything is consistent.  This 
isn't as fast as using `device replace`, but is still quicker than a 
full balance most of the time.  In this particular case, I would expect 
behavior like what you're seeing above at least some of the time.

* The third, and slowest method, is to add the new device, then run a 
full balance.  This will make sure data is evenly distributed 
proportionate to device size and will rebuild all the partial chunks. 
It will also take the longest, and put significantly more stress on the 
array than the other two options (it rewrites the entire array).  If 
this is what you used, then you probably found a bug, because it should 
never result in what you're seeing.
