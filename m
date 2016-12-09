Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47750 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751764AbcLIAjR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 19:39:17 -0500
Subject: Re: [PATCH 1/2] btrfs: qgroup: Introduce extent changeset for qgroup
 reserve functions
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <20161202020307.6025-1-quwenruo@cn.fujitsu.com>
 <10093188.Rk5diOXqMO@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <aa9d3698-2c0e-b162-4ef1-a2b7506d0a2c@cn.fujitsu.com>
Date: Fri, 9 Dec 2016 08:39:11 +0800
MIME-Version: 1.0
In-Reply-To: <10093188.Rk5diOXqMO@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/08/2016 10:29 PM, Chandan Rajendra wrote:
> On Friday, December 02, 2016 10:03:06 AM Qu Wenruo wrote:
>> Introduce a new parameter, struct extent_changeset for
>> btrfs_qgroup_reserved_data() and its callers.
>>
>> Such extent_changeset was used in btrfs_qgroup_reserve_data() to record
>> which range it reserved in current reserve, so it can free it at error
>> path.
>>
>> The reason we need to export it to callers is, at buffered write error
>> path, without knowing what exactly which range we reserved in current
>> allocation, we can free space which is not reserved by us.
>>
>> This will lead to qgroup reserved space underflow.
>>
>
> Hi Qu,
>
> On which git tree are these patches based off? This patch fails to apply
> cleanly on kdave/for-next branch that is available as of today.
>
It's based on David's for-next-20161125 branch, but with several other 
qgroup fixes as prerequisite.
btrfs: qgroup: Fix qgroup reserved space underflow caused by buffered 
write and quota enable
btrfs: qgroup: Return actually freed bytes for qgroup release or free data
btrfs: Add trace point for qgroup reserved space
btrfs: Add WARN_ON for qgroup reserved underflow

Or you can get the branch from my github repo:
https://github.com/adam900710/linux.git qgroup_fixes

Thanks,
Qu


