Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:48720 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753372AbdIRJ1M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 05:27:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 18 Sep 2017 18:27:09 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to run balance successfully (No space left on device)?
In-Reply-To: <CAA91j0W5YNU-StfRY_M4YUC=aLY-W+VEZ+wP2XciiHmDB1q7gQ@mail.gmail.com>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
 <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
 <CAA91j0W5YNU-StfRY_M4YUC=aLY-W+VEZ+wP2XciiHmDB1q7gQ@mail.gmail.com>
Message-ID: <d4dce3d04c11e171b44a1924114f5ddd@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-18 17:29, Andrei Borzenkov wrote:
> On Mon, Sep 18, 2017 at 11:20 AM, Tomasz Chmielewski <mangoo@wpkg.org> 
> wrote:
>>>> # df -h /var/lib/lxd
>>>> 
>>>> FWIW, standard (aka util-linux) df is effectively useless in a 
>>>> situation
>>>> such as this, as it really doesn't give you the information you need 
>>>> (it
>>>> can say you have lots of space available, but if btrfs has all of it
>>>> allocated into chunks, even if the chunks have space in them still, 
>>>> there
>>>> can be problems).
>> 
>> 
>> I see here on RAID-1, "df -h" it shows pretty much the same amount of 
>> free
>> space as "btrfs fi show":
>> 
>> - "df -h" shows 105G free
>> - "btrfs fi show" says: Free (estimated):            104.28GiB      
>> (min:
>> 104.28GiB)
>> 
> 
> I think both use the same algorithm to compute free space (df at the
> end just shows what kernel returns). The problem is that this
> algorithm itself is just approximation in general case. For uniform
> RAID1 profile it should be correct though.

And perhaps more important - can I assume that right now, with the 
latest stable kernel (4.13.2 right now), running "btrfs balance" is not 
safe and can lead to data corruption or loss?


Consider the following case:

- system admin runs btrfs balance on a filesystem with 100 GB free and 
assumes it is enough space to complete successfully

- btrfs balance fails due to some bug with "No space left on device"

- at the same time, a database using this filesystem will fail with "No 
space left on device", apt/rpm will fail a package upgrade, some program 
using temp space will fail, log collector will fail to catch some data, 
because of "No space left on device" and so on?



Tomasz Chmielewski
https://lxadm.com
