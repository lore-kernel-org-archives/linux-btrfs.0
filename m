Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54096 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751301AbcKGBMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Nov 2016 20:12:07 -0500
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
To: Marc MERLIN <marc@merlins.org>
References: <20161031054719.GN28648@merlins.org>
 <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com>
 <20161031062509.GO28648@merlins.org>
 <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com>
 <20161031063737.GP28648@merlins.org>
 <81e30812-be45-b4ff-3bf2-c79e805d445a@cn.fujitsu.com>
 <20161031084412.GI16645@carfax.org.uk> <20161031150422.GQ28648@merlins.org>
 <38fa8b04-ec2d-884f-e03c-8bc2fb888efb@cn.fujitsu.com>
 <20161101042140.atn73lqehgpqslgz@merlins.org>
 <20161104080113.GG3529@merlins.org>
CC: Hugo Mills <hugo@carfax.org.uk>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4a5c36c5-3608-ef78-892c-6157bf2f34ae@cn.fujitsu.com>
Date: Mon, 7 Nov 2016 09:11:54 +0800
MIME-Version: 1.0
In-Reply-To: <20161104080113.GG3529@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/04/2016 04:01 PM, Marc MERLIN wrote:
> On Mon, Oct 31, 2016 at 09:21:40PM -0700, Marc MERLIN wrote:
>> On Tue, Nov 01, 2016 at 12:13:38PM +0800, Qu Wenruo wrote:
>>> Would you try to locate the range where we starts to fail to read?
>>>
>>> I still think the root problem is we failed to read the device in user
>>> space.
>>
>> Understood.
>>
>> I'll run this then:
>> myth:~# dd if=/dev/mapper/crypt_bcache0 of=/dev/null bs=1M &
>> [2] 21108
>> myth:~# while :; do killall -USR1 dd; sleep 1200; done
>> 275+0 records in
>> 274+0 records out
>> 287309824 bytes (287 MB) copied, 7.20248 s, 39.9 MB/s
>>
>> This will take a while to run, I'll report back on how far it goes.
>
> Well, turns out you were right. My array is 14TB and dd was only able to
> copy 8.8TB out of it.
>
> I wonder if it's a bug with bcache and source devices that are too big?

At least we know it's not a problem of btrfs-progs.

And for bcache/soft raid/encryption, unfortunately I'm not familiar with 
any of them.

I would recommend to report it to bcache/mdadm/encryption ML after 
locating the layer which returns EINVAL.

>
> 8782434271232 bytes (8.8 TB) copied, 214809 s, 40.9 MB/s
> dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
> 8388608+0 records in
> 8388608+0 records out
> 8796093022208 bytes (8.8 TB) copied, 215197 s, 40.9 MB/s
> [2]+  Exit 1                  dd if=/dev/mapper/crypt_bcache0 of=/dev/null bs=1M
>
> What's vexing is that absolutely nothing has been logged in the kernel dmesg
> buffer about this read error.
>
> Basically I have this:
> sde                            8:64   0   3.7T  0
> └─sde1                         8:65   0   3.7T  0
>   └─md5                        9:5    0  14.6T  0
>     └─bcache0                252:0    0  14.6T  0
>       └─crypt_bcache0 (dm-0) 253:0    0  14.6T  0
>
> I'll try dd'ing the md5 directly now, but that's going to take another 2 days :(

No need to read them out, just reading from the 8T would be good enough 
for me.

BTW, that's really a complicated layout, with soft raid, bcache, and 
encryption, it will take a long time to find the real cause.

But at least we know the 8.8T position, we can save some time not 
reading the whole disk.

Thanks,
Qu

>
> That said, given that almost half the device is not readable from user space
> for some reason, that would explain why btrfs check is failing. Obviously it
> can't do its job if it can't read blocks.
>
> I'll report back on what I find out with this problem but if you have
> suggestions on what to look for, let me know :)
>
> Thanks.
> Marc
>


