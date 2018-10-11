Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49949C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 07:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DF4020841
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 07:55:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3mAzHtjS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DF4020841
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbeJKPVU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 11:21:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46556 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbeJKPVT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 11:21:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B7s6sK054063;
        Thu, 11 Oct 2018 07:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Rd1ztc4v6OqjQ+DaPW0a5UY7tcnHke2HwQ58sx/YgN4=;
 b=3mAzHtjSbMmeUCn5ISpDu3kk8qZJR9r1Le2/oiIayXLyKuPZkmSjhujBepYD3T1aSzfK
 xtLnjjDrvsHaQBmCiwKMNA5bAojzi3kaTOboMF9s7WCX5hkOS7gf5QhJLNqckunJJfZv
 pGKv0EZxKa6cZZ1cwdVNWxc8kwW3220r2PqQ/vkcET9u82sApnATVa7Ho/l4lRN6UUIV
 yQtQ8E5gaWsymRgzr5TkqB8iPAu2SrS+R6BQo4D7mSMyrVeOzB9CnCDVHsvxgORQH5DW
 rQf7mey77KZ/gLP9/vSvU7CDjK5E/ZrQ66PZayY5oni/TmQ5RzDV/xASqZF6N2zsUDNV qg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mxn0qaema-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 07:55:12 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9B7tCUa028800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 07:55:12 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9B7tChL000910;
        Thu, 11 Oct 2018 07:55:12 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 07:55:12 +0000
Subject: Re: [PATCH v3] geneirc/077 fix min size for btrfs
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1539228360-8575-1-git-send-email-anand.jain@oracle.com>
 <20181011042517.GA6695@magnolia>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <8a1a994f-ca36-7a7a-8e3d-fbcd30720beb@oracle.com>
Date:   Thu, 11 Oct 2018 15:55:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181011042517.GA6695@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110078
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/11/2018 12:25 PM, Darrick J. Wong wrote:
> On Thu, Oct 11, 2018 at 11:26:00AM +0800, Anand Jain wrote:
>> If btrfs need to be tested at its default blockgroup which is non-mixed,
>> then it needs at least 256mb.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v2->v3:
>> 	separated from the patch set of 9.
>> 	notrun for the cases where filler is not big enough to fill the
>> 		fssize.
>> v2->v1: ref the cover-letter of the set.
>>
>>   tests/generic/077 | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/tests/generic/077 b/tests/generic/077
>> index ef6af18c83e3..784afe448940 100755
>> --- a/tests/generic/077
>> +++ b/tests/generic/077
>> @@ -13,7 +13,7 @@ echo "QA output created by $seq"
>>   here=`pwd`
>>   tmp=/tmp/$$
>>   status=1
>> -# Something w/ enough data to fill 50M of fs...
>> +# Something w/ enough data to fill 256M of fs...
>>   filler=/lib/modules/
>>   
>>   # fall back in case /lib/modules doesn't exist
>> @@ -38,6 +38,11 @@ _supported_os Linux
>>   
>>   [ ! -d $filler ] && _notrun "No directory to source files from"
>>   
>> +# check if two iterations of the assigned filler is big enough to fill fssize
>> +fs_size=$((256 * 1024 * 1024))
>> +[ $(( $(du -h -m /usr | tail -1| cut -f1) * 2 )) -lt 256 ] && \
> 
> Err... what does measuring /usr have to do with /lib/modules?

Ah. Thanks Darrick. Its a bug, I fixed it in v4.

> Also, /lib/modules is 58M on my test VM, which means that a 256M
> filesystem isn't going to ENOSPC.

  Yep as above its only checking for /usr its a bug fixed in v4.

Thanks, Anand

> (Though weirdly it doesn't fail despite the lack of ENOSPC even at the
> 50M size, so I'm not sure what this test is actually supposed to do...)
 >
> --D
> 
>> +	_notrun "filler $filler isn't big enough to fill fssize $fssize"
>> +
>>   _require_scratch
>>   _require_attrs
>>   _require_acls
>> @@ -49,9 +54,7 @@ rm -f $seqres.full
>>   _scratch_unmount >/dev/null 2>&1
>>   echo "*** MKFS ***"                         >>$seqres.full
>>   echo ""                                     >>$seqres.full
>> -SIZE=`expr 50 \* 1024 \* 1024`
>> -_scratch_mkfs_sized $SIZE                   >>$seqres.full 2>&1 \
>> -	|| _fail "mkfs failed"
>> +_scratch_mkfs_sized $fs_size >> $seqres.full 2>&1 || _fail "mkfs failed"
>>   _scratch_mount
>>   mkdir $SCRATCH_MNT/subdir
>>   
>> -- 
>> 1.8.3.1
>>
