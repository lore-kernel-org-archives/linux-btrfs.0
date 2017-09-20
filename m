Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:46523 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbdITIoo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 04:44:44 -0400
Received: by mail-qk0-f171.google.com with SMTP id z143so2029707qkb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 01:44:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP9W88ig1fXyrE0KURbP-1Z0-t63ODADA4HO0tO4KM3eVrRtLg@mail.gmail.com>
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
 <CAGqmi74XQkpRwhZ23qyNg7EuGi=aC8aKymUU8g8XeMsLmNHkVA@mail.gmail.com>
 <CAP9W88gs6xYh4MxU--ktS-Ozv8vqs3q84vp52x8OM=Rz3a12vg@mail.gmail.com>
 <CAGqmi74Es55Ptfkyd=sBHdfSoE_rqqyis4juZBbiKc9+LAwMGA@mail.gmail.com> <CAP9W88ig1fXyrE0KURbP-1Z0-t63ODADA4HO0tO4KM3eVrRtLg@mail.gmail.com>
From: shally verma <shallyvermacavium@gmail.com>
Date: Wed, 20 Sep 2017 14:14:13 +0530
Message-ID: <CAP9W88ifgTWGE_9Xpro=wUJkMSs9263e0Sw6yeG8Km16rdD6AA@mail.gmail.com>
Subject: Re: using fio to test btrfs compression
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 20, 2017 at 2:06 PM, shally verma
<shallyvermacavium@gmail.com> wrote:
> On Mon, Sep 18, 2017 at 7:11 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>> 2017-09-18 16:28 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
>>> On Mon, Sep 18, 2017 at 1:56 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>>>> 2017-09-18 10:36 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
>>>>> Hi
>>>>>
>>>>> I wanted to test btrfs compression using fio command but somehow
>>>>> during fio writes, I don't see code taking route of compression blocks
>>>>> where as If I do a copy to btrfs compression enabled mount point then
>>>>> I can easily see code falling through compression.c.
>>>>>
>>>>> Here's how I do my setup
>>>>>
>>>>> 1. mkfs.btrfs /dev/sdb1
>>>>> 2. mount -t btrfs -o compress=zlib,compress-force /dev/sdb1 /mnt
>>>>> 3. cp <some large test file> /mnt
>>>>> 4. dmesg shows print staments from compression.c and zlib.c confirming
>>>>> compression routine was invoked during write
>>>>> 5. now, copy back from btrfs mount point to home directory also shows
>>>>> decompress call invokation
>>>>>
>>>>> Now, try same with fio commands:
>>>>>
>>>>> fio command
>>>>>
>>>>> fio --directory=/mnt/ --numjobs=1 --direct=0 --buffered=1
>>>>> --ioengine=libaio --group_reporting --bs=64k --rw=write --iodepth=128
>>>>> --name=test --size=10G --runtime=180 --time_based
>>>>>
>>>>> But it seems to write uncompressed data.
>>>>>
>>>>> Any help here? what's missing?
>>>>>
>>>>> Thanks
>>>>> Shally
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>> 1. mount -t btrfs -o compress=zlib,compress-force -> compress-force=zlib
>>>> 2. Tune fio to generate compressible data
>>>>
>>> How do I "tune" fio to generate data. I had assumed once compression
>>> is enabled on btrfs any system fwrite call will simply compress data
>>> into it .Isn't it so?
>>> Can you share fio command that I can test?
>>> Thanks
>>> Shally
>>>>
>>>> --
>>>> Have a nice day,
>>>> Timofey.
>>
>> That useless to compress uncompressible data.
>> Also, as you enable compress, not compress-force
>> So after first uncompressible write btrfs just stop trying compress that file.
>>
>> From man fio:
>> buffer_compress_percentage=int
>>              If this is set, then fio will attempt to provide I/O
>> buffer content (on WRITEs) that compresses to the specified level. Fio
>> does this by providing a mix of random data and a fixed  pattern.  The
>>  fixed  pattern  is  either
>>              zeros,  or the pattern specified by buffer_pattern. If
>> the pattern option is used, it might skew the compression ratio
>> slightly. Note that this is per block size unit, for file/disk wide
>> compression level that matches this
>>              setting, you'll also want to set refill_buffers.
>>
>>       buffer_compress_chunk=int
>>              See buffer_compress_percentage. This setting allows fio
>> to manage how big the ranges of random data and zeroed data is.
>> Without this set, fio will provide buffer_compress_percentage of
>> blocksize random  data,  followed  by
>>              the remaining zeroed. With this set to some chunk size
>> smaller than the block size, fio can alternate random and zeroed data
>> throughout the I/O buffer.
>>
>> Good luck :)
>
> Now. I did following:
>
> 1. mount -t btrfs -o compress-force=zlib /dev/sdb1 mnt
>
> 2. fio --directory=mnt/ --numjobs=1 --direct=0 --buffered=1 --bs=64k
> --rw=write --iodepth=128 --name=test --size=1G
> --buffer_compress_percentage=100 --buffer_pattern=0xFF --refill_buffer
> --ioengine=libaio
>
> 1GN file written uncompressed. Here no compression invoked (though
> compress-force=zlib)
>
> 3. cp mnt/test ./ --> copy back fio generated test file from btrfs
> mount point to local drive
>
> 4. hex dump test file (all FFs) -- confirmed that data is compressible
> no random data.
>
> 5. cp test mnt/  --> now, copy same test again back to mount point
> (reverse of step 3) . Now, here I see during copying compression is
> invoked.
>
> I am using kernel 4.9 and compress-foce is said to be working for
> kernel > 2.13 from wiki ... so I wonder what's so special with cp
> command which is not happening during fio writes???
>
One more catch... I am initiating fio from non-btrfs filesystem i.e.
pwd is ext4 based fs where as mount point is btrfs.
Could that make difference?

> Thanks
> Shally
>
>
>> --
>> Have a nice day,
>> Timofey.
