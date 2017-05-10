Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2171 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751709AbdEJDjv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 23:39:51 -0400
Subject: Re: [PATCH v3] btrfs: relocation: Enhance kernel error output for
 relocation
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <bo.li.liu@oracle.com>,
        <fdmanana@gmail.com>
References: <20170215013905.17677-1-quwenruo@cn.fujitsu.com>
 <20170509172943.GI5491@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <436b506c-4ab7-408c-130b-1cebe00f2746@cn.fujitsu.com>
Date: Wed, 10 May 2017 11:39:40 +0800
MIME-Version: 1.0
In-Reply-To: <20170509172943.GI5491@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/10/2017 01:29 AM, David Sterba wrote:
> On Wed, Feb 15, 2017 at 09:39:05AM +0800, Qu Wenruo wrote:
>> When balance(relocation) fails, btrfs-progs will report like:
>>
>> ERROR: error during balancing '/mnt/scratch': Input/output error
>> There may be more info in syslog - try dmesg | tail
>>
>> However kernel can't provide may useful info in many cases to locate the
>> problem.
>>
>> This patch will add error messages in relocation to help user and
>> developer to locate the problem.
> 
> I think it's too verbose for a user, and not really helpful what to do
> after such error message appears in the log. The errors translate name
> of the last function that failed, so the user would need to be familiar
> with the inner workings of the balance to make sense of it.

Yes, normal user may never need such verbose output.

But it will help developers or support guys to wipe out some really easy 
cases.

> 
> The meessages may make sense to a developer, but then it's not necessary
> to print them as btrfs_err, but btrfs_debug.

I also considered btrfs_debug, but the problem is btrfs_debug() depend 
on either CONFIG_DYANMIC_DEBUG or DEBUG.

So when problem happens in real world, we're too late to ensure such output.

Thanks,
Qu



