Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46388 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753834AbcK3AYo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 19:24:44 -0500
Subject: Re: [PATCH v4 1/3] btrfs: Add WARN_ON for qgroup reserved underflow
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <lkml.page@gmail.com>
References: <20161128014009.12179-1-quwenruo@cn.fujitsu.com>
 <20161129161053.GI12522@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8b47bfc3-672b-fcab-4f76-df7fed747c76@cn.fujitsu.com>
Date: Wed, 30 Nov 2016 08:24:32 +0800
MIME-Version: 1.0
In-Reply-To: <20161129161053.GI12522@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/30/2016 12:10 AM, David Sterba wrote:
> On Mon, Nov 28, 2016 at 09:40:07AM +0800, Qu Wenruo wrote:
>> Goldwyn Rodrigues has exposed and fixed a bug which underflows btrfs
>> qgroup reserved space, and leads to non-writable fs.
>>
>> This reminds us that we don't have enough underflow check for qgroup
>> reserved space.
>>
>> For underflow case, we should not really underflow the numbers but warn
>> and keeps qgroup still work.
>>
>> So add more check on qgroup reserved space and add WARN_ON() and
>> btrfs_warn() for any underflow case.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>
> One of the warnings is visible during xfstests
> (btrfs_qgroup_free_refroot), is there a fix? Either a patch in
> mailinglist or work in progress. If not, I'm a bit reluctant to add it
> to 4.10 as we'd get that reported from users for sure.

Fix WIP, ETA would be in this week.

At least, this warning is working and helped us to find bugs.

Thanks,
Qu


