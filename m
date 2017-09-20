Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:44082 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdITI7k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 04:59:40 -0400
Received: by mail-qt0-f172.google.com with SMTP id o13so2114885qtf.1
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 01:59:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi75DoErKwwHu7+abu62sUbbEgjMZ1ExzpCpQ68JKmTF==g@mail.gmail.com>
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
 <CAGqmi74XQkpRwhZ23qyNg7EuGi=aC8aKymUU8g8XeMsLmNHkVA@mail.gmail.com>
 <CAP9W88gs6xYh4MxU--ktS-Ozv8vqs3q84vp52x8OM=Rz3a12vg@mail.gmail.com>
 <CAGqmi74Es55Ptfkyd=sBHdfSoE_rqqyis4juZBbiKc9+LAwMGA@mail.gmail.com>
 <CAP9W88ig1fXyrE0KURbP-1Z0-t63ODADA4HO0tO4KM3eVrRtLg@mail.gmail.com>
 <CAP9W88ifgTWGE_9Xpro=wUJkMSs9263e0Sw6yeG8Km16rdD6AA@mail.gmail.com> <CAGqmi75DoErKwwHu7+abu62sUbbEgjMZ1ExzpCpQ68JKmTF==g@mail.gmail.com>
From: shally verma <shallyvermacavium@gmail.com>
Date: Wed, 20 Sep 2017 14:29:08 +0530
Message-ID: <CAP9W88ip0ef7yFc3-o8LNO=WsBjhpADbSuzQoppz6yC5KpRTQg@mail.gmail.com>
Subject: Re: using fio to test btrfs compression
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 20, 2017 at 2:25 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> 2017-09-20 11:44 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
>> One more catch... I am initiating fio from non-btrfs filesystem i.e.
>> pwd is ext4 based fs where as mount point is btrfs.
>> Could that make difference?
>>
>>> Thanks
>>> Shally
>
> Only matter are where you store test file =)
> If you store test file on btrfs, pwd does nothing.
>

Then steps listed in previous mail should work right?  Am listing them
again here:

" ----
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

"-----

Thanks
Shally


> --
> Have a nice day,
> Timofey.
