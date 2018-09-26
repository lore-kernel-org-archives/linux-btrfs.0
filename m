Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3117BC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 04:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9E7720833
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 04:09:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YOzwESP5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9E7720833
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbeIZKT5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 06:19:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38248 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbeIZKT5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 06:19:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8Q43TOv127795;
        Wed, 26 Sep 2018 04:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=TWb4HmPZ1pNcmkBEBJXg4r4WmVIQe14aVG4QNkz4Qxs=;
 b=YOzwESP5PY4oOgwycnFQ5XLD/3k93GwNiMQqUMSNeBIjcvfXSvdT+fl3zQSr5LW5prxH
 msBWMXdrQM947qbmQYU9A7YiC/GGekSKKsl06AQrQzOAZmk+pAjngfGTUU+La9W6HNLW
 84nTW0P1vpzswiaUAvU8w2BXVmQwdGtJjiF076zX9STG6gr6zSASboiqgcPqV7Dlug3b
 lSSvPR84+LrjnZIycBTMyl/1acR2Clb4+DBPxtLZ2W5Aa6DIWfjWj4ntJ4IHaopgl5Jm
 ue8T+NlXP0+iZR61Zd3IvmRbsnFoR1cTlFRUayENPHFx/VvQOO/N7UpPrfgF5nhwOUEq Nw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mnvtupnre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Sep 2018 04:09:00 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8Q48x02029769
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Sep 2018 04:08:59 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8Q48xHr022705;
        Wed, 26 Sep 2018 04:08:59 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Sep 2018 21:08:59 -0700
Subject: Re: [PATCH v2 5/9] generic/102 open code dev_size
 _scratch_mkfs_sized()
To:     Nikolay Borisov <nborisov@suse.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
 <1537849462-619-6-git-send-email-anand.jain@oracle.com>
 <6bdc26df-7beb-53dd-69a2-c3d1789cf3c9@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <d5e4b2ef-6e8b-f760-9e5a-13c93533abb2@oracle.com>
Date:   Wed, 26 Sep 2018 12:08:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <6bdc26df-7beb-53dd-69a2-c3d1789cf3c9@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9027 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809260041
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 09/25/2018 06:54 PM, Nikolay Borisov wrote:
> 
> 
> On 25.09.2018 07:24, Anand Jain wrote:
>> Open code helps to grep and find out parameter sent to the
>> _scratch_mkfs_sized here.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> IMO this is noise, you can just as simply do
> "grep _scratch_mkfs_sized" and then open the file to inspect the actual
> argument. But it's up to the xfstest maintainers

  I am ok. Its just a nice cleanup.

Thanks, Anand

>> ---
>>   tests/generic/102 | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/tests/generic/102 b/tests/generic/102
>> index faf940ac5070..aad496a5bc69 100755
>> --- a/tests/generic/102
>> +++ b/tests/generic/102
>> @@ -31,8 +31,7 @@ _require_scratch
>>   
>>   rm -f $seqres.full
>>   
>> -dev_size=$((512 * 1024 * 1024))     # 512MB filesystem
>> -_scratch_mkfs_sized $dev_size >>$seqres.full 2>&1
>> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
>>   _scratch_mount
>>   
>>   for ((i = 0; i < 10; i++)); do
>>
