Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48FAC10F0E
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 11:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66416218D0
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 11:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o/uqsZTS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfDGLyf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 07:54:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfDGLyf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2019 07:54:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x37BsUpj153870;
        Sun, 7 Apr 2019 11:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=XYGn6E09ftEYibyEAF9dBiBXcryovfd3LHsHeQGka5Q=;
 b=o/uqsZTSeOBVCEJG/I3PskGUElFtZgi5FjfFr5Lfvn4FNLk702DoDP9DpJv5yixuJt+S
 hEQoyxUvzOHPGOIfJszl2EPuvPQQH0myYXU9gVUGZJnNQ3QkHVTJLhH3lfZmCpbuZLFZ
 QQ0lDj+YFkURr9fKP3W+FYP6vGSkiKvHJBLIgxXpQba2d5Lduzru+uPWy9T01CoWSnAl
 4aAlP7vBKhCrhiFf0PQG8Apm4M7ll43EWYC5Ef/gFO8uhYhtXWyaZ+xMN9fF4NIAQi9a
 IL/Pdmg/uF87lU7yGYP/AKLWQJOk7kpQt4k4UQZZ6q0ZX3LSTGmoaDe6klr6q8SCNn2N 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rpkhsjm2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Apr 2019 11:54:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x37BsURH100703;
        Sun, 7 Apr 2019 11:54:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2rph7rmxxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Apr 2019 11:54:30 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x37BsTSu015776;
        Sun, 7 Apr 2019 11:54:29 GMT
Received: from [192.168.1.119] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Apr 2019 11:54:28 +0000
Subject: Re: [PATCH v2] fstests: btrfs/048: amend property validation cases
To:     Eryu Guan <guaneryu@gmail.com>, Nikolay Borisov <nborisov@suse.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20190403165419.12666-1-anand.jain@oracle.com>
 <20190403170437.14448-1-anand.jain@oracle.com>
 <7de2d0fd-e777-2bec-5731-15ba2f2af4f2@suse.com>
 <20190406120207.GG2824@desktop>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <20062818-d303-047c-358f-52ac9dad50de@oracle.com>
Date:   Sun, 7 Apr 2019 19:54:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190406120207.GG2824@desktop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9219 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904070112
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9219 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904070112
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 6/4/19 8:02 pm, Eryu Guan wrote:
> On Fri, Apr 05, 2019 at 04:21:10PM +0300, Nikolay Borisov wrote:
>>
>>
>> On 3.04.19 г. 20:04 ч., Anand Jain wrote:
>>> Add more property validation cases which are fixed by the patches [1]
>>>   [1]
>>>    btrfs: fix vanished compression property after failed set
>>>    btrfs: fix zstd compression parameter
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> Thanks for the test and the review!
> 
> But this looks like a targeted regression test that may fail an existing
> test. It's better to write a new test for this.

Regression is only when fstests is upgraded. This
test case mentions the prerequisite kernel patches [1].
So that should suffice the concern?

Thanks, Anand

> 
> Thanks,
> Eryu
> 
>>
>>> ---
>>> v2: correct kernel patch titles in the test header and change log
>>>
>>>   tests/btrfs/048     | 23 +++++++++++++++++++++++
>>>   tests/btrfs/048.out | 16 ++++++++++++++++
>>>   2 files changed, 39 insertions(+)
>>>
>>> diff --git a/tests/btrfs/048 b/tests/btrfs/048
>>> index 588219579cc6..f6de0b8ca8b1 100755
>>> --- a/tests/btrfs/048
>>> +++ b/tests/btrfs/048
>>> @@ -6,6 +6,9 @@
>>>   #
>>>   # Btrfs properties test. The btrfs properties feature was introduced in the
>>>   # linux kernel 3.14.


[1]

>>> +# Fails without the kernel patches:
>>> +#  btrfs: fix vanished compression property after failed set
>>> +#  btrfs: fix zstd compression parameter
>>>   #
>>>   seq=`basename $0`
>>>   seqres=$RESULT_DIR/$seq
>>> @@ -34,6 +37,7 @@ _supported_os Linux
>>>   _require_test
>>>   _require_scratch
>>>   _require_btrfs_command "property"
>>> +_require_btrfs_command inspect-internal dump-super
>>>   
>>>   send_files_dir=$TEST_DIR/btrfs-test-$seq
>>>   
>>> @@ -203,5 +207,24 @@ $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 compression
>>>   touch $SCRATCH_MNT/sv1/file2
>>>   $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1/file2 compression
>>>   
>>> +echo -e "\nTesting argument validation, should fail"
>>> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
>>> +echo "***"
>>> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
>>> +echo "***"
>>> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zst' | _filter_scratch
>>> +
>>> +echo -e "\nTesting if property is persistent across failed validation"
>>> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lzo'
>>> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
>>> +$BTRFS_UTIL_PROG property get $SCRATCH_MNT compression
>>> +
>>> +echo -e "\nTesting generation is unchanged after failed validation"
>>> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
>>> +$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
>>> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
>>> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
>>> +$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
>>> +
>>>   status=0
>>>   exit
>>> diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
>>> index 3e4e3d28950a..00f39bc01227 100644
>>> --- a/tests/btrfs/048.out
>>> +++ b/tests/btrfs/048.out
>>> @@ -76,3 +76,19 @@ compression=zlib
>>>   Testing subvolume property inheritance
>>>   compression=lzo
>>>   compression=lzo
>>> +
>>> +Testing argument validation, should fail
>>> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
>>> +***
>>> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
>>> +***
>>> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
>>> +
>>> +Testing if property is persistent across failed validation
>>> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
>>> +compression=lzo
>>> +
>>> +Testing generation is unchanged after failed validation
>>> +generation		7
>>> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
>>> +generation		7
>>>

