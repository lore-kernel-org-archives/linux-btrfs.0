Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49279 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbdJEBa2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 21:30:28 -0400
Subject: Re: Can't mount array with super_total_bytes mismatch with fs_devices
 total_rw_bytes
To: Asif Youssuff <yoasif@gmail.com>, linux-btrfs@vger.kernel.org
References: <f561678d-17f0-f06e-b781-3445a59e0349@gmail.com>
 <9dc8fe6e-bda5-2b19-b616-ab64696f2102@gmx.com>
 <fdc1dcba-219b-bff2-0b67-eedd97a6d4ba@gmail.com>
 <7cbdb7e9-3c1b-c5cb-4ff0-4530de23f6e1@gmx.com>
 <b109b1f1-9ebd-7dc8-d7fd-990d877cd2ab@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <52bdb59b-a7e2-302a-475f-d29be8876658@gmx.com>
Date: Thu, 5 Oct 2017 09:30:21 +0800
MIME-Version: 1.0
In-Reply-To: <b109b1f1-9ebd-7dc8-d7fd-990d877cd2ab@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年10月05日 07:13, Asif Youssuff wrote:
> 
> 
> On 10/04/2017 01:18 AM, Qu Wenruo wrote:
>>
>>
>> On 2017年10月04日 12:00, Asif Youssuff wrote:
>>> Thanks for the advice.
>>>
>>> On 10/03/2017 09:38 PM, Qu Wenruo wrote:
>>>
>>>
>>>>>
>>>>> [210017.281912] BTRFS info (device sdb): disk space caching is enabled
>>>>> [210017.281915] BTRFS info (device sdb): has skinny extents
>>>>> [210017.402084] BTRFS error (device sdb): super_total_bytes 
>>>>> 92017859088384
>>>>> mismatch with fs_devices total_rw_bytes 92017859094528
>>>>
>>>> One of your device size is not aligned to 4K.
>>>> Which is fine, but recently enhanced validation checker does not 
>>>> allow it.
>>>> (Which should be a regression, and there is some other WARN_ON 
>>>> related to it)
>>>>
>>>>> [210017.402126] BTRFS error (device sdb): failed to read chunk 
>>>>> tree: -22
>>>>> [210017.461473] BTRFS error (device sdb): open_ctree failed
>>>>>
>>>>> I've tried a few steps --
>>>>>
>>>>> btrfs-chunk-recover, super-recover and I have run a btrfs check 
>>>>> --repair on two of the disks in the array (this takes a very long 
>>>>> time, so I'm hoping I don't have to run this on all of the disks).
>>>>>
>>>>> I had run into this problem once before in the past, and I'm not 
>>>>> sure how I recovered from it; I may have simply rolled back the 
>>>>> booted kernel to escape the extra checks around this mismatch.
>>>>>
>>>>> I'm at a loss for ideas and am running a btrfs-image so I can also 
>>>>> report an issue -- I'm not sure whether 'btrfs-image -c9 -t4 
>>>>> /dev/sdo btrfs.image' is  the right command to run if it is a 
>>>>> multi-device array.
>>>>>
>>>>> Any ideas would be helpful, and I am happy to provide further 
>>>>> information.
>>>>>
>>>>> root@ubuntu-server:~#   uname -a
>>>>> Linux ubuntu-server 4.14.0-041400rc2-generic #201709242031 SMP Mon 
>>>>> Sep 25 00:33:13 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>> You can rollback to an earlier kernel to mount the fs.
>>>>
>>>> And manually find and resize the device with unaligned size:
>>>>
>>>> # btrfs fi show -b
>>>> And check each device for its size:
>>>> Label: none  uuid: 839ddcfa-5701-4437-aff3-bcb2a26ae6dd
>>>>      Total devices 1 FS bytes used 397312
>>>>      devid    1 size <<10737418240>> used 2172649472 path 
>>>> /dev/mapper/data-btrfs
>>>>
>>>> If it's not align, round it down to 4K, and resize it using devid:
>>>>
>>>> # btrfs fi resize <devid>:<rounded_size> <mount_point>
>>>>
>>>> All device must be rounded. And the command should finish almost in 
>>>> no time.
>>>
>>> I was able to mount the fs using kernel version 4.4 and rounded down 
>>> (took the size in bytes, and rounded down to a smaller number 
>>> divisible by 4096).
>>>
>>> This is what btrfs fi show looks like now:
>>>
>>> asif@ubuntu-server:~$ sudo btrfs fi show --raw
>>> [sudo] password for asif:
>>> Label: none  uuid: 48ed8a66-731d-499b-829e-dd07dd7260cc
>>>      Total devices 13 FS bytes used 44783241728000
>>>      devid    4 size 6001141571584 used 5955045097472 path /dev/sdh
>>>      devid    5 size 6001141571584 used 5955128983552 path /dev/sdg
>>>      devid    7 size 6001141571584 used 5955709960192 path /dev/sdk
>>>      devid    9 size 6001175126016 used 5955716186112 path /dev/sde
>>>      devid   10 size 6001141571584 used 5955145760768 path /dev/sdc
>>>      devid   11 size 8001563222016 used 7955416416256 path /dev/sdl
>>>      devid   12 size 6001175126016 used 5956054286336 path /dev/sdf
>>>      devid   14 size 8001563222016 used 7956009123840 path /dev/sdb
>>>      devid   15 size 8001563222016 used 7956373831680 path /dev/sdj
>>>      devid   17 size 8001563222016 used 6341094866944 path /dev/sdd
>>>      devid   18 size 8001563222016 used 7955827064832 path /dev/sdn
>>>      devid   20 size 8001563222016 used 7955378339840 path /dev/sdi
>>>      devid   21 size 8001563222016 used 7955386728448 path /dev/sdo
>>>
>>>>
>>>> Then check if latest kernel can mount it.
>>>
>>> Unfortunately, the latest kernel still cannot mount it, showing  the 
>>> same errors as before.
>>>
>>> [  139.852862] BTRFS error (device sdj): super_total_bytes 
>>> 92017859086336 mismatch with fs_devices total_rw_bytes 92017859092480
>>> [  139.852894] BTRFS error (device sdj): failed to read chunk tree: -22
>>> [  139.916645] BTRFS error (device sdj): open_ctree failed
>>
>> Then the problem is btrfs doesn't update its super_total_bytes correctly.
>>
>>  From what I can see, grow/shrink only update its delta, not 
>> re-calculate it.
>>
>> Before we have a good way to fix it in kernel, the only way is to 
>> manually modify the superblock to allow it pass kernel validation 
>> checker.
>>
> 
> A manual edit of the superblock sounds painful unless there is good 
> documentation for that.

