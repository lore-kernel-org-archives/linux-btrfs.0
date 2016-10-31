Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41270 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1761280AbcJaHEj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 03:04:39 -0400
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
To: Marc MERLIN <marc@merlins.org>
References: <20161030183437.GA3287@merlins.org>
 <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com>
 <20161031020616.GH28648@merlins.org>
 <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com>
 <20161031054719.GN28648@merlins.org>
 <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com>
 <20161031062509.GO28648@merlins.org>
 <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com>
 <20161031063737.GP28648@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <81e30812-be45-b4ff-3bf2-c79e805d445a@cn.fujitsu.com>
Date: Mon, 31 Oct 2016 15:04:27 +0800
MIME-Version: 1.0
In-Reply-To: <20161031063737.GP28648@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/31/2016 02:37 PM, Marc MERLIN wrote:
> On Mon, Oct 31, 2016 at 02:32:53PM +0800, Qu Wenruo wrote:
>>
>>
>> At 10/31/2016 02:25 PM, Marc MERLIN wrote:
>>> On Mon, Oct 31, 2016 at 02:04:10PM +0800, Qu Wenruo wrote:
>>>>> Sorry for asking, am I doing this wrong?
>>>>> myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32
>>>>> skip=26367830208
>>>>> dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
>>>>> 0+0 records in
>>>>> 0+0 records out
>>>>> 0 bytes (0 B) copied, 0.000401393 s, 0.0 kB/s
>>>>
>>>> So, the underlying MD RAID5 are complaining about some wrong data, and
>>>> refuse to read out.
>>>>
>>>> It seems that btrfs-progs can't handle read failure?
>>>> Maybe dm-error could emulate it.
>>>>
>>>> And what about the 2nd range?
>>>
>>> they both fail the same, but I wasn' tsure if I typed the wrong dd command
>>> or not.
>>
>> Strange, your command seems OK to me.
>>
>> Does it has anything to do with your security setup or something like that?
>> Or is it related to dm-crypt or bcache?
>>
>>
>> But this reminds me, if dd can't read it, maybe btrfs-progs is the same.
>>
>> Maybe only kernel can read dm-crypt device while user space tools can't
>> access dm-crypt devices directly?
>
> It can, it's just the offset seems wrong:
>
> myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32 skip=26367830208
> dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.000421662 s, 0.0 kB/s
>
> If I divide by 1000, it works:
> myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32 skip=26367830
> 32+0 records in
> 32+0 records out
> 16384 bytes (16 kB) copied, 0.139005 s, 118 kB/s
>
> so that's why I was asking you if I counted the offset wrong. I took the
> value you asked and divided by 512, but it seems too big
>
> 13500329066496 / 512 = 26367830208
>
> Marc
>
But according to your dump-super output, that's strange.
------
chunk_root              13835462344704 (CR)
         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 13835461197824) (CS)
                 chunk length 33554432 owner 2 stripe_len 65536
                 type SYSTEM|DUP num_stripes 2
                         stripe 0 devid 1 offset 13500327919616 (ST1)
                         dev uuid: 0cf779be-8e16-4982-b7d7-f8241deea0d1
                         stripe 1 devid 1 offset 13500361474048 (ST2)
                         dev uuid: 0cf779be-8e16-4982-b7d7-f8241deea0d1
------

Here, your chunk logical bytenr is 13835461197824, and its physical 
bytenr is 13500327919616 and 13500361474048.

My calculation is quite simple.
Start1 = CR - CS + ST1
Start2 = CR - CS + ST2

Unless the superblock is incorrect, it is not possile.

And the physical offset, is about 12.2 TiB, which is smaller than 15TiB 
of your device.

So that's quite strange that dd can't read out the data.
And if dd can't read it out, then I see no reason btrfs-progs can read 
it out.

Any idea on special dm setup which can make us fail to read out some 
data range?

Thanks,
Qu



