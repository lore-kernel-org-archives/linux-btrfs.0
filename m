Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5124C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 14:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 904BD2064D
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 14:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oUdJ8IN3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 904BD2064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbeI1VUG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 17:20:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47840 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbeI1VUG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 17:20:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8SEn0eN190288;
        Fri, 28 Sep 2018 14:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=/10BjbFnhN6ZLRIb+AZIe3lYX7wc0hN2W1SNKRYoSts=;
 b=oUdJ8IN3f0CDd2annljQvJWt6WkA1MjRsh7XC8uexV/PwImyCz6RTZQtBvm58iI1sL50
 iWd9sV4sXMWb20wU/zYGB5W+Qgld7MbTfA0V8TdIIn2Ictq/h2Ck9TToIPhlWksffbHB
 GJeJSyz703A5L6TjUgyI8KlgxP6YG9lFGyPPNynadPmX0dYMz9lW/Zcc2cI/WT8RqwpR
 NmOQpOwomyRsDr3867WWVByYy21VKuvlHl6FVOXcCBdfxOMw5iDyxxre+g3nOx54X2OZ
 yugHAf8JHyelvGF5Bo78RGRQw4PJ6+94iYMYwO0DKDavv2+aCwQ1kw50CZRQ1zIFeJu/ 3w== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mnd5u0ste-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Sep 2018 14:55:56 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8SEtt9a009231
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Sep 2018 14:55:55 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8SEttq7012049;
        Fri, 28 Sep 2018 14:55:55 GMT
Received: from [192.168.0.182] (/202.156.138.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Sep 2018 07:55:55 -0700
Subject: Re: [PATCH] test unaligned punch hole at ENOSPC
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1537789659-29460-1-git-send-email-anand.jain@oracle.com>
 <20180928124249.GH17817@desktop>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <1296c326-9451-6c73-2c18-ffcc6db8599b@oracle.com>
Date:   Fri, 28 Sep 2018 22:55:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20180928124249.GH17817@desktop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9029 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809280150
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



Oops I just realized I sent v2 only to linux-btrfs@vger.kernel.org.
more below..

On 09/28/2018 08:42 PM, Eryu Guan wrote:
> On Mon, Sep 24, 2018 at 07:47:39PM +0800, Anand Jain wrote:
>> Try to punch hole with unaligned size and offset when the FS
>> returns ENOSPC
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> This test case fails on btrfs as of now.
>>
>>   tests/btrfs/172     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/172.out |  2 ++
>>   tests/btrfs/group   |  1 +
>>   3 files changed, 69 insertions(+)
>>   create mode 100755 tests/btrfs/172
>>   create mode 100644 tests/btrfs/172.out
>>
>> diff --git a/tests/btrfs/172 b/tests/btrfs/172
>> new file mode 100755
>> index 000000000000..9c32a173f912
>> --- /dev/null
>> +++ b/tests/btrfs/172
>> @@ -0,0 +1,66 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2018 Oracle. All Rights Reserved.
>> +#
>> +# FS QA Test 172
>> +#
>> +# Test if the unaligned (by size and offset) punch hole is successful when FS
>> +# is at ENOSPC.
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
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_scratch
>> +
>> +_scratch_mkfs_sized $((200 * 1024 *1024)) >> $seqres.full
>> +
>> +# max_inline helps to create regular extent
>> +_scratch_mount "-o max_inline=0,nodatacow"
>> +
>> +echo "Fill fs upto ENOSPC" >> $seqres.full
>> +dd status=none if=/dev/zero of=$SCRATCH_MNT/filler bs=512 >> $seqres.full 2>&1
>> +
>> +extent_size=$(_scratch_btrfs_sectorsize)
>> +unalign_by=512
>> +echo extent_size=$extent_size unalign_by=$unalign_by >> $seqres.full
>> +
>> +hole_offset=0
>> +hole_len=$unalign_by
>> +run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
> 
> Please don't introduce new run_check/_run_btrfs_util_prog users, just
> redirect output to /dev/null if the outputs don't matter. Please refer
> to this thread

Fixed in v3.

> https://www.spinics.net/lists/linux-btrfs/msg80996.html


> And use xfs_io fpunch command instead of bare 'fallocate -p', and check
> xfs_io and kernel support on fpunch by calling

> _require_xfs_io_comand "fpunch"

Fixed in v3.

>> +
>> +hole_offset=$(($extent_size + $unalign_by))
>> +hole_len=$(($extent_size - $unalign_by))
>> +run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
>> +
>> +hole_offset=$(($extent_size * 2 + $unalign_by))
>> +hole_len=$(($extent_size * 5))
>> +run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
>> +
>> +# success, all done
>> +echo "Silence is golden"
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/172.out b/tests/btrfs/172.out
>> new file mode 100644
>> index 000000000000..ce2de3f0d107
>> --- /dev/null
>> +++ b/tests/btrfs/172.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 172
>> +Silence is golden
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index feffc45b6564..7e1a638ab7e1 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -174,3 +174,4 @@
>>   169 auto quick send
>>   170 auto quick snapshot
>>   171 auto quick qgroup
>> +172 auto quick
> 
> Add 'punch' group too.

Ah there is punch group..  I was searching with the key word 'hole'.
Will fix in v4.

Thanks, Anand


> Thanks,
> Eryu
> 
>> -- 
>> 1.8.3.1
>>
