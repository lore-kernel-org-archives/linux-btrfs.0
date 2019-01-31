Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DATE_IN_FUTURE_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4212FC282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 23:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E852F20882
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 23:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ovUFC+S+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfA3XZn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 18:25:43 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34348 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfA3XZm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 18:25:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0UMStWP051900;
        Wed, 30 Jan 2019 22:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=2/Zxjf9VjQDXtxUXUZ8d6GwAo3ZNe1Z+S4t8l/Vl0sY=;
 b=ovUFC+S+JXuWcCPpcdAu1chdvsRxkH0DzyA5iGS3jgrEHa4NWPqX5i8UJBh2kxQ83LIN
 00qDoR9ea+Ck49w9gdfU07YKR6dT4aJSpzlLSd2DAqoW3+KCOCwbwct/87JlNuXxJNjG
 ebgVUWoMzlzq3nrwoVtszJ7qW2BxLZe0dmB/KPsN7qOf4uLP2tNE7v8lDHQMpvJ8G43r
 mW5vtRoKTvku9kZW90ZT4EtCS/PT/T7Es15Xr32yGq19fG7Rk2byPppUMdqfntw7UvxQ
 ZHESjc4RyytHJk1bSfVL+Gh9uImHEPYiU3gEMQilZKWKqVCfq1QdR4tfQVPlWEowW85W nA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2q8d2edmhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jan 2019 22:34:59 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0UMYrKi023265
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jan 2019 22:34:53 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0UMYrhc001739;
        Wed, 30 Jan 2019 22:34:53 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Jan 2019 14:34:52 -0800
Subject: Re: [PATCH v4 1/3] btrfs: scrub: fix circular locking dependency
 warning
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
 <1548830702-14676-2-git-send-email-anand.jain@oracle.com>
 <20190130140758.GR2900@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <be521dbc-0b2a-696a-7167-21d50c6c71a9@oracle.com>
Date:   Thu, 31 Jan 2019 14:34:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190130140758.GR2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9152 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1901300163
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 1/30/19 10:07 PM, David Sterba wrote:
> On Wed, Jan 30, 2019 at 02:45:00PM +0800, Anand Jain wrote:
>> v3->v4: Fix list corruption as reported by btrfs/073 by David.
>>             [1]
>>             https://patchwork.kernel.org/patch/10705741/
>> 	Which I was able to reproduce with an instrumented kernel but not with
>> 	btrfs/073.
>>          In v3 patch, it releases the fs_info::scrub_lock to destroy the work queue
>> 	which raced with new scrub requests, overwriting the scrub workers
>> 	pointers. So in v4, it kills the function scrub_workers_put(), and
>> 	performs the destroy_workqueue in two stages, with worker pointers
>> 	copied locally.
> 
>> @@ -3932,9 +3925,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>   
>>   	mutex_lock(&fs_info->scrub_lock);
>>   	dev->scrub_ctx = NULL;
>> -	scrub_workers_put(fs_info);
>> +	if (--fs_info->scrub_workers_refcnt == 0) {
>> +		scrub_workers = fs_info->scrub_workers;
>> +		scrub_wr_comp = fs_info->scrub_wr_completion_workers;
>> +		scrub_parity = fs_info->scrub_parity_workers;
>> +	}
>>   	mutex_unlock(&fs_info->scrub_lock);
>>   
>> +	btrfs_destroy_workqueue(scrub_workers);
>> +	btrfs_destroy_workqueue(scrub_wr_comp);
>> +	btrfs_destroy_workqueue(scrub_parity);
> 
> https://lore.kernel.org/linux-btrfs/1543554924-17397-2-git-send-email-anand.jain@oracle.com/
> 
> Comparing to the previous version, it's almost the same I think. If
> scrub_workers_get races between the unlock and destroy_workers, anything
> that uses fs_info->scrub_wokers will soon use freed memory.
> 
> The difference is that the worker pointers are read from fs_info under a
> lock but are still used outside. I haven't tested this version but from
> the analysis of previous crash, I don't see how v4 is supposed to be
> better.
>

Consider v3 code as below:

When process-A is at [1] (below) start another
btrfs scrub start, lets call it process-B.
When process-A is at [1] it unlocks the fs_info::scrub_lock so the
process-B can overwrite fs_info::scrub_workers,
fs_info::scrub_wr_completion_workers, fs_info::scrub_parity_workers
which the process-A at [1] has not yet called destroyed.

Process-A
---------

btrfs scrub start /mnt

::
         mutex_lock(&fs_info->scrub_lock);
::
         if (dev->scrub_ctx ||
             (!is_dev_replace &&
              btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
                 up_read(&fs_info->dev_replace.rwsem);
                 mutex_unlock(&fs_info->scrub_lock);
                 mutex_unlock(&fs_info->fs_devices->device_list_mutex);
                 ret = -EINPROGRESS;
                 goto out_free_ctx;
         }
::
         ret = scrub_workers_get(fs_info, is_dev_replace);  <-- [2]
::
         dev->scrub_ctx = sctx;
         mutex_unlock(&fs_info->scrub_lock);

::
                 ret = scrub_enumerate_chunks(sctx, dev, start, end);
::
         atomic_dec(&fs_info->scrubs_running);
::

         mutex_lock(&fs_info->scrub_lock);
         dev->scrub_ctx = NULL;
         scrub_workers_put(fs_info);
         mutex_unlock(&fs_info->scrub_lock);



static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info 
*fs_info)
{
         lockdep_assert_held(&fs_info->scrub_lock);
         if (--fs_info->scrub_workers_refcnt == 0) {
                 mutex_unlock(&fs_info->scrub_lock);

		<wait for process-B>  [1]

                 btrfs_destroy_workqueue(fs_info->scrub_workers);
 
btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
                 btrfs_destroy_workqueue(fs_info->scrub_parity_workers);
                 mutex_lock(&fs_info->scrub_lock);
         }
         WARN_ON(fs_info->scrub_workers_refcnt < 0);
}




Process-B
---------
Start when process-A is at [1] (above)
btrfs scrub start /mnt

::
  at [2] (above) the fs_info::scrub_workers,
fs_info::scrub_wr_completion_workers, fs_info::scrub_parity_workers
of process-A are overwritten.


So in v4.
--------

Similar to dev::scrub_ctx the fs_info::scrub_workers,
fs_info::scrub_wr_completion_workers, fs_info::scrub_parity_workers
are stored locally before fs_info::scrub_lock is released, so the
list pointers aren't corrupted.

Hope this clarifies.

Thanks, Anand
