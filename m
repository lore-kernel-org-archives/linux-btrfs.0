Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28500 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750808AbdBBCNC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 21:13:02 -0500
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
To: Christoph Anton Mitterer <christoph.anton.mitterer@lmu.de>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
 <1485276845.12065.1.camel@scientia.net>
 <35be430d-1210-9b33-3b18-c22127cc64a7@cn.fujitsu.com>
 <1485305208.12065.9.camel@scientia.net>
 <8d21a04e-7035-5b5d-5b58-9ac0d7f93f02@cn.fujitsu.com>
 <1485399036.23328.7.camel@scientia.net>
 <bb42c075-fcbd-2248-8e9f-ea5d2a836273@cn.fujitsu.com>
 <1485473476.7613.12.camel@lmu.de>
 <7125b67b-1b7e-c191-290d-cf60e63ee93e@gmx.com>
 <1485745624.6333.1.camel@lmu.de>
 <0715efbc-44cd-5f84-9870-938dd80b7ae3@cn.fujitsu.com>
 <1485986636.6573.13.camel@lmu.de>
 <3c464199-27df-1a81-f309-8491c368ff13@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <97d42767-4ae4-a97e-2625-5028300fff67@cn.fujitsu.com>
Date: Thu, 2 Feb 2017 10:12:57 +0800
MIME-Version: 1.0
In-Reply-To: <3c464199-27df-1a81-f309-8491c368ff13@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/02/2017 08:25 AM, Qu Wenruo wrote:
> Thanks for your test.
>
> At 02/02/2017 06:03 AM, Christoph Anton Mitterer wrote:
>> On Wed, 2017-02-01 at 09:06 +0800, Qu Wenruo wrote:
>>> https://github.com/adam900710/btrfs-progs/tree/lowmem_fixes
>>>
>>> Which is also rebased to latest v4.9.1.
>>
>> Same game as last time, applied to 4.9, no RW mount between the runs.
>>
>>
[snipped]
>> => same as
>> before
>>
>> # btrfs check --mode=lowmem /dev/nbd0 ; echo $?
>> checking extents
>> checking free space cache
>> checking fs roots
>> ERROR: errors found in fs roots
>> Checking filesystem on /dev/nbd0
>> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
>> found 7519512838144 bytes used, error(s) found
>> total csum bytes: 7330834320
>> total tree bytes: 10902437888
>> total fs tree bytes: 2019704832
>> total extent tree bytes: 1020149760
>> btree space waste bytes: 925714197
>> file data blocks allocated: 7509228494848
>>  referenced 7630551511040
>> 1
>>
>> => Unfortunately :-(
>

Would you please to check the latest lowmem_tests branch?
https://github.com/adam900710/btrfs-progs/tree/lowmem_tests

This time I added several debug output to catch the whole path where the 
silent error happens, to help us to solve the problem.

Sorry for the extra trouble.

Thanks,
Qu


