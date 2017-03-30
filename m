Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35736 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933178AbdC3KwD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 06:52:03 -0400
Subject: Re: [PATCH 1/4] btrfs: REQ_PREFLUSH does not use btrfs_end_bio()
 completion callback
To: dsterba@suse.cz
References: <20170313074214.24123-1-anand.jain@oracle.com>
 <20170313074214.24123-2-anand.jain@oracle.com>
 <20170328151956.GZ4781@twin.jikos.cz>
 <7dab96d3-51d5-e738-6305-1a470675caf7@oracle.com>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <a63dcb1f-8261-fefe-1759-70892c3e56f2@oracle.com>
Date: Thu, 30 Mar 2017 18:57:01 +0800
MIME-Version: 1.0
In-Reply-To: <7dab96d3-51d5-e738-6305-1a470675caf7@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/29/2017 06:00 PM, Anand Jain wrote:
>
>
> On 03/28/2017 11:19 PM, David Sterba wrote:
>> On Mon, Mar 13, 2017 at 03:42:11PM +0800, Anand Jain wrote:
>>> REQ_PREFLUSH bio to flush dev cache uses btrfs_end_empty_barrier()
>>> completion callback only, as of now, and there it accounts for dev
>>> stat flush errors BTRFS_DEV_STAT_FLUSH_ERRS, so remove it from the
>>> btrfs_end_bio().
>>
>> Can you please be more specific? I was trying to find the code path that
>> does the supposedly duplicate accounting for BTRFS_DEV_STAT_FLUSH_ERRS,
>> but still not there after half an hour.
>>
>> submit_stripe_bio
>>   btrfsic_submit_bio
>>     btrfs_end_bio
>>       -> stats accounting
>>
>> write_dev_flush
>>   btrfsic_submit_bio
>>     btrfs_end_empty_barrier
>>       complete
>>
>> now here it wakes up flush_wait, that is only waited for in
>> write_dev_flush, there the FLUSH_ERRS accounting happens, but ... I'm
>> not sure if I haven't lost in the bio handling maze.



>  As I am checking again, we aren't using REQ_PREFLUSH flag for
>  any other bio and would suffice for its correctness IMO.

  I mean for this patch correctness.

> Thanks, Anand
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
