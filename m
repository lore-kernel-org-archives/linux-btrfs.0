Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33956 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751062AbcK1Akl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Nov 2016 19:40:41 -0500
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
To: <kreijack@inwind.it>, Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
 <20161126185402.GK8685@hungrycats.org>
 <59e0b1c7-51a9-ede4-6571-fa0b20394145@inwind.it>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <451f26a9-2880-9887-c17e-97c2690a2baa@cn.fujitsu.com>
Date: Mon, 28 Nov 2016 08:40:35 +0800
MIME-Version: 1.0
In-Reply-To: <59e0b1c7-51a9-ede4-6571-fa0b20394145@inwind.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/27/2016 07:16 AM, Goffredo Baroncelli wrote:
> On 2016-11-26 19:54, Zygo Blaxell wrote:
>> On Sat, Nov 26, 2016 at 02:12:56PM +0100, Goffredo Baroncelli wrote:
>>> On 2016-11-25 05:31, Zygo Blaxell wrote:
> [...]
>>>
>>> BTW Btrfs in RAID1 mode corrects the data even in the read case. So
>>
>> Have you tested this?  I think you'll find that it doesn't.
>
> Yes I tested it; and it does the rebuild automatically.
> I corrupted a disk of mirror, then I read the related file. The log  says:
>
> [   59.287748] BTRFS warning (device vdb): csum failed ino 257 off 0 csum 12813760 expected csum 3114703128
> [   59.291542] BTRFS warning (device vdb): csum failed ino 257 off 0 csum 12813760 expected csum 3114703128
> [   59.294950] BTRFS info (device vdb): read error corrected: ino 257 off 0 (dev /dev/vdb sector 2154496)
>                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> IIRC In case of RAID5/6 the last line is missing. However in both the case the data returned is good; but in RAID1 the data is corrected also on the disk.
>
> Where you read that the data is not rebuild automatically ?
>
> In fact I was surprised that RAID5/6 behaves differently....
>

Yes, I also tried that and realized that RAID1 is recovering corrupted 
data at *READ* time.

The main difference between RAID1 and RAID56 seems to be the complexity.

For RAID56, we have different read/write behavior, for read, we use flag 
BTRFS_RBIO_READ_REBUILD, which will only rebuild data but not write them 
into disk.
And I'm a little concern about the race between read time fix and write.

I assume it's possible to change the behavior to follow RAID1, but I'd 
like to do it in the following steps:
1) Fix known RAID56 bugs
    With the v3 patch and previous 2 patches, it seems OK now.
2) Full fstests test case, with all possible corruption combination
    (WIP)
3) Rework current RAID56 code to a cleaner and more readable status
    (long term)
4) Add the support to fix things at read time.

So the behavior change is not something we will see in short time.

Thanks,
Qu
>>
>>> I am still convinced that is the RAID5/6 behavior "strange".
>>>
>>> BR
>>> G.Baroncelli
>>> --
>>> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
>>> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>>>
>
>


