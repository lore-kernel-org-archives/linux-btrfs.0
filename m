Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:65200 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaISBlz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 21:41:55 -0400
Received: by mail-ig0-f196.google.com with SMTP id h18so15405igc.7
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 18:41:54 -0700 (PDT)
Message-ID: <541B89E0.5010905@gmail.com>
Date: Thu, 18 Sep 2014 21:41:52 -0400
From: nick <yocto6@gmail.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: XFS Tests for Btrfs
References: <541B3D0C.4040004@gmail.com> <541B8215.9080301@cn.fujitsu.com> <541B8430.7040000@gmail.com> <541B8993.1000604@cn.fujitsu.com>
In-Reply-To: <541B8993.1000604@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14-09-18 09:40 PM, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: XFS Tests for Btrfs
> From: nick <yocto6@gmail.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
> Date: 2014年09月19日 09:17
>>
>> On 14-09-18 09:08 PM, Qu Wenruo wrote:
>>> Hi,
>>>
>>> Xfstests uses several environment variants to setup the test environment.
>>> You can set it manually using export, or write them into local.conf in xfstests directory.
>>>
>>> These environment variants are mandatory:
>>> TEST_DEV: device for normal tests, like all generic tests
>>> TEST_DIR: where TEST_DEV is mounted to.
>>>
>>> And somecommon optional environment variants:
>>> SCRATCH_DEV: scratch device for some tests, if you want to test btrfs' multi device related feature, you need
>>> to set SCRATCH_DEV_POOL.
>>> SCRATCH_DEV_POOL: a list for devices mainly for btrfs' muti-device related test.
>>> SCRATCH_MNT: where SCRATCH_DEV/SCRATCH_DEV_POOL is mounted to.
>>>
>>> SCRATCH_DEV_POOL should not contain the TEST_DEV.
>>>
>>> FSTYP: the filesystem type you want to test.
>>> MKFS_OPTIONS: the mkfs time options. Useful to test mkfs time feature like no-holes.
>>> MOUNT_OPTIONS: the mount time options. Useful to test feature like compress.
>>>
>>> So short guide on how to run xfstests:
>>> 1. download the xfstests source, better the git version
>>>
>>> 2. compile xfstests
>>> make will do everything for you, except you lacks some headers or dependency.
>>> When that happens, follow your distribution's method to install them.
>>>
>>> 3. setup the environment variants
>>> Manually or into the local.conf is both OK.
>>>
>>> 4. run tests
>>> You can run all tests by ./check -g auto, or multiple/single test using blob/testcase number like:
>>> # ./check generic/311
>>> # ./check btrfs/[0-9][0-9][0-9]
>>>
>>> Thanks
>>> Qu
>>>
>>> -------- Original Message --------
>>> Subject: XFS Tests for Btrfs
>>> From: nick <yocto6@gmail.com>
>>> To: <linux-btrfs@vger.kernel.org>
>>> Date: 2014年09月19日 04:14
>>>> Hey Fellow Btrfs Developers,
>>>> I am wondering how to run the xfs tests for btrfs as I tried to do it based on a link online
>>>> written I believe a few years ago. If someone can help me get set up for testing the btrfs
>>>> code using xfs tests that would be great. In addition afterwards I already build kernel 3.17
>>>> r5 release candidate and would be glad to run any times you need run to test single drive
>>>> config issues.
>>>> Thanks Nick
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> The issue I was hitting was my TEST_DIR not being configured properly. I will list my variables below.
>> /dev/sdc1 was my TEST_DEV
>> /media/nick/x was my TEST_DIR
>> Nick
> Did you mkfs on TEST_DEV? Can TEST_DEV be mounted correctly?
> 
> Thanks,
> Qu
I partitioned  it using gparted and I can mount it normally but not with xfstests.
Nick 