I'll submit a patchset for btrfs-progs.
So you can later use "btrfs check --fix-dev-size" to fix it, no matter 
how kernel part changes.

> 
> How can I follow up to get this fixed in the kernel? Do we have enough 
> information in this thread to create a bug on bugzilla?  Should I open one?

A bugzilla may help us to trace it.
Feel free to open one.

Thanks,
Qu

> 
> Thanks!
>> Thanks,
>> Qu
>>>
>>>>
>>>> I think it can be made as part of "btrfs check" to fix it.
>>>> (Although it should be handled by kernel well)
>>>>
>>>> Thanks,
>>>> Qu
>>>
>>> Hope there are some other ideas (or please correct me if I have done 
>>> something wrong!).
>>>
>>> Thanks,
>>> Asif
>>>
>>>>
>>>>>
>>>>> root@ubuntu-server:~#   btrfs --version
>>>>> btrfs-progs v4.13.1
>>>>>
>>>>> root@ubuntu-server:~#   btrfs fi show
>>>>> Label: none  uuid: 48ed8a66-731d-499b-829e-dd07dd7260cc
>>>>> Total devices 13 FS bytes used 40.73TiB
>>>>> devid    4 size 5.46TiB used 5.42TiB path /dev/sdo
>>>>> devid    5 size 5.46TiB used 5.42TiB path /dev/sdn
>>>>> devid    7 size 5.46TiB used 5.42TiB path /dev/sdc
>>>>> devid    9 size 5.46TiB used 5.42TiB path /dev/sdk
>>>>> devid   10 size 5.46TiB used 5.42TiB path /dev/sdj
>>>>> devid   11 size 7.28TiB used 7.24TiB path /dev/sdd
>>>>> devid   12 size 5.46TiB used 5.42TiB path /dev/sdm
>>>>> devid   14 size 7.28TiB used 7.24TiB path /dev/sdh
>>>>> devid   15 size 7.28TiB used 7.24TiB path /dev/sdb
>>>>> devid   17 size 7.28TiB used 5.77TiB path /dev/sdl
>>>>> devid   18 size 7.28TiB used 7.24TiB path /dev/sdf
>>>>> devid   20 size 7.28TiB used 7.24TiB path /dev/sdi
>>>>> devid   21 size 7.28TiB used 7.24TiB path /dev/sdg
>>>>>
>>>>> Thanks,
>>>>> Asif
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
