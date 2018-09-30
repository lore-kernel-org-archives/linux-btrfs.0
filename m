Return-Path: <SRS0=O281=MM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88ABFC43143
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Sep 2018 00:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EFDB2082A
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Sep 2018 00:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZMr0idY7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EFDB2082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbeI3H2a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 30 Sep 2018 03:28:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48440 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbeI3H23 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Sep 2018 03:28:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8U0s5Tf039130;
        Sun, 30 Sep 2018 00:57:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=CF4T8dO+je96LLWxoGzjMEuY3JO1LQWKgNNeUoKIDnY=;
 b=ZMr0idY7Dr2vh6II8HvHwMeVMQN/bM+mnnxDXSwKswfIvAT6GL1/iddnzJekmnjVbWwO
 mx9blMqC6B7fXBJxits7jZrHApIyrhu87UNBgcwoakqWz/XmSEHWc4A7KrhsbHwvEjQP
 tF+vlxQ9LW619D/k6lnaEDNHVWSV/geGIdJXhm+AP9bMC1Wgx3w4hZrGmsVOVNExDyPL
 229/o4NvfFOrPgvW500eTU83bLrw/mE/kmFaxek4jPnFrQJcgXBSlxc727BB9uWyvSVs
 iVoX+uq7Ap3ZJanlJRgCw4oQi3QAc8dgf9iz20v3h2YgF2SZRNoMV+BFUfw8rbCTxzHk Uw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2mt1bphyx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Sep 2018 00:57:49 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8U0vhu1005413
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Sep 2018 00:57:43 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8U0vh41023948;
        Sun, 30 Sep 2018 00:57:43 GMT
Received: from [172.20.10.2] (/183.90.36.230)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Sep 2018 00:57:43 +0000
Subject: Re: [PATCH v3] test unaligned punch hole at ENOSPC
To:     fdmanana@gmail.com
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1538146248-1759-1-git-send-email-anand.jain@oracle.com>
 <CAL3q7H4XNMMHwQLdQbvGvxcj=ALqjFJzJi00UFiyA9VV4dKhiw@mail.gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <ab507ac7-6d85-5e93-13da-1522be4fd388@oracle.com>
Date:   Sun, 30 Sep 2018 08:57:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4XNMMHwQLdQbvGvxcj=ALqjFJzJi00UFiyA9VV4dKhiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9031 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809300008
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 09/29/2018 01:08 AM, Filipe Manana wrote:
> On Fri, Sep 28, 2018 at 3:51 PM Anand Jain <anand.jain@oracle.com> wrote:
>>
>> Try to punch hole with unaligned size and offset when the FS
>> returns ENOSPC
> 
> The FS returns ENOSPC is confusing. It's more clear to say when the
> filesystem doesn't have more space available for data allocation.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v2->v3:
>>   add _require_xfs_io_command "fpunch"
>>   add more logs to $seqfull.full
>>     mount options and
>>     group profile info
>>   add sync after dd upto ENOSPC
>>   drop fallocate -p and use xfs_io punch to create holes
>> v1->v2: Use at least 256MB to test.
>> This test case fails on btrfs as of now.
>>
>>   tests/btrfs/172     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/172.out |  2 ++
>>   tests/btrfs/group   |  1 +
>>   3 files changed, 77 insertions(+)
>>   create mode 100755 tests/btrfs/172
>>   create mode 100644 tests/btrfs/172.out
>>
>> diff --git a/tests/btrfs/172 b/tests/btrfs/172
>> new file mode 100755
>> index 000000000000..59413a5de12f
>> --- /dev/null
>> +++ b/tests/btrfs/172
>> @@ -0,0 +1,74 @@
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
>> +status=1       # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +       cd /
>> +       rm -f $tmp.*
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
>> +_require_scratch
>> +_require_xfs_io_command "fpunch"
>> +
>> +_scratch_mkfs_sized $((256 * 1024 *1024)) >> $seqres.full
>> +
>> +# max_inline helps to create regular extent
> max_inline ensures data is not inlined within metadata extents

  Right. Hmm I saw the term regular extent used some where,
  so used it here. Looks that wasn't better?

>> +_scratch_mount "-o max_inline=0,nodatacow"
>> +
>> +cat /proc/self/mounts | grep $SCRATCH_DEV >> $seqres.full
>> +$BTRFS_UTIL_PROG filesystem df $SCRATCH_MNT >> $seqres.full
>> +
>> +extent_size=$(_scratch_btrfs_sectorsize)
>> +unalign_by=512
>> +echo extent_size=$extent_size unalign_by=$unalign_by >> $seqres.full
>> +
>> +$XFS_IO_PROG -f -d -c "pwrite -S 0xab 0 $((extent_size * 10))" \
>> +                                       $SCRATCH_MNT/testfile >> $seqres.full
>> +
>> +echo "Fill fs upto ENOSPC" >> $seqres.full
> Fill all space available for data and all unallocated space.

  Will update comment. (I hope that's what you mean?)

>> +dd status=none if=/dev/zero of=$SCRATCH_MNT/filler bs=512 >> $seqres.full 2>&1
> Why do you use dd here and not xfs_io?

  What I figured out xfs_io can't write until FS is full, as you need to
  specify the size for pwrite. OR did I miss something? I see some test
  cases just specify some arbitrary large number big enough than the FS.
  I didn't like that approach.

>> +sync
> Why is the sync needed?

  Yep not needed. Will remove in v6.

>> +
>> +hole_offset=0
>> +hole_len=$unalign_by
>> +$XFS_IO_PROG -f -d -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
> 
> No need to pass -f anymore. No need for -d either.

  Ah. Thanks will fix in v6.

>> +
>> +hole_offset=$(($extent_size + $unalign_by))
>> +hole_len=$(($extent_size - $unalign_by))
>> +$XFS_IO_PROG -f -d -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
> 
> No need to pass -f anymore. No need for -d either.

  Will fix in v6.

>> +
>> +hole_offset=$(($extent_size * 2 + $unalign_by))
>> +hole_len=$(($extent_size * 5))
>> +$XFS_IO_PROG -f -d -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
> 
> No need to pass -f anymore. No need for -d either.

  Got it.

Thanks, Anand

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
>> --
>> 1.8.3.1
>>
> 
> 
