Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33473 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730897AbeGRRpn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 13:45:43 -0400
Received: by mail-io0-f177.google.com with SMTP id z20-v6so4711728iol.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 10:06:53 -0700 (PDT)
Subject: Re: Healthy amount of free space?
To: Chris Murphy <lists@colorremedies.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Nikolay Borisov <nborisov@suse.com>, Wolf <wolf@wolfsden.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
 <2197534.TZSffJRfLT@merkaba> <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com>
 <1736761.B5nO4FXixV@merkaba> <33396c10-33ef-b8ff-0041-c94d87c67722@gmail.com>
 <CAJCQCtSZruKeM117EfQNQnEFuk_bswhhKnEnFVD2i7MHWU65RQ@mail.gmail.com>
 <d42d5c79-46df-4e11-0ba2-1adb9e073ed9@gmail.com>
 <CAJCQCtSpMi-GmJSQx+tjt+WjDqvEH5Z9yeUrYSjLFz+P4f2j2A@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0a3a8550-3622-0c7b-bcf7-e2d7cabf6b4a@gmail.com>
Date: Wed, 18 Jul 2018 13:06:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSpMi-GmJSQx+tjt+WjDqvEH5Z9yeUrYSjLFz+P4f2j2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-18 13:04, Chris Murphy wrote:
> On Wed, Jul 18, 2018 at 7:30 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>>
>> I'm not sure.  In this particular case, this will fail on BTRFS for any X
>> larger than just short of one third of the total free space.  I would expect
>> it to fail for any X larger than just short of half instead.
> 
> I'm confused. I can't get it to fail when X is 3/4 of free space.
> 
> lvcreate -V 2g -T vg/thintastic -n btrfstest
> mkfs.btrfs -M /dev/mapper/vg-btrfstest
> mount /dev/mapper/vg-btrfstest /mnt/btrfs
> cd /mnt/btrfs
> fallocate -l 1500m tmp
> dd if=/dev/zero of=/mnt/btrfs/tmp bs=1M count=1450
> 
> Succeeds. No enospc. This is on kernel 4.17.6.
Odd, I could have sworn it would fail reliably.  Unless something has 
changed since I last tested though, doing it with X equal to the free 
space on the filesystem will fail.
> 
> 
> Copied from terminal:
> 
> [chris@f28s btrfs]$ df -h
> Filesystem                Size  Used Avail Use% Mounted on
> /dev/mapper/vg-btrfstest  2.0G   17M  2.0G   1% /mnt/btrfs
> [chris@f28s btrfs]$ sudo fallocate -l 1500m /mnt/btrfs/tmp
> [chris@f28s btrfs]$ filefrag -v tmp
> Filesystem type is: 9123683e
> File size of tmp is 1572864000 (384000 blocks of 4096 bytes)
>   ext:     logical_offset:        physical_offset: length:   expected: flags:
>     0:        0..   32767:      16400..     49167:  32768:             unwritten
>     1:    32768..   65535:      56576..     89343:  32768:      49168: unwritten
>     2:    65536..   98303:     109824..    142591:  32768:      89344: unwritten
>     3:    98304..  131071:     163072..    195839:  32768:     142592: unwritten
>     4:   131072..  163839:     216320..    249087:  32768:     195840: unwritten
>     5:   163840..  196607:     269568..    302335:  32768:     249088: unwritten
>     6:   196608..  229375:     322816..    355583:  32768:     302336: unwritten
>     7:   229376..  262143:     376064..    408831:  32768:     355584: unwritten
>     8:   262144..  294911:     429312..    462079:  32768:     408832: unwritten
>     9:   294912..  327679:     482560..    515327:  32768:     462080: unwritten
>    10:   327680..  344063:      89344..    105727:  16384:     515328: unwritten
>    11:   344064..  360447:     142592..    158975:  16384:     105728: unwritten
>    12:   360448..  376831:     195840..    212223:  16384:     158976: unwritten
>    13:   376832..  383999:     249088..    256255:   7168:     212224:
> last,unwritten,eof
> tmp: 14 extents found
> [chris@f28s btrfs]$ df -h
> Filesystem                Size  Used Avail Use% Mounted on
> /dev/mapper/vg-btrfstest  2.0G  1.5G  543M  74% /mnt/btrfs
> [chris@f28s btrfs]$ sudo dd if=/dev/zero of=/mnt/btrfs/tmp bs=1M count=1450
> 1450+0 records in
> 1450+0 records out
> 1520435200 bytes (1.5 GB, 1.4 GiB) copied, 13.4757 s, 113 MB/s
> [chris@f28s btrfs]$ df -h
> Filesystem                Size  Used Avail Use% Mounted on
> /dev/mapper/vg-btrfstest  2.0G  1.5G  591M  72% /mnt/btrfs
> [chris@f28s btrfs]$ filefrag -v tmp
> Filesystem type is: 9123683e
> File size of tmp is 1520435200 (371200 blocks of 4096 bytes)
>   ext:     logical_offset:        physical_offset: length:   expected: flags:
>     0:        0..   16383:     302336..    318719:  16384:
>     1:    16384..   32767:     355584..    371967:  16384:     318720:
>     2:    32768..   49151:     408832..    425215:  16384:     371968:
>     3:    49152..   65535:     462080..    478463:  16384:     425216:
>     4:    65536..   73727:     515328..    523519:   8192:     478464:
>     5:    73728..   86015:       3328..     15615:  12288:     523520:
>     6:    86016..   98303:     256256..    268543:  12288:      15616:
>     7:    98304..  104959:      49168..     55823:   6656:     268544:
>     8:   104960..  109047:     105728..    109815:   4088:      55824:
>     9:   109048..  113143:     158976..    163071:   4096:     109816:
>    10:   113144..  117239:     212224..    216319:   4096:     163072:
>    11:   117240..  121335:     318720..    322815:   4096:     216320:
>    12:   121336..  125431:     371968..    376063:   4096:     322816:
>    13:   125432..  128251:     425216..    428035:   2820:     376064:
>    14:   128252..  131071:     478464..    481283:   2820:     428036:
>    15:   131072..  132409:       1460..      2797:   1338:     481284:
>    16:   132410..  165177:     322816..    355583:  32768:       2798:
>    17:   165178..  197945:     376064..    408831:  32768:     355584:
>    18:   197946..  230713:     429312..    462079:  32768:     408832:
>    19:   230714..  263481:     482560..    515327:  32768:     462080:
>    20:   263482..  296249:      16400..     49167:  32768:     515328:
>    21:   296250..  327687:      56576..     88013:  31438:      49168:
>    22:   327688..  328711:     428036..    429059:   1024:      88014:
>    23:   328712..  361479:     109824..    142591:  32768:     429060:
>    24:   361480..  371199:      88014..     97733:   9720:     142592: last,eof
> tmp: 25 extents found
> [chris@f28s btrfs]$
> 
> 
> *shrug*
> 
> 

