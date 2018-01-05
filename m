Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAECY3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jan 2018 21:24:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w052MceJ108579
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 02:24:28 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fa08w011b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jan 2018 02:24:28 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w052OR7C023370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 02:24:27 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w052ORFd003371
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 02:24:27 GMT
Subject: Re: [PATCH v2] btrfs: not a disk error if the bio_add_page fails
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20180103080729.20804-1-anand.jain@oracle.com>
 <20180103135243.21169-1-anand.jain@oracle.com>
 <20180104174756.GB5829@lim.localdomain>
 <20180104185035.GC5829@lim.localdomain>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0e4a1789-ecf2-9a6a-3c75-4e75ba2616c2@oracle.com>
Date: Fri, 5 Jan 2018 10:25:24 +0800
MIME-Version: 1.0
In-Reply-To: <20180104185035.GC5829@lim.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/05/2018 02:50 AM, Liu Bo wrote:
> On Thu, Jan 04, 2018 at 09:47:56AM -0800, Liu Bo wrote:
>> On Wed, Jan 03, 2018 at 09:52:43PM +0800, Anand Jain wrote:
>>> bio_add_page() can fail for logical reasons as from the bio_add_page()
>>> comments:- 'This will only fail if either
>>> bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.' Don't inc the
>>> write error statistics for this. And set -EINVAL instead of -EIO.
>>>
>>
>> It's correct to skip increasing counter, but why -EINVAL?
>> (its caller only cares about if it's non-zero.)
> 
> Well...there is no chance that bio_add_page() could return
> non-PAGE_SIZE as this bio has been just created, we can remove the
> error handling after bio_add_page().

  Ah. right, bio_add_page() can't fail in this thread, its not
  a bio clone, and its the first call to bio_add_page(). Will
  remove error handling part.

Thanks, Anand

> thanks,
> -liubo
>>
>> thanks,
>>
>> -liubo
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>> v1->v2: Add missing bio_put(). Thanks Filipe.
>>>
>>>   fs/btrfs/scrub.c | 9 +++++----
>>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>>> index ecfe3118d9dd..57ac39a3f046 100644
>>> --- a/fs/btrfs/scrub.c
>>> +++ b/fs/btrfs/scrub.c
>>> @@ -4617,15 +4617,16 @@ static int write_page_nocow(struct scrub_ctx *sctx,
>>>   	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
>>>   	ret = bio_add_page(bio, page, PAGE_SIZE, 0);
>>>   	if (ret != PAGE_SIZE) {
>>> -leave_with_eio:
>>> +		bio_put(bio);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (btrfsic_submit_bio_wait(bio)) {
>>>   		bio_put(bio);
>>>   		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
>>>   		return -EIO;
>>>   	}
>>>   
>>> -	if (btrfsic_submit_bio_wait(bio))
>>> -		goto leave_with_eio;
>>> -
>>>   	bio_put(bio);
>>>   	return 0;
>>>   }
>>> -- 
>>> 2.15.0
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
