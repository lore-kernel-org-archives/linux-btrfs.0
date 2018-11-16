Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0937C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 06:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 838CB2145D
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 06:38:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O/gJ2fdO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 838CB2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbeKPQtu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 11:49:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:32926 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbeKPQtu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 11:49:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAG6cVJp060448;
        Fri, 16 Nov 2018 06:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=5MKnnGEpDEOTL2xgwHNG9C4GwlwlawKN3QJUkESteQ4=;
 b=O/gJ2fdObZOUWG7nBNyjHQXoVWA23bJZxLTmTSO3BXgPD2ScdeRq7bWWzhZ3ASDXXtOg
 P9q5qTcUXSJhpCGA3GbymkpdK2fv5yXjjUzg+Y0gGwzigt877cRHO8pnLIdpUycLc4J4
 CNsuqEaY8d73P44bAz+e/sf9OL1qSXG0FUMkxXOS2Nm5tNKcsbgLQdzq9TOriMyiwRQC
 npQZMihKQZR+/Y8KBAj/nx9Iv5FatKsnzKU4pqdEHLOX/yXg7C1T9TRHKWj/XdPrC355
 +S06/1Erpl8h04Mn5+n1k390CqvmMWSyHDegAzNvpp7vKlZKoNFilKno6PDfnGWY+zUk Bw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nr7csdgyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 06:38:42 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAG6cfpu003126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 06:38:42 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAG6cfmY025390;
        Fri, 16 Nov 2018 06:38:41 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Nov 2018 22:38:41 -0800
Subject: Re: [PATCH 5/9] btrfs: replace cancel is successful if scrub cancel
 is successful
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
 <1541946144-8174-6-git-send-email-anand.jain@oracle.com>
 <20181115152754.GS24115@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <8ece8cde-013f-b6ef-b969-8e0b560f8f17@oracle.com>
Date:   Fri, 16 Nov 2018 14:38:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181115152754.GS24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9078 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811160059
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/15/2018 11:27 PM, David Sterba wrote:
> On Sun, Nov 11, 2018 at 10:22:20PM +0800, Anand Jain wrote:
>> In btrfs_dev_replace_cancel() we should check if the
>> btrfs_scrub_cancel() is successful. If the btrfs_scrub_cancel() fails, return
>> BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED so that user can try to
>> cancel the replace again.
> 
> I've updated the subject and changelog as this was not easy to
> understand what's going on.
> 
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/dev-replace.c | 22 +++++++++++++---------
>>   1 file changed, 13 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index d32d696d931c..9fc3cb8d3918 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -799,18 +799,22 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
>>   		btrfs_dev_replace_write_unlock(dev_replace);
>>   		break;
>>   	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
>> -		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
>>   		tgt_device = dev_replace->tgtdev;
>>   		src_device = dev_replace->srcdev;
>>   		btrfs_dev_replace_write_unlock(dev_replace);
>> -		btrfs_scrub_cancel(fs_info);
>> -		/*
>> -		 * btrfs_dev_replace_finishing() will handle the cleanup part
>> -		 */
>> -		btrfs_info_in_rcu(fs_info,
>> -			"dev_replace from %s (devid %llu) to %s canceled",
>> -			btrfs_dev_name(src_device), src_device->devid,
>> -			btrfs_dev_name(tgt_device));
>> +		ret = btrfs_scrub_cancel(fs_info);
>> +		if (ret) {
> 
> This should be ret < 0, fixed.

  Ok with me. Thanks for fixing. Anand

> 
>> +			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED;
>> +		} else {
>> +			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
>> +			/*
>> +			 * btrfs_dev_replace_finishing() will handle the cleanup part
>> +			 */
>> +			btrfs_info_in_rcu(fs_info,
>> +				"dev_replace from %s (devid %llu) to %s canceled",
>> +				btrfs_dev_name(src_device), src_device->devid,
>> +				btrfs_dev_name(tgt_device));
>> +		}
>>   		break;
>>   	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
>>   		/*
>> -- 
>> 1.8.3.1
