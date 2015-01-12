Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45781 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750967AbbALEUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Jan 2015 23:20:09 -0500
Message-ID: <54B34B78.2000601@cn.fujitsu.com>
Date: Mon, 12 Jan 2015 12:20:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Dmitriy Perlow <dap@open.by>, <linux-btrfs@vger.kernel.org>
Subject: Re: Any help to restore broken partition?
References: <op.xsbdt8ccodbuyo@darkness> <54B328F0.4010207@cn.fujitsu.com> <op.xsbz12d2odbuyo@darkness>
In-Reply-To: <op.xsbz12d2odbuyo@darkness>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Any help to restore broken partition?
From: Dmitriy Perlow <dap@open.by>
To: <linux-btrfs@vger.kernel.org>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月12日 11:59
> Qu Wenruo <quwenruo@cn.fujitsu.com>  Mon, 12 Jan 2015 04:52:48 +0300:
>
>> Hi,
>> -------- Original Message --------
>> Subject: Any help to restore broken partition?
>> From: Dmitriy Perlow <dap@open.by>
>> To: <linux-btrfs@vger.kernel.org>
>> Date: 2015年01月12日 03:59
>>> Hi to all!
>>>
>>> I've been using btrfs at my /home partition without any problems for 
>>> about
>>> 3 years but today it was made read only. I umounted it and executed 
>>> `btrfs
>>> check --repair` and got lots of errors.
>> Did you saved all the outputs of the btrfsck --repair?
>
> No, sorry.
>
>>> I run openSUSE 13.1 x64 with linux 3.11.10, Btrfs v3.18+20141230.
>> Kernel is somewhat old, but btrfs-progs is new enough for possible 
>> recovery.
>>>
>>> # btrfs fi show
>>> Label: none  uuid: 96e5c775-86b2-4dd9-a671-fe9a343cc10b
>>>             Total devices 1 FS bytes used 5.35GiB
>>>             devid    1 size 10.85GiB used 10.85GiB path /dev/sda3
>> Size seems small enough to do a full dd backup.
>> Better to do it in case btrfsck --repair makes things worse.
>> But it seems too late for your case.... it should be done before any 
>> 'btrfs check --repair'
>>
>> Also, you can use btrfs-image to do a backup, which should be much 
>> smaller than dd dump,
>> at the cost of no data dumped
>> (mainly used for dev purpose, like to check btrfsck works as expected 
>> or not,
>> and since it contains no data but only metadata, it should be 
>> somewhat OK to send it to developers)
>
> Attached.
It's quite wired....
BLOCK_GROUP_ITEM is everywhere where it shouldn't be...
In ROOT tree, CSUM tree, even FS tree.

So the filesystem is totally damaged.
>
>> If it's OK for you, it would be better to dump the driver with "-c9" 
>> option and send it to us for better test.
>>
>>>
>>> # mount -o ro,recovery /home
>>> → no directories except of lost+found.
>> And what's inside that dir?
>
> -rwx------ 1 root root 0 2015-01-11 23:23 1103101952
> -rwx------ 1 root root 0 2015-01-11 23:23 12582912
> -rwx------ 1 root root 0 2015-01-11 23:23 20971520
> -rwx------ 1 root root 0 2015-01-11 23:23 2176843776
> -rwx------ 1 root root 0 2015-01-11 23:23 29360128
> -rwx------ 1 root root 0 2015-01-11 23:23 29368320
> -rwx------ 1 root root 0 2015-01-11 23:23 29380608
> -rwx------ 1 root root 0 2015-01-11 23:23 29384704
> -rwx------ 1 root root 0 2015-01-11 23:23 3250585600
> -rwx------ 1 root root 0 2015-01-11 23:23 4194304
> -rwx------ 1 root root 0 2015-01-11 23:23 4324327424
> -rwx------ 1 root root 0 2015-01-11 23:23 5398069248
> -rwx------ 1 root root 0 2015-01-11 23:23 6471811072
> -rwx------ 1 root root 0 2015-01-11 23:23 7545552896
> -rwx------ 1 root root 0 2015-01-11 23:23 8619294720
> -rwx------ 1 root root 0 2015-01-11 23:23 9693036544
btrfsck repaired the fs tree with what it can recover, but only inode 
number is recovered...
So no help.
>
>>> # btrfs check /dev/sda3
>>> Checking filesystem on /dev/sda3
>>> UUID: 96e5c775-86b2-4dd9-a671-fe9a343cc10b
>>> checking extents
>>> Block Group[0, 4194304] existed.
>>> Block Group[4194304, 8388608] existed.
>>> Block Group[12582912, 8388608] existed.
>>> Block Group[20971520, 8388608] existed.
>>> Block Group[29360128, 1073741824] existed.
>>> Block Group[1103101952, 1073741824] existed.
>>> Block Group[2176843776, 1073741824] existed.
>>> Block Group[3250585600, 1073741824] existed.
>>> Block Group[4324327424, 1073741824] existed.
>>> Block Group[5398069248, 1073741824] existed.
>>> Block Group[6471811072, 1073741824] existed.
>>> Block Group[7545552896, 1073741824] existed.
>>> Block Group[8619294720, 1073741824] existed.
>>> Block Group[9693036544, 874512384] existed.
>> Seems only block group problems. --init-extent-tree may helps.
>> WARNING: Do it *AFTER* a full backup or do it on a btrfs-image 
>> restored backup!!
>
> It didn't.
Due to the totally damaged trees, it's not strange it didn't help.

Sorry for not providing too much help

Thanks,
Qu
>
>>> Errors found in extent allocation tree or chunk allocation
>>> checking free space cache
>>> cache and super generation don't match, space cache will be invalidated
>>> checking fs roots
>>> checking csums
>>> checking root refs
>> Other things seems good.
>> Seems btrfsck --repair did the job, hoping your btrfs-progs has the 
>> patch to fix a bug that
>> may delete all the repaired files...
>>
>> Thanks,
>> Qu
>>>
>>> found 36864 bytes used err is 0
>>> total csum bytes: 0
>>> total tree bytes: 20480
>>> total fs tree bytes: 8192
>>> total extent tree bytes: 4096
>>> btree space waste bytes: 15135
>>> file data blocks allocated: 0
>>>  referenced 0
>>>
>>>
>>> Any help please?
>
>

