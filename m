Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58653 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaGDFRQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 01:17:16 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 005C23EE0B6
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 14:17:14 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 0CC79AC03EB
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 14:17:13 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id AC11F1DB8038
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 14:17:12 +0900 (JST)
Message-ID: <53B638B1.7080203@jp.fujitsu.com>
Date: Fri, 4 Jul 2014 14:16:33 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Kevin Brandstatter <icarusthecow@gmail.com>, <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: Quota Ignored On write
References: <53B60DE1.9070905@gmail.com> <53B60F91.9070004@jp.fujitsu.com> <53B610B6.8020704@gmail.com> <53B61247.4070406@jp.fujitsu.com> <53B61E94.3030908@jp.fujitsu.com>
In-Reply-To: <53B61E94.3030908@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef, Chris, Kevin,

(2014/07/04 12:25), Satoru Takeuchi wrote:
> Hi Chris and Kevin,
>
>>> On 07/03/2014 09:21 PM, Satoru Takeuchi wrote:
>>>> Hi Kevin,
>>>>
>>>> (2014/07/04 11:13), Kevin Brandstatter wrote:
>>>>> basing of the latest for-linus branch i found i can write way more than
>>>>> the quota
>>>>>
>>>>> btrfs quota enable
>>>>> btrfs subvolume create test
>>>>> btrfs qgruop limit 1G test
>>>>> dd if=/dev/zero of=test/file bs=1024 count=1500000
>>>>> output:
>>>>> 1500000+0 records in
>>>>> 1500000+0 records out
>>>>> 1536000000 bytes (1.5 GB) copied, 5.91909 s, 259 MB/s
>>>>>
>>>>> thats a full half gig over the quota limit. I noticed some changes to
>>>>> the quota
>>>>> accounting in the logs, what changed that could cause this?
>>>>
>>>> Do you remember what kernel version quota worked correctly?
> (2014/07/04 11:32), Satoru Takeuchi wrote:
>> (2014/07/04 11:25), Kevin Brandstatter wrote:
>>> 3.15.3 via arch/ and from linux-git
>>
>> OK, I'll bisect it.
>
> I made the following reproducer based on your operation.
> It succeeded with 3.15 and failed with 3.16-rc3. So, the problematic
> patch is not in mason/for-linux branch, but in somewhere between
> 3.15 and 3.16-rc3. Please wait for a while to finish my bisect...

I bisected and found the bad commit is the following patch.

===============================================================================
commit fcebe4562dec83b3f8d3088d77584727b09130b2
Author: Josef Bacik <jbacik@fb.com>
Date:   Tue May 13 17:30:47 2014 -0700

     Btrfs: rework qgroup accounting
===============================================================================

Josef, please take a look at this patch.

Thanks,
Satoru

>
> ===============================================================================
> #!/bin/bash -x
>
> TEST_DEV=/dev/vdb
> TEST_MNT=/home/sat/mnt
>
> umount $TEST_MNT
> mkfs.btrfs -f $TEST_DEV
> mount $TEST_DEV $TEST_MNT
> btrfs quota enable $TEST_MNT
>
> SUBVOLPATH=$TEST_MNT/quota_test
> LIMIT=$((1024*1000000))
> btrfs subvolume create $SUBVOLPATH
> btrfs qgroup limit $LIMIT $SUBVOLPATH
> TESTFILE=$SUBVOLPATH/test
> dd if=/dev/zero of=$TESTFILE bs=1024 count=$(($LIMIT*3/2/1024))
> SIZE=$(($(ls -s $TESTFILE | awk '{print $1}')*1024))
>
> RET=0
> if [ $SIZE -le $LIMIT ] ; then
>    echo "[PASS] quota works correctly" >&2
> else
>    echo "[FAIL] quota doesn't work" >&2
>    RET=1
> fi
>
> exit $RET
> ===============================================================================
>
> Thanks,
> Satoru
>
>>>>
>>>> Thanks,
>>>> Satoru
>>>>
>>>>>
>>>>> -Kevin Brandstatter
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

