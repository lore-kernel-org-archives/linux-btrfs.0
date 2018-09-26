Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2489FC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 07:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D39A32089D
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 07:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kSuzFAKT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D39A32089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbeIZNyJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 09:54:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59428 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbeIZNyJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 09:54:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8Q7cYFs127613;
        Wed, 26 Sep 2018 07:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=q11HlJ0CSZlEdb6P6yQxBi0TX9nWJcBOxPVDithJxpQ=;
 b=kSuzFAKT5KMEdN+uBHf9BP9Ek5dqh9JjCoth1ZA5HY4UPVWYXQtlRGH4PMUDqAaaZeJP
 osqvllY/3vwg59UiEye19qqngr8Mk7lcV/5O/6+GIV9RRvRGK6BJcj55wuSy8UCZOyo8
 eiOoF6lE++S6Ac570+ofFi0+pH/ymdleFW2yNMO5/F8tL3RVanIHl4+KWNOLm8iqcSQd
 q/xTy6/APDHRf4rtkSoMcf89P/ryZeQWZaBE9hlT96IiP/gaXSbLFp8ewyH8f/zxdv7J
 Lvu4xaEdbG2tfvIwt/67So9f9VcTWCpWhCxSoo7N8lSSZAyviI1bOvE6vefvc0yZWwIm nA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mnd5tgqkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Sep 2018 07:42:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8Q7gSkR004485
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Sep 2018 07:42:29 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8Q7gSne006682;
        Wed, 26 Sep 2018 07:42:28 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Sep 2018 00:42:28 -0700
Subject: Re: [PATCH] btrfs-progs: delete unused is_vol_small() and
 BTRFS_MKFS_SMALL_VOLUME_SIZE
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1537947388-10396-1-git-send-email-anand.jain@oracle.com>
 <205f0847-7fd4-c716-80ad-2553a8dae4e8@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <0e3595e3-0a60-75cb-50c7-0354d126b1e4@oracle.com>
Date:   Wed, 26 Sep 2018 15:42:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <205f0847-7fd4-c716-80ad-2553a8dae4e8@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9027 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809260079
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 09/26/2018 03:39 PM, Qu Wenruo wrote:
> 
> 
> On 2018/9/26 下午3:36, Anand Jain wrote:
>> Since commit c11e36a29e84 (Btrfs-progs: Do not force mixed block group
>> creation unless '-M' option is specified) we don't have automatic
>> mixed mode, and the function is_vol_small() and the define
>> BTRFS_MKFS_SMALL_VOLUME_SIZE was obsolete since then so clean it up.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   mkfs/common.c | 29 -----------------------------
>>   mkfs/common.h |  1 -
>>   2 files changed, 30 deletions(-)
>>
>> diff --git a/mkfs/common.c b/mkfs/common.c
>> index 0ace262b0e5f..c59e1d8eda4a 100644
>> --- a/mkfs/common.c
>> +++ b/mkfs/common.c
>> @@ -772,35 +772,6 @@ int test_status_for_mkfs(const char *file, bool force_overwrite)
>>   	return 0;
>>   }
>>   
>> -int is_vol_small(const char *file)
>> -{
>> -	int fd = -1;
>> -	int e;
>> -	struct stat st;
>> -	u64 size;
>> -
>> -	fd = open(file, O_RDONLY);
>> -	if (fd < 0)
>> -		return -errno;
>> -	if (fstat(fd, &st) < 0) {
>> -		e = -errno;
>> -		close(fd);
>> -		return e;
>> -	}
>> -	size = btrfs_device_size(fd, &st);
>> -	if (size == 0) {
>> -		close(fd);
>> -		return -1;
>> -	}
>> -	if (size < BTRFS_MKFS_SMALL_VOLUME_SIZE) {
>> -		close(fd);
>> -		return 1;
>> -	} else {
>> -		close(fd);
>> -		return 0;
>> -	}
>> -}
>> -
>>   int test_minimum_size(const char *file, u64 min_dev_size)
>>   {
>>   	int fd;
>> diff --git a/mkfs/common.h b/mkfs/common.h
>> index 28912906d0a9..18f5c3b66270 100644
>> --- a/mkfs/common.h
>> +++ b/mkfs/common.h
>> @@ -26,7 +26,6 @@
>>   #include "common-defs.h"
>>   
>>   #define BTRFS_MKFS_SYSTEM_GROUP_SIZE SZ_4M
>> -#define BTRFS_MKFS_SMALL_VOLUME_SIZE SZ_1G
> 
> Wait for a minute, is_vol_small()'s declaration is not removed.
> 
> Did I miss something? Or it's already removed by some newer commit?

  You caught me ;-). Its still there will fix in v2.

Thanks, Anand

> Thanks,
> Qu
> 
>>   
>>   /*
>>    * Tree root blocks created during mkfs
>>
> 
