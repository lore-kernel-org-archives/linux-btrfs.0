Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:58720 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752954AbeEHAli (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 May 2018 20:41:38 -0400
Date: Tue, 8 May 2018 08:41:32 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: qgroup: swap the argument in the caller of
 update_qgroup_relation
Message-ID: <20180508004132.GA545@fnst.localdomain>
References: <20180507085027.23059-1-lufq.fnst@cn.fujitsu.com>
 <985b33f2-ea6f-aa25-493a-5895cc2b8eb0@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <985b33f2-ea6f-aa25-493a-5895cc2b8eb0@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 07, 2018 at 07:19:32PM +0800, Qu Wenruo wrote:
>
>
>On 2018年05月07日 16:50, Lu Fengqi wrote:
>> The QGROUP_RELATION item is very special, it always exists in pairs
>> (objectid and offset exchange). Its objectid and offset are the ids of a
>> pair of parent and child qgroups, respectively. The larger one is
>> parent and the smaller one is child. After the following commit, the order
>> of the parameters is wrong and causes qgroup show to output the wrong
>> qgroup parent-child relationship.
>> 
>> Fixes: aaf2dac5ef37 ("btrfs-progs: qgroup: split update_qgroup to reduce arguments")
>> Issue: #129
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>>  qgroup.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>> 
>> diff --git a/qgroup.c b/qgroup.c
>> index 11659e8394dd..e7e127daf5ce 100644
>> --- a/qgroup.c
>> +++ b/qgroup.c
>> @@ -1122,11 +1122,16 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
>>  				qgroupid = btrfs_search_header_offset(sh);
>>  				qgroupid1 = btrfs_search_header_objectid(sh);
>>  
>> -				if (qgroupid < qgroupid1)
>> +				if (qgroupid <= qgroupid1)
>>  					break;
>>  
>> +				/*
>> +				 * because of qgroupid > qgroupid1, qgroupid is
>> +				 * the id of parent, and qgroupid1 is the id of
>> +				 * child.
>> +				 */
>
>Instead of such comment, renaming @qgroupid to @parent, and @qgroupid1
>to @child makes more sense.

Although we are not sure which one is the parent before this if statement,
renaming may indeed make the code clearer, so V2 is coming.

>
>And a test case would definitely help in this case.

Make sense.

-- 
Thanks,
Lu

>
>Thanks,
>Qu
>
>>  				ret = update_qgroup_relation(qgroup_lookup,
>> -							qgroupid, qgroupid1);
>> +							qgroupid1, qgroupid);
>>  				break;
>>  			default:
>>  				return ret;
>> 
>


