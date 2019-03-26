Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79279C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 14:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42B662075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 14:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbfCZOLO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 10:11:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:40154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726261AbfCZOLO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 10:11:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5449BAF94;
        Tue, 26 Mar 2019 14:11:12 +0000 (UTC)
Subject: Re: [PATCH v2] fstests: Verify that removed device has its
 superblocks deleted
To:     Anand Jain <anand.jain@oracle.com>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190325094200.18687-1-nborisov@suse.com>
 <20190325140713.9509-1-nborisov@suse.com>
 <b50e36d4-b65a-3b9e-e776-3b11d90a32e2@oracle.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f6512798-1e7a-37fd-6309-cfa1de1f7ac1@suse.com>
Date:   Tue, 26 Mar 2019 16:11:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <b50e36d4-b65a-3b9e-e776-3b11d90a32e2@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 25.03.19 г. 23:55 ч., Anand Jain wrote:
> 
> 
> On 3/25/19 10:07 PM, Nikolay Borisov wrote:
>> When a device is removed from a btrfs filesystem its superblock copies
>> must be deleted. 
> 
> AFAIK this bug was fixed a long time back in the kernel. Is there any
> newer fix in the kernel?

No there isn't but we currently don't have a test that covers that
functionality and I have some changes in progress that touch superblock
writing code so I'd rather be safe than sorry.

> 
>> This test ensures this is indeed the case.
> 
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Looks good.
> 
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
> 
>> ---
>>
>> Changes since v1:
>>   * Use _scratch_dev_pool_(get|put) to ensure the test uses exactly 2
>> devices.
>>     * Explicitly use -draid0 -mraid0 mkfs options for the scratch
>> devices to
>>   ensure at least one of the device could be removed. Also add a
>> comment about
>>   that.
>>
>>   tests/btrfs/184     | 63
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/184.out |  2 ++
>>   tests/btrfs/group   |  1 +
>>   3 files changed, 66 insertions(+)
>>   create mode 100755 tests/btrfs/184
>>   create mode 100644 tests/btrfs/184.out
>>
>> diff --git a/tests/btrfs/184 b/tests/btrfs/184
>> new file mode 100755
>> index 000000000000..49fe5c9c27bb
>> --- /dev/null
>> +++ b/tests/btrfs/184
>> @@ -0,0 +1,63 @@
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
>> +_scratch_dev_pool_get 2
>> +
>> +# Explicitly use raid0 mode to ensure at least one of the devices can be
>> +# removed.
>> +_scratch_pool_mkfs "-d raid0 -m raid0" >> $seqres.full 2>&1 || _fail
>> "mkfs failed"
>> +_scratch_mount
>> +
>> +# pick last dev in the list
>> +dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
>> +$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs
>> device delete failed"
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
>> +_scratch_dev_pool_put
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
> 
