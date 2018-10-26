Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCEDC6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 15:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B96720868
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 15:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oi6xVgII"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B96720868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbeJ0Afd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 20:35:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58486 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbeJ0Afc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 20:35:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9QFsNM9001150;
        Fri, 26 Oct 2018 15:57:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=v53QAQvSblTSsfAtJuciQKFkop4KCqiIXz4w8Wxsvs8=;
 b=oi6xVgIIb+rwaJq9qf4Jsk4SImIfvTNFe5nluzSgnukd78MnyKeHIIpYXDQgUDE+mBey
 HjBH4fZ+Zt/3yL9S7JnYgTYEB0MgyBjdbIeSTX/0o10jhy4pE/fabCThC2M6OfNCeLRn
 IIbHCIvlNS07Vh37SqWYtlTqL01adAsnaJyQz4Q8yexMaZ8vG1ix9WYMfWvPNKLMqQrv
 jFO8vwF2hX54dF2XTARmQRpbDYo6K1rZxq3HCvrVOpQZ3UnJUotIOzBbDVOgI7iLbX+j
 s3QlL8BO0bP+tryn2SDqFcPf7UCZ8ftub45uWBpZP1m87Z6eOO5ds62+2YMSlu/RkqwZ 8Q== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2n7vaqg2qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Oct 2018 15:57:53 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9QFvqag029113
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Oct 2018 15:57:53 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9QFvqg8031151;
        Fri, 26 Oct 2018 15:57:52 GMT
