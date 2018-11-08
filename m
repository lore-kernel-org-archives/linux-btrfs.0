Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A050AC32789
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 07:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62D5F2081D
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 07:26:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dJI5z4Qq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62D5F2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbeKHRAk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 12:00:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55696 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeKHRAk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2018 12:00:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA87OGlG097102;
        Thu, 8 Nov 2018 07:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=5WdRmkgy+BYt5NY3G+V6OlZv8vkEioiJRuOCGX7ve/8=;
 b=dJI5z4Qqtv5yA0xBQhWaiia3Yf/Ct6hDvG//XtK5bo/wI6r9R8/QaL9xbBk5rMXVFX4V
 gTR7KiSqIrHiimnLQpGwZn6cvLyYpT18edtGsPJMjUH3q8Dc1XczdhlML/JVfWRWAni5
 syIdU4NBtI0ShXZQMVPOlwqJnpKckkjXQSgjkSDvR6eAJ4HpvtRdn1Z1J9qzu73/BL8g
 5K4x1ZpStCSRlao/f/dWJf93TRO3WwswSaD5rWiFF1jBFTpKd1vlzwiySVNtGku8HDSC
 RecG6eqVLL80frGgezWhZv+sn43AH3E19tY03YMfcR2vymHbi3wdCt6CBKIf0FwI2l8Q 1w== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nh33u7s86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Nov 2018 07:26:28 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA87QQCM009767
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Nov 2018 07:26:27 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA87QQnL006707;
        Thu, 8 Nov 2018 07:26:26 GMT
Received: from [192.168.0.120] (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 23:26:26 -0800
Subject: Re: [PATCH 9/9] btrfs: add explicit check for replace result no error
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
 <1541591010-29789-10-git-send-email-anand.jain@oracle.com>
 <47b5f790-b4a6-c149-bb92-59868900c2d8@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <71c8fc98-ed7a-feea-e7ba-8f5aa9e328c2@oracle.com>
Date:   Thu, 8 Nov 2018 15:26:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <47b5f790-b4a6-c149-bb92-59868900c2d8@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9070 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811080064
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/07/2018 08:15 PM, Nikolay Borisov wrote:
> 
> 
> On 7.11.18 г. 13:43 ч., Anand Jain wrote:
>> We recast the replace return status
>> BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS to 0, to indicate no
>> error.
>> And since BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR should also return 0,
>> which is also declared as 0, so we just return. Instead add it to the if
>> statement so that there is enough clarity while reading the code.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/dev-replace.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index cf3554554616..ca44998189c7 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -533,8 +533,9 @@ int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
>>   					args->start.cont_reading_from_srcdev_mode);
>>   	args->result = ret;
>>   	/* don't warn if EINPROGRESS, someone else might be running scrub */
>> -	if (ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS)
>> -		ret = 0;
>> +	if (ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS ||
>> +	    ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR)
> 
> BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR can only be returned from
> btrfs_dev_replace_cancel,

  It can return 0 and which is also
  BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR which this patch makes it
  explicit.

  Looking at this again tells me that, as btrfs_dev_replace_start()
  is internal helper function, its better if it free from all usage
  of BTRFS_IOCTL_DEV_REPLACE_RESULT*.

Thanks, Anand

> so what you are doing with checking ret ==
> BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR is redundant. So using
> BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR is at the very least misleading
> here.

> I suggest you drop this patch.
> 
>> +		return 0;
>>   
>>   	return ret;
>>   }
>>
