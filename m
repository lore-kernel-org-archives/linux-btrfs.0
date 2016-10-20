Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27073 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751284AbcJTBFi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 21:05:38 -0400
Subject: Re: [PATCH 1/2] btrfs: Add WARN_ON for qgroup reserved underflow
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <rgoldwyn@suse.de>,
        <rgoldwyn@suse.com>
References: <20160930011537.4857-1-quwenruo@cn.fujitsu.com>
 <20161019143142.GS11398@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0b4d5b87-4f47-3874-b1e3-a7e7e06f0c59@cn.fujitsu.com>
Date: Thu, 20 Oct 2016 09:05:34 +0800
MIME-Version: 1.0
In-Reply-To: <20161019143142.GS11398@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/19/2016 10:31 PM, David Sterba wrote:
> On Fri, Sep 30, 2016 at 09:15:36AM +0800, Qu Wenruo wrote:
>> While the reason why qgroup reserved space may underflow is still under
>> investigation, such WARN_ON will help us to expose the bug more easily,
>> and for end-user we can detect and avoid underflow.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  fs/btrfs/qgroup.c | 21 ++++++++++++++++-----
>>  1 file changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 8db2e29..8532587 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1061,8 +1061,12 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>>  	WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>>  	qgroup->excl += sign * num_bytes;
>>  	qgroup->excl_cmpr += sign * num_bytes;
>> -	if (sign > 0)
>> -		qgroup->reserved -= num_bytes;
>> +	if (sign > 0) {
>> +		if (WARN_ON(qgroup->reserved < num_bytes))
>
> That's only partially helpful, you should also print the numbers,
> ref_root and/or qgroup id.
>

I'm OK to add more output.
But normally it's not really help though.

Thanks,
Qu


