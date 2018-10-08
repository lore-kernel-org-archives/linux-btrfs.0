Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A99CC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 18:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2C272145D
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 18:29:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N37wR+jc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2C272145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbeJIBmS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 21:42:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47758 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbeJIBmS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 21:42:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w98INj3n161123;
        Mon, 8 Oct 2018 18:29:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=JhjCjEXbw/e2Xj9bRHyZUBco29dSbe/ZtKAQkzy4fXU=;
 b=N37wR+jcLNGT1gsWwuWqT9b/o3lq/EXcuKHSnPMDvybxJHT5UYfsyivV80TkaMoxzkrL
 BjRjyt1ONR2T+TWFuz4ScMjldNkBdi2rR60P2lSMT7JJHHLyHRkEHh/mNBJJ1BCpAELr
 rxskBTYvDJOwcLWe4trjg/AkThegQ5gsn/T3IZ3Vu83GHiht/qwQafVAHZRY4MIcYDrj
 4WP1YyFYPmcUysUknPF8RBo2ym2UjM/QZn+VjMiAC+37TvxDXC32F7yYMZbQWlBXGEvD
 6z05YyOjAjhXa8HhSquuumUqfUh+Oci40iOvxeQzn2pcWLTqnwjRTy85ZYYQS1YqYqX1 lg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2mxmftgjdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Oct 2018 18:29:15 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w98ITEDH031851
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Oct 2018 18:29:15 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w98ITErg027616;
        Mon, 8 Oct 2018 18:29:14 GMT
