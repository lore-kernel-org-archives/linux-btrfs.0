Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33469 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdIVFeB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 01:34:01 -0400
Received: by mail-qt0-f196.google.com with SMTP id b1so64179qtc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Sep 2017 22:34:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi74eviuSf=LL7sGEJnH1YYqu_pHdaGDvq4Qdr4aSpvqxkQ@mail.gmail.com>
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
 <CAGqmi74XQkpRwhZ23qyNg7EuGi=aC8aKymUU8g8XeMsLmNHkVA@mail.gmail.com>
 <CAP9W88gs6xYh4MxU--ktS-Ozv8vqs3q84vp52x8OM=Rz3a12vg@mail.gmail.com>
 <CAGqmi74Es55Ptfkyd=sBHdfSoE_rqqyis4juZBbiKc9+LAwMGA@mail.gmail.com>
 <CAP9W88ig1fXyrE0KURbP-1Z0-t63ODADA4HO0tO4KM3eVrRtLg@mail.gmail.com>
 <CAP9W88ifgTWGE_9Xpro=wUJkMSs9263e0Sw6yeG8Km16rdD6AA@mail.gmail.com>
 <CAGqmi75DoErKwwHu7+abu62sUbbEgjMZ1ExzpCpQ68JKmTF==g@mail.gmail.com>
 <CAP9W88ip0ef7yFc3-o8LNO=WsBjhpADbSuzQoppz6yC5KpRTQg@mail.gmail.com>
 <CAGqmi75wKaxpJNO6HfjUJZU4tESQA-r_4rTfe7MY9KW5C67JaQ@mail.gmail.com>
 <CAP9W88hrM+9vPTL=RFXC9+VdWSLMvM1UAtR+XX89FcvorYLqvQ@mail.gmail.com>
 <CAGqmi77ZFmaeSf_Ehoe_T76_RqnG2YcG68y57w8UVpuJ=_awcA@mail.gmail.com>
 <CAP9W88g-XpOcL0CyVOHEGkTc7YN=Kodpb7XCVF45TcO+equ2Vw@mail.gmail.com> <CAGqmi74eviuSf=LL7sGEJnH1YYqu_pHdaGDvq4Qdr4aSpvqxkQ@mail.gmail.com>
From: shally verma <shallyvermacavium@gmail.com>
Date: Fri, 22 Sep 2017 11:03:30 +0530
Message-ID: <CAP9W88hH32dYTLocRtTaFhCfY1qSgUA-F=ThKWmWMtsK7XDNGQ@mail.gmail.com>
Subject: Re: using fio to test btrfs compression
To: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: vikas.aggarwal@cavium.com,
        "Narayana, Prasad Athreya" <PrasadAthreya.Narayana@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 20, 2017 at 5:26 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> 2017-09-20 14:10 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
>> Interesting part is I dont see "encoded" under flags. I couldn't
>> understand if flags are retrieved from btrfs file metadata info. As
>> you are running on 4.14 and I am on 4.9
>>
>> So, am still under doubt, even with dd if files are getting compressed.
>>
>> What is the filesize shown if you run
>> btrfs fi du /mnt/test0.0 .. is it less or actual size?
>>
>> Is there any command that i can run to confirm file has been compressed?
>>
>> So far, I had my prints enabled in kernel/fs/btrfs/compression.c and
>> check in dmesg that code jumped to compress_page() func.
>>
>> Thanks
>> Shally
>>
>
> Okay, lets play different.
> encoded work for last several years for kernel releases, so you must see that.
>
> Reproduction script:
> #!/bin/bash -e
>
> FILE_NAME=$RANDOM$RANDOM
> TMP_DIR=$(mktemp -d)
> IMAGE_FILE="$HOME/$FILE_NAME"
>
> truncate -s 4G $IMAGE_FILE
> mkfs.btrfs -m single -L COMPRESS_TEST $IMAGE_FILE
> mount -o compress-force $IMAGE_FILE $TMP_DIR
> dd if=/dev/zero bs=128K count=2 of=$TMP_DIR/zero
> sync
> filefrag -v $TMP_DIR/zero
> umount $TMP_DIR
> rm -v $IMAGE_FILE
>
> Example output:
> ~ sudo ./btrfs_compress_test.sh
> btrfs-progs v4.13
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              COMPRESS_TEST
> UUID:               abfedc39-dd94-4105-87d6-49eedb13467f
> Node size:          16384
> Sector size:        4096
> Filesystem size:    4.00GiB
> Block group profiles:
>  Data:             single            8.00MiB
>  Metadata:         single            8.00MiB
>  System:           single            4.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>   ID        SIZE  PATH
>    1     4.00GiB  /root/322906281
>
> 2+0 records in
> 2+0 records out
> 262144 bytes (262 kB, 256 KiB) copied, 0.000197746 s, 1.3 GB/s
> Filesystem type is: 9123683e
> File size of /tmp/tmp.bDyt3EkEG5/zero is 262144 (64 blocks of 4096 bytes)
> ext:     logical_offset:        physical_offset: length:   expected: flags:
>   0:        0..      31:       3072..      3103:     32:             encoded
>   1:       32..      63:       3073..      3104:     32:       3104:
> last,encoded,eof
> /tmp/tmp.bDyt3EkEG5/zero: 2 extents found
> removed '/root/322906281'
>
> Good luck.
Here's my output - Everything is same except:

1. nodesize and sector size = 64K
2. extent length = 2
3. I  don't see "encoded" in filefrag here.

btrfs-progs v4.13
See http://btrfs.wiki.kernel.org for more information.

Label:              COMPRESS_TEST
UUID:               fad6907e-d4eb-4dbb-9014-3918a822c9ce
Node size:          65536
Sector size:        65536
Filesystem size:    4.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         single            8.00MiB
  System:           single            4.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1     4.00GiB  /root/2808626087

2+0 records in
2+0 records out
262144 bytes (262 kB) copied, 0.00028777 s, 911 MB/s
Filesystem type is: 9123683e
File size of /tmp/tmp.346ESCdOIi/zero is 262144 (4 blocks of 65536 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       1:        192..       193:      2:
   1:        2..       3:        193..       194:      2:        194: eof
/tmp/tmp.346ESCdOIi/zero: 2 extents found
removed '/root/2808626087'

And this is my dmesg

[170127.417119] BTRFS: device label COMPRESS_TEST devid 1 transid 5 /dev/loop0
[170127.417493] BTRFS info (device loop0): force zlib compression
[170127.417496] BTRFS info (device loop0): disk space caching is enabled
[170127.417499] BTRFS info (device loop0): has skinny extents
[170127.425858] BTRFS info (device loop0): creating UUID tree

This is fio --version
fio-3.0

What do we doubt here?

Thanks
Shally

> --
> Have a nice day,
> Timofey.
