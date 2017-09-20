Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:45762 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdITLKq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 07:10:46 -0400
Received: by mail-qk0-f175.google.com with SMTP id r141so2323104qke.2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 04:10:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi77ZFmaeSf_Ehoe_T76_RqnG2YcG68y57w8UVpuJ=_awcA@mail.gmail.com>
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
 <CAGqmi74XQkpRwhZ23qyNg7EuGi=aC8aKymUU8g8XeMsLmNHkVA@mail.gmail.com>
 <CAP9W88gs6xYh4MxU--ktS-Ozv8vqs3q84vp52x8OM=Rz3a12vg@mail.gmail.com>
 <CAGqmi74Es55Ptfkyd=sBHdfSoE_rqqyis4juZBbiKc9+LAwMGA@mail.gmail.com>
 <CAP9W88ig1fXyrE0KURbP-1Z0-t63ODADA4HO0tO4KM3eVrRtLg@mail.gmail.com>
 <CAP9W88ifgTWGE_9Xpro=wUJkMSs9263e0Sw6yeG8Km16rdD6AA@mail.gmail.com>
 <CAGqmi75DoErKwwHu7+abu62sUbbEgjMZ1ExzpCpQ68JKmTF==g@mail.gmail.com>
 <CAP9W88ip0ef7yFc3-o8LNO=WsBjhpADbSuzQoppz6yC5KpRTQg@mail.gmail.com>
 <CAGqmi75wKaxpJNO6HfjUJZU4tESQA-r_4rTfe7MY9KW5C67JaQ@mail.gmail.com>
 <CAP9W88hrM+9vPTL=RFXC9+VdWSLMvM1UAtR+XX89FcvorYLqvQ@mail.gmail.com> <CAGqmi77ZFmaeSf_Ehoe_T76_RqnG2YcG68y57w8UVpuJ=_awcA@mail.gmail.com>
From: shally verma <shallyvermacavium@gmail.com>
Date: Wed, 20 Sep 2017 16:40:15 +0530
Message-ID: <CAP9W88g-XpOcL0CyVOHEGkTc7YN=Kodpb7XCVF45TcO+equ2Vw@mail.gmail.com>
Subject: Re: using fio to test btrfs compression
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 20, 2017 at 4:00 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> 2017-09-20 13:13 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
>> On Wed, Sep 20, 2017 at 3:06 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>>> 2017-09-20 11:59 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
>>>> On Wed, Sep 20, 2017 at 2:25 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>>>>> 2017-09-20 11:44 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
>>>>>> One more catch... I am initiating fio from non-btrfs filesystem i.e.
>>>>>> pwd is ext4 based fs where as mount point is btrfs.
>>>>>> Could that make difference?
>>>>>>
>>>>>>> Thanks
>>>>>>> Shally
>>>>>
>>>>> Only matter are where you store test file =)
>>>>> If you store test file on btrfs, pwd does nothing.
>>>>>
>>>>
>>>> Then steps listed in previous mail should work right?  Am listing them
>>>> again here:
>>>>
>>>> " ----
>>>>>
>>>>> 1. mount -t btrfs -o compress-force=zlib /dev/sdb1 mnt
>>>>>
>>>>> 2. fio --directory=mnt/ --numjobs=1 --direct=0 --buffered=1 --bs=64k
>>>>> --rw=write --iodepth=128 --name=test --size=1G
>>>>> --buffer_compress_percentage=100 --buffer_pattern=0xFF --refill_buffer
>>>>> --ioengine=libaio
>>>>>
>>>>> 1GN file written uncompressed. Here no compression invoked (though
>>>>> compress-force=zlib)
>>>>>
>>>>> 3. cp mnt/test ./ --> copy back fio generated test file from btrfs
>>>>> mount point to local drive
>>>>>
>>>>> 4. hex dump test file (all FFs) -- confirmed that data is compressible
>>>>> no random data.
>>>>>
>>>>> 5. cp test mnt/  --> now, copy same test again back to mount point
>>>>> (reverse of step 3) . Now, here I see during copying compression is
>>>>> invoked.
>>>>>
>>>>> I am using kernel 4.9 and compress-foce is said to be working for
>>>>> kernel > 2.13 from wiki ... so I wonder what's so special with cp
>>>>> command which is not happening during fio writes???
>>>>
>>>> "-----
>>>>
>>>> Thanks
>>>> Shally
>>>>
>>>>
>>>>> --
>>>>> Have a nice day,
>>>>> Timofey.
>>>
>>> I did try reproduce your problem on 4.14, i'm hard to explain that
>>> happens and why file created by FIO will not use compression.
>>>
>>> Suggest workaround:
>>> rm -v /mnt/test.0.0
>>> dd if=/dev/zero of=/mnt/test.0.0 bs=1M count=1024
>>
>> You mean "compression" using "dd" write.
>>
>>> fio --directory=$HOME/test/ --numjobs=1 --direct=1 --buffered=0
>>> --bs=64k --rw=write --iodepth=128 --name=test --size=1G
>>> --buffer_compress_percentage=100 --buffer_pattern=0xFF --refill_buffer
>>> --ioengine=libaio
>>
>> You mean "no compression" during fio writes and you see similar behavior as I?
>> BTW here --direct=0 and --buffered = 1.
>>
>>>
>>> You can check if data compressed by filefrag -v /mnt/test.0.0 (you
>>> will see encoded extents)
>>>
>> if I do filefrag on mnt/test.0.0, then it shows up like this:
>> ext:     logical_offset:        physical_offset: length:   expected: flags:
>>    0:        0..       1:    1329922..   1329923:      2:
>>    1:        2..       3:    1329923..   1329924:      2:    1329924:
>>    2:        4..       5:    1329924..   1329925:      2:    1329925:
>>
>> An new to this, how does it says extents are encoded here?
>>
>> Thanks
>> Shally
>>
>>> --
>>> Have a nice day,
>>> Timofey.
>
> Yes, i was reproduce your problem, new file created by fio not compressed.
> So i write you about workaround, because i don't want to deep dig in
> that problem.
>
> Example of encoded:
> ~ dd if=/dev/zero of=./test.0.0 bs=1M count=1M count=1; sync
> ~ filefrag -v test.0.0
> Filesystem type is: 9123683e
> File size of test.0.0 is 1048576 (256 blocks of 4096 bytes)
> ext:     logical_offset:        physical_offset: length:   expected: flags:
>   0:        0..      31:   72779979..  72780010:     32:             encoded
>   1:       32..      63:   72751509..  72751540:     32:   72780011: encoded
>   2:       64..      95:   72755246..  72755277:     32:   72751541: encoded
>   3:       96..     127:   72755610..  72755641:     32:   72755278: encoded
>   4:      128..     159:   72755631..  72755662:     32:   72755642: encoded
>   5:      160..     191:   72755722..  72755753:     32:   72755663: encoded
>   6:      192..     223:   72757862..  72757893:     32:   72755754: encoded
>   7:      224..     255:   72769455..  72769486:     32:   72757894:
> last,encoded,eof
> test.0.0: 8 extents found
>
Interesting part is I dont see "encoded" under flags. I couldn't
understand if flags are retrieved from btrfs file metadata info. As
you are running on 4.14 and I am on 4.9

So, am still under doubt, even with dd if files are getting compressed.

What is the filesize shown if you run
btrfs fi du /mnt/test0.0 .. is it less or actual size?

Is there any command that i can run to confirm file has been compressed?

So far, I had my prints enabled in kernel/fs/btrfs/compression.c and
check in dmesg that code jumped to compress_page() func.

Thanks
Shally

> --
> Have a nice day,
> Timofey.
