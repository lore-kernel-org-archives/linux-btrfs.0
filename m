Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BAFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 21:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D8A52083D
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 21:55:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xAQMpGxY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfCYVzx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:55:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57202 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728563AbfCYVzx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 17:55:53 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2PLhc3T057015;
        Mon, 25 Mar 2019 21:55:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=k2hUL+C4GxN8w5bBQcm30E930S513zWeHl3E/+DKcwE=;
 b=xAQMpGxYdKb5XEA32nHwp6G9c6QclN7U3fbFqQ77bMptuilqwabc1vbhQ7/ncjzgZwdk
 ZY/M+6xdR9Wd44eXUXCtNuzyj8tBYM3u/u7PSGEslHP5TWosNnQVdd3TZ7qKjSRToN+Z
 eYLuccYe2n/kkna0hVNr+AVDm8y4aI38B88boawJwpd2vokTsnf4llv3dk4D5+EnSoe6
 fEgfgnWUfziXORM6HGyo1evGOVBZQ93u+Oo1W/g3RYT8BbSLzyNEQWpvRggbE48UKrVs
 yrF56TkjOskJ9QQMqP4Qgtl/on5iTaWtQqCOU8klDd675SbMuEPc68yeD/5linELeLlS 9g== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2re6g0pt83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 21:55:48 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2PLtgEK007628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 21:55:43 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2PLtggu001164;
        Mon, 25 Mar 2019 21:55:42 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Mar 2019 14:55:42 -0700
Subject: Re: [PATCH v2] fstests: Verify that removed device has its
 superblocks deleted
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190325094200.18687-1-nborisov@suse.com>
 <20190325140713.9509-1-nborisov@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <b50e36d4-b65a-3b9e-e776-3b11d90a32e2@oracle.com>
Date:   Tue, 26 Mar 2019 05:55:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190325140713.9509-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9206 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903250154
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/25/19 10:07 PM, Nikolay Borisov wrote:
> When a device is removed from a btrfs filesystem its superblock copies
> must be deleted. 

AFAIK this bug was fixed a long time back in the kernel. Is there any 
newer fix in the kernel?

 > This test ensures this is indeed the case.

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

> ---
> 
> Changes since v1:
>   * Use _scratch_dev_pool_(get|put) to ensure the test uses exactly 2 devices.
>   
>   * Explicitly use -draid0 -mraid0 mkfs options for the scratch devices to
>   ensure at least one of the device could be removed. Also add a comment about
>   that.
> 
>   tests/btrfs/184     | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/184.out |  2 ++
>   tests/btrfs/group   |  1 +
>   3 files changed, 66 insertions(+)
>   create mode 100755 tests/btrfs/184
>   create mode 100644 tests/btrfs/184.out
> 
> diff --git a/tests/btrfs/184 b/tests/btrfs/184
> new file mode 100755
> index 000000000000..49fe5c9c27bb
> --- /dev/null
> +++ b/tests/btrfs/184
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 SUSE LLC. All Rights Reserved.
> +#
> +# FS QA Test 184
> +#
> +# Verify that when a device is removed from a multi-device
> +# filesystem its superblock copies are correctly deleted
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_scratch_dev_pool 2
> +_require_btrfs_command inspect-internal dump-super
> +
> +_scratch_dev_pool_get 2
> +
> +# Explicitly use raid0 mode to ensure at least one of the devices can be
> +# removed.
> +_scratch_pool_mkfs "-d raid0 -m raid0" >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +
> +# pick last dev in the list
> +dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
> +$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
> +for i in {0..2}; do
> +    output=$($BTRFS_UTIL_PROG inspect-internal dump-super -s $i $dev_del 2>&1)
> +    $BTRFS_UTIL_PROG inspect-internal dump-super -s $i $dev_del 2>&1 | grep -q "bad magic"
> +    ret=$?
> +    if [[ "$output" != "" && $ret -eq 1 ]]; then
> +        _fail "Deleted dev superblocks not scratched"
> +    fi
> +done
> +_scratch_unmount
> +
> +_scratch_dev_pool_put
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/184.out b/tests/btrfs/184.out
> new file mode 100644
> index 000000000000..b4ce96cfc047
> --- /dev/null
> +++ b/tests/btrfs/184.out
> @@ -0,0 +1,2 @@
> +QA output created by 184
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index f3227c1708d9..c1d215bf5ff8 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -186,3 +186,4 @@
>   181 auto quick balance
>   182 auto quick balance
>   183 auto quick clone compress punch
> +184 auto quick volume
> 