Received: from [10.191.44.115] (/10.191.44.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Oct 2018 18:29:14 +0000
Subject: Re: [PATCH] fstests: btrfs verify hardening agaist duplicate fsid
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1538383475-2532-1-git-send-email-anand.jain@oracle.com>
 <20181006101449.GJ17817@desktop>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <a29ebcda-cf19-2704-2f80-0ec427769317@oracle.com>
Date:   Tue, 9 Oct 2018 02:28:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181006101449.GJ17817@desktop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9040 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810080173
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/06/2018 06:14 PM, Eryu Guan wrote:
> On Mon, Oct 01, 2018 at 04:44:35PM +0800, Anand Jain wrote:
>> We have a known bug in btrfs, that we let the device path be changed
>> after the device has been mounted. So using this loop hole the new
>> copied device would appears as if its mounted immediately after its
>> been copied. So this test case reproduces this issue.
>>
>> For example:
>>
>> Initially.. /dev/mmcblk0p4 is mounted as /
>>
>> lsblk
>> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
>> mmcblk0     179:0    0 29.2G  0 disk
>> |-mmcblk0p4 179:4    0    4G  0 part /
>> |-mmcblk0p2 179:2    0  500M  0 part /boot
>> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
>> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
>>
>> btrfs fi show
>> Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>>      Total devices 1 FS bytes used 1.40GiB
>>      devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4
>>
>> Copy mmcblk0 to sda
>> dd if=/dev/mmcblk0 of=/dev/sda
>>
>> And immediately after the copy completes the change in the device
>> superblock is notified which the automount scans using
>> btrfs device scan and the new device sda becomes the mounted root
>> device.
>>
>> lsblk
>> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
>> sda           8:0    1 14.9G  0 disk
>> |-sda4        8:4    1    4G  0 part /
>> |-sda2        8:2    1  500M  0 part
>> |-sda3        8:3    1  256M  0 part
>> `-sda1        8:1    1  256M  0 part
>> mmcblk0     179:0    0 29.2G  0 disk
>> |-mmcblk0p4 179:4    0    4G  0 part
>> |-mmcblk0p2 179:2    0  500M  0 part /boot
>> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
>> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
>> btrfs fi show /
>> Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>>      Total devices 1 FS bytes used 1.40GiB
>>      devid    1 size 4.00GiB used 3.00GiB path /dev/sda4
>>
>> The bug is quite nasty that you can't either unmount /dev/sda4 or
>> /dev/mmcblk0p4. And the problem does not get solved until you take
>> the sda out of the system on to another system to change its fsid using
>> the 'btrfstune -u' command.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Looks like that the test will break the whole test env as it leaves an
> unmountable $SCRATCH_MNT. I'd wait for the fix to get in first before
> merging the test, in case it breaks normal regression tests. (I noticed
> that the test is not in 'auto' group, so it's not that dangerous.)

Its possible that its unmountable without the kernel patch. But I am 
unable to reproduce it consistently with or without the kernel patch.

Any idea ways to make it auto for kernels without the patch?

> Also, it'd be great if test can be reviewed by btrfs folks too!
> 
>> ---
>>   tests/btrfs/173     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/173.out |  5 ++++
>>   tests/btrfs/group   |  1 +
>>   3 files changed, 78 insertions(+)
>>   create mode 100755 tests/btrfs/173
>>   create mode 100644 tests/btrfs/173.out
>>
>> diff --git a/tests/btrfs/173 b/tests/btrfs/173
>> new file mode 100755
>> index 000000000000..f59a62e206c3
>> --- /dev/null
>> +++ b/tests/btrfs/173
>> @@ -0,0 +1,72 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2018 Oracle. All Rights Reserved.
>> +#
>> +# FS QA Test 173
>> +#
>> +# Fuzzy test for FS image duplication.
>> +#  Could be fixed by
>> +#    [patch] btrfs: harden agaist duplicate fsid
>> +#
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch_dev_pool 2
>> +_scratch_dev_pool_get 2
>> +
>> +dev_foo=$(echo $SCRATCH_DEV_POOL | awk '{print $1}' | rev | cut -d"/" -f1 | rev)
>> +dev_bar=$(echo $SCRATCH_DEV_POOL | awk '{print $2}' | rev | cut -d"/" -f1 | rev)
> 
> This doesn't work if the devices in SCRATCH_DEV_POOL are symlinks, e.g.
> lvm devices: /dev/mapper/testvg-testlv1, dev_foo is "testvg-testlv1" in
> this case.

  Ah, right will fix.

>> +
>> +_mkfs_dev /dev/$dev_foo
> 
> But /dev/testvg-testlv1 isn't existed.
> 
> _short_dev and/or _real_dev is useful in this case. e.g.
> 
> dev_foo=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
> # dev_foo is like "dm-1"
> dev_foo=$(_short_dev $dev_foo)
> # dev_foo is like "/dev/dm-1"
> dev_foo=$(_real_dev $dev_foo)

  I changed the code a bit which avoids the split. Pls review if that 
will be ok.

>> +_mount /dev/$dev_foo $SCRATCH_MNT
> 
> It'd better to mount non-SCRATCH_DEV to other mount point, e.g.
> $TEST_DIR/$seq.mnt

  Will do, any idea why? Isn't the framework automatically try to 
unmount SCRATCH_MNT.

Thanks, Anand

> Thanks,
> Eryu
> 
>> +
>> +echo mount before btrfs image clone | tee -a $seqres.full
>> +findmnt /dev/$dev_foo | grep -v TARGET | awk '{print $1" "$2}' | \
>> +	sed -e "s/$dev_foo/dev_foo/g" | _filter_scratch | tee -a $seqres.full
>> +findmnt /dev/$dev_bar | grep -v TARGET | awk '{print $1" "$2}' | \
>> +	sed -e "s/$dev_bar/dev_bar/g" | _filter_scratch | tee -a $seqres.full
>> +
>> +for sb_bytenr in 65536 67108864
>> +do
>> +	echo -n "dd status=none if=/dev/$dev_foo of=/dev/$dev_bar bs=1 "\
>> +		"seek=$sb_bytenr skip=$sb_bytenr count=4096" >> $seqres.full
>> +	dd status=none if=/dev/$dev_foo of=/dev/$dev_bar bs=1 seek=$sb_bytenr \
>> +				skip=$sb_bytenr count=4096 >> $seqres.full 2>&1
>> +	echo ..:$? >> $seqres.full
>> +done
>> +
>> +echo mount after btrfs image clone | tee -a $seqres.full
>> +findmnt /dev/$dev_foo | grep -v TARGET | awk '{print $1" "$2}' | \
>> +	sed -e "s/$dev_foo/dev_foo/g" | _filter_scratch | tee -a $seqres.full
>> +findmnt /dev/$dev_bar | grep -v TARGET | awk '{print $1" "$2}' | \
>> +	sed -e "s/$dev_bar/dev_bar/g" | _filter_scratch | tee -a $seqres.full
>> +
>> +_scratch_dev_pool_put
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/173.out b/tests/btrfs/173.out
>> new file mode 100644
>> index 000000000000..a2ef7a26f4b9
>> --- /dev/null
>> +++ b/tests/btrfs/173.out
>> @@ -0,0 +1,5 @@
>> +QA output created by 173
>> +mount before btrfs image clone
>> +SCRATCH_MNT /dev/dev_foo
>> +mount after btrfs image clone
>> +SCRATCH_MNT /dev/dev_foo
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index 45782565c3b7..b2f1393f3e97 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -175,3 +175,4 @@
>>   170 auto quick snapshot
>>   171 auto quick qgroup
>>   172 auto quick punch
>> +173 volume
>> -- 
>> 1.8.3.1
>>
