Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37965 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754354AbdECUwO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 16:52:14 -0400
Subject: Re: [PATCH 0/2] [RFC] Introduce device state 'failed'
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <20170503133457.9901-1-anand.jain@oracle.com>
 <6d31270e-f569-28d0-a40f-50113c36cd50@gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <3145dc93-6b00-7385-5209-f842e8fad974@oracle.com>
Date: Thu, 4 May 2017 04:57:50 +0800
MIME-Version: 1.0
In-Reply-To: <6d31270e-f569-28d0-a40f-50113c36cd50@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/03/2017 11:31 PM, Austin S. Hemmelgarn wrote:
> On 2017-05-03 09:34, Anand Jain wrote:
>> As the below two patches are about managing the failed disk,
>> I have separated them from the spare disk and auto replace
>> support patch set which was sent before here [1]..
>>
>>     [1] https://lwn.net/Articles/684195/
>>
>> V7 changes are very limited in this individual patches. But adds
>> the mount option degrad without going through the remount. And is
>> for your comments, (RFC).
>>
>> This set [1] was extensively tested, however as these two patches
>> are out of the set now, and with a minor change v6-v7, I have
>> removed the Tested-by: sorry.
> Entirely understood.
>>
>> The script which I have used to verify v7 is here [2], which
>> eventually will be part of fstests, once we confirm on the RFC.
>>
>> [2]
>> ----------------
>> create_err_dev_raid1()
>> {
>>         dm_backing_dev="/dev/sdd"
>>         blk_dev_size=`blockdev --getsz $dm_backing_dev`
>>         dmerror_dev="/dev/mapper/dm-sdd"
>>         dmlinear_table="0 $blk_dev_size linear $dm_backing_dev 0"
>>         dmerror_table="0 $blk_dev_size error $dm_backing_dev 0"
>>
>>         echo -e dm_backing_dev'\t'= $dm_backing_dev
>>         echo -e blk_dev_size'\t'= $blk_dev_size
>>         [[ $blk_dev_size ]] || exit
>>         echo -e dmerror_dev'\t'= $dmerror_dev
>>         echo -e dmlinear_table'\t'= $dmlinear_table
>>         echo -e dmerror_table'\t'= $dmerror_table
>>         echo
>>
>>         runnt "dmsetup remove dm-sdd > /dev/null 2>&1"
>>         run "dmsetup create dm-sdd --table '${dmlinear_table}'"
>>
>>         run "mkfs.btrfs -f -draid1 -mraid1 /dev/sdc $dmerror_dev >
>> /dev/null 2>&1"
>>         run mount /dev/sdc /btrfs
>>         run "dd if=/dev/zero of=/btrfs/tf1 bs=4096 count=100 >
>> /dev/null 2>&1"
>>
>>         run btrfs fi show -m /btrfs
>>
>>         run dmsetup suspend dm-sdd
>>         run "dmsetup load dm-sdd --table '$dmerror_table'"
>>         run dmsetup resume dm-sdd
>>         run "dd if=/dev/zero of=/btrfs/tf1 bs=4096 count=100 >
>> /dev/null 2>&1"
>>
>>     run sleep 32
>>         run btrfs fi show -m /btrfs
>>     run cat /proc/self/mounts
>> }
>> ---------------
>>
>> Anand Jain (2):
>>   btrfs: introduce device dynamic state transition to offline or failed
>>   btrfs: check device for critical errors and mark failed
>>
>>  fs/btrfs/ctree.h   |   2 +
>>  fs/btrfs/disk-io.c | 101 ++++++++++++++++++++++++++++++++++++++-
>>  fs/btrfs/volumes.c | 135
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/volumes.h |  18 +++++++
>>  4 files changed, 255 insertions(+), 1 deletion(-)
>>
> All my tests passed, and manual testing shows that it does as
> advertised, so for the series as a whole you can add:
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

Thanks!
  Anand

