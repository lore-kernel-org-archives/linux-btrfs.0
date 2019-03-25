Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325A4C4360F
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECCF320854
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K+SZhEVr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfCYMmI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:42:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50414 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730858AbfCYMmE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 08:42:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2PCcw63152954;
        Mon, 25 Mar 2019 12:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hebY1JrHFg0ecyrakRlA+prJiAx0wiX8McU2aAL3s7w=;
 b=K+SZhEVrPmLCy5R2SRKVfFxMkZ0iXxImozfkLM8XXZr68WWvxTPGH1l4iVENwzs4elhd
 YezO0QMYjiCV00xkHykj3gquGDPGicEeR9fjnry8BmUI1A62R672VPucZG0GrhZwFDP/
 B4guXTTrSF3nl20hr/Og+dvrhhox9156tvOtrR6IULwPozAH093dHZoqdd+i/Igx1fct
 /X9FpCkUPiQZb5dAiBQB6wmYP8FwzwukdRrZrvLu3XvJF+0pbR5G8ZpsX/l2RBsAUSB4
 pNk20JQdaVwEHD7o9HJXQP9I+OX4g6SxS9/bq0WjJ5/2evo/M9xs9K79Bcpvvsx2P/LX Aw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2re6g0kq9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 12:41:38 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2PCfWfL001392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 12:41:32 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2PCfVWc006321;
        Mon, 25 Mar 2019 12:41:31 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Mar 2019 05:41:31 -0700
Subject: Re: [PATCH] fstests: Verify that removed device has its superblocks
 deleted
From:   Anand Jain <anand.jain@oracle.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     guaneryu@gmail.com, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20190325094200.18687-1-nborisov@suse.com>
 <620fe973-9b9a-8915-8b41-bb1baccfee2b@oracle.com>
Message-ID: <b7d33a7f-9f38-11a5-aab0-eb4639b603a0@oracle.com>
Date:   Mon, 25 Mar 2019 20:41:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <620fe973-9b9a-8915-8b41-bb1baccfee2b@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9205 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903250094
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/25/19 8:36 PM, Anand Jain wrote:
> 
> 
> On 3/25/19 5:42 PM, Nikolay Borisov wrote:
>> When a device is removed from a btrfs filesystem its superblock copies
>> must be deleted. This test ensures this is indeed the case.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>   tests/btrfs/184     | 57 
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/184.out |  2 ++
>>   tests/btrfs/group   |  1 +
>>   3 files changed, 60 insertions(+)
>>   create mode 100755 tests/btrfs/184
>>   create mode 100644 tests/btrfs/184.out
>>
>> diff --git a/tests/btrfs/184 b/tests/btrfs/184
>> new file mode 100755
>> index 000000000000..3bf7d201a145
>> --- /dev/null
>> +++ b/tests/btrfs/184
>> @@ -0,0 +1,57 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2019 SUSE LLC. All Rights Reserved.
>> +#
>> +# FS QA Test 184
>> +#
>> +# Verify that when a device is removed from a multi-device
>> +# filesystem its superblock copies are correctly deleted
>> +#
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1    # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    cd /
>> +    rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch
>> +_require_scratch_dev_pool 2
>> +_require_btrfs_command inspect-internal dump-super
>> +
>> +_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
>> +_scratch_mount
>> +
>> +# pick last dev in the list
>> +dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
> 
>> +$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs 
>> device delete failed"
> 
>   Device delete will fail with the raid1 mkfs option in the config fail.

  Also needs

  _scratch_dev_pool_get 2
  _scratch_dev_pool_put


> Thanks, Anand
> 
> 
>> +for i in {0..2}; do
>> +    output=$($BTRFS_UTIL_PROG inspect-internal dump-super -s $i 
>> $dev_del 2>&1)
>> +    $BTRFS_UTIL_PROG inspect-internal dump-super -s $i $dev_del 2>&1 
>> | grep -q "bad magic"
>> +    ret=$?
>> +    if [[ "$output" != "" && $ret -eq 1 ]]; then
>> +        _fail "Deleted dev superblocks not scratched"
>> +    fi
>> +done
>> +_scratch_unmount
>> +
>> +# success, all done
>> +echo "Silence is golden"
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/184.out b/tests/btrfs/184.out
>> new file mode 100644
>> index 000000000000..b4ce96cfc047
>> --- /dev/null
>> +++ b/tests/btrfs/184.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 184
>> +Silence is golden
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index f3227c1708d9..c1d215bf5ff8 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -186,3 +186,4 @@
>>   181 auto quick balance
>>   182 auto quick balance
>>   183 auto quick clone compress punch
>> +184 auto quick volume
>>