Received: from [172.20.10.2] (/183.90.36.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 26 Oct 2018 08:57:52 -0700
Subject: Re: [PATCH v2 rev log added] fstests: btrfs verify hardening agaist
 duplicate fsid
To:     Nikolay Borisov <nborisov@suse.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <1538383475-2532-1-git-send-email-anand.jain@oracle.com>
 <1539023301-4583-1-git-send-email-anand.jain@oracle.com>
 <c2e09b66-6c15-9bbe-c340-0a6015ea4a0e@suse.com>
 <6b58c095-d0a1-6330-0385-b06aa9c99483@oracle.com>
 <8003c16e-1eef-1e7e-d697-11d8d32c2e91@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <cbdb0ebb-0bd4-561e-4509-096a72c4e710@oracle.com>
Date:   Fri, 26 Oct 2018 23:57:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <8003c16e-1eef-1e7e-d697-11d8d32c2e91@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9057 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810260134
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/26/2018 11:52 PM, Nikolay Borisov wrote:
> 
> 
> On 26.10.18 г. 18:34 ч., Anand Jain wrote:
>>
>>
>> On 10/26/2018 11:02 PM, Nikolay Borisov wrote:
>>>
>>>
>>> On 8.10.18 г. 21:28 ч., Anand Jain wrote:
>>>> We have a known bug in btrfs, that we let the device path be changed
>>>> after the device has been mounted. So using this loop hole the new
>>>> copied device would appears as if its mounted immediately after its
>>>> been copied. So this test case reproduces this issue.
>>>>
>>>> For example:
>>>>
>>>> Initially.. /dev/mmcblk0p4 is mounted as /
>>>>
>>>> lsblk
>>>> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
>>>> mmcblk0     179:0    0 29.2G  0 disk
>>>> |-mmcblk0p4 179:4    0    4G  0 part /
>>>> |-mmcblk0p2 179:2    0  500M  0 part /boot
>>>> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
>>>> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
>>>>
>>>> btrfs fi show
>>>> Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>>>>       Total devices 1 FS bytes used 1.40GiB
>>>>       devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4
>>>>
>>>> Copy mmcblk0 to sda
>>>> dd if=/dev/mmcblk0 of=/dev/sda
>>>>
>>>> And immediately after the copy completes the change in the device
>>>> superblock is notified which the automount scans using
>>>> btrfs device scan and the new device sda becomes the mounted root
>>>> device.
>>>>
>>>> lsblk
>>>> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
>>>> sda           8:0    1 14.9G  0 disk
>>>> |-sda4        8:4    1    4G  0 part /
>>>> |-sda2        8:2    1  500M  0 part
>>>> |-sda3        8:3    1  256M  0 part
>>>> `-sda1        8:1    1  256M  0 part
>>>> mmcblk0     179:0    0 29.2G  0 disk
>>>> |-mmcblk0p4 179:4    0    4G  0 part
>>>> |-mmcblk0p2 179:2    0  500M  0 part /boot
>>>> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
>>>> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
>>>> btrfs fi show /
>>>> Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>>>>       Total devices 1 FS bytes used 1.40GiB
>>>>       devid    1 size 4.00GiB used 3.00GiB path /dev/sda4
>>>>
>>>> The bug is quite nasty that you can't either unmount /dev/sda4 or
>>>> /dev/mmcblk0p4. And the problem does not get solved until you take
>>>> the sda out of the system on to another system to change its fsid using
>>>> the 'btrfstune -u' command.
>>>
>>> Is there a pending fix for this?
>>
>> Yes.
>> https://patchwork.kernel.org/patch/10641041/
>>
>> Test case header mentioned it.
>>
>>>
>>>>
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>> ---
>>>> v1->v2:
>>>>     dont play around with dev patch use it as it is.
>>>>     do not use SCRATCH_MNT instead create it at the TEST_DIR and its
>>>> related
>>>>      changes.
>>>>     golden out changes
>>>>        tests/btrfs/173     | 88
>>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    tests/btrfs/173.out |  6 ++++
>>>>    tests/btrfs/group   |  1 +
>>>>    3 files changed, 95 insertions(+)
>>>>    create mode 100755 tests/btrfs/173
>>>>    create mode 100644 tests/btrfs/173.out
>>>>
>>>> diff --git a/tests/btrfs/173 b/tests/btrfs/173
>>>> new file mode 100755
>>>> index 000000000000..b466ae921e19
>>>> --- /dev/null
>>>> +++ b/tests/btrfs/173
>>>> @@ -0,0 +1,88 @@
>>>> +#! /bin/bash
>>>> +# SPDX-License-Identifier: GPL-2.0
>>>> +# Copyright (c) 2018 Oracle. All Rights Reserved.
>>>> +#
>>>> +# FS QA Test 173
>>>> +#
>>>> +# Fuzzy test for FS image duplication.
>>>> +#  Could be fixed by
>>>> +#    [patch] btrfs: harden agaist duplicate fsid
>>>> +#
>>>> +seq=`basename $0`
>>>> +seqres=$RESULT_DIR/$seq
>>>> +echo "QA output created by $seq"
>>>> +
>>>> +here=`pwd`
>>>> +tmp=/tmp/$$
>>>> +status=1    # failure is the default!
>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>> +
>>>> +mnt=$TEST_DIR/$seq.mnt
>>>> +_cleanup()
>>>> +{
>>>> +    rm -rf $mnt > /dev/null 2>&1
>>>> +    cd /
>>>> +    rm -f $tmp.*
>>>> +}
>>>> +
>>>> +# get standard environment, filters and checks
>>>> +. ./common/rc
>>>> +. ./common/filter
>>>> +
>>>> +# remove previous $seqres.full before test
>>>> +rm -f $seqres.full
>>>> +
>>>> +# real QA test starts here
>>>> +
>>>> +# Modify as appropriate.
>>>> +_supported_fs btrfs
>>>> +_supported_os Linux
>>>> +_require_scratch_dev_pool 2
>>>> +_scratch_dev_pool_get 2
>>>> +
>>>> +dev_foo=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
>>>> +dev_bar=$(echo $SCRATCH_DEV_POOL | awk '{print $2}')
>>>
>>> Naming devices _foo and _bar just shows you could not care less about
>>> the test.
>>
>>    Hmm. Will make it device_1 and device_2.
>>
>>> Either use sane names - primary_dev/secondary dev or device_1
>>> and device_2.
>>
>>>> +
>>>> +echo dev_foo=$dev_foo >> $seqres.full
>>>> +echo dev_bar=$dev_bar >> $seqres.full
>>>> +echo | tee -a $seqres.full
>>>> +
>>>> +rm -rf $mnt > /dev/null 2>&1
>>>
>>> So what is $mnt? I can see it's used by very few tests and it's not
>>> obvious? Generally you should either define it as a local variable or
>>> use one of the SCRATCH_MNT/TEST_MNT global variables. Also I checked
>>> with Eric re. the use of $mnt in tests and his conclusion is :
>>>
>>> "<sandeen> looks like a bug"
>>
>>   No its not. As few lines above, I have assigned it as..
>>      mnt=$TEST_DIR/$seq.mnt
> 
> I missed that, I will recommend moving the assignment near where you set
> the devices

  cleanup() is using $mnt. cleanup() may get called for any trap before 
the actual test.

Thanks, Anand


>>
>>
>>>> +mkdir $mnt
>>>> +_mkfs_dev $dev_foo
>>>> +_mount $dev_foo $mnt
>>>> +
>>>> +check_btrfs_mount()
>>>> +{
>>>> +    local x=$(findmnt $mnt | grep -v TARGET | awk '{print $2}')
>>>> +    [[ $x == $dev_foo ]] && echo DEV_FOO
>>>> +    [[ $x == $dev_bar ]] && echo DEV_BAR
>>>> +}
>>>
>>> Same thing here re. DEV_(FOO|BAR).
>>>
>>>> +
>>>> +echo MNT $(check_btrfs_mount)
>>>> +
>>>> +for sb_bytenr in 65536 67108864
>>>> +do
>>>> +    echo -n "dd status=none if=$dev_foo of=$dev_bar bs=1 "\
>>>> +        "seek=$sb_bytenr skip=$sb_bytenr count=4096" >> $seqres.full
>>>> +    dd status=none if=$dev_foo of=$dev_bar bs=1 seek=$sb_bytenr \
>>>> +                skip=$sb_bytenr count=4096 >> $seqres.full 2>&1
>>>> +    echo ..:$? >> $seqres.full
>>>
>>> This is an overkill, just use dd ... >/dev/null 2>&1, no one cares about
>>> the output of that. Also use DIO so that sb's are directly written to
>>> the devices.
>>
>>   Yeah right will fix.
>>
>>>> +done
>>>> +
>>>> +#Original device is mounted, scan of its clone should fail
>>>> +$BTRFS_UTIL_PROG device scan $dev_bar >> $seqres.full 2>&1
>>>> +echo btrfs device scan dev_bar ...:$?| tee -a $seqres.full
>>>> +
>>>> +echo MNT $(check_btrfs_mount)
>>>> +
>>>> +#Original device scan should be successful
>>>> +$BTRFS_UTIL_PROG device scan $dev_foo >> $seqres.full 2>&1
>>>> +echo btrfs device scan dev_foo ...:$?| tee -a $seqres.full
>>>> +
>>>> +umount $mnt > /dev/null 2>&1
>>>> +_scratch_dev_pool_put
>>>> +
>>>> +# success, all done
>>>> +status=0
>>>> +exit
>>>> diff --git a/tests/btrfs/173.out b/tests/btrfs/173.out
>>>> new file mode 100644
>>>> index 000000000000..3c7e3fb4e3f7
>>>> --- /dev/null
>>>> +++ b/tests/btrfs/173.out
>>>> @@ -0,0 +1,6 @@
>>>> +QA output created by 173
>>>> +
>>>> +MNT DEV_FOO
>>>> +btrfs device scan dev_bar ...:1
>>>> +MNT DEV_FOO
>>>> +btrfs device scan dev_foo ...:0
>>>
>>> It seems the output is really pointless it should just be "Silence is
>>> golden". Then in the test you would do all your run-time checks of
>>> what's the source of the mount etc etc and if your expectations don't
>>> match you fail the test and don't output "Silence is golden" which would
>>> signal success. Check for example
>>
>>   I could do that. Will fix.
>>
>> Thanks, Anand
>>
>>>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>>>> index 45782565c3b7..b2f1393f3e97 100644
>>>> --- a/tests/btrfs/group
>>>> +++ b/tests/btrfs/group
>>>> @@ -175,3 +175,4 @@
>>>>    170 auto quick snapshot
>>>>    171 auto quick qgroup
>>>>    172 auto quick punch
>>>> +173 volume
>>>>
>>
