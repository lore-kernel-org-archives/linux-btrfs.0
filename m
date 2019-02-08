Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDA0C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B6F92147C
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="03cr1eym"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfBHHRQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:17:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57488 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfBHHRQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 02:17:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x187DM0i171516;
        Fri, 8 Feb 2019 07:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=H8rBnWyma0oq5Wf6mmM/K9N+7lDyXxw0IgE3REU+qJM=;
 b=03cr1eymCPK9ChUmlpsBlywsXaVyZU4xzAnhI35oY4XQ9HKTjiNSxtAvLLWm4Rp71tPZ
 badiUlAPS+uBLlN5b1uLm/SGUn+LU46UnfjA3GDkmx/HtYLQlbqv2O5ZDRaxhA4Tc8CS
 SHnBuj06v2/zQmDqnVApJEhpB1CmcXva1wnKz92GhqrIRJMq8azxlxPS4VlUNrQ67j4q
 7+hAShzom52Wc2glv0wzmo0T/4jcHu66Bnf9ryx7SPLnWeOej/s9P8mV7VxqON7OvOVc
 1nPUwn7zTqditah/HGQHbCrx+0TZOrSiKbLvCAExuLTG+JwMwdhVEt1NcI62b6MVb8+3 Ow== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qd9aru0g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Feb 2019 07:16:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x187GnBo013626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Feb 2019 07:16:49 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x187Gn80008037;
        Fri, 8 Feb 2019 07:16:49 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 23:16:48 -0800
Subject: Re: [PATCH 1/5] btrfs: fix comment its device list mutex not volume
 lock
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
 <1549609355-11053-2-git-send-email-anand.jain@oracle.com>
 <b4404ffe-12f8-0f3f-672d-4eb23291b710@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <ffce7d69-8072-99fd-e489-6751cf50928f@oracle.com>
Date:   Fri, 8 Feb 2019 15:16:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <b4404ffe-12f8-0f3f-672d-4eb23291b710@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9160 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902080053
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/8/19 3:07 PM, Nikolay Borisov wrote:
> 
> 
> On 8.02.19 г. 9:02 ч., Anand Jain wrote:
>> We have killed volume mutex (commit: dccdb07bc996
>> btrfs: kill btrfs_fs_info::volume_mutex) update comment. This a trival one
>> seems to have escaped.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index fe122e6099ae..8160749cd9ba 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1129,7 +1129,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
>>   	mutex_lock(&orig->device_list_mutex);
>>   	fs_devices->total_devices = orig->total_devices;
>>   
>> -	/* We have held the volume lock, it is safe to get the devices. */
>> +	/* We have held the device_list_mutex, it is safe to get the devices. */
> 
> I'd rather have the comment replaced with lockdep_assert_held it's a lot
> more eloquent.

   I agree if we don't acquire the required lock in the same function,
   but here, we call the required mutex_lock(&orig->device_list_mutex);
   just three lines above in the same function.

   Where do we need the lockdep_assert_held()?

-Anand

>>   	list_for_each_entry(orig_dev, &orig->devices, dev_list) {
>>   		struct rcu_string *name;
>>   
>>
