Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:55182 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752979AbdIRNl4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 09:41:56 -0400
Received: by mail-io0-f169.google.com with SMTP id h66so2102693ioh.11
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 06:41:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP9W88gs6xYh4MxU--ktS-Ozv8vqs3q84vp52x8OM=Rz3a12vg@mail.gmail.com>
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
 <CAGqmi74XQkpRwhZ23qyNg7EuGi=aC8aKymUU8g8XeMsLmNHkVA@mail.gmail.com> <CAP9W88gs6xYh4MxU--ktS-Ozv8vqs3q84vp52x8OM=Rz3a12vg@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 18 Sep 2017 16:41:15 +0300
Message-ID: <CAGqmi74Es55Ptfkyd=sBHdfSoE_rqqyis4juZBbiKc9+LAwMGA@mail.gmail.com>
Subject: Re: using fio to test btrfs compression
To: shally verma <shallyvermacavium@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-18 16:28 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
> On Mon, Sep 18, 2017 at 1:56 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>> 2017-09-18 10:36 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
>>> Hi
>>>
>>> I wanted to test btrfs compression using fio command but somehow
>>> during fio writes, I don't see code taking route of compression blocks
>>> where as If I do a copy to btrfs compression enabled mount point then
>>> I can easily see code falling through compression.c.
>>>
>>> Here's how I do my setup
>>>
>>> 1. mkfs.btrfs /dev/sdb1
>>> 2. mount -t btrfs -o compress=zlib,compress-force /dev/sdb1 /mnt
>>> 3. cp <some large test file> /mnt
>>> 4. dmesg shows print staments from compression.c and zlib.c confirming
>>> compression routine was invoked during write
>>> 5. now, copy back from btrfs mount point to home directory also shows
>>> decompress call invokation
>>>
>>> Now, try same with fio commands:
>>>
>>> fio command
>>>
>>> fio --directory=/mnt/ --numjobs=1 --direct=0 --buffered=1
>>> --ioengine=libaio --group_reporting --bs=64k --rw=write --iodepth=128
>>> --name=test --size=10G --runtime=180 --time_based
>>>
>>> But it seems to write uncompressed data.
>>>
>>> Any help here? what's missing?
>>>
>>> Thanks
>>> Shally
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> 1. mount -t btrfs -o compress=zlib,compress-force -> compress-force=zlib
>> 2. Tune fio to generate compressible data
>>
> How do I "tune" fio to generate data. I had assumed once compression
> is enabled on btrfs any system fwrite call will simply compress data
> into it .Isn't it so?
> Can you share fio command that I can test?
> Thanks
> Shally
>>
>> --
>> Have a nice day,
>> Timofey.

That useless to compress uncompressible data.
Also, as you enable compress, not compress-force
So after first uncompressible write btrfs just stop trying compress that file.

>From man fio:
buffer_compress_percentage=int
             If this is set, then fio will attempt to provide I/O
buffer content (on WRITEs) that compresses to the specified level. Fio
does this by providing a mix of random data and a fixed  pattern.  The
 fixed  pattern  is  either
             zeros,  or the pattern specified by buffer_pattern. If
the pattern option is used, it might skew the compression ratio
slightly. Note that this is per block size unit, for file/disk wide
compression level that matches this
             setting, you'll also want to set refill_buffers.

      buffer_compress_chunk=int
             See buffer_compress_percentage. This setting allows fio
to manage how big the ranges of random data and zeroed data is.
Without this set, fio will provide buffer_compress_percentage of
blocksize random  data,  followed  by
             the remaining zeroed. With this set to some chunk size
smaller than the block size, fio can alternate random and zeroed data
throughout the I/O buffer.

Good luck :)
-- 
Have a nice day,
Timofey.
