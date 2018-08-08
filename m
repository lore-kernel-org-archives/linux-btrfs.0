Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10680 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727050AbeHHQbK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 12:31:10 -0400
Message-ID: <5B6AF9FB.10701@huawei.com>
Date: Wed, 8 Aug 2018 22:11:07 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] fs/btrfs: remove the unneeded variable "err" and change
 the function to be void function
References: <1533523978-50321-1-git-send-email-zhongjiang@huawei.com> <20180807152500.GJ3218@twin.jikos.cz>
In-Reply-To: <20180807152500.GJ3218@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/8/7 23:25, David Sterba wrote:
> On Mon, Aug 06, 2018 at 10:52:58AM +0800, zhong jiang wrote:
>> The err is not modified after initalization, So just remove it and make
>> the function to be void function.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>> v1->v2:
>>  - Merge v1 series into a patch to void same changelog.
> Please do one patch per function. If the change follows the same logic,
> it's not a problem to use the same changelog, but the patch should be
> revieweable and not doing unrelated things.
>
> If the function prototype or return values is changed it's easier from
> the reviewer's perspective to focus on just one function and the
> surrounding code. Even if it looks straightforward to you to merge them
> together.
>
> When the return value changes from int -> void, it's necessary to check
> wheter any of the callees is not hiding a BUG_ON that should be really
> turned into proper error handling in the caller. In that case the return
> type should stay and error handling added.
>
> After a brief look I think all functions are safe here, but that's
> something that should be mentioned in the changelog. Please update the
> patches and resend. Thanks.
>
> .
>
I will repost the patches with detailed changlog. Thank you for explaination.

Thanks
zhong jiang

