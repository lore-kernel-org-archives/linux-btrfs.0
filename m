Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:45666 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdITJhC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 05:37:02 -0400
Received: by mail-oi0-f43.google.com with SMTP id z73so1765954oia.2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 02:37:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP9W88ip0ef7yFc3-o8LNO=WsBjhpADbSuzQoppz6yC5KpRTQg@mail.gmail.com>
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
 <CAGqmi74XQkpRwhZ23qyNg7EuGi=aC8aKymUU8g8XeMsLmNHkVA@mail.gmail.com>
 <CAP9W88gs6xYh4MxU--ktS-Ozv8vqs3q84vp52x8OM=Rz3a12vg@mail.gmail.com>
 <CAGqmi74Es55Ptfkyd=sBHdfSoE_rqqyis4juZBbiKc9+LAwMGA@mail.gmail.com>
 <CAP9W88ig1fXyrE0KURbP-1Z0-t63ODADA4HO0tO4KM3eVrRtLg@mail.gmail.com>
 <CAP9W88ifgTWGE_9Xpro=wUJkMSs9263e0Sw6yeG8Km16rdD6AA@mail.gmail.com>
 <CAGqmi75DoErKwwHu7+abu62sUbbEgjMZ1ExzpCpQ68JKmTF==g@mail.gmail.com> <CAP9W88ip0ef7yFc3-o8LNO=WsBjhpADbSuzQoppz6yC5KpRTQg@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 20 Sep 2017 12:36:21 +0300
Message-ID: <CAGqmi75wKaxpJNO6HfjUJZU4tESQA-r_4rTfe7MY9KW5C67JaQ@mail.gmail.com>
Subject: Re: using fio to test btrfs compression
To: shally verma <shallyvermacavium@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-20 11:59 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
> On Wed, Sep 20, 2017 at 2:25 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>> 2017-09-20 11:44 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
>>> One more catch... I am initiating fio from non-btrfs filesystem i.e.
>>> pwd is ext4 based fs where as mount point is btrfs.
>>> Could that make difference?
>>>
>>>> Thanks
>>>> Shally
>>
>> Only matter are where you store test file =)
>> If you store test file on btrfs, pwd does nothing.
>>
>
> Then steps listed in previous mail should work right?  Am listing them
> again here:
>
> " ----
>>
>> 1. mount -t btrfs -o compress-force=zlib /dev/sdb1 mnt
>>
>> 2. fio --directory=mnt/ --numjobs=1 --direct=0 --buffered=1 --bs=64k
>> --rw=write --iodepth=128 --name=test --size=1G
>> --buffer_compress_percentage=100 --buffer_pattern=0xFF --refill_buffer
>> --ioengine=libaio
>>
>> 1GN file written uncompressed. Here no compression invoked (though
>> compress-force=zlib)
>>
>> 3. cp mnt/test ./ --> copy back fio generated test file from btrfs
>> mount point to local drive
>>
>> 4. hex dump test file (all FFs) -- confirmed that data is compressible
>> no random data.
>>
>> 5. cp test mnt/  --> now, copy same test again back to mount point
>> (reverse of step 3) . Now, here I see during copying compression is
>> invoked.
>>
>> I am using kernel 4.9 and compress-foce is said to be working for
>> kernel > 2.13 from wiki ... so I wonder what's so special with cp
>> command which is not happening during fio writes???
>
> "-----
>
> Thanks
> Shally
>
>
>> --
>> Have a nice day,
>> Timofey.

I did try reproduce your problem on 4.14, i'm hard to explain that
happens and why file created by FIO will not use compression.

Suggest workaround:
rm -v /mnt/test.0.0
dd if=/dev/zero of=/mnt/test.0.0 bs=1M count=1024
fio --directory=$HOME/test/ --numjobs=1 --direct=1 --buffered=0
--bs=64k --rw=write --iodepth=128 --name=test --size=1G
--buffer_compress_percentage=100 --buffer_pattern=0xFF --refill_buffer
--ioengine=libaio

You can check if data compressed by filefrag -v /mnt/test.0.0 (you
will see encoded extents)

-- 
Have a nice day,
Timofey.
