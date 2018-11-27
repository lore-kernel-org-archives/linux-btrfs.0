Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470F8C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 13:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CC3020989
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 13:38:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jmfxmgef"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CC3020989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbeK1AgI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 19:36:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42432 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbeK1AgI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 19:36:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wARDXpnC098115;
        Tue, 27 Nov 2018 13:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=d1+mGngOTXnI2rFVs30T/RgYtX04fb3He78ca134154=;
 b=jmfxmgef2Kt0TcJ9MTUXkjRNKlBN8Q/c3Ip8VtUUUgjtQytcZxcyInNEKGO736l/hEUV
 CUcx4RRCzL6HGwS+ETFVx2mqFiA3iuc+Y1GNEJ9Di2KwdAn9+WkLQxd9uXnOvVr1eRoc
 11iXK81OMVyd1EDx2zO7mEWWa12ybyRAL6NdjekmQqyMaWgKnmYeZCQ3EP2h9T0lajXN
 TQ0GGxi2vA4/aGrvE1yzPUlYehrvI4X80eRIaK6+qFi64qd/wexVQ0iUP7ITqjkJd37P
 n6f3INjB3hTYnCJODXsOVQkOl9jYV1QfzLqzMqM+DhN+UrD9z/SggmjRszNYhCxaamXP Og== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nxy9r3xc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Nov 2018 13:38:06 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wARDc690023871
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Nov 2018 13:38:06 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wARDc5i4001484;
        Tue, 27 Nov 2018 13:38:05 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Nov 2018 05:38:05 -0800
From:   Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 1/2] btrfs: scrub: maintain the unlock order in scrub
 thread
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1543223228-28232-1-git-send-email-anand.jain@oracle.com>
 <1543223228-28232-2-git-send-email-anand.jain@oracle.com>
 <f7d06f21-f4a0-f46f-c241-fab35b9c0ed7@suse.com>
Message-ID: <89cef6a5-ca0c-9017-4219-0c19ce4a04dc@oracle.com>
Date:   Tue, 27 Nov 2018 21:37:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <f7d06f21-f4a0-f46f-c241-fab35b9c0ed7@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9089 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811270117
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/26/2018 05:47 PM, Nikolay Borisov wrote:
> 
> 
> On 26.11.18 г. 11:07 ч., Anand Jain wrote:
>> The fs_info::device_list_mutex and fs_info::scrub_lock creates a
>> nested locks in btrfs_scrub_dev(). During the lock acquire the
>> hierarchy is fs_info::device_list_mutex and then fs_info::scrub_lock,
>> so following the same reverse order during unlock, that is
>> fs_info::scrub_lock and then fs_info::device_list_mutex.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/scrub.c | 16 +++++++---------
>>   1 file changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index 902819d3cf41..b1c2d1cdbd4b 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -3865,7 +3865,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>   	}
>>   	sctx->readonly = readonly;
>>   	dev->scrub_ctx = sctx;
>> -	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>>   
>>   	/*
>>   	 * checking @scrub_pause_req here, we can avoid
>> @@ -3875,15 +3874,14 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>   	atomic_inc(&fs_info->scrubs_running);
>>   	mutex_unlock(&fs_info->scrub_lock);
>>   
>> -	if (!is_dev_replace) {
>> -		/*
>> -		 * by holding device list mutex, we can
>> -		 * kick off writing super in log tree sync.
>> -		 */
>> -		mutex_lock(&fs_info->fs_devices->device_list_mutex);
>> +	/*
>> +	 * by holding device list mutex, we can kick off writing super in log
>> +	 * tree sync.
>> +	 */
>> +	if (!is_dev_replace)
>>   		ret = scrub_supers(sctx, dev);
>> -		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>> -	}
>> +
>> +	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> 
> Have you considered whether this change will have any negative impact
> due to the fact that __scrtub_blocked_if_needed can go to sleep for
> arbitrary time with device_list_mutex held now ?

  You are right. I missed that point. The device_list_mutex must not be
  blocked. In fact here we don't need the nested device_list_mutex and
  scrub_lock at all. I have comeup with a new fix [1] below separating
  them.

[1]
---------------------------------
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 902819d3cf41..db895ad23eda 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3830,42 +3830,37 @@ int btrfs_scrub_dev(struct btrfs_fs_info 
*fs_info, u64 devid, u64 start,
                 return -EROFS;
         }

-       mutex_lock(&fs_info->scrub_lock);
         if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &dev->dev_state) ||
             test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &dev->dev_state)) {
-               mutex_unlock(&fs_info->scrub_lock);
                 mutex_unlock(&fs_info->fs_devices->device_list_mutex);
                 return -EIO;
         }
+       mutex_unlock(&fs_info->fs_devices->device_list_mutex);

         btrfs_dev_replace_read_lock(&fs_info->dev_replace);
         if (dev->scrub_ctx ||
             (!is_dev_replace &&
              btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
                 btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
-               mutex_unlock(&fs_info->scrub_lock);
-               mutex_unlock(&fs_info->fs_devices->device_list_mutex);
                 return -EINPROGRESS;
         }
         btrfs_dev_replace_read_unlock(&fs_info->dev_replace);

+       mutex_lock(&fs_info->scrub_lock);
         ret = scrub_workers_get(fs_info, is_dev_replace);
         if (ret) {
                 mutex_unlock(&fs_info->scrub_lock);
-               mutex_unlock(&fs_info->fs_devices->device_list_mutex);
                 return ret;
         }

         sctx = scrub_setup_ctx(dev, is_dev_replace);
         if (IS_ERR(sctx)) {
                 mutex_unlock(&fs_info->scrub_lock);
-               mutex_unlock(&fs_info->fs_devices->device_list_mutex);
                 scrub_workers_put(fs_info);
                 return PTR_ERR(sctx);
         }
         sctx->readonly = readonly;
         dev->scrub_ctx = sctx;
-       mutex_unlock(&fs_info->fs_devices->device_list_mutex);

         /*
          * checking @scrub_pause_req here, we can avoid
------------------------------------------------

Will send v2.

Thanks, Anand



> 
>>   
>>   	if (!ret)
>>   		ret = scrub_enumerate_chunks(sctx, dev, start, end);
>>
