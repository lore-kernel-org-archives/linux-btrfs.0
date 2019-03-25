Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752E4C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 441E52085A
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="5mBKNe76"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbfCYMgi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:36:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52418 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730603AbfCYMgi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 08:36:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2PCSkMc145437;
        Mon, 25 Mar 2019 12:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=IRQinJ2CAuslF0WhFbUAZdrAYQJ1idb5bbHmz23hdlc=;
 b=5mBKNe76GfsBwzhOzgxabx6El8L5Ia0vzW5gO5wavN+FGWZ5jkfKnYtNaZldGNDwhslb
 Eq3tl72aHU0UULR4x//9bpPbNtUXUj/Zrc6H0vholFws18xs3SBFTXrmQpZlDUhACsb1
 BJnxH7fMbrVQE4WXCp2cK2FjJCHMv16saA6TUT0+/YawxUcitU+2H5FP3CM46rhIincb
 YhFbqFjQhUJAa6/ngfI0KnEvLnRXo8JjPCkkKhdQgK5sPmiseUUURLxI0XMYac7eo9UG
 xBE1Cq3T2aL6n7Y3cDNGxi+YE7m8Am61CX18dwjuIVs23y5yKPpUXn9GiqxClD6Yz7WC Jw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2re6g0upg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 12:36:33 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2PCaR6l008086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 12:36:27 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2PCaRU8004380;
        Mon, 25 Mar 2019 12:36:27 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Mar 2019 05:36:27 -0700
Subject: Re: [PATCH] fstests: Verify that removed device has its superblocks
 deleted
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     guaneryu@gmail.com, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20190325094200.18687-1-nborisov@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <620fe973-9b9a-8915-8b41-bb1baccfee2b@oracle.com>
Date:   Mon, 25 Mar 2019 20:36:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190325094200.18687-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9205 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903250093
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/25/19 5:42 PM, Nikolay Borisov wrote:
> When a device is removed from a btrfs filesystem its superblock copies
> must be deleted. This test ensures this is indeed the case.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>   tests/btrfs/184     | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/184.out |  2 ++
>   tests/btrfs/group   |  1 +
>   3 files changed, 60 insertions(+)
>   create mode 100755 tests/btrfs/184
>   create mode 100644 tests/btrfs/184.out
> 
> diff --git a/tests/btrfs/184 b/tests/btrfs/184
> new file mode 100755
> index 000000000000..3bf7d201a145
> --- /dev/null
> +++ b/tests/btrfs/184
> @@ -0,0 +1,57 @@
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
> +_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +
> +# pick last dev in the list
> +dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`

> +$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"

  Device delete will fail with the raid1 mkfs option in the config fail.

Thanks, Anand


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
