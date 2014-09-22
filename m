Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:56596 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaIVKHG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 06:07:06 -0400
Received: by mail-ig0-f173.google.com with SMTP id l13so2383848iga.6
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 03:07:04 -0700 (PDT)
Message-ID: <541FF4C5.3030005@gmail.com>
Date: Mon, 22 Sep 2014 06:07:01 -0400
From: nick <yocto6@gmail.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: XFS Tests for Btrfs
References: <541B3D0C.4040004@gmail.com> <541B8215.9080301@cn.fujitsu.com> <541B8430.7040000@gmail.com> <541B8993.1000604@cn.fujitsu.com> <541B89E0.5010905@gmail.com> <541B8AFC.5040208@cn.fujitsu.com> <541B8C90.7030503@gmail.com> <541B90C8.60806@cn.fujitsu.com> <541B9591.7040509@gmail.com> <541B9680.5020309@cn.fujitsu.com> <541B9783.2020609@gmail.com> <541B98EE.1070908@cn.fujitsu.com> <541C0A4D.80501@gmail.com> <541FDB2A.6060706@cn.fujitsu.com>
In-Reply-To: <541FDB2A.6060706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14-09-22 04:17 AM, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: XFS Tests for Btrfs
> From: nick <yocto6@gmail.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014年09月19日 18:49
>>
>> On 14-09-18 10:46 PM, Qu Wenruo wrote:
>>> -------- Original Message --------
>>> Subject: Re: XFS Tests for Btrfs
>>> From: nick <yocto6@gmail.com>
>>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> Date: 2014年09月19日 10:40
>>>> [snip]
>>>>>> Sorry Qu,ur local _scratch_mkfs routine ...
>>>>>> Error: unable to open /dev/sdc: Device or resource busy
>>>>>> check: failed to mkfs $SCRATCH_DEV using specified options
>>>>>> Passed all 0 tests
>>>>>> Is happening to me now. How do I fix this ?
>>>>>> Nick
>>>>>>
>>>>> Full local.conf please.
>>>>>
>>>>> Also lsblk output is needed.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>> Thank for the Help Qu,
>>>> Here is the output of lsblk:
>>>> NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
>>>> sda      8:0    0 111.8G  0 disk
>>>> └─sda1   8:1    0 111.8G  0 part /
>>>> sdb      8:16   0 465.8G  0 disk
>>>> ├─sdb1   8:17   0   7.6G  0 part [SWAP]
>>>> └─sdb2   8:18   0 458.1G  0 part /home
>>>> sdc      8:32   0 931.5G  0 disk
>>>> └─sdc1   8:33   0 931.5G  0 part
>>>> sr0     11:0    1  1024M  0 rom
>>>> # Ideally define at least these 4 to match your environment
>>>> # The first 2 are required.
>>>> # See README for other variables which can be set.
>>>> #
>>>> # Note: SCRATCH_DEV >will< get overwritten!
>>>>
>>>> export TEST_DEV=/dev/sdX1
>>>> export TEST_DIR=/mnt/test
>>>> export SCRATCH_DEV=/dev/sdX2
>>>> export SCRATCH_MNT=/mnt/scratch.
>>>> I am new to this so sorry for the troubles.
>>>> Nick
>>> Part your /dev/sdc into the following layout:
>>> sdc
>>>      sdc5        40G    <- Use as TEST_DEV
>>>      sdc6        15G
>>>      sdc7        15G
>>>      sdc8        15G
>>>      sdc9        15G
>>>
>>> then
>>> # mkfs.btrfs -f /dev/sdc5
>>> # mkfs.btrfs -f /dev/sdc[6-9]
>>> # mkdir -p /mnt/test
>>> # mkdir -p /mnt/scratch
>>>
>>>
>>> then write your local.conf like the following:
>>> export FSTYP=btrfs
>>> export TEST_DEV=/dev/sdc5
>>> export TEST_MNT=/mnt/test
>>> export SCRATCH_DEV_POOL="/dev/sdc6 /dev/sdc7 /dev/sdc8 /dev/sdc9"
>>> export SCRATCH_MNT=/mnt/scratch
>>>
>>> Then, you should be able to run ./check -g auto.
>>>
>>> Thanks,
>>> Qu
>> I got three failing tests now, would you like me to post the logs.
>> Nick
> There are some tests that are already known to fail but not bugs or already fixed.
> 
> As far as I can tell, if using 3.17-rc1,
> btrfs/010, btrfs/047, btrfs/054 are always failure under all mount options.
> btrfs/010 is somewhat outdated, since kernel now disables defrage with subvolume, so it will never pass.
> btrfs/047 and btrfs/054, as you can see in the comments of these tests, it's already fixed.
> Maybe next release or later RCs.
> 
> Generic/015 and generic/027 will sometims fail using nodatasum/nodatacow/compress=lzo mount options
> Also generic/275 will sometimes fail with compress=lzo, none of them is bug.
> Some btrfs features or designs make them not pass.
> 
> Geneirc/018 will always fails with nodatacow mount option, but the patch is already sent.
> 
> So if you encounters other bugs, I'll be happen to see the failed test number and test log.
> 
> BTW, as I mentioned, different mount options may cause different test results,
> so it's high recommended to run xfstest against all supported mount options.
> 
> Thanks,
> Qu
> 
> 
Qu,
I will run the tests later and see if any of them are failing beside the ones you mentioned.
Nick
