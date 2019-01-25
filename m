Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E56C282C3
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 02:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06CD9217D7
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 02:56:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w4CQgYcT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbfAYC40 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 21:56:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48878 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfAYC40 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 21:56:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0P2nUJN193893;
        Fri, 25 Jan 2019 02:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=s82zIZL2pamnaSjZ2HHjiYt7Gsop/qfwe/whAR7atG0=;
 b=w4CQgYcT59/HeUS+wW+3BsWlKb6jw5MxzL2ELz+25wYNSnEsgMWLj3n8VCAwGDTMPGbw
 3NE7LwrG/OVeefjkn2Js3orCzNNiF9LPFs79Au4offxHDDen8zEt0CsNcU7np30k/vli
 FbAUCM15DEKY1miJinzLIp8huTLPsewDxXiTNMcuJlIZJMbd25/517sdEomq39/u5frV
 i8cHoljXfFBPHxzV39BAJuOe4cfBMzKFze2AIe753Ftdp/2B9sMHJPPvKyjgs/zIpcAX
 TC+ElJS0bfMkkd870KRbu+k4nekLrHpS8sr3wsfmMQwgAZt/7Wl2g7qBO2VCd6gtwJjy HQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2q3sdeuj77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jan 2019 02:56:20 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0P2uFkC010365
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jan 2019 02:56:15 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0P2uEQ6009520;
        Fri, 25 Jan 2019 02:56:14 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Jan 2019 18:56:14 -0800
Subject: Re: [PATCH v2] Btrfs: avoid deadlock with memory reclaim due to
 allocation of devices
To:     dsterba@suse.cz, fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181213211725.14832-1-fdmanana@kernel.org>
 <20190111171759.19920-1-fdmanana@kernel.org>
 <0cd4bdb0-9389-a8f0-9094-78b3ccd1d254@oracle.com>
 <20190118180753.GF2900@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <f2cfd7c9-d07a-1002-6139-c4fb03ae5a44@oracle.com>
Date:   Fri, 25 Jan 2019 10:56:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190118180753.GF2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9146 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901250020
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/19/2019 02:07 AM, David Sterba wrote:
> On Mon, Jan 14, 2019 at 04:21:43PM +0800, Anand Jain wrote:
>>
>>
>> On 01/12/2019 01:17 AM, fdmanana@kernel.org wrote:
>>> From: Filipe Manana <fdmanana@suse.com>
>>>
>>> In a few places we are allocating a device using the GFP_KERNEL flag when
>>> it is not safe to do so, because if reclaim is triggered it can cause a
>>> transaction commit while we are holding the device list mutex. This mutex
>>> is required in the transaction commit path (at write_all_supers() and
>>> btrfs_update_commit_device_size()).
>>>
>>> So fix this by setting up a nofs memory allocation context in those cases.
>>>
>>> Fixes: 78f2c9e6dbb14 ("btrfs: device add and remove: use GFP_KERNEL")
>>> Fixes: e0ae999414238 ("btrfs: preallocate device flush bio")
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>
>>> V2: Change the approach to fix the problem by setting up nofs contextes
>>>       where needed.
>>>
>>>    fs/btrfs/volumes.c | 33 ++++++++++++++++++++++++++++++---
>>>    1 file changed, 30 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 2576b1a379c9..663566baae78 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -14,6 +14,7 @@
>>>    #include <linux/semaphore.h>
>>>    #include <linux/uuid.h>
>>>    #include <linux/list_sort.h>
>>> +#include <linux/sched/mm.h>
>>>    #include "ctree.h"
>>>    #include "extent_map.h"
>>>    #include "disk-io.h"
>>> @@ -988,20 +989,29 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>>>    	}
>>>    
>>>    	if (!device) {
>>> +		unsigned int nofs_flag;
>>> +
>>>    		if (fs_devices->opened) {
>>>    			mutex_unlock(&fs_devices->device_list_mutex);
>>>    			return ERR_PTR(-EBUSY);
>>>    		}
>>>    
>>> +		/*
>>> +		 * Setup nofs context because we are holding the device list
>>> +		 * mutex, which is required for a transaction commit.
>>> +		 */
>>
>> I wonder if there is a bug due to GFP_KERNEL in device_list_add()?
>> as device_list_add() can only be called only when the FSID is not yet
>> mounted. OR if its done for the sake of consistency when calling\
>> btrfs_alloc_device().
> 
> It still could be called but a new device will not be allocated, all is
> done either via scan or during mount. A missing device has an entry in
> fs_devices.



> We can keep th NOFS protection around that to make it future-proof, as
> it's not trivial to see if this is always called from safe context or
> not.

  Makes sense to me.

Thanks.


